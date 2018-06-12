Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46334 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbeFLFr3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 01:47:29 -0400
From: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: tm6000: add error handling for dvb_register_adapter
Date: Tue, 12 Jun 2018 13:47:20 +0800
Message-Id: <1528782443-43329-1-git-send-email-jiazhouyang09@gmail.com>
In-Reply-To: <1528691962-31010-1-git-send-email-jiazhouyang09@gmail.com>
References: <1528691962-31010-1-git-send-email-jiazhouyang09@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When dvb_register_adapter fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling dvb_register_adapter.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/media/usb/tm6000/tm6000-dvb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index c811fc6..2e69486 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -266,6 +266,11 @@ static int register_dvb(struct tm6000_core *dev)
 
 	ret = dvb_register_adapter(&dvb->adapter, "Trident TVMaster 6000 DVB-T",
 					THIS_MODULE, &dev->udev->dev, adapter_nr);
+	if (ret < 0) {
+		printk(KERN_ERR "tm6000: couldn't register the adapter!\n");
+		goto err;
+	}
+
 	dvb->adapter.priv = dev;
 
 	if (dvb->frontend) {
-- 
2.7.4
