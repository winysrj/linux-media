Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53839 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3CZRaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:12 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 01/10] V4L: Add MATRIX option to V4L2_CID_EXPOSURE_METERING
 control
Date: Tue, 26 Mar 2013 18:29:43 +0100
Message-id: <1364318992-20562-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a menu option to the V4L2_CID_EXPOSURE_METERING
control for multi-zone metering.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    7 +++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    1 +
 include/uapi/linux/v4l2-controls.h           |    1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7fe5be1..c5398ed 100644
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

