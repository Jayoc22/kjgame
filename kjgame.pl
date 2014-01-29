#!/usr/bin/perl
use strict;

use SDL;
use SDL::Video;
use SDLx::App;
use SDL::Surface;
use SDL::Rect;
use SDL::Image;
use SDL::Event;
#use SDL::Mouse;
use SDLx::Sound;
use SDL::Cursor;
use SDLx::Text;
use SDL::GFX::Rotozoom;
#use SDL_Surface::cursor;
#use SDL_Surface::image;

#SDL_ShowCursor( SDL_DISABLE ); //Standard cursor must be turned off

#image = SDL_LoadBMP("mouse.bmp"); //Load my cursor

#cursor = SDL_DisplayFormat(image); //Set

#//Set the color as transparent
#SDL_SetColorKey(cursor,SDL_SRCCOLORKEY|SDL_RLEACCEL,SDL_MapRGB(cursor->format,0x0,0x0,0x0));
#(sdl-mixer:OPEN-AUDIO)
# (let ((music (sdl-mixer:load-music "gamemusic.mp3")))
  # (sdl-mixer:play-music music :loop t)

   #(sdl:with-events ()
   #  (:quit-event ()
    #        (sdl-mixer:Halt-Music)
    #        (sdl-mixer:free music)
    #        (sdl-mixer:close-audio)
    #        t)
     #(:idle () (sdl:update-display)))))
    

my ($application,$key_name,$mouse_x,$mouse_y, $background, $background_rect, $event, $exiting, $filename,$crosshair,     $item_movex, $target_rect, $background_rect, $game, $move_x, $num,$inf_move, $quit_event_handle, $gun_event_handle, $move_crosshair_handle,$key_event_handle, $mouse_event_handle, $x, $y ,$cover, $cover_rect, $cursor,@cursor_data, @cursor_mask, $hotspot_left, $hotspot_top,$cursor_width,$cursor_height,$cursor_event_handle, $target, $target_filename, $targetmaster,$target_x, $target_y, $target_rect, $show_target_handle, $new_target_rect, $target_step,$target_w, $target_h, $move_target_handle, $step, $t, $back, $target, $target_x,$target_y, $target_h, $target_move_handle, $target_show_handle, $target_w, $target_rect,$oldx, $score_text, $score, $target_01_move_handle, $target_01, $target_x_01,$target_y_01, $target_w_01, $target_h_01, $target_rect_01, $oldy_01, $target_x_01,$target_y_01, $bady_01, $score, $pixel, $r, $g, $hex, $path_color, $target_01,$target_01_x, $target_01_y, $target_01_w, $target_01_h, $target_01_rect,$target_01_show_handle, $oldy, $new_target_rect, $new_target_rect_01, $cover_rect_01,$oldx_01, $targetmaster_01, $target_02_x, $target_02_y, $target_02_w, $target_02_h,$target_02_rect, $target_02_show_handle, $target_02,$target_x_02, $target_y_02,
$target_w_02, $target_02_move_handle, $target_h_02, $target_rect_02, $oldx_02, $oldy_02,$cover_rect_02, $targetmaster_02, $new_target_rect_02, $level, $target_03, $target_x_03,$target_y_03, $target_w_03, $target_h_03, $target_rect_03, $new_target_rect_03,$targetmaster_03, $oldx_03, $oldy_03, $target_03_show_handle, $target_03_move_handle,$cover_rect_03  );


my ($application, $bomb_sound, $goal, $level_02_show_handle, $title_screen,
$title_screen_rect, $playing, $text_box, $text_box_01, $target_04, $target_x_04,
$target_y_04, $target_w_04, $target_h_04, $target_rect_04,  $goal2, $new_target_rect_04,
$cover_rect_04, $targetmaster_04, $oldx_04, $oldy_04, $targetstep_04, $targetupper_04,
$targetlower_04);
$level=1;
$exiting=0;
$score=0;
$playing = 0;
$goal=100;
$goal2=150;
$text_box = SDLx::Text->new(size=>'24',
    color=>[255,0,0], # [R,G,B]
    x =>580,
    y=> 540);

