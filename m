Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:48 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id EE75A8535A
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:47 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 03/17] alsa_stream: Make latency configurable
Date: Sat, 13 Feb 2016 19:47:24 +0100
Message-Id: <1455389258-13470-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/tvtime.c     |  2 +-
 src/tvtimeconf.c | 23 ++++++++++++++++++++++-
 src/tvtimeconf.h |  1 +
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/src/tvtime.c b/src/tvtime.c
index 116c20a..e0c5e62 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -1257,7 +1257,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     /* Setup the ALSA streaming device */
     alsa_thread_startup(config_get_alsa_outputdev( ct ),
 			config_get_alsa_inputdev( ct ),
-			50,		/* FIXME: Add a var to adjust latency */
+			config_get_alsa_latency( ct ),
 			stderr, verbose );
 
     /* Setup the speedy calls. */
diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index 001351b..3667dd7 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -124,6 +124,7 @@ struct config_s
 
     char *alsa_inputdev;
     char *alsa_outputdev;
+    int alsa_latency;
 };
 
 static unsigned int parse_colour( const char *str )
@@ -421,6 +422,9 @@ static void parse_option( config_t *ct, xmlNodePtr node )
             ct->alsa_outputdev = strdup( curval );
         }
 
+        if( !xmlStrcasecmp( name, BAD_CAST "AlsaLatency" ) ) {
+            ct->alsa_latency = atoi( curval );
+        }
     }
 
     if( name ) xmlFree( name );
@@ -717,6 +721,7 @@ static void print_config_usage( char **argv )
               "                                 Examples:\n"
               "                                          hw:0,0\n"
               "                                          disabled\n"), stderr );
+    lfputs( _("  -z, --alsalatency=LATENCY  Specifies ALSA loopback latency in milli-seconds\n"), stderr );
 }
 
 static void print_scanner_usage( char **argv )
@@ -818,6 +823,7 @@ config_t *config_new( void )
 
     ct->alsa_inputdev = strdup( "hw:1,0" );
     ct->alsa_outputdev = strdup( "default" );
+    ct->alsa_latency = 50;
 
     /* Default key bindings. */
     ct->keymap[ 0 ] = TVTIME_NOCOMMAND;
@@ -1092,6 +1098,7 @@ int config_parse_tvtime_config_command_line( config_t *ct, int argc, char **argv
         { "priority", 2, 0, 'R' },
         { "alsainputdev", 2, 0, 'p' },
         { "alsaoutputdev", 2, 0, 'P' },
+        { "alsalatency", 2, 0, 'z' },
         { 0, 0, 0, 0 }
     };
     int option_index = 0;
@@ -1104,7 +1111,7 @@ int config_parse_tvtime_config_command_line( config_t *ct, int argc, char **argv
     }
 
     while( (c = getopt_long( argc, argv,
-            "aAhmMF:g:I:d:b:i:c:n:D:f:x:t:Ll:R:p:P",
+            "aAhmMF:g:I:d::b::i::c:n::D:f::x:t::Ll::R::p::P::z::",
             long_options, &option_index )) != -1 ) {
         switch( c ) {
         case 'a': ct->aspect = 1; break;
@@ -1206,6 +1213,13 @@ int config_parse_tvtime_config_command_line( config_t *ct, int argc, char **argv
                       ct->alsa_outputdev = strdup( optarg );
                   }
                   break;
+        case 'z': if( !optarg ) {
+                      fprintf( stdout, "AlsaLatency:%d\n", 
+			       config_get_alsa_latency( ct ) );
+                  } else {
+                      ct->alsa_latency = atoi( optarg );
+                  }
+                  break;
         default:
             print_config_usage( argv );
             return 0;
@@ -1277,6 +1291,8 @@ int config_parse_tvtime_config_command_line( config_t *ct, int argc, char **argv
 
         config_save( ct, "AlsaInputDev", ct->alsa_inputdev );
         config_save( ct, "AlsaOutputDev", ct->alsa_outputdev );
+        snprintf( tempstring, sizeof( tempstring ), "%d", ct->alsa_latency );
+        config_save( ct, "AlsaLatency", tempstring );
     }
 
     return 1;
@@ -1754,3 +1770,8 @@ const char *config_get_alsa_outputdev( config_t *ct )
 {
     return ct->alsa_outputdev;
 }
+
+int config_get_alsa_latency( config_t *ct )
+{
+    return ct->alsa_latency;
+}
diff --git a/src/tvtimeconf.h b/src/tvtimeconf.h
index 030d885..92dc211 100644
--- a/src/tvtimeconf.h
+++ b/src/tvtimeconf.h
@@ -195,6 +195,7 @@ int config_get_show_taglines( config_t *ct );
 int config_get_square_pixels( config_t *ct );
 const char *config_get_alsa_inputdev( config_t *ct );
 const char *config_get_alsa_outputdev( config_t *ct );
+int config_get_alsa_latency( config_t *ct );
 
 #ifdef __cplusplus
 };
-- 
2.5.0

