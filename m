Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 54EC6C0AD405
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:07 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 12/17] Fix compiler warnings
Date: Sat, 13 Feb 2016 19:47:33 +0100
Message-Id: <1455389258-13470-12-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix various compiler warnings, a note about the removal of the prefetch
stuff from the speedy code. As the compiler warnings where showing this
was being optimized away anyways, so best to just completely remove it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 plugins/greedy.c      |  1 -
 plugins/linearblend.c |  1 -
 src/Makefile.am       |  2 +-
 src/cpuinfo.c         |  6 ------
 src/mixer-alsa.c      |  1 -
 src/osdtools.c        |  7 ++-----
 src/pnginput.c        | 14 +-------------
 src/pulldown.c        | 16 ----------------
 src/speedtools.h      | 46 ----------------------------------------------
 src/speedy.c          |  7 -------
 src/tvtime-scanner.c  |  6 +-----
 src/vbidata.c         | 34 +++++++++++++++++-----------------
 src/videotools.c      |  8 ++------
 13 files changed, 24 insertions(+), 125 deletions(-)
 delete mode 100644 src/speedtools.h

diff --git a/plugins/greedy.c b/plugins/greedy.c
index 9896a8b..10a251e 100644
--- a/plugins/greedy.c
+++ b/plugins/greedy.c
@@ -35,7 +35,6 @@
 #include "mmx.h"
 #include "mm_accel.h"
 #include "deinterlace.h"
-#include "speedtools.h"
 #include "copyfunctions.h"
 
 // This is a simple lightweight DeInterlace method that uses little CPU time
diff --git a/plugins/linearblend.c b/plugins/linearblend.c
index 70a877e..4b0ad70 100644
--- a/plugins/linearblend.c
+++ b/plugins/linearblend.c
@@ -33,7 +33,6 @@
 #include "attributes.h"
 #include "mmx.h"
 #include "mm_accel.h"
-#include "speedtools.h"
 #include "copyfunctions.h"
 #include "deinterlace.h"
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 931c65c..869ebf3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -40,7 +40,7 @@ COMMON_SRCS = mixer.c videoinput.c rtctimer.c leetft.c osdtools.c tvtimeconf.c \
 	input.h mixer.h mm_accel.h mmx.h osdtools.h pnginput.h pngoutput.h \
 	rtctimer.h speedy.h taglines.h tvtimeconf.h tvtimeosd.h videoinput.h \
 	videotools.h performance.h performance.c vbidata.h vbidata.c \
-	speedtools.h vbiscreen.h vbiscreen.c fifo.h fifo.c commands.h \
+	vbiscreen.h vbiscreen.c fifo.h fifo.c commands.h \
 	commands.c videofilter.h videofilter.c station.h station.c bands.h \
 	utils.h utils.c pulldown.h pulldown.c hashtable.h hashtable.c \
 	cpuinfo.h cpuinfo.c menu.c menu.h \
