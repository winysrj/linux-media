Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295AbbD1PoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 06/14] saa717x: fix multi-byte read code
Date: Tue, 28 Apr 2015 12:43:45 -0300
Message-Id: <69efa97ec6ad7eaa6476aae6904d47c17fb46f1e.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/i2c/saa717x.c:155 saa717x_read() warn: mask and shift to zero
	drivers/media/i2c/saa717x.c:155 saa717x_read() warn: mask and shift to zero

This is done right at saa717x_write(), but the read function is
broken. Thankfully, there's just one place at saa717x driver that
uses multibyte read (for status report, via printk).

Yet, let's fix it. From saa717x_write(), it is clear that the
bytes are in little endian:
		mm1[4] = (value >> 16) & 0xff;
		mm1[3] = (value >> 8) & 0xff;
		mm1[2] = value & 0xff;

So, the same order should be valid for read too.

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 0d0f9a917cd3..17557b2f1b09 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -152,9 +152,9 @@ static u32 saa717x_read(struct v4l2_subdev *sd, u32 reg)
 	i2c_transfer(adap, msgs, 2);
 
 	if (fw_addr)
-		value = (mm2[2] & 0xff)  | ((mm2[1] & 0xff) >> 8) | ((mm2[0] & 0xff) >> 16);
+		value = (mm2[2] << 16)  | (mm2[1] << 8) | mm2[0];
 	else
-		value = mm2[0] & 0xff;
+		value = mm2[0];
 
 	v4l2_dbg(2, debug, sd, "read:  reg 0x%03x=0x%08x\n", reg, value);
 	return value;
-- 
2.1.0

