Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSrw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:52 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 1BF91804E0
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:52 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 05/17] mute: Always keep the videodev and mixer mute in sync
Date: Sat, 13 Feb 2016 19:47:26 +0100
Message-Id: <1455389258-13470-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the "m" hotkey for mute not working on cards where there
is no mute on the videodev, and fixes the last setting for mute not
being properly restored on the next run.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/commands.c       |  9 +--------
 src/tvtime-scanner.c |  5 +----
 src/tvtime.c         | 11 ++++-------
 src/videoinput.c     | 32 +++++++++++++++++++++-----------
 src/videoinput.h     |  4 ++--
 5 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/src/commands.c b/src/commands.c
index 586d2c7..9ed6b44 100644
--- a/src/commands.c
+++ b/src/commands.c
@@ -3020,14 +3020,6 @@ void commands_handle( commands_t *cmd, int tvtime_cmd, const char *arg )
         }
         break;
 
-    case TVTIME_MIXER_TOGGLE_MUTE:
-        mixer_mute( !mixer->ismute() );
-
-        if( cmd->osd ) {
-            tvtime_osd_show_data_bar( cmd->osd, _("Volume"), (mixer->get_volume()) & 0xff );
-        }
-        break;
-
     case TVTIME_MIXER_UP:
 
         /* If the user increases the volume, drop us out of mute mode. */
@@ -3050,6 +3042,7 @@ void commands_handle( commands_t *cmd, int tvtime_cmd, const char *arg )
         }
         break;
 
+    case TVTIME_MIXER_TOGGLE_MUTE:
     case TVTIME_TOGGLE_MUTE:
         if( cmd->vidin ) {
             videoinput_mute( cmd->vidin, !videoinput_get_muted( cmd->vidin ) );
diff --git a/src/tvtime-scanner.c b/src/tvtime-scanner.c
index fefae00..371d668 100644
--- a/src/tvtime-scanner.c
+++ b/src/tvtime-scanner.c
@@ -105,10 +105,7 @@ int main( int argc, char **argv )
         return 1;
     }
 