diff --git a/src/cpuinfo.c b/src/cpuinfo.c
index 5f0c8cd..437e72a 100644
--- a/src/cpuinfo.c
+++ b/src/cpuinfo.c
@@ -196,9 +196,7 @@ static void store32( char *d, unsigned int v )
 void cpuinfo_print_info( void )
 {
     cpuid_regs_t regs, regs_ext;
-    unsigned int max_cpuid;
     unsigned int max_ext_cpuid;
-    unsigned int amd_flags;
     int family, model, stepping;
     char idstr[13];
     char *model_name;
@@ -206,7 +204,6 @@ void cpuinfo_print_info( void )
     int i;
 
     regs = cpuid(0);
-    max_cpuid = regs.eax;
 
     store32(idstr+0, regs.ebx);
     store32(idstr+4, regs.edx);
@@ -225,7 +222,6 @@ void cpuinfo_print_info( void )
 
     if (max_ext_cpuid >= (1<<31) + 1) {
         regs_ext = cpuid((1<<31) + 1);
-        amd_flags = regs_ext.edx;
 
         if (max_ext_cpuid >= (1<<31) + 4) {
             for (i = 2; i <= 4; i++) {
@@ -238,8 +234,6 @@ void cpuinfo_print_info( void )
             processor_name[48] = 0;
             model_name = processor_name;
         }
-    } else {
-        amd_flags = 0;
     }
 
     /* Is this dangerous? */
diff --git a/src/mixer-alsa.c b/src/mixer-alsa.c
index e84a3d0..771a18e 100644
--- a/src/mixer-alsa.c
+++ b/src/mixer-alsa.c
@@ -24,7 +24,6 @@
 #include "utils.h"
 #include "mixer.h"
 
-static const char alsa_core_devnames[] = "default";
 static char *card, *channel;
 static int muted = 0;
 static int mutecount = 0;
diff --git a/src/osdtools.c b/src/osdtools.c
index 3487ce3..1b6d609 100644
--- a/src/osdtools.c
+++ b/src/osdtools.c
@@ -191,11 +191,9 @@ static void osd_string_render_bordered_image4444( osd_string_t *osds, const char
 {
     int stringwidth, stringheight;
     ft_font_t *font = osd_font_get_font( osds->font );
-    int left_x, right_x;
-    int top_y, bottom_y;
+    int right_x, bottom_y;
     int textpos_x, textpos_y;
 
-    left_x = top_y = 0;
     right_x = ft_font_points_to_subpix_width( font, 2 );
     bottom_y = 2;
     textpos_x = ft_font_points_to_subpix_width( font, 1 );
@@ -380,13 +378,12 @@ static int load_png_to_packed4444( uint8_t *buffer, int *active,
                                    double pixel_aspect, pnginput_t *pngin )
 {
     int has_alpha = pnginput_has_alpha( pngin );
-    int pngwidth, pngheight;
+    int pngwidth;
     uint8_t *cb444;
     uint8_t *curout;
     int i;
 
     pngwidth = pnginput_get_width( pngin );
-    pngheight = pnginput_get_height( pngin );
 
     cb444 = malloc( pngwidth * 3 );
     if( !cb444 ) return 0;
diff --git a/src/pnginput.c b/src/pnginput.c
index f357937..e793c76 100644
--- a/src/pnginput.c
+++ b/src/pnginput.c
@@ -31,8 +31,7 @@ struct pnginput_s
 pnginput_t *pnginput_new( const char *filename )
 {
     pnginput_t *pnginput = malloc( sizeof( pnginput_t ) );
-    png_uint_32 width, height;
-    int bit_depth, colour_type, channels, rowbytes;
+    int colour_type;
     double gamma;
 
     if( !pnginput ) return 0;
@@ -71,12 +70,7 @@ pnginput_t *pnginput_new( const char *filename )
     png_read_png( pnginput->png_ptr, pnginput->info_ptr,
                   PNG_TRANSFORM_IDENTITY, 0 );
 
-    width = png_get_image_width( pnginput->png_ptr, pnginput->info_ptr );
-    height = png_get_image_height( pnginput->png_ptr, pnginput->info_ptr );
-    bit_depth = png_get_bit_depth( pnginput->png_ptr, pnginput->info_ptr );
     colour_type = png_get_color_type( pnginput->png_ptr, pnginput->info_ptr );
-    channels = png_get_channels( pnginput->png_ptr, pnginput->info_ptr );
-    rowbytes = png_get_rowbytes( pnginput->png_ptr, pnginput->info_ptr );
 
     png_get_gAMA( pnginput->png_ptr, pnginput->info_ptr, &gamma );
 
@@ -87,12 +81,6 @@ pnginput_t *pnginput_new( const char *filename )
         pnginput->has_alpha = 0;
     }
 
-/*
-    fprintf( stderr, "width %u, height %u, depth %d, "
-                     "colour %d, rowbytes %d, gamma %f\n",
-             width, height, bit_depth, colour_type, rowbytes, gamma );
-*/
-
     return pnginput;
 }
 
diff --git a/src/pulldown.c b/src/pulldown.c
index 6cc9175..b8cc901 100644
--- a/src/pulldown.c
+++ b/src/pulldown.c
@@ -257,7 +257,6 @@ int determine_pulldown_offset_history_new( int top_repeat, int bot_repeat, int t
     int minbotpos = -1;
     int min2botval = -1;
     int min2botpos = -1;
-    int predicted_pos = 0;
 
     tophistory[ histpos ] = top_repeat;
     bothistory[ histpos ] = bot_repeat;
@@ -269,12 +268,6 @@ int determine_pulldown_offset_history_new( int top_repeat, int bot_repeat, int t
     avgtop /= 5;
     avgbot /= 5;
 
-    for( i = 0; i < 5; i++ ) { if( (1<<i) == predicted ) { predicted_pos = i; break; } }
-
-    /*
-    fprintf( stderr, "top: %8d bot: %8d\ttop-avg: %8d bot-avg: %8d (%d)\n", top_repeat, bot_repeat, top_repeat - avgtop, bot_repeat - avgbot, (5 + predicted_pos - reference) % 5 );
-    */
-
     for( j = 0; j < HISTORY_SIZE; j++ ) {
         int cur = tophistory[ j ];
         if( cur < mintopval || mintopval < 0 ) {
@@ -365,7 +358,6 @@ int determine_pulldown_offset_short_history_new( int top_repeat, int bot_repeat,
     int minbotpos = -1;
     int min2botval = -1;
     int min2botpos = -1;
-    int predicted_pos = 0;
 
     tophistory[ histpos ] = top_repeat;
     bothistory[ histpos ] = bot_repeat;
@@ -377,14 +369,6 @@ int determine_pulldown_offset_short_history_new( int top_repeat, int bot_repeat,
     avgtop /= 3;
     avgbot /= 3;
 
-    for( i = 0; i < 5; i++ ) { if( (1<<i) == predicted ) { predicted_pos = i; break; } }
-
-    /*
-    fprintf( stderr, "top: %8d bot: %8d\ttop-avg: %8d bot-avg: %8d (%d)\n",
-             top_repeat, bot_repeat, top_repeat - avgtop, bot_repeat - avgbot,
-             (5 + predicted_pos - reference) % 5 );
-    */
-
     for( j = 0; j < 3; j++ ) {
         int cur = tophistory[ (histpos + 5 - j) % 5 ];
         if( cur < mintopval || mintopval < 0 ) {
diff --git a/src/speedtools.h b/src/speedtools.h
deleted file mode 100644
index 059d8a5..0000000
--- a/src/speedtools.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/**
- * Copyright (c) 2002 Billy Biggs <vektor@dumbterm.net>.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef SPEEDTOOLS_H_INCLUDED
-#define SPEEDTOOLS_H_INCLUDED
-
-#define PREFETCH_2048(x) \
-    { int *pfetcha = (int *) x; \
-        prefetchnta( pfetcha ); \
-        prefetchnta( pfetcha + 64 ); \
-        prefetchnta( pfetcha + 128 ); \
-        prefetchnta( pfetcha + 192 ); \
-        pfetcha += 256; \
-        prefetchnta( pfetcha ); \
-        prefetchnta( pfetcha + 64 ); \
-        prefetchnta( pfetcha + 128 ); \
-        prefetchnta( pfetcha + 192 ); }
-
-#define READ_PREFETCH_2048(x) \
-    { int *pfetcha = (int *) x; int pfetchtmp; \
-        pfetchtmp = pfetcha[ 0 ] + pfetcha[ 16 ] + pfetcha[ 32 ] + pfetcha[ 48 ] + \
-            pfetcha[ 64 ] + pfetcha[ 80 ] + pfetcha[ 96 ] + pfetcha[ 112 ] + \
-            pfetcha[ 128 ] + pfetcha[ 144 ] + pfetcha[ 160 ] + pfetcha[ 176 ] + \
-            pfetcha[ 192 ] + pfetcha[ 208 ] + pfetcha[ 224 ] + pfetcha[ 240 ]; \
-        pfetcha += 256; \
-        pfetchtmp = pfetcha[ 0 ] + pfetcha[ 16 ] + pfetcha[ 32 ] + pfetcha[ 48 ] + \
-            pfetcha[ 64 ] + pfetcha[ 80 ] + pfetcha[ 96 ] + pfetcha[ 112 ] + \
-            pfetcha[ 128 ] + pfetcha[ 144 ] + pfetcha[ 160 ] + pfetcha[ 176 ] + \
-            pfetcha[ 192 ] + pfetcha[ 208 ] + pfetcha[ 224 ] + pfetcha[ 240 ]; }
-
-#endif /* SPEEDTOOLS_H_INCLUDED */
diff --git a/src/speedy.c b/src/speedy.c
index e429910..2c85dc4 100644
--- a/src/speedy.c
+++ b/src/speedy.c
@@ -47,7 +47,6 @@
 #endif
 
 #include "speedy.h"
-#include "speedtools.h"
 #include "copyfunctions.h"
 #include "attributes.h"
 #include "mmx.h"
@@ -1036,9 +1035,6 @@ static void composite_packed4444_alpha_to_packed422_scanline_mmxext( uint8_t *ou
         return;
     }
 
-    READ_PREFETCH_2048( input );
-    READ_PREFETCH_2048( foreground );
-
     movq_m2r( alpha, mm2 );
     pshufw_r2r( mm2, mm2, 0 );
     pxor_r2r( mm7, mm7 );
@@ -1166,9 +1162,6 @@ static void composite_packed4444_to_packed422_scanline_mmxext( uint8_t *output,
     const mmx_t round  = { 0x0080008000800080ULL };
     int i;
 
-    READ_PREFETCH_2048( input );
-    READ_PREFETCH_2048( foreground );
-
     pxor_r2r( mm7, mm7 );
     for( i = width/2; i; i-- ) {
         int fg1 = *((uint32_t *) foreground);
diff --git a/src/tvtime-scanner.c b/src/tvtime-scanner.c
index 371d668..0c1a154 100644
--- a/src/tvtime-scanner.c
+++ b/src/tvtime-scanner.c
@@ -50,7 +50,7 @@ int main( int argc, char **argv )
     config_t *cfg;
     station_mgr_t *stationmgr = 0;
     videoinput_t *vidin;
-    int fi, on, tuned;
+    int on, tuned;
     int f, f1, f2, fc;
     int verbose, norm;
     int curstation = 1;
@@ -132,7 +132,6 @@ int main( int argc, char **argv )
     fc = 0;
     f1 = 0;
     f2 = 0;
-    fi = -1;
 
     for( f = 44*16; f <= 958*16; f += 4 ) {
         char stationmhz[ 128 ];
@@ -150,13 +149,11 @@ int main( int argc, char **argv )
         if( 0 == on && 0 != tuned ) {
             fprintf( stderr, "  + %-30s\r", _("Signal detected") );
             f1 = f;
-            /* if( i != chancount ) { fi = i; fc = f; } */
             on = 1;
             continue;
         }
         if( 0 != on && 0 != tuned ) {
             fprintf( stderr, "  * %-30s\r", _("Signal detected") );
-            /* if( i != chancount ) { fi = i; fc = f; } */
             continue;
         }
         /* if (on != 0 && 0 == tuned)  --  found one, read name from vbi */
@@ -181,7 +178,6 @@ int main( int argc, char **argv )
         fc = 0;
         f1 = 0;
         f2 = 0;
-        fi = -1;
     }
 
     station_delete( stationmgr );
diff --git a/src/vbidata.c b/src/vbidata.c
index 2fe6a2d..fba820f 100644
--- a/src/vbidata.c
+++ b/src/vbidata.c
@@ -615,7 +615,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
             }
 
             vbi->current_chan = (b1 & 8) >> 3;
-            if( !bottom == vbi->wanttop ) {
+            if( (!bottom) == vbi->wanttop ) {
                 if( vbi->chan != vbi->current_chan )
                     return 0;
             } else return 0;
@@ -636,7 +636,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                      vbi->current_ital, vbi->current_ul, vbi->current_colour,
                      vbi->current_indent, vbi->current_row );
 
-            if( !bottom == vbi->wanttop && 
+            if( (!bottom) == vbi->wanttop && 
                 vbi->current_chan == vbi->chan && 
                 vbi->current_istext == vbi->wanttext ) {
 
@@ -681,7 +681,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
 
             if( vbi->verbose ) fprintf( stderr, "Tab Offset: %d columns\n", b2 & 3 );
             if( vbi->wanttext && vbi->current_istext && 
-                vbi->current_chan == vbi->chan && !bottom == vbi->wanttop ) {
+                vbi->current_chan == vbi->chan && (!bottom) == vbi->wanttop ) {
                 vbiscreen_tab( vbi->vs, b2 & 3 );
             }
             vbi->lastcode = ( b1 << 8) | b2;
@@ -705,7 +705,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
             switch( code ) {
             case 0: /* POP-UP */
                 if( !vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Pop-Up\n");
                     vbi->indent = vbi->current_indent;
@@ -718,7 +718,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 5: /* ROLL UP 2 */ 
                 if( !vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Roll-Up 2 (RU2)\n");
                     vbi->indent = vbi->current_indent;
@@ -731,7 +731,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 6: /* ROLL UP 3 */ 
                 if( !vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Roll-Up 3 (RU3)\n");
                     vbi->indent = vbi->current_indent;
@@ -744,7 +744,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 7: /* ROLL UP 4 */ 
                 if( !vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Roll-Up 4 (RU4)\n");
                     vbi->indent = vbi->current_indent;
@@ -757,7 +757,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 9: /* PAINT-ON */
                 if( !vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Paint-On\n");
                     vbi->indent = vbi->current_indent;
@@ -770,7 +770,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 10:/* TEXT */
                 if( vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Text Restart\n");
                     vbi->indent = vbi->current_indent;
@@ -783,7 +783,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 11:/* TEXT */
                 if( vbi->wanttext && vbi->current_chan == vbi->chan &&
-                    !bottom == vbi->wanttop ) {
+                    (!bottom) == vbi->wanttop ) {
                     if( vbi->verbose )
                         fprintf( stderr, "Resume Text Display\n");
                     vbi->indent = vbi->current_indent;
@@ -803,7 +803,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
             if( !bottom && vbi->lastcode == ( (b1 << 8) | b2 ) ) {
                 vbi->lastcount = (vbi->lastcount + 1) % 2;
             }
-            if( !bottom == vbi->wanttop && vbi->current_chan == vbi->chan &&
+            if( (!bottom) == vbi->wanttop && vbi->current_chan == vbi->chan &&
                 vbi->current_istext == vbi->wanttext ) {
                 if( vbi->verbose )
                     fprintf( stderr, "Backspace\n");
@@ -820,7 +820,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
             if( !bottom && vbi->lastcode == ( (b1 << 8) | b2 ) ) {
                 vbi->lastcount = (vbi->lastcount + 1) % 2;
             }
-            if( !bottom == vbi->wanttop && vbi->current_chan == vbi->chan &&
+            if( (!bottom) == vbi->wanttop && vbi->current_chan == vbi->chan &&
                 vbi->current_istext == vbi->wanttext ) {
                 if( vbi->verbose )
                     fprintf( stderr, "Delete to End of Row\n");
@@ -845,7 +845,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
             switch( code ) {
             case 12:
                 /* Show buffer 1, Fill buffer 2 */
-                if( !bottom == vbi->wanttop && 
+                if( (!bottom) == vbi->wanttop && 
                     vbi->current_chan == vbi->chan && 
                     vbi->current_istext == vbi->wanttext ) {
                     if( vbi->verbose )
@@ -854,7 +854,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 }
                 break;
             case 13:
-                if( !bottom == vbi->wanttop && 
+                if( (!bottom) == vbi->wanttop && 
                     vbi->current_chan == vbi->chan && 
                     vbi->current_istext == vbi->wanttext ) {
                     if( vbi->verbose )
@@ -863,7 +863,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 }
                 break;
             case 14:
-                if( !bottom == vbi->wanttop && 
+                if( (!bottom) == vbi->wanttop && 
                     vbi->current_chan == vbi->chan && 
                     vbi->current_istext == vbi->wanttext ) {
                     if( vbi->verbose )
@@ -873,7 +873,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
                 break;
             case 15:
                 /* Show buffer 2, Fill Buffer 1 */
-                if( !bottom == vbi->wanttop && 
+                if( (!bottom) == vbi->wanttop && 
                     vbi->current_chan == vbi->chan && 
                     vbi->current_istext == vbi->wanttext ) {
                     if( vbi->verbose )
@@ -913,7 +913,7 @@ int ProcessLine( vbidata_t *vbi, uint8_t *s, int bottom )
         return 0;
     }
 
-    if( !bottom != vbi->wanttop || vbi->current_chan != vbi->chan || 
+    if( (!bottom) != vbi->wanttop || vbi->current_chan != vbi->chan || 
         vbi->current_istext != vbi->wanttext ) {
         return 0;
     }
diff --git a/src/videotools.c b/src/videotools.c
index 2257e1d..3c3675b 100644
--- a/src/videotools.c
+++ b/src/videotools.c
@@ -156,9 +156,8 @@ void composite_packed4444_to_packed422( uint8_t *output, int owidth,
                                         int fheight, int fstride,
                                         int xpos, int ypos )
 {
-    int dest_x, dest_y, src_x, src_y, blit_w, blit_h;
+    int dest_x, dest_y, src_y, blit_w, blit_h;
 
-    src_x = 0;
     src_y = 0;
     dest_x = xpos;
     dest_y = ypos;
@@ -166,7 +165,6 @@ void composite_packed4444_to_packed422( uint8_t *output, int owidth,
     blit_h = fheight;
 
     if( dest_x < 0 ) {
-        src_x = -dest_x;
         blit_w += dest_x;
         dest_x = 0;
     }
@@ -203,9 +201,8 @@ void composite_packed4444_alpha_to_packed422( uint8_t *output,
                                               int fstride,
                                               int xpos, int ypos, int alpha )
 {
-    int dest_x, dest_y, src_x, src_y, blit_w, blit_h;
+    int dest_x, dest_y, src_y, blit_w, blit_h;
 
-    src_x = 0;
     src_y = 0;
     dest_x = xpos;
     dest_y = ypos;
@@ -213,7 +210,6 @@ void composite_packed4444_alpha_to_packed422( uint8_t *output,
     blit_h = fheight;
 
     if( dest_x < 0 ) {
-        src_x = -dest_x;
         blit_w += dest_x;
         dest_x = 0;
     }
-- 
2.5.0

