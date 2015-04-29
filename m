Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbD2XGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>
Subject: [PATCH 23/27] ttusb-dec: fix bad indentation
Date: Wed, 29 Apr 2015 20:06:08 -0300
Message-Id: <303d0172eafad11a4eac6aa94384d45a58b22f93.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/ttusb-dec/ttusb_dec.c:1434 ttusb_dec_init_stb() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 15ab584cf265..322b53a4f1dd 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1431,8 +1431,8 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 			       __func__, model);
 			return -ENOENT;
 		}
-			if (version >= 0x01770000)
-				dec->can_playback = 1;
+		if (version >= 0x01770000)
+			dec->can_playback = 1;
 	}
 	return 0;
 }
-- 
2.1.0

