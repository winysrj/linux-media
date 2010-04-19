Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46886 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0DSDbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 23:31:19 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Bian, Jonathan" <jonathan.bian@intel.com>
Date: Mon, 19 Apr 2010 11:31:02 +0800
Subject: [PATCH] To support more color effects (negative, sketch, emboss,
 etc) by extending v4l2_colorfx enum items
Message-ID: <33AB447FBD802F4E932063B962385B351D8B5DDA@shsmsx501.ccr.corp.intel.com>
References: <33AB447FBD802F4E932063B962385B351D84C129@shsmsx501.ccr.corp.intel.com>
 <258a57e817688f9fa0c1e87fdadc740c.squirrel@webmail.xs4all.nl>
 <33AB447FBD802F4E932063B962385B351D84C1BF@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351D84C1BF@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the patch to follow up the last week RFC proposal in the mailing list. Welcome review and any comment and feedback. 
These changes have tested by my co-worker without compilation error.

>From f84ef393f28e4c2f20502c1e884773db016f0a2e Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Mon, 19 Apr 2010 10:06:50 +0800
Subject: [PATCH] support more color effects (negative, sketch, emboss, etc) by extending the
 v4l2_colorfx enum items.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 Documentation/DocBook/v4l/controls.xml    |   11 +++++++++--
 Documentation/DocBook/v4l/videodev2.h.xml |    7 +++++++
 drivers/media/video/v4l2-common.c         |    7 +++++++
 include/linux/videodev2.h                 |    7 +++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index f464506..ee0a359 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -277,8 +277,15 @@ minimum value disables backlight compensation.</entry>
 	    <entry>Selects a color effect. Possible values for
 <constant>enum v4l2_colorfx</constant> are:
 <constant>V4L2_COLORFX_NONE</constant> (0),
-<constant>V4L2_COLORFX_BW</constant> (1) and
-<constant>V4L2_COLORFX_SEPIA</constant> (2).</entry>
+<constant>V4L2_COLORFX_BW</constant> (1),
+<constant>V4L2_COLORFX_SEPIA</constant> (2),
+<constant>V4L2_COLORFX_NEGATIVE</constant> (3),
+<constant>V4L2_COLORFX_EMBOSS</constant> (4),
+<constant>V4L2_COLORFX_SKETCH</constant> (5),
+<constant>V4L2_COLORFX_SKY_BLUE</constant> (6),
+<constant>V4L2_COLORFX_GRASS_GREEN</constant> (7),
+<constant>V4L2_COLORFX_SKIN_WHITEN</constant> (8) and
+<constant>V4L2_COLORFX_VIVID</constant> (9).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 0683259..11bf4cc 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -1018,6 +1018,13 @@ enum <link linkend="v4l2-colorfx">v4l2_colorfx</link> {
         V4L2_COLORFX_NONE       = 0,
         V4L2_COLORFX_BW         = 1,
         V4L2_COLORFX_SEPIA      = 2,
+        V4L2_COLORFX_NEGATIVE   = 3,
+        V4L2_COLORFX_EMBOSS     = 4,
+        V4L2_COLORFX_SKETCH     = 5,
+        V4L2_COLORFX_SKY_BLUE   = 6,
+        V4L2_COLORFX_GRASS_GREEN = 7,
+        V4L2_COLORFX_SKIN_WHITEN = 8,
+        V4L2_COLORFX_VIVID      = 9.
 };
 #define V4L2_CID_AUTOBRIGHTNESS                 (V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER               (V4L2_CID_BASE+33)
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 36b5cb8..cc5c499 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -340,6 +340,13 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"None",
 		"Black & White",
 		"Sepia",
+		"Negative",
+		"Emboss",
+		"Sketch",
+		"Sky blue",
+		"Grass green",
+		"Skin whiten",
+		"Vivid",
 		NULL
 	};
 	static const char *tune_preemphasis[] = {
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3793d16..a8f2c35 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1023,6 +1023,13 @@ enum v4l2_colorfx {
 	V4L2_COLORFX_NONE	= 0,
 	V4L2_COLORFX_BW		= 1,
 	V4L2_COLORFX_SEPIA	= 2,
+	V4L2_COLORFX_NEGATIVE = 3,
+	V4L2_COLORFX_EMBOSS = 4,
+	V4L2_COLORFX_SKETCH = 5,
+	V4L2_COLORFX_SKY_BLUE = 6,
+	V4L2_COLORFX_GRASS_GREEN = 7,
+	V4L2_COLORFX_SKIN_WHITEN = 8,
+	V4L2_COLORFX_VIVID = 9,
 };
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
-- 
1.6.3.2

