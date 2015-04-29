Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbbD2XG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 08/27] ov7670: check read error also for REG_AECHH on ov7670_s_exp()
Date: Wed, 29 Apr 2015 20:05:53 -0300
Message-Id: <ff849563e43277ddf2cf83309963c74ca4428f7d.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov7670_s_exp() checks read error for 2 registers: REG_COM1
and REG_COM8. But, although it uses the value latter, it
doesn't check errors on REG_AECHH read. Yet, as it is doing
a bitmask operation there, the read operation should succeed.

So, fix the code to also check if this succeeded.

This fixes this smatch report:
	drivers/media/i2c/ov7670.c:1366 ov7670_s_exp() warn: inconsistent indenting

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index b9847527eb5a..f2fe20aad274 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1362,7 +1362,7 @@ static int ov7670_s_exp(struct v4l2_subdev *sd, int value)
 	unsigned char com1, com8, aech, aechh;
 
 	ret = ov7670_read(sd, REG_COM1, &com1) +
-		ov7670_read(sd, REG_COM8, &com8);
+		ov7670_read(sd, REG_COM8, &com8) +
 		ov7670_read(sd, REG_AECHH, &aechh);
 	if (ret)
 		return ret;
-- 
2.1.0

