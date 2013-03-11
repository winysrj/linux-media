Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1814 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab3CKLrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 38/42] s2250: add comment describing the hardware.
Date: Mon, 11 Mar 2013 12:46:16 +0100
Message-Id: <3de44ea12d2caf5bb5deca0106fed23059304d03.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/s2250-board.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index cb36427..beaa98b 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -29,6 +29,13 @@
 MODULE_DESCRIPTION("Sensoray 2250/2251 i2c v4l2 subdev driver");
 MODULE_LICENSE("GPL v2");
 
+/*
+ * Note: this board has two i2c devices: a vpx3226f and a tlv320aic23b.
+ * Due to the unusual way these are accessed on this device we do not
+ * reuse the i2c drivers, but instead they are implemented in this
+ * driver. It would be nice to improve on this, though.
+ */
+
 #define TLV320_ADDRESS      0x34
 #define VPX322_ADDR_ANALOGCONTROL1	0x02
 #define VPX322_ADDR_BRIGHTNESS0		0x0127
-- 
1.7.10.4

