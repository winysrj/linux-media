Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3393 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3LJNZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mikhail Khelik <mkhelik@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/15] adv7604: add hdmi driver strength adjustment
Date: Tue, 10 Dec 2013 14:23:07 +0100
Message-Id: <f0ac603bce611fd73be3e151ccabd899a6db8730.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mikhail Khelik <mkhelik@cisco.com>

The driver strength is board dependent, so set it from the platform_data.

Signed-off-by: Mikhail Khelik <mkhelik@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 7 ++++++-
 include/media/adv7604.h     | 5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 6372d31..99734b2 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1942,7 +1942,12 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 	io_write(sd, 0x06, 0xa6);   /* positive VS and HS */
-	io_write(sd, 0x14, 0x7f);   /* Drive strength adjusted to max */
+
+	/* Adjust drive strength */
+	io_write(sd, 0x14, 0x40 | pdata->dr_str << 4 |
+				pdata->dr_str_clk << 2 |
+				pdata->dr_str_sync);
+
 	cp_write(sd, 0xba, (pdata->hdmi_free_run_mode << 1) | 0x01); /* HDMI free run */
 	cp_write(sd, 0xf3, 0xdc); /* Low threshold to enter/exit free run mode */
 	cp_write(sd, 0xf9, 0x23); /*  STDI ch. 1 - LCVS change threshold -
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 0c96e16..0e13d1b 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -110,6 +110,11 @@ struct adv7604_platform_data {
 	unsigned replicate_av_codes:1;
 	unsigned invert_cbcr:1;
 
+	/* IO register 0x14 */
+	unsigned dr_str:2;
+	unsigned dr_str_clk:2;
+	unsigned dr_str_sync:2;
+
 	/* IO register 0x30 */
 	unsigned output_bus_lsb_to_msb:1;
 
-- 
1.8.4.rc3

