Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4367 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaILJCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 05:02:18 -0400
Message-ID: <5412B68A.1020702@xs4all.nl>
Date: Fri, 12 Sep 2014 11:02:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Martin Bugge <marbugge@cisco.com>
Subject: [PATCH for v3.17] adv7604: fix inverted condition
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The log_status function should show HDMI information, but the test checking for
an HDMI input was inverted. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org      # for v3.12 and up

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d4fa213..de88b98 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2325,7 +2325,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "HDCP keys read: %s%s\n",
 			(hdmi_read(sd, 0x04) & 0x20) ? "yes" : "no",
 			(hdmi_read(sd, 0x04) & 0x10) ? "ERROR" : "");
-	if (!is_hdmi(sd)) {
+	if (is_hdmi(sd)) {
 		bool audio_pll_locked = hdmi_read(sd, 0x04) & 0x01;
 		bool audio_sample_packet_detect = hdmi_read(sd, 0x18) & 0x01;
 		bool audio_mute = io_read(sd, 0x65) & 0x40;
