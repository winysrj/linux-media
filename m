Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbcBMSsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:09 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 66F3A8E371
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:09 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 13/17] Remove the defunct (empty) audiomode menu
Date: Sat, 13 Feb 2016 19:47:34 +0100
Message-Id: <1455389258-13470-13-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the defunct (empty) audiomode menu and related helper functions.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/commands.c   | 41 ++++++++++++-----------------------------
 src/tvtime.c     |  1 -
 src/tvtimeconf.c | 13 -------------
 src/tvtimeconf.h |  1 -
 4 files changed, 12 insertions(+), 44 deletions(-)

diff --git a/src/commands.c b/src/commands.c
index 9ed6b44..0fc6adb 100644
--- a/src/commands.c
+++ b/src/commands.c
@@ -610,12 +610,6 @@ static void reset_pal_input_menu( menu_t *menu, videoinput_t *vidin, station_mgr
     char string[ 128 ];
     int cur = 2;
 
-    snprintf( string, sizeof( string ), TVTIME_ICON_STATIONMANAGEMENT "  %s",
-              _("Preferred audio mode") );
-    menu_set_text( menu, cur, string );
-    menu_set_enter_command( menu, cur, TVTIME_SHOW_MENU, "audiomode" );
-    cur++;
-
     if( videoinput_is_v4l2( vidin ) ) {
         const char *curnorm = "PAL-BG";
         int defnorm = station_get_default_audio_norm( stationmgr );
@@ -1272,39 +1266,34 @@ commands_t *commands_new( config_t *cfg, videoinput_t *vidin,
     menu_set_enter_command( menu, 1, TVTIME_TOGGLE_INPUT, "" );
 
     snprintf( string, sizeof( string ), TVTIME_ICON_STATIONMANAGEMENT "  %s",
-              _("Preferred audio mode") );
-    menu_set_text( menu, 2, string );
-    menu_set_enter_command( menu, 2, TVTIME_SHOW_MENU, "audiomode" );
-
-    snprintf( string, sizeof( string ), TVTIME_ICON_STATIONMANAGEMENT "  %s",
               _("Audio volume boost") );
-    menu_set_text( menu, 3, string );
-    menu_set_enter_command( menu, 3, TVTIME_SHOW_MENU, "audioboost" );
+    menu_set_text( menu, 2, string );
+    menu_set_enter_command( menu, 2, TVTIME_SHOW_MENU, "audioboost" );
 
     snprintf( string, sizeof( string ), TVTIME_ICON_TELEVISIONSTANDARD "  %s",
               _("Television standard") );
-    menu_set_text( menu, 4, string );
-    menu_set_enter_command( menu, 4, TVTIME_SHOW_MENU, "norm" );
+    menu_set_text( menu, 3, string );
+    menu_set_enter_command( menu, 3, TVTIME_SHOW_MENU, "norm" );
 
     snprintf( string, sizeof( string ), TVTIME_ICON_INPUTWIDTH "  %s",
               _("Horizontal resolution") );
-    menu_set_text( menu, 5, string );
-    menu_set_enter_command( menu, 5, TVTIME_SHOW_MENU, "hres" );
+    menu_set_text( menu, 4, string );
+    menu_set_enter_command( menu, 4, TVTIME_SHOW_MENU, "hres" );
 
     snprintf( string, sizeof( string ), TVTIME_ICON_CLOSEDCAPTIONICON "  %s",
               _("Toggle closed captions") );
-    menu_set_text( menu, 6, string );
-    menu_set_enter_command( menu, 6, TVTIME_TOGGLE_CC, "" );
+    menu_set_text( menu, 5, string );
+    menu_set_enter_command( menu, 5, TVTIME_TOGGLE_CC, "" );
 
     snprintf( string, sizeof( string ), TVTIME_ICON_TVPGICON "  %s",
               _("Toggle XDS decoding") );
-    menu_set_text( menu, 7, string );
-    menu_set_enter_command( menu, 7, TVTIME_TOGGLE_XDS, "" );
+    menu_set_text( menu, 6, string );
+    menu_set_enter_command( menu, 6, TVTIME_TOGGLE_XDS, "" );
 
     snprintf( string, sizeof( string ), TVTIME_ICON_PLAINLEFTARROW "  %s",
               _("Back") );
-    menu_set_text( menu, 8, string );
-    menu_set_enter_command( menu, 8, TVTIME_SHOW_MENU, "root" );
+    menu_set_text( menu, 7, string );
+    menu_set_enter_command( menu, 7, TVTIME_SHOW_MENU, "root" );
 
     commands_add_menu( cmd, menu );
 
@@ -1337,12 +1326,6 @@ commands_t *commands_new( config_t *cfg, videoinput_t *vidin,
     reset_inputwidth_menu( commands_get_menu( cmd, "hres" ),
                            config_get_inputwidth( cfg ), maxwidth);
 
-    menu = menu_new( "audiomode" );
-    snprintf( string, sizeof( string ), "%s - %s - %s",
-              _("Setup"), _("Input configuration"), _("Preferred audio mode") );
-    menu_set_text( menu, 0, string );
-    commands_add_menu( cmd, menu );
-
     menu = menu_new( "audioboost" );
     snprintf( string, sizeof( string ), "%s - %s - %s",
               _("Setup"), _("Input configuration"), _("Audio volume boost") );
diff --git a/src/tvtime.c b/src/tvtime.c
index 1cc1681..e564963 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -1338,7 +1338,6 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
         videoinput_delete( vidin );
         vidin = 0;
      } else {
-        const char *audiomode = config_get_audio_mode( ct );
         videoinput_set_input_num( vidin, config_get_inputnum( ct ) );
 
         width = videoinput_get_width( vidin );
diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index 7f8fed5..773a8f2 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -104,7 +104,6 @@ struct config_s
     char *freq;
     char *ssdir;
     char *timeformat;
-    char *audiomode;
     char *xmltvfile;
     char *xmltvlanguage;
     unsigned int channel_text_rgb;
@@ -270,11 +269,6 @@ static void parse_option( config_t *ct, xmlNodePtr node )
             ct->send_fields = atoi( curval );
         }
 
-        if( !xmlStrcasecmp( name, BAD_CAST "AudioMode" ) ) {
-            if( ct->audiomode ) free( ct->audiomode );
-            ct->audiomode = strdup( curval );
-        }
-
         if( !xmlStrcasecmp( name, BAD_CAST "XMLTVFile" ) ) {
             if( ct->xmltvfile ) free( ct->xmltvfile );
             ct->xmltvfile = expand_user_path( curval );
@@ -802,7 +796,6 @@ config_t *config_new( void )
     } else {
         ct->ssdir = 0;
     }
-    ct->audiomode = strdup( "stereo" );
     ct->xmltvfile = strdup( "none" );
     ct->xmltvlanguage = strdup( "none" );
     ct->timeformat = strdup( "%X" );
@@ -1355,7 +1348,6 @@ void config_free_data( config_t *ct )
     if( ct->norm ) free( ct->norm );
     if( ct->freq ) free( ct->freq );
     if( ct->ssdir ) free( ct->ssdir );
-    if( ct->audiomode ) free( ct->audiomode );
     if( ct->xmltvfile ) free( ct->xmltvfile );
     if( ct->xmltvlanguage ) free( ct->xmltvlanguage );
     if( ct->timeformat ) free( ct->timeformat );
@@ -1705,11 +1697,6 @@ int config_get_global_hue( config_t *ct )
     return ct->hue;
 }
 
-const char *config_get_audio_mode( config_t *ct )
-{
-    return ct->audiomode;
-}
-
 const char *config_get_xmltv_file( config_t *ct )
 {
     return ct->xmltvfile;
diff --git a/src/tvtimeconf.h b/src/tvtimeconf.h
index 92dc211..ba81311 100644
--- a/src/tvtimeconf.h
+++ b/src/tvtimeconf.h
@@ -177,7 +177,6 @@ int config_get_global_brightness( config_t *ct );
 int config_get_global_contrast( config_t *ct );
 int config_get_global_saturation( config_t *ct );
 int config_get_global_hue( config_t *ct );
-const char *config_get_audio_mode( config_t *ct );
 const char *config_get_xmltv_file( config_t *ct );
 const char *config_get_xmltv_language( config_t *ct );
 double config_get_overscan( config_t *ct );
-- 
2.5.0

