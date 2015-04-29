Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37509 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbbD2XGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 16/27] stk014: fix bad indenting
Date: Wed, 29 Apr 2015 20:06:01 -0300
Message-Id: <8c46e39ccf3117d46c8b50cc3fd9354cb91807c0.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/gspca/stk014.c:279 sd_start() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/gspca/stk014.c b/drivers/media/usb/gspca/stk014.c
index b0c70fea760b..d324d001e114 100644
--- a/drivers/media/usb/gspca/stk014.c
+++ b/drivers/media/usb/gspca/stk014.c
@@ -276,7 +276,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		gspca_dev->usb_err = ret;
 		goto out;
 	}
-	 reg_r(gspca_dev, 0x0630);
+	reg_r(gspca_dev, 0x0630);
 	rcv_val(gspca_dev, 0x000020);	/* << (value ff ff ff ff) */
 	reg_r(gspca_dev, 0x0650);
 	snd_val(gspca_dev, 0x000020, 0xffffffff);
-- 
2.1.0

