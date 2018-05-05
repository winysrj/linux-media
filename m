Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50117 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbeEEQJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 12:09:51 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org
Subject: [PATCH 2/2] media: gp8psk: don't abuse of GFP_DMA
Date: Sat,  5 May 2018 12:09:46 -0400
Message-Id: <ed4fd8f165a3fcaa4459f7f78b6206fb552367fc.1525536580.git.mchehab+samsung@kernel.org>
In-Reply-To: <dc56acf384130d9703684a239d8daa8748f63d8e.1525536580.git.mchehab+samsung@kernel.org>
References: <dc56acf384130d9703684a239d8daa8748f63d8e.1525536580.git.mchehab+samsung@kernel.org>
In-Reply-To: <dc56acf384130d9703684a239d8daa8748f63d8e.1525536580.git.mchehab+samsung@kernel.org>
References: <dc56acf384130d9703684a239d8daa8748f63d8e.1525536580.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's s no reason why it should be using GFP_DMA there.
This is an USB driver. Any restriction should be, instead,
at HCI core, if any.

Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/dvb-usb/gp8psk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 37f062225ed2..334b9fb98112 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -148,7 +148,7 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 	info("downloading bcm4500 firmware from file '%s'",bcm4500_firmware);
 
 	ptr = fw->data;
-	buf = kmalloc(64, GFP_KERNEL | GFP_DMA);
+	buf = kmalloc(64, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto out_rel_fw;
-- 
2.17.0
