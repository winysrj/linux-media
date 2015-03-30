Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbbC3LLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 06/12] [media] tc358743: split set_csi into set_csi and start_csi
Date: Mon, 30 Mar 2015 13:10:50 +0200
Message-Id: <1427713856-10240-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI Tx can't be stopped except by pulling the CTx reset.
Split the actual CSI start out of set_csi. This allows to call
it later in s_stream, as the Synopsys Designware MIPI CSI-2 Host
Controller needs to start with the lanes in stop state before
it can sync its PLL to the clock lane.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 74e83c5..34acfed 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -759,6 +759,14 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
 			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
 
 	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
+}
+
+static void tc358743_start_csi(struct v4l2_subdev *sd)
+{
+	unsigned lanes = tc358743_num_csi_lanes_needed(sd);
+
+	v4l2_dbg(3, debug, sd, "%s:\n", __func__);
+
 	i2c_wr32(sd, STARTCNTRL, MASK_START);
 	i2c_wr32(sd, CSI_START, MASK_STRT);
 
@@ -1177,6 +1185,7 @@ static long tc358743_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 		i2c_wr16(sd, CONFCTL, confctl &
 				(~(MASK_VBUFEN | MASK_ABUFEN)));
 		tc358743_set_csi(sd);
+		tc358743_start_csi(sd);
 		i2c_wr16(sd, CONFCTL, confctl |
 				(MASK_VBUFEN | MASK_ABUFEN));
 		return 0;
@@ -1505,7 +1514,11 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 
 static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 {
+	if (enable)
+		tc358743_start_csi(sd);
 	enable_stream(sd, enable);
+	if (!enable)
+		tc358743_set_csi(sd);
 
 	return 0;
 }
-- 
2.1.4