-    vidin = videoinput_new( config_get_v4l_device( cfg ), 
-                            config_get_inputwidth( cfg ), 
-                            config_get_audio_boost( cfg ), 
-                            norm, verbose, error_string );
+    vidin = videoinput_new( cfg, norm, verbose, error_string );
     if( !vidin ) {
         station_delete( stationmgr );
         config_delete( cfg );
diff --git a/src/tvtime.c b/src/tvtime.c
index b6b1017..afc8940 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -1321,10 +1321,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     /* Default to a width specified on the command line. */
     width = config_get_inputwidth( ct );
 
-    vidin = videoinput_new( config_get_v4l_device( ct ), 
-                            config_get_inputwidth( ct ), 
-                            config_get_audio_boost( ct ), 
-                            norm, verbose, error_string2 );
+    vidin = videoinput_new( ct, norm, verbose, error_string2 );
     if( !vidin ) {
         if( asprintf( &error_string,
                       _("Cannot open capture device %s."),
@@ -2549,10 +2546,10 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     snprintf( number, 6, "%d", mixer->get_unmute_volume() );
     config_save( ct, "UnmuteVolume", number );
 
-    snprintf( number, 4, "%d", mixer->ismute() );
-    config_save( ct, "Muted", number );
-
     if( vidin ) {
+        snprintf( number, 4, "%d", videoinput_get_muted( vidin ) );
+        config_save( ct, "Muted", number );
+
         snprintf( number, 4, "%d", videoinput_get_input_num( vidin ) );
         config_save( ct, "V4LInput", number );
 
diff --git a/src/videoinput.c b/src/videoinput.c
index e3ad7d1..0af6ab7 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -312,14 +312,19 @@ int videoinput_buffer_invalid( videoinput_t *vidin, int frameid )
     return vidin->capbuffers[ frameid ].free;
 }
 
-videoinput_t *videoinput_new( const char *v4l_device, int capwidth,
-                              int volume, int norm, int verbose, char *error_string )
+videoinput_t *videoinput_new( config_t *cfg, int norm, int verbose,
+                              char *error_string )
 {
     videoinput_t *vidin = malloc( sizeof( videoinput_t ) );
     struct v4l2_capability caps_v4l2;
     struct v4l2_input in;
     int i;
 
+    const char *v4l_device = config_get_v4l_device( cfg );
+    int capwidth = config_get_inputwidth( cfg );
+    int volume = config_get_audio_boost( cfg );
+    int user_muted = config_get_muted( cfg );
+
     if( capwidth & 1 ) {
         capwidth -= 1;
         if( verbose ) {
@@ -355,7 +360,7 @@ videoinput_t *videoinput_new( const char *v4l_device, int capwidth,
     vidin->signal_recover_wait = 0;
     vidin->signal_acquire_wait = 0;
     vidin->change_muted = 1;
-    vidin->user_muted = 0;
+    vidin->user_muted = user_muted;
     vidin->hw_muted = 1;
     vidin->hasaudio = 1;
     vidin->audiomode = 0;
@@ -698,8 +703,13 @@ void videoinput_set_saturation_relative( videoinput_t *vidin, int offset )
     }
 }
 
-static void videoinput_do_mute( videoinput_t *vidin, int mute )
+static void videoinput_do_mute( videoinput_t *vidin )
 {
+    int mute = vidin->user_muted || vidin->change_muted;
+
+    if( mute )
+        mixer_mute( 1 );
+
     if( vidin->hasaudio && mute != vidin->hw_muted ) {
 	struct v4l2_control control;
 
@@ -717,6 +727,9 @@ static void videoinput_do_mute( videoinput_t *vidin, int mute )
 	}
         vidin->hw_muted = mute;
     }
+
+    if( !mute )
+        mixer_mute( 0 );
 }
 
 /* freqKHz is in KHz (duh) */
@@ -739,8 +752,7 @@ void videoinput_set_tuner_freq( videoinput_t *vidin, int freqKHz )
         }
 
         vidin->change_muted = 1;
-        mixer_mute( 1 );
-        videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
+        videoinput_do_mute( vidin );
         vidin->cur_tuner_state = TUNER_STATE_SIGNAL_DETECTED;
         vidin->signal_acquire_wait = SIGNAL_ACQUIRE_DELAY;
         vidin->signal_recover_wait = 0;
@@ -911,8 +923,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
         default:
             if( vidin->change_muted ) {
                 vidin->change_muted = 0;
-                videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
-                mixer_mute( 0 );
+                videoinput_do_mute( vidin );
             }
             break;
         }
@@ -923,8 +934,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
             vidin->cur_tuner_state = TUNER_STATE_SIGNAL_LOST;
             vidin->signal_recover_wait = SIGNAL_RECOVER_DELAY;
             vidin->change_muted = 1;
-            mixer_mute( 1 );
-            videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
+            videoinput_do_mute( vidin );
         case TUNER_STATE_SIGNAL_LOST:
             if( vidin->signal_recover_wait ) {
                 vidin->signal_recover_wait--;
@@ -960,7 +970,7 @@ void videoinput_switch_pal_secam( videoinput_t *vidin, int norm )
 void videoinput_mute( videoinput_t *vidin, int mute )
 {
     vidin->user_muted = mute;
-    videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
+    videoinput_do_mute( vidin );
 }
 
 int videoinput_get_muted( videoinput_t *vidin )
diff --git a/src/videoinput.h b/src/videoinput.h
index 7187deb..808896d 100644
--- a/src/videoinput.h
+++ b/src/videoinput.h
@@ -24,6 +24,7 @@
 #else
 # include <stdint.h>
 #endif
+#include "tvtimeconf.h"
 
 #ifdef __cplusplus
 extern "C" {
@@ -108,8 +109,7 @@ const char *videoinput_get_audio_mode_name( videoinput_t *vidin, int mode );
  * The verbose flag indicates we should print to stderr when things go
  * bad, and maybe for some helpful information messages.
  */
-videoinput_t *videoinput_new( const char *v4l_device, int capwidth,
-                              int volume, int norm, int verbose,
+videoinput_t *videoinput_new( config_t *cfg, int norm, int verbose,
                               char *error_string );
 
 /**
-- 
2.5.0

