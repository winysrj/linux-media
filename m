Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56826 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZJMPNj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:13:39 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9DFD0ZN013319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 10:13:03 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>,
	Brijesh Jadav <brijesh.j@ti.com>
Subject: [PATCH 6/6] TVP514x:Switch to automode for s_input/querystd
Date: Tue, 13 Oct 2009 20:42:59 +0530
Message-Id: <1255446779-16969-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Driver should switch to AutoSwitch mode on S_INPUT and QUERYSTD ioctls.
It has been observed that, if user configure the standard explicitely
then driver preserves the old settings.

Reviewed by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
---
 drivers/media/video/tvp514x.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 2443726..0b0412d 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -523,10 +523,18 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 	enum tvp514x_std current_std;
 	enum tvp514x_input input_sel;
 	u8 sync_lock_status, lock_mask;
+	int err;

 	if (std_id == NULL)
 		return -EINVAL;

+	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
+			VIDEO_STD_AUTO_SWITCH_BIT);
+	if (err < 0)
+		return err;
+
+	msleep(LOCK_RETRY_DELAY);
+
 	/* get the current standard */
 	current_std = tvp514x_get_current_std(sd);
 	if (current_std == STD_INVALID)
@@ -643,6 +651,15 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 		/* Index out of bound */
 		return -EINVAL;

+	/* Since this api is goint to detect the input, it is required
+	   to set the standard in the auto switch mode */
+	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
+			VIDEO_STD_AUTO_SWITCH_BIT);
+	if (err < 0)
+		return err;
+
+	msleep(LOCK_RETRY_DELAY);
+
 	input_sel = input;
 	output_sel = output;

--
1.6.2.4