$text_box_01 = SDLx::Text->new(
    ##size=>'24',
    color=>[255,0,0], # [R,G,B]
    x =>20,
    y=> 20);

$application = SDLx::App->new(
 title  => "K.J TARGET SHOOTER",
 width  => 800,
 height => 600,
 depth  => 20,
 exit_on_quit => 1
);

$background = SDL::Image::load('main.png');
$background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
SDL::Video::update_rects($application, $background_rect);
sleep (2);

$background = SDL::Image::load('main.png');
$background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
SDL::Video::update_rects($application, $background_rect);
sleep (2);

$background = SDL::Image::load('main.png');

$background_rect = SDL::Rect->new(0,0, $background->w, $background->h);

SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
SDL::Video::update_rects($application, $background_rect);
sleep (2);

$quit_event_handle=$application->add_event_handler( \&quit_event );
$mouse_event_handle=$application->add_event_handler( \&mouse_event );
$key_event_handle=$application->add_event_handler( \&key_event );

$target_show_handle = $application->add_show_handler(\&target_show);
$target_move_handle = $application->add_move_handler(\&target_move);
$target_01_show_handle = $application->add_show_handler(\&target_01_show);
$target_01_move_handle = $application->add_move_handler(\&target_01_move);
$target_02_show_handle = $application->add_show_handler(\&target_02_show);
$target_02_move_handle = $application->add_move_handler(\&target_02_move);

$bomb_sound = SDLx::Sound->new();
$bomb_sound->load('gunshot.ogg');
$background = SDL::Image::load('main.png');
$cover = $background;
$background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
$event = SDL::Event->new();
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
$event = SDL::Event->new();
$cursor_width=9;
$cursor_height=9;
$hotspot_left=4;
$hotspot_top=4;

# Circle crosshair mouse
@cursor_data = (
    0b00111000,0b00000000,
    0b01010100,0b00000000,
    0b10010010,0b00000000,
    0b10000010,0b00000000,
    0b11010110,0b00000000,
    0b10000010,0b00000000,
    0b10010010,0b00000000,
    0b01010100,0b00000000,
    0b00111000,0b00000000

);
@cursor_mask = @cursor_data;
$cursor = SDL::Cursor->new(\@cursor_data, \@cursor_mask, $cursor_width, $cursor_height,
$hotspot_left, $hotspot_top);

$target = SDL::Image::load('target.png');
$target_x = 700;
$target_y = 350;
$target_w = $target_01->w;
$target_h = $target_01->h;
$target_rect = SDL::Rect->new($target_x, $target_y ,$target_w ,$target_h);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );

$target_01 = SDL::Image::load('target_01.png');
$target_x_01 = 0;
$target_y_01 = 0;
$target_w_01 = $target_02->w;
$target_h_01 = $target_02->h;
$target_rect_01 = SDL::Rect->new($target_x_01, $target_y_01 ,$target_w_01 ,$target_h_01);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );

$target_02 = SDL::Image::load('target_02.png');
$target_x_02 = 0;
$target_y_02= 0;
$target_w_02 = $target_03->w;
$target_h_02 = $target_03->h;
$target_rect_02 = SDL::Rect->new($target_x_02, $target_y_02 ,$target_w_02 ,$target_h_02);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );

$target_03 = SDL::Image::load('target_03.png');
$target_x_03 = 0;
$target_y_03= 0;
$target_w_03 = $target_04->w;
$target_h_03 = $target_04->h;
$target_rect_03 = SDL::Rect->new($target_x_03, $target_y_03 ,$target_w_03 ,$target_h_03);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );

$target_04 = SDL::Image::load('target_04.png');
$target_x_04 = 0;
$target_y_04= 0;
$target_w_04 = $target_04->w;
$target_h_04 = $target_04->h;
$target_rect_04 = SDL::Rect->new($target_x_04, $target_y_04 ,$target_w_04 ,$target_h_04);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );

