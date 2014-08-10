Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 06/18] [media] au0828: be sure to reenable the bridge and GPIOs on resume
Date: Sat,  9 Aug 2014 21:47:12 -0300
Message-Id: <1407631644-11990-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At resume, we should restore the register contents. So,
reenable the bridge and GPIO settings.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 3a02de142f9f..87340a8af7d7 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -302,6 +302,12 @@ static int au0828_resume(struct usb_interface *interface)
 	if (!dev)
 		return 0;
 
+	/* Power Up the bridge */
+	au0828_write(dev, REG_600, 1 << 4);
+
+	/* Bring up the GPIO's and supporting devices */
+	au0828_gpio_setup(dev);
+
 	au0828_rc_resume(dev);
 
 	/* FIXME: should resume also ATV/DTV */
-- 
1.9.3

