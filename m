Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45602 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab0ADODM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:03:12 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/9] TVP514x:Switch to automode for querystd
Date: Mon,  4 Jan 2010 19:32:55 +0530
Message-Id: <1262613782-20463-3-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Driver should switch to AutoSwitch mode on QUERYSTD ioctls.
It has been observed that, if user configure the standard explicitely
then driver preserves the old settings, but query_std must detect the
standard instead of returning old settings.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/tvp514x.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 26b4e71..4cf3593 100644
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
-- 
1.6.2.4