my $targetstep = 4;
my $targetupper = 755;
my $targetlower = 0;
my $target_x = 0;
my $target_y = 50;

my $targetstep_01 =4.5;
my $targetupper_01 = 755;  
my $targetlower_01 = 0;
my $target_x_01 = 0;
my $target_y_01 = 200;

my $targetstep_02 = 6.5;
my $targetupper_02 = 755;
my $targetlower_02 = 0;
my $target_x_02 = 0;
my $target_y_02 = 350;

my $targetstep_03 = 7.5;
my $targetupper_03 = 755;
my $targetlower_03 = 0;
my $target_x_03 = 0;
my $target_y_03 = 150;

$application->run;

sub target_show {
 my ($delta, $application) = @_;
 $new_target_rect = SDL::Rect->new($target_x,$target_y,$target->w,$target->h);  
 $cover_rect = SDL::Rect->new($oldx, $target_y, $target->w, $target->h);
 SDL::Video::blit_surface($cover, $cover_rect, $application, $cover_rect );      
 SDL::Video::blit_surface ($target, $targetmaster, $application, $new_target_rect);
 SDL::Video::update_rects($application, $new_target_rect);
 $application->sync();  
}

sub target_move {
 if ($target_x >790) {
   $target_x = 790;
 }
 if ($target_y<-50) {
   $target_y = 0;
 }
 if ($target_y>575) {
   $target_y = 580;
   }
 if ($target_x <-50) {
      $target_x = 0;
 }
    my ($step, $application, $t) = @_;
 $oldx = $target_x;
 $oldy = $target_y;
    $target_x+= $targetstep; # change x by +/- step
    if ($target_x > $targetupper) { # limit test
      $target_x = $targetupper;
      $targetstep*= -1;  
    }
         
 if ($target_x < $targetlower) {
      $target_x = $targetlower;
      $targetstep*= -1; # invert step
    }
}

sub target_01_show {
 my ($delta, $application) = @_;
 $new_target_rect_01 =
SDL::Rect->new($target_x_01,$target_y_01,$target_01->w,$target_01->h);  
 $cover_rect_01 = SDL::Rect->new($oldx_01, $target_y_01, $target_01->w, $target_01->h);
 SDL::Video::blit_surface($cover, $cover_rect_01, $application, $cover_rect_01 );      
 SDL::Video::blit_surface ($target_01, $targetmaster_01, $application,
$new_target_rect_01);
 SDL::Video::update_rects($application, $new_target_rect_01);
 $application->sync();  
}

sub target_01_move  {
 if ($target_x_01 >850) {
   $target_x_01 = 780;
 }
 if ($target_y_01<-50) {
   $target_y_01 = 0;
 }
 if ($target_y_01>575) {
      $target_y_01 = 0;
 }
 if ($target_x_01 <-50) {
   $target_x_01 = 0;
 }
    my ($step, $application, $t) = @_;
 $oldx_01 = $target_x_01;
 $oldy_01 = $target_y_01;
    $target_x_01+= $targetstep_01;  
 if ($target_x_01 > $targetupper_01) {
   $target_x_01 = $targetupper_01;
   $targetstep_01*= -1;  
 }

 if ($target_x_01 < $targetlower_01) {  
   $target_x_01 = $targetlower_01;
   $targetstep_01*= -1; # invert step
 }
    if ($score>=$goal){
         $targetstep_01+=05;
    }
}

sub target_02_show {
 my ($delta, $application) = @_;
 $new_target_rect_02 = SDL::Rect->new($target_x_02, $target_y_02,
$target_02->w,$target_02->h);  
 $cover_rect_02 = SDL::Rect->new($oldx_02, $target_y_02, $target_02->w, $target_02->h);
 SDL::Video::blit_surface($cover, $cover_rect_02, $application, $cover_rect_02 );      
 SDL::Video::blit_surface ($target_02, $targetmaster_02, $application,
$new_target_rect_02);
 SDL::Video::update_rects($application, $new_target_rect_02);
 $application->sync();  
}

