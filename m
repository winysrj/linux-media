Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbbD2XGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 18/27] cx25840: fix bad identing
Date: Wed, 29 Apr 2015 20:06:03 -0300
Message-Id: <9320588d2588de050aee555dc688209c20e982a0.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/cx25840/cx25840-core.c:974 input_change() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index bd496447749a..18e3615737f2 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -971,7 +971,7 @@ static void input_change(struct i2c_client *client)
 		   not used by any public broadcast network, force
 		   6.5 MHz carrier to be interpreted as System DK,
 		   this avoids DK audio detection instability */
-	       cx25840_write(client, 0x80b, 0x00);
+		cx25840_write(client, 0x80b, 0x00);
 	} else if (std & V4L2_STD_SECAM) {
 		/* Autodetect audio standard and audio system */
 		cx25840_write(client, 0x808, 0xff);
-- 
2.1.0

