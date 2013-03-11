Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43993 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab3CKTBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:01:25 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 11/11] V4L: Add MATRIX option to V4L2_CID_EXPOSURE_METERING
 control
Date: Mon, 11 Mar 2013 20:00:26 +0100
Message-id: <1363028426-2771-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a menu option to the V4L2_CID_EXPOSURE_METERING
control for multi-zone metering.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    9 ++++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c         |    1 +
 include/uapi/linux/v4l2-controls.h           |    1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7fe5be1..0484a7d 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3159,6 +3159,13 @@ giving priority to the center of the metered area.</entry>
 		  <entry><constant>V4L2_EXPOSURE_METERING_SPOT</constant>&nbsp;</entry>
 		  <entry>Measure only very small area at the center of the frame.</entry>
 		</row>
+		<row>
+		  <entry><constant>V4L2_EXPOSURE_METERING_MATRIX</constant>&nbsp;</entry>
+		  <entry>A multi-zone metering. The light intensity is measured
+in several points of the frame and the the results are combined. The
+algorithm of the zones selection and their significance in calculating the
+final value is device dependant.</entry>
+		</row>
 	      </tbody>
 	    </entrytbl>
 	  </row>
@@ -3986,7 +3993,7 @@ interface and may change in the future.</para>
 
           <table pgwide="1" frame="none" id="flash-control-id">
           <title>Flash Control IDs</title>
-    
+
           <tgroup cols="4">
     	<colspec colname="c1" colwidth="1*" />
     	<colspec colname="c2" colwidth="6*" />
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 4b45d49..6b56d7b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -234,6 +234,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Average",
 		"Center Weighted",
 		"Spot",
+		"Matrix",
 		NULL
 	};
 	static const char * const camera_auto_focus_range[] = {
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index f56c945..22556a2 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -642,6 +642,7 @@ enum v4l2_exposure_metering {
 	V4L2_EXPOSURE_METERING_AVERAGE		= 0,
 	V4L2_EXPOSURE_METERING_CENTER_WEIGHTED	= 1,
 	V4L2_EXPOSURE_METERING_SPOT		= 2,
+	V4L2_EXPOSURE_METERING_MATRIX		= 3,
 };
 
 #define V4L2_CID_SCENE_MODE			(V4L2_CID_CAMERA_CLASS_BASE+26)
-- 
1.7.9.5

