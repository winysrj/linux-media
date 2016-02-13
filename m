Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:11 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 7AD8E13A6A
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:11 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 14/17] Save/restore output matte setting on exit/startup
Date: Sat, 13 Feb 2016 19:47:35 +0100
Message-Id: <1455389258-13470-14-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Save/restore output matte setting on exit/startup and while at it
define a default hotkey for toggling through the matte modes.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/commands.c   |  5 +++++
 src/tvtime.c     | 19 +++++++++++++++++--
 src/tvtimeconf.c | 14 ++++++++++++++
 src/tvtimeconf.h |  1 +
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/src/commands.c b/src/commands.c
index 0fc6adb..893a120 100644
--- a/src/commands.c
+++ b/src/commands.c
@@ -1057,7 +1057,12 @@ commands_t *commands_new( config_t *cfg, videoinput_t *vidin,
     cmd->checkfreq = config_get_check_freq_present( cfg );
     cmd->usexds = config_get_usexds( cfg );
     cmd->pulldown_alg = 0;
+
     memset( cmd->newmatte, 0, sizeof( cmd->newmatte ) );
+    if( config_get_matte( cfg ) ) {
+        strcpy( cmd->newmatte, config_get_matte( cfg ) );
+    }
+
     memset( cmd->newpos, 0, sizeof( cmd->newpos ) );
 
     /* Number of frames to wait for next channel digit. */
diff --git a/src/tvtime.c b/src/tvtime.c
index e564963..1905387 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -1751,6 +1751,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
                           _("16:9 display mode active.") );
                 }
                 config_save( ct, "WideScreen", "1" );
+                config_save( ct, "Matte", "16:9" );
                 pixel_aspect = ( (double) width ) /
                     ( ( (double) height ) * (16.0 / 9.0) );
             } else {
@@ -1760,6 +1761,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
                           _("4:3 display mode active.") );
                 }
                 config_save( ct, "WideScreen", "0" );
+                config_save( ct, "Matte", "4:3" );
                 pixel_aspect =
                     ( (double) width ) / ( ( (double) height ) * (4.0 / 3.0) );
             }
