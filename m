Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34284 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbHQLUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2015 07:20:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@osg.samsung.com, linux-kernel@vger.kernel.org,
	corbet@lwn.net, sakari.ailus@linux.intel.com,
	linux-media@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [media] DocBook media: Fix typo "the the" in xml files
Date: Mon, 17 Aug 2015 20:20:56 +0900
Message-Id: <1439810456-22401-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix spelling typo "the the" found in controls.xml
and vidioc-g-param.xml.
These xml files are generated from NOT any files, so I have
to fix these xml files.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml      | 2 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 6e1667b..33aece5 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3414,7 +3414,7 @@ giving priority to the center of the metered area.</entry>
 		<row>
 		  <entry><constant>V4L2_EXPOSURE_METERING_MATRIX</constant>&nbsp;</entry>
 		  <entry>A multi-zone metering. The light intensity is measured
-in several points of the frame and the the results are combined. The
+in several points of the frame and the results are combined. The
 algorithm of the zones selection and their significance in calculating the
 final value is device dependent.</entry>
 		</row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
index f4e28e7..7217287 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
@@ -267,7 +267,7 @@ is intended for still imaging applications. The idea is to get the
 best possible image quality that the hardware can deliver. It is not
 defined how the driver writer may achieve that; it will depend on the
 hardware and the ingenuity of the driver writer. High quality mode is
-a different mode from the the regular motion video capture modes. In
+a different mode from the regular motion video capture modes. In
 high quality mode:<itemizedlist>
 		  <listitem>
 		    <para>The driver may be able to capture higher
-- 
2.5.0.234.gefc8a62