sub target_02_move  {
 if ($target_x_02 >800) {
   $target_x_02 = 780;
 }
    if ($target_y_02<-50) {
   $target_y_02 = 0;
 }
 if ($target_y_02>500) {
   $target_y_02 = 0;
 }
 if ($target_x_02 <-50) {
     $target_x_02 = 0;
 }

    my ($step, $application, $t) = @_;
     $oldx_02 = $target_x_02;
     $oldy_02 = $target_y_02;
     $target_x_02+= $targetstep_02; # change x by +/- step
 if ($target_x_02 > $targetupper_02) { # limit test
   $target_x_02 = $targetupper_02;
   $targetstep_02*= -1; # invert step
 }

     if ($target_x_02 < $targetlower_02) {# limit test
         $target_x_02 = $targetlower_02;
         $targetstep_02*= -1; # invert step
     }
}

sub target_03_show {
 my ($delta, $application) = @_;
 $new_target_rect_03 = SDL::Rect->new($target_x_03, $target_y_03,
$target_03->w,$target_03->h);  
 $cover_rect_03 = SDL::Rect->new($oldx_03, $target_y_03, $target_03->w, $target_03->h);
 SDL::Video::blit_surface($cover, $cover_rect_03, $application, $cover_rect_03 );      
 SDL::Video::blit_surface ($target_03, $targetmaster_03, $application,
$new_target_rect_03);
 SDL::Video::update_rects($application, $new_target_rect_03);
 $application->sync();  
}

sub target_03_move  {
 if ($target_x_03 >850) {
      $target_x_03 = 780;
 }
 if ($target_y_03<-50) {
   $target_y_03 = 0;
 }
 if ($target_y_03>575) {  
   $target_y_03 = 0;
 }
 if ($target_x_03 <-50) {
   $target_x_03 = 0;
 }

my ($step, $application, $t) = @_;
$oldx_03 = $target_x_03;
$oldy_03 = $target_y_03;
$target_x_03+= $targetstep_03;  
 if ($target_x_03 > $targetupper_03) {
   $target_x_03 = $targetupper_03;
   $targetstep_03*= -1; # invert step
 }

 if ($target_x_03 < $targetlower_03) {  
   $target_x_03 = $targetlower_03;
   $targetstep_03*= -1;
 }
}

sub target_04_show {
 my ($delta, $application) = @_;
 $new_target_rect_04 = SDL::Rect->new($target_x_04, $target_y_04,
$target_04->w,$target_04->h);  
 $cover_rect_03 = SDL::Rect->new($oldx_04, $target_y_04, $target_04->w, $target_04->h);
 SDL::Video::blit_surface($cover, $cover_rect_04, $application, $cover_rect_04 );      
 SDL::Video::blit_surface ($target_04, $targetmaster_04, $application,
$new_target_rect_04);
 SDL::Video::update_rects($application, $new_target_rect_04);
 $application->sync();  
}

sub target_04_move  {
 if ($target_x_04 >850) {
      $target_x_04 = 780;
 }
 if ($target_y_04<-50) {
      $target_y_04 = 0;
  }
  if ($target_y_04>575) {
       $target_y_04 = 0;
  }
  if ($target_x_04 <-50) {
    $target_x_04 = 0;
  }

    my ($step, $application, $t) = @_;
     $oldx_04 = $target_x_04;
     $oldy_04 = $target_y_04;
     $target_x_04+= $targetstep_04; # change x by +/- step
 if ($target_x_04 > $targetupper_04) { # limit test
   $target_x_04 = $targetupper_04;
   $targetstep_04*= -1; # invert step
 }

 if ($target_x_04 < $targetlower_04) {# limit test
   $target_x_04 = $targetlower_04;
   $targetstep_04*= -1; # invert step
 }
}

sub quit_event {
 my($event, $application)=@_;
 if($event->type == SDL_QUIT){
         $application->stop;
    }
}