@@ -1846,12 +1848,16 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
             if( sixteennine ) {
                 if( matte_mode == 0 ) {
                     matte = 16.0 / 9.0;
+                    config_save( ct, "Matte", "16:9" );
                 } else if( matte_mode == 1 ) {
                     matte = 1.85;
+                    config_save( ct, "Matte", "1.85:1" );
                 } else if( matte_mode == 2 ) {
                     matte = 2.35;
+                    config_save( ct, "Matte", "2.35:1" );
                 } else if( matte_mode == 3 ) {
                     matte = 4.0 / 3.0;
+                    config_save( ct, "Matte", "4:3" );
                     matte_w = (int) (((double) sqheight * matte) + 0.5);
                     matte_x = (width - matte_w) / 2;
                     /* We're cropping the sides off so we add overscan to avoid mess
@@ -1861,6 +1867,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
                     output->set_matte( (matte_h * 4) / 3, matte_h );
                 } else if( matte_mode == 4 ) {
                     matte = 1.6;
+                    config_save( ct, "Matte", "16:10" );
                     matte_w = (int) (((double) sqheight * matte) + 0.5);
                     matte_x = (width - matte_w) / 2;
                     /* We're cropping the sides off so we add overscan to avoid mess
@@ -1870,14 +1877,21 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
                     output->set_matte( (matte_h * 16) / 10, matte_h );
                 }
             } else {
-                if( matte_mode == 1 ) {
+                if( matte_mode == 0 ) {
+                    matte = 4.0 / 3.0;
+                    config_save( ct, "Matte", "4:3" );
+                } else if( matte_mode == 1 ) {
                     matte = 16.0 / 9.0;
+                    config_save( ct, "Matte", "16:9" );
                 } else if( matte_mode == 2 ) {
                     matte = 1.6;
+                    config_save( ct, "Matte", "16:10" );
                 } else if( matte_mode == 3 ) {
                     matte = 1.85;
+                    config_save( ct, "Matte", "1.85:1" );
                 } else if( matte_mode == 4 ) {
                     matte = 2.35;
+                    config_save( ct, "Matte", "2.35:1" );
                 }
             }
             if( !matte_x ) {
@@ -1885,7 +1899,8 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
                 matte_y = (height - matte_h) / 2;
                 output->set_matte( sqwidth, matte_h );
             }
-            if( osd && !commands_menu_active( commands ) ) {
+            if( osd && last_current_id != -1 &&
+                    !commands_menu_active( commands ) ) {
                 osd_list_matte( osd, matte_mode, sixteennine );
             }
             build_matte_menu( commands_get_menu( commands, "matte" ),
diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index 773a8f2..3814a3b 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -125,6 +125,7 @@ struct config_s
     int slave_mode;
 
     double overscan;
+    char *matte;
 
     char *config_filename;
     xmlDocPtr doc;
@@ -409,6 +410,11 @@ static void parse_option( config_t *ct, xmlNodePtr node )
             setlocale( LC_NUMERIC, prevloc );
         }
 
+        if( !xmlStrcasecmp( name, BAD_CAST "Matte" ) ) {
+            if( ct->matte ) free( ct->matte );
+            ct->matte = strdup( curval );
+        }
+
         if( !xmlStrcasecmp( name, BAD_CAST "MixerDevice" ) ) {
             if( ct->mixerdev ) free( ct->mixerdev );
             ct->mixerdev = strdup( curval );
@@ -818,6 +824,7 @@ config_t *config_new( void )
     ct->slave_mode = 0;
 
     ct->overscan = 0.0;
+    ct->matte = NULL;
 
     ct->config_filename = 0;
     ct->doc = 0;
@@ -850,6 +857,7 @@ config_t *config_new( void )
     ct->keymap[ 'd' ] = TVTIME_SHOW_STATS;
     ct->keymap[ 'g' ] = TVTIME_SHOW_EPG;
     ct->keymap[ 'a' ] = TVTIME_TOGGLE_ASPECT;
+    ct->keymap[ I_INSERT ] = TVTIME_TOGGLE_MATTE;
     ct->keymap[ 'f' ] = TVTIME_TOGGLE_FULLSCREEN;
     ct->keymap[ 'i' ] = TVTIME_TOGGLE_INPUT;
     ct->keymap[ 's' ] = TVTIME_SCREENSHOT;
@@ -1353,6 +1361,7 @@ void config_free_data( config_t *ct )
     if( ct->timeformat ) free( ct->timeformat );
     if( ct->mixerdev ) free( ct->mixerdev );
     if( ct->vbidev ) free( ct->vbidev );
+    if( ct->matte ) free( ct->matte );
     if( ct->config_filename ) free( ct->config_filename );
     if( ct->deinterlace_method ) free( ct->deinterlace_method );
     if( ct->alsa_inputdev ) free( ct->alsa_inputdev );
@@ -1642,6 +1651,11 @@ double config_get_overscan( config_t *ct )
     return ct->overscan;
 }
 
+const char *config_get_matte( config_t *ct )
+{
+    return ct->matte;
+}
+
 int config_get_ntsc_cable_mode( config_t *ct )
 {
     return ct->ntsc_mode;
diff --git a/src/tvtimeconf.h b/src/tvtimeconf.h
index ba81311..b56cedc 100644
--- a/src/tvtimeconf.h
+++ b/src/tvtimeconf.h
@@ -180,6 +180,7 @@ int config_get_global_hue( config_t *ct );
 const char *config_get_xmltv_file( config_t *ct );
 const char *config_get_xmltv_language( config_t *ct );
 double config_get_overscan( config_t *ct );
+const char *config_get_matte( config_t *ct );
 int config_get_check_freq_present( config_t *ct );
 int config_get_usexds( config_t *ct );
 int config_get_invert( config_t *ct );
-- 
2.5.0

