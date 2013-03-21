Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab3CUKDe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:03:34 -0400
Date: Thu, 21 Mar 2013 07:03:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: em28xx: commit aab3125c43d8fecc7134e5f1e729fabf4dd196da broke
 HVR 900
Message-ID: <20130321070327.772c6301@redhat.com>
In-Reply-To: <201303210933.41537.hverkuil@xs4all.nl>
References: <201303210933.41537.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Mar 2013 09:33:41 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> I tried to use my HVR 900 stick today and discovered that it no longer worked.
> I traced it to commit aab3125c43d8fecc7134e5f1e729fabf4dd196da: "em28xx: add
> support for registering multiple i2c buses".
> 
> The kernel messages for when it fails are:
...
> Mar 21 09:26:57 telek kernel: [ 1396.542517] xc2028 12-0061: attaching existing instance
> Mar 21 09:26:57 telek kernel: [ 1396.542521] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
> Mar 21 09:26:57 telek kernel: [ 1396.542523] em2882/3 #0: em2882/3 #0/2: xc3028 attached
...
> Mar 21 09:26:57 telek kernel: [ 1396.547833] xc2028 12-0061: Error on line 1293: -19

Probably, the I2C speed is wrong. I noticed a small bug on this patch.
The following patch should fix it. Could you please test?

-- 

Regards,
Mauro

[PATCH] em28xx: fix I2C write to register 06

Signed-off-by: Mauro Carvalho Chehab

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index de9b208..dd1f2de 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -295,7 +295,9 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			dev->cur_i2c_bus |= EM2874_I2C_SECONDARY_BUS_SELECT;
 		else
 			dev->cur_i2c_bus &= ~EM2874_I2C_SECONDARY_BUS_SELECT;
-		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->cur_i2c_bus);
+		em28xx_write_reg_bits(dev, EM28XX_R06_I2C_CLK,
+				      dev->cur_i2c_bus,
+				      EM2874_I2C_SECONDARY_BUS_SELECT);
 		dev->cur_i2c_bus = bus;
 	}
 
