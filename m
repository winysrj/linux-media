Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSru (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:50 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 05ED08E258
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:50 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 04/17] mute: Enable / disable digital loopback on mute
Date: Sat, 13 Feb 2016 19:47:25 +0100
Message-Id: <1455389258-13470-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes muting work properly with the alsa digital loopback.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/Makefile.am      |  3 +--
 src/commands.c       |  2 +-
 src/mixer.c          | 43 +++++++++++++++++++++++++++++++++++++++++--
 src/mixer.h          |  6 +++++-
 src/tvtime-scanner.c |  5 +++++
 src/tvtime.c         | 18 +++---------------
 src/videoinput.c     |  6 +++---
 7 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 4b4612f..bf05b90 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -94,8 +94,7 @@ tvtime_configure_SOURCES = utils.h utils.c tvtimeconf.h tvtimeconf.c \
 tvtime_configure_CFLAGS = $(OPT_CFLAGS) $(XML2_FLAG) $(AM_CFLAGS)
 tvtime_configure_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS)
 tvtime_scanner_SOURCES = utils.h utils.c videoinput.h videoinput.c \
-	tvtimeconf.h tvtimeconf.c station.h station.c tvtime-scanner.c \
-	mixer.h mixer.c
+	tvtimeconf.h tvtimeconf.c station.h station.c tvtime-scanner.c
 tvtime_scanner_CFLAGS = $(OPT_CFLAGS) $(XML2_FLAG) $(ALSA_CFLAGS) $(AM_CFLAGS)
 tvtime_scanner_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS) $(ALSA_LIBS)
 
diff --git a/src/commands.c b/src/commands.c
index 841bb5b..586d2c7 100644
--- a/src/commands.c
+++ b/src/commands.c
@@ -3021,7 +3021,7 @@ void commands_handle( commands_t *cmd, int tvtime_cmd, const char *arg )
         break;
 
     case TVTIME_MIXER_TOGGLE_MUTE:
-        mixer->mute( !mixer->ismute() );
+        mixer_mute( !mixer->ismute() );
 
         if( cmd->osd ) {
             tvtime_osd_show_data_bar( cmd->osd, _("Volume"), (mixer->get_volume()) & 0xff );
diff --git a/src/mixer.c b/src/mixer.c
index 901ef78..06e61a2 100644
--- a/src/mixer.c
+++ b/src/mixer.c
@@ -19,7 +19,10 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <stdio.h>
+#include "alsa_stream.h"
 #include "mixer.h"
+#include "tvtimeconf.h"
 
 /**
  * Sets the mixer device and channel.
@@ -104,14 +107,21 @@ static struct mixer *mixers[] = {
 /* The actual access method. */
 struct mixer *mixer = &null_mixer;
 
+/* Config settings */
+config_t *mixer_cfg;
+
 /**
  * Sets the mixer device and channel.
  * Try each access method until one succeeds.
  */
-void mixer_set_device( const char *devname )
+void mixer_init( config_t *cfg )
 {
+    const char *devname;
     int i;
-    mixer->close_device();
+
+    mixer_cfg = cfg;
+    devname = config_get_mixer_device( mixer_cfg );
+
     for (i = 0; i < sizeof(mixers)/sizeof(mixers[0]); i++) {
         mixer = mixers[i];
         if (!mixer)
@@ -119,4 +129,33 @@ void mixer_set_device( const char *devname )
         if (mixer->set_device(devname) == 0)
             break;
     }
+
+    /* Always start muted, video_input.c will unmute later */
+    mixer->set_state( 1, config_get_unmute_volume( mixer_cfg ) );
+}
+
+void mixer_exit( void )
+{
+    alsa_thread_stop();
+
+    if( config_get_mute_on_exit( mixer_cfg ) ) {
+        mixer->mute( 1 );
+    }
+
+    mixer->close_device();
+}
+
+void mixer_mute( int mute )
+{
+    if( mute ) {
+        alsa_thread_stop();
+        mixer->mute( 1 );
+    } else {
+        mixer->mute( 0 );
+        alsa_thread_startup( config_get_alsa_outputdev( mixer_cfg ),
+                             config_get_alsa_inputdev( mixer_cfg ),
+                             config_get_alsa_latency( mixer_cfg ),
+                             stderr,
+                             config_get_verbose( mixer_cfg ) );
+    }
 }
diff --git a/src/mixer.h b/src/mixer.h
index a26fc88..9b5365a 100644
--- a/src/mixer.h
+++ b/src/mixer.h
@@ -22,6 +22,8 @@
 #ifndef MIXER_H_INCLUDED
 #define MIXER_H_INCLUDED
 
+#include "tvtimeconf.h"
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -30,7 +32,9 @@ extern "C" {
  * Sets the mixer device and channel.
  * All interfaces are scanned until one succeeds.
  */
-void mixer_set_device( const char *devname );
+void mixer_init( config_t *cfg );
+void mixer_exit( void );
+void mixer_mute( int mute );
 
 struct mixer {
 /**
diff --git a/src/tvtime-scanner.c b/src/tvtime-scanner.c
index fbecc7e..fefae00 100644
--- a/src/tvtime-scanner.c
+++ b/src/tvtime-scanner.c
@@ -40,6 +40,11 @@
 #include "station.h"
 #include "utils.h"
 
+/* Dummy mixer_mute for video_input.c */
+void mixer_mute( int mute )
+{
+}
+
 int main( int argc, char **argv )
 {
     config_t *cfg;
diff --git a/src/tvtime.c b/src/tvtime.c
index e0c5e62..b6b1017 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -77,7 +77,6 @@
 #include "mm_accel.h"
 #include "menu.h"
 #include "tvtimeglyphs.h"
-#include "alsa_stream.h"
 
 /**
  * This is how many frames to wait until deciding if the pulldown phase
@@ -1254,12 +1253,6 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
         return 1;
     }
 
-    /* Setup the ALSA streaming device */
-    alsa_thread_startup(config_get_alsa_outputdev( ct ),
-			config_get_alsa_inputdev( ct ),
-			config_get_alsa_latency( ct ),
-			stderr, verbose );
-
     /* Setup the speedy calls. */
     setup_speedy_calls( mm_accel(), verbose );
 
@@ -1426,9 +1419,8 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     blit_packed422_scanline( saveframe, blueframe, width * height );
     secondlastframe = lastframe = blueframe;
 
-    /* Set the mixer device. */
-    mixer_set_device( config_get_mixer_device( ct ) );
-    mixer->set_state( config_get_muted( ct ), config_get_unmute_volume( ct ) );
+    /* Init the mixer (and alsa digital loopback) */
+    mixer_init( ct );
 
     /* Setup OSD stuff. */
     pixel_aspect = ( (double) width ) /
@@ -2560,10 +2552,6 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     snprintf( number, 4, "%d", mixer->ismute() );
     config_save( ct, "Muted", number );
 
-    if( config_get_mute_on_exit( ct ) ) {
-        mixer->mute( 1 );
-    }
-
     if( vidin ) {
         snprintf( number, 4, "%d", videoinput_get_input_num( vidin ) );
         config_save( ct, "V4LInput", number );
@@ -2598,7 +2586,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     if( osd ) {
         tvtime_osd_delete( osd );
     }
-    mixer->close_device();
+    mixer_exit();
 
     /* Free temporary memory. */
     free( colourbars );
diff --git a/src/videoinput.c b/src/videoinput.c
index 9ac97da..e3ad7d1 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -739,7 +739,7 @@ void videoinput_set_tuner_freq( videoinput_t *vidin, int freqKHz )
         }
 
         vidin->change_muted = 1;
-        mixer->mute( 1 );
+        mixer_mute( 1 );
         videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
         vidin->cur_tuner_state = TUNER_STATE_SIGNAL_DETECTED;
         vidin->signal_acquire_wait = SIGNAL_ACQUIRE_DELAY;
@@ -912,7 +912,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
             if( vidin->change_muted ) {
                 vidin->change_muted = 0;
                 videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
-                mixer->mute( 0 );
+                mixer_mute( 0 );
             }
             break;
         }
@@ -923,7 +923,7 @@ int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
             vidin->cur_tuner_state = TUNER_STATE_SIGNAL_LOST;
             vidin->signal_recover_wait = SIGNAL_RECOVER_DELAY;
             vidin->change_muted = 1;
-            mixer->mute( 1 );
+            mixer_mute( 1 );
             videoinput_do_mute( vidin, vidin->user_muted || vidin->change_muted );
         case TUNER_STATE_SIGNAL_LOST:
             if( vidin->signal_recover_wait ) {
-- 
2.5.0

