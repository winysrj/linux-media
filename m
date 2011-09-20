Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50001 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ITL7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 07:59:06 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRT00B8PLAF7T@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 12:59:03 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRT00EHNLAEQ6@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 12:59:03 +0100 (BST)
Date: Tue, 20 Sep 2011 13:58:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v1 1/3] v4l: Extend V4L2_CID_COLORFX control with AQUA effect
In-reply-to: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1316519939-22540-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_COLORFX_AQUA image effect in the V4L2_CID_COLORFX menu.
Aqua means cool tone, in opposite to Sepia.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    5 +++--
 include/linux/videodev2.h                    |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 23fdf79..2420e4a 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -294,8 +294,9 @@ minimum value disables backlight compensation.</entry>
 <constant>V4L2_COLORFX_SKETCH</constant> (5),
 <constant>V4L2_COLORFX_SKY_BLUE</constant> (6),
 <constant>V4L2_COLORFX_GRASS_GREEN</constant> (7),
-<constant>V4L2_COLORFX_SKIN_WHITEN</constant> (8) and
-<constant>V4L2_COLORFX_VIVID</constant> (9).</entry>
+<constant>V4L2_COLORFX_SKIN_WHITEN</constant> (8),
+<constant>V4L2_COLORFX_VIVID</constant> (9) and
+<constant>V4L2_COLORFX_AQUA</constant> (10).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a5359c6..c33f462 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1144,6 +1144,7 @@ enum v4l2_colorfx {
 	V4L2_COLORFX_GRASS_GREEN = 7,
 	V4L2_COLORFX_SKIN_WHITEN = 8,
 	V4L2_COLORFX_VIVID = 9,
+	V4L2_COLORFX_AQUA = 10,
 };
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
-- 
1.7.6.3

