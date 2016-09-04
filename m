Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbcIDOOI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 10:14:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Terry Heo <terryheo@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/7] [media] cx231xx: prints error code if can't switch TV mode
Date: Sun,  4 Sep 2016 11:13:55 -0300
Message-Id: <b2dffeb4bbda549b27a459ce4b75cd38237ed622.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

If something bad happens when switching between digital
and analog mode, prints an error and outputs the returned code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 6c8f825452dd..44288f265a26 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -746,6 +746,10 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 		}
 	}
 
+	dev_err(dev->dev, "Failed to set devmode to %s: error: %i",
+		dev->mode == CX231XX_DIGITAL_MODE ? "digital" : "analog",
+		errCode);
+
 	return errCode ? -EINVAL : 0;
 }
 EXPORT_SYMBOL_GPL(cx231xx_set_mode);
-- 
2.7.4

