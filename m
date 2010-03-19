Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38149 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab0CSGEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:23 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2J64Kom003963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 01:04:22 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>,
	Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH-V2 7/7] TVP514x: Add Powerup sequence during s_input to lock the signal properly
Date: Fri, 19 Mar 2010 11:34:13 +0530
Message-Id: <1268978653-32710-8-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

For the sequence streamon -> streamoff and again s_input, it fails
to lock the signal, since streamoff puts TVP514x into power off state
which leads to failure in sub-sequent s_input.

So add powerup sequence in s_routing (if disabled), since it is
important to lock the signal at this stage.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
---
 drivers/media/video/tvp514x.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 26b4e71..97b7db5 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -78,6 +78,8 @@ struct tvp514x_std_info {
 };

 static struct tvp514x_reg tvp514x_reg_list_default[0x40];
+
+static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
 /**
  * struct tvp514x_decoder - TVP5146/47 decoder object
  * @sd: Subdevice Slave handle
@@ -643,6 +645,17 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 		/* Index out of bound */
 		return -EINVAL;

+	/*
+	 * For the sequence streamon -> streamoff and again s_input
+	 * it fails to lock the signal, since streamoff puts TVP514x
+	 * into power off state which leads to failure in sub-sequent s_input.
+	 *
+	 * So power up the TVP514x device here, since it is important to lock
+	 * the signal at this stage.
+	 */
+	if (!decoder->streaming)
+		tvp514x_s_stream(sd, 1);
+
 	input_sel = input;
 	output_sel = output;

--
1.6.2.4

