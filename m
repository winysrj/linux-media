Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53750 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbaB0AWU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:22:20 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 03/13] v4l: reorganize RF tuner control ID numbers
Date: Thu, 27 Feb 2014 02:21:58 +0200
Message-Id: <1393460528-11684-4-git-send-email-crope@iki.fi>
In-Reply-To: <1393460528-11684-1-git-send-email-crope@iki.fi>
References: <1393460528-11684-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It appears that controls are ordered by ID number when enumerating.
That could lead illogical UI as controls are usually enumerated and
drawn by the application at runtime.

Change order of controls by reorganizing assigned IDs now as we can.
It is not reasonable possible after the API is released. Also, leave
some spare space between IDs too for possible future extensions.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/uapi/linux/v4l2-controls.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2f6b5fb..b7d4bb8 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -899,13 +899,13 @@ enum v4l2_deemphasis {
 #define V4L2_CID_RF_TUNER_CLASS_BASE		(V4L2_CTRL_CLASS_RF_TUNER | 0x900)
 #define V4L2_CID_RF_TUNER_CLASS			(V4L2_CTRL_CLASS_RF_TUNER | 1)
 
-#define V4L2_CID_RF_TUNER_LNA_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 1)
-#define V4L2_CID_RF_TUNER_LNA_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 2)
-#define V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 3)
-#define V4L2_CID_RF_TUNER_MIXER_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 4)
-#define V4L2_CID_RF_TUNER_IF_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 5)
-#define V4L2_CID_RF_TUNER_IF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 6)
-#define V4L2_CID_RF_TUNER_BANDWIDTH_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 7)
-#define V4L2_CID_RF_TUNER_BANDWIDTH		(V4L2_CID_RF_TUNER_CLASS_BASE + 8)
+#define V4L2_CID_RF_TUNER_BANDWIDTH_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 11)
+#define V4L2_CID_RF_TUNER_BANDWIDTH		(V4L2_CID_RF_TUNER_CLASS_BASE + 12)
+#define V4L2_CID_RF_TUNER_LNA_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 41)
+#define V4L2_CID_RF_TUNER_LNA_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 42)
+#define V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 51)
+#define V4L2_CID_RF_TUNER_MIXER_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 52)
+#define V4L2_CID_RF_TUNER_IF_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 61)
+#define V4L2_CID_RF_TUNER_IF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 62)
 
 #endif
-- 
1.8.5.3

