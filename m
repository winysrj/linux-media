Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:57918 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbcFKWkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 18:40:16 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	steve_longerbeam@mentor.com
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH 1/2] [media] v4l2-subdev.h: allow V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
Date: Sun, 12 Jun 2016 00:29:59 +0200
Message-Id: <1465684199-12438-1-git-send-email-phdm@macqel.be>
In-Reply-To: <56E7FC02.50006@xs4all.nl>
References: <56E7FC02.50006@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add max_interval and step_interval to struct
v4l2_subdev_frame_interval_enum.

When filled correctly by the sensor driver, those fields must be
used as follows by the intermediate level :

	struct v4l2_frmivalenum *fival;
	struct v4l2_subdev_frame_interval_enum fie;

	if (fie.max_interval.numerator == 0) {
		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
		fival->discrete = fie.interval;
	} else if (fie.step_interval.numerator == 0) {
		fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
		fival->stepwise.min = fie.interval;
		fival->stepwise.max = fie.max_interval;
	} else {
		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
		fival->stepwise.min = fie.interval;
		fival->stepwise.max = fie.max_interval;
		fival->stepwise.step = fie.step_interval;
	}

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 include/uapi/linux/v4l2-subdev.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index dbce2b554..846dd36 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -127,7 +127,9 @@ struct v4l2_subdev_frame_interval_enum {
 	__u32 height;
 	struct v4l2_fract interval;
 	__u32 which;
-	__u32 reserved[8];
+	struct v4l2_fract max_interval;
+	struct v4l2_fract step_interval;
+	__u32 reserved[4];
 };
 
 /**
-- 
1.8.1.4

