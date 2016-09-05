Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55072 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933302AbcIEKcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:50 -0400
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
Subject: [PATCH v2 03/12] [media] cx231xx: prints error code if can't switch TV mode
Date: Mon,  5 Sep 2016 07:32:31 -0300
Message-Id: <52b4a990e28715272386b9bbf5af770af5c553ef.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

If something bad happens when switching between digital
and analog mode, prints an error and outputs the returned code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 6c8f825452dd..4b3acbd1d7f0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -746,7 +746,14 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 		}
 	}
 
-	return errCode ? -EINVAL : 0;
+	if (errCode < 0) {
+		dev_err(dev->dev, "Failed to set devmode to %s: error: %i",
+			dev->mode == CX231XX_DIGITAL_MODE ? "digital" : "analog",
+			errCode);
+		return errCode;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(cx231xx_set_mode);
 
-- 
2.7.4


