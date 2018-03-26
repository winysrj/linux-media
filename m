Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64947 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbeCZVK5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:10:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Sergiy Redko <sergredko@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 14/18] media: staging: atomisp: use %p to print pointers
Date: Mon, 26 Mar 2018 17:10:47 -0400
Message-Id: <bed901e424710091c1415aa2fcf1c7013897f678.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of a converting pointers to unsigned long, just print
them as-is, using %p.

Fixes this warning:
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:3012 ia_css_debug_pipe_graph_dump_sp_raw_copy() warn: argument 4 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../css2400/runtime/debug/src/ia_css_debug.c         | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index 60395904f89a..aa9a2d115265 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -2679,9 +2679,9 @@ ia_css_debug_pipe_graph_dump_frame(
 	}
 	dtrace_dot(
 		"node [shape = box, "
-		"fixedsize=true, width=2, height=0.7]; \"0x%08lx\" "
+		"fixedsize=true, width=2, height=0.7]; \"%p\" "
 		"[label = \"%s\\n%d(%d) x %d, %dbpp\\n%s\"];",
-		HOST_ADDRESS(frame),
+		frame,
 		debug_frame_format2str(frame->info.format),
 		frame->info.res.width,
 		frame->info.padded_width,
@@ -2691,16 +2691,16 @@ ia_css_debug_pipe_graph_dump_frame(
 
 	if (in_frame) {
 		dtrace_dot(
-			"\"0x%08lx\"->\"%s(pipe%d)\" "
+			"\"%p\"->\"%s(pipe%d)\" "
 			"[label = %s_frame];",
-			HOST_ADDRESS(frame),
+			frame,
 			blob_name, id, frame_name);
 	} else {
 		dtrace_dot(
-			"\"%s(pipe%d)\"->\"0x%08lx\" "
+			"\"%s(pipe%d)\"->\"%p\" "
 			"[label = %s_frame];",
 			blob_name, id,
-			HOST_ADDRESS(frame),
+			frame,
 			frame_name);
 	}
 }
@@ -3011,9 +3011,9 @@ ia_css_debug_pipe_graph_dump_sp_raw_copy(
 
 	snprintf(ring_buffer, sizeof(ring_buffer),
 		"node [shape = box, "
-		"fixedsize=true, width=2, height=0.7]; \"0x%08lx\" "
+		"fixedsize=true, width=2, height=0.7]; \"%p\" "
 		"[label = \"%s\\n%d(%d) x %d\\nRingbuffer\"];",
-		HOST_ADDRESS(out_frame),
+		out_frame,
 		debug_frame_format2str(out_frame->info.format),
 		out_frame->info.res.width,
 		out_frame->info.padded_width,
@@ -3022,9 +3022,9 @@ ia_css_debug_pipe_graph_dump_sp_raw_copy(
 	dtrace_dot(ring_buffer);
 
 	dtrace_dot(
-		"\"%s(pipe%d)\"->\"0x%08lx\" "
+		"\"%s(pipe%d)\"->\"%p\" "
 		"[label = out_frame];",
-		"sp_raw_copy", 1, HOST_ADDRESS(out_frame));
+		"sp_raw_copy", 1, out_frame);
 
 	snprintf(dot_id_input_bin, sizeof(dot_id_input_bin), "%s(pipe%d)", "sp_raw_copy", 1);
 }
-- 
2.14.3
