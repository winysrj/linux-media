Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1502 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1KVMDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 07:03:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ian Armstrong <mail01@iarmst.co.uk>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 1/3] v4l2 spec: clarify usage of V4L2_FBUF_FLAG_OVERLAY
Date: Tue, 22 Nov 2011 13:03:20 +0100
Message-Id: <22fb81ba5ba878d10fe996d5421f983dd34a1988.1321963291.git.hans.verkuil@cisco.com>
In-Reply-To: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
References: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml |   23 ++++++++++++--------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
index 93817f3..7c63815 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
@@ -364,15 +364,20 @@ capability and it is cleared otherwise.</entry>
 	  <row>
 	    <entry><constant>V4L2_FBUF_FLAG_OVERLAY</constant></entry>
 	    <entry>0x0002</entry>
-	    <entry>The frame buffer is an overlay surface the same
-size as the capture. [?]</entry>
-	  </row>
-	  <row>
-	    <entry spanname="hspan">The purpose of
-<constant>V4L2_FBUF_FLAG_OVERLAY</constant> was never quite clear.
-Most drivers seem to ignore this flag. For compatibility with the
-<wordasword>bttv</wordasword> driver applications should set the
-<constant>V4L2_FBUF_FLAG_OVERLAY</constant> flag.</entry>
+	    <entry>If this flag is set for a video capture device, then the
+driver will set the initial overlay size to cover the full framebuffer size,
+otherwise the existing overlay size (as set by &VIDIOC-S-FMT;) will be used.
+
+Only one video capture driver (bttv) supports this flag. The use of this flag
+for capture devices is deprecated. There is no way to detect which drivers
+support this flag, so the only reliable method of setting the overlay size is
+through &VIDIOC-S-FMT;.
+
+If this flag is set for a video output device, then the video output overlay
+window is relative to the top-left corner of the framebuffer and restricted
+to the size of the framebuffer. If it is cleared, then the video output
+overlay window is relative to the video output display.
+            </entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_FBUF_FLAG_CHROMAKEY</constant></entry>
-- 
1.7.7.3