sub key_event {
     my($event, $application)= @_;
     my ($mouse_mask,$mouse_x,$mouse_y)  = @{SDL::Events::get_mouse_state()};
  my ($r, $g, $b, $pixel, $hex);
     # printed output from here is going to the CLI
     #     print "Key is: ";
     my $key_name = SDL::Events::get_key_name( $event->key_sym );  
  #print "[$key_name]\n";
  if ($key_name eq "LButton") {
    if ($playing == 3) {
      $playing=1;
      $bomb_sound->play('gunshot.ogg');
    }
      else {
        $bomb_sound->stop();
        $playing = 3;
        $bomb_sound->play('bulletfalling.ogg');
        $bomb_sound->stop();
    }
      }
  }
        
if ($key_name eq "LButton"){
 $pixel =SDL::Surface::get_pixel($application, $background->w*$mouse_y+$mouse_x);
 # convert it to RGB (5:6:?)
 ($r, $g, $b) = @{SDL::Video::get_RGB($application->format(), $pixel)};
 # show those values
 print "R[$r] G[$g] B[$b]\n";
 print "Decimal[$pixel]\n";
 # get a Hexadecimal representation
 $hex = sprintf("%x",$pixel);
 # and show it
 print "Hex[$hex]\n";
      if  (($hex eq "ff0018")||($hex eq "ff0030")||($hex eq "ff0025")||($hex eq "ff3552")){
               $score+=10;
               print"     BULLSEYE cant get better than that  [$score]\n";
               SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
         }
         elsif  (($hex eq"ffedef")||($hex eq"ffffff")||($hex eq"efefe8")||($hex eq "fdeef0")){
           $score+=7;
           print"Good Hit!  [$score]\n";
           SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
      }

   elsif  (($hex eq"ff3a51")||($hex eq"ff224c")||($hex eq "ff3140")||($hex eq "ea1735")){
        $score+=5;
              print"not to good ENOUGH try again!  [$score]\n";
              SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         }

         if  (($hex eq "ff0018")||($hex eq"ffedef")||($hex eq"ff3a51"))     {
     SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
     $target_show_handle = $application->remove_show_handler(\&target_show);
              $target_move_handle = $application->remove_move_handler(\&target_move);
              $target_x="0";
              $target_y+="70";
     if ($target_y>520){  
                   $target_y="60";
              }
              $target_show_handle = $application->add_show_handler(\&target_show);
              $target_move_handle = $application->add_move_handler(\&target_move);
     }

         if  (($hex eq"ff0030")||($hex eq"ffffff")||($hex eq"ff224c"))     {
           SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
     $target_01_show_handle = $application->remove_show_handler(\&target_01_show);
              $target_01_move_handle = $application->remove_move_handler(\&target_01_move);
              $target_x_01="0";
              $target_y_01+="80";
     if ($target_y_01>500){  
                   $target_y_01="60";
              }
     if ($target_x_01>780){  
                   $target_x_01="0";
              }

              $target_01_show_handle = $application->add_show_handler(\&target_01_show);
              $target_01_move_handle = $application->add_move_handler(\&target_01_move);

         }
         if  (($hex eq"ff0025")||($hex eq"efefe8")||($hex eq"ff3140"))     {
     SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
     $target_02_show_handle = $application->remove_show_handler(\&target_02_show);
              $target_02_move_handle = $application->remove_move_handler(\&target_02_move);
              $target_x_02+="0";
              $target_y_02+="80";
     if ($target_y_02>500){  
                $target_y_02="60";
     }
     if ($target_x_02>780){  
                $target_x_02="0";
     }
              $target_02_show_handle = $application->add_show_handler(\&target_02_show);
              $target_02_move_handle = $application->add_move_handler(\&target_02_move);
     }

         if  (($hex eq"ff3552")||($hex eq"fdeef0")||($hex eq"ea1735"))     {
           SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
     $target_03_show_handle = $application->remove_show_handler(\&target_03_show);
              $target_03_move_handle = $application->remove_move_handler(\&target_03_move);
              $target_x_03+="0";
              $target_y_03+="80";
     if ($target_y_03>500){  
                $target_y_03="60";
     }
     if ($target_x_03>780){  
                $target_x_03="0";
     }
              $target_03_show_handle = $application->add_show_handler(\&target_03_show);
              $target_03_move_handle = $application->add_move_handler(\&target_03_move);
         }
}

 if (($key_name eq "q") || ($key_name eq "Q") ) {
   $score=0;
   SDL::Video::blit_surface($background, $background_rect, $application,
$background_rect );
    }
    if (($key_name eq "x") || ($key_name eq "X") ) {
         $application->stop;
    }
    $text_box->write_to($application,"Goal:[$goal]\nCurrent Score:[$score] ");
    $text_box_01->write_to($application,"Level[$level]");

    if ($score>=$goal){
         $background = SDL::Image::load('level 1.jpg');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 1 DONE');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 2');
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep(2);

         $goal=150;
         $level=2;

         $text_box->write_to($application,"Goal:[$goal]\nCurrent Score:[$score] ");
         $text_box_01->write_to($application,"Level[$level]");

         $target_show_handle = $application->remove_show_handler(\&target_show);
         $target_move_handle = $application->remove_move_handler(\&target_move);
         $target_01_show_handle = $application->remove_show_handler(\&target_01_show);
         $target_01_move_handle = $application->remove_move_handler(\&target_01_move);
         $target_02_show_handle = $application->remove_show_handler(\&target_02_show);
         $target_02_move_handle = $application->remove_move_handler(\&target_02_move);
         $targetstep+=4;
         $targetstep_01+=4;
         $targetstep_02+=4;

         $target_show_handle = $application->add_show_handler(\&target_show);
         $target_move_handle = $application->add_move_handler(\&target_move);
         $target_01_show_handle = $application->add_show_handler(\&target_01_show);
         $target_01_move_handle = $application->add_move_handler(\&target_01_move);
         $target_02_show_handle = $application->add_show_handler(\&target_02_show);
         $target_02_move_handle = $application->add_move_handler(\&target_02_move);
         $background = SDL::Image::load('MAIN BACKGROUNG IMAGE');
         $cover = $background;
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);

         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
   SDL::Video::update_rects($application, $background_rect);
         $goal=150; 
         
      

    if ($score>=$goal){
         $background = SDL::Image::load('level 2 DONE');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 3');
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep(2);

         $goal=200;
         $level=3;
         if ($score>=$goal){
         $background = SDL::Image::load('level 4.jpg');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 4 DONE');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 4');
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep(2);
         
         $goal=250;
         $level=4;
         
         $text_box->write_to($application,"Goal:[$goal]\nCurrent Score:[$score] ");
         $text_box_01->write_to($application,"Level[$level]");

         $target_show_handle = $application->remove_show_handler(\&target_show);
         $target_move_handle = $application->remove_move_handler(\&target_move);
         $target_01_show_handle = $application->remove_show_handler(\&target_01_show);
         $target_01_move_handle = $application->remove_move_handler(\&target_01_move);
         $target_02_show_handle = $application->remove_show_handler(\&target_02_show);
         $target_02_move_handle = $application->remove_move_handler(\&target_02_move);
         $targetstep+=4;
         $targetstep_01+=4;
         $targetstep_02+=4;

         $target_show_handle = $application->add_show_handler(\&target_show);
         $target_move_handle = $application->add_move_handler(\&target_move);
         $target_01_show_handle = $application->add_show_handler(\&target_01_show);
         $target_01_move_handle = $application->add_move_handler(\&target_01_move);
         $target_02_show_handle = $application->add_show_handler(\&target_02_show);
         $target_02_move_handle = $application->add_move_handler(\&target_02_move);
         $background = SDL::Image::load('MAIN BACKGROUNG IMAGE');
         $cover = $background;
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);

         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
   SDL::Video::update_rects($application, $background_rect);
         $goal=250;

         $text_box->write_to($application,"Goal:[$goal]\nCurrent Score:[$score] ");
         $text_box_01->write_to($application,"Level[$level]");
    $background, $background_rect;
         $target_show_handle = $application->remove_show_handler(\&target_show);
         $target_move_handle = $application->remove_move_handler(\&target_move);
         $target_01_show_handle = $application->remove_show_handler(\&target_01_show);
         $target_01_move_handle = $application->remove_move_handler(\&target_01_move);
         $target_02_show_handle = $application->remove_show_handler(\&target_02_show);
         $target_02_move_handle = $application->remove_move_handler(\&target_02_move);
         $targetstep+=1;
         $targetstep_01+=1;
         $targetstep_02+=1;
         $targetstep_03+=6;
         $target_show_handle = $application->add_show_handler(\&target_show);
         $target_move_handle = $application->add_move_handler(\&target_move);
         $target_01_show_handle = $application->add_show_handler(\&target_01_show);
         $target_01_move_handle = $application->add_move_handler(\&target_01_move);
         $target_02_show_handle = $application->add_show_handler(\&target_02_show);
         $target_02_move_handle = $application->add_move_handler(\&target_02_move);
         $target_03_show_handle = $application->add_show_handler(\&target_03_show);
         $target_03_move_handle = $application->add_move_handler(\&target_03_move);
         if ($score>=$goal){
         
         $background = SDL::Image::load('level 5.jpg');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 5 DONE');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (1);

         $background = SDL::Image::load('level 5');
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep(2);

         $goal=300;
         $level=5;

         $text_box->write_to($application,"Goal:[$goal]\nCurrent Score:[$score] ");
         $text_box_01->write_to($application,"Level[$level]");

         $target_show_handle = $application->remove_show_handler(\&target_show);
         $target_move_handle = $application->remove_move_handler(\&target_move);
         $target_01_show_handle = $application->remove_show_handler(\&target_01_show);
         $target_01_move_handle = $application->remove_move_handler(\&target_01_move);
         $target_02_show_handle = $application->remove_show_handler(\&target_02_show);
         $target_02_move_handle = $application->remove_move_handler(\&target_02_move);
         $targetstep+=4;
         $targetstep_01+=4;
         $targetstep_02+=4;

         $target_show_handle = $application->add_show_handler(\&target_show);
         $target_move_handle = $application->add_move_handler(\&target_move);
         $target_01_show_handle = $application->add_show_handler(\&target_01_show);
         $target_01_move_handle = $application->add_move_handler(\&target_01_move);
         $target_02_show_handle = $application->add_show_handler(\&target_02_show);
         $target_02_move_handle = $application->add_move_handler(\&target_02_move);
         $background = SDL::Image::load('MAIN BACKGROUNG IMAGE');
         $cover = $background;
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);

         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
   SDL::Video::update_rects($application, $background_rect);
         $goal=300;            
         

         $background = SDL::Image::load('MAIN BACGROUND IMAGE');
      $cover = $background;
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);     
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
      SDL::Video::update_rects($application, $background_rect);
      
  
}

    if ($score>=$goal){
      $playing = 0;
         $target_show_handle = $application->remove_show_handler(\&target_show);
         $target_move_handle = $application->remove_move_handler(\&target_move);
         $target_01_show_handle = $application->remove_show_handler(\&target_01_show);
         $target_01_move_handle = $application->remove_move_handler(\&target_01_move);
         $target_02_show_handle = $application->remove_show_handler(\&target_02_show);
         $target_02_move_handle = $application->remove_move_handler(\&target_02_move);
         $target_03_show_handle = $application->remove_show_handler(\&target_03_show);
         $target_03_move_handle = $application->remove_move_handler(\&target_03_move);
         $score=0;
         $background = SDL::Image::load('level 5');
         $background_rect = SDL::Rect->new(0,0, $background->w, $background->h);
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep (2);
         $background = SDL::Image::load('GAME FINISHED IMAGE');
         SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
         SDL::Video::update_rects($application, $background_rect);
         sleep(15);
      $application->stop;

}

}

sub mouse_event {
 my ($event, $application ) = @_;
 my ($mouse_mask,$mouse_x,$mouse_y)  = @{SDL::Events::get_mouse_state()};
 my ($r, $g, $b, $pixel, $hex);

}
}
} 