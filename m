Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaHHKnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 06:43:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] au0828: don't let the IR polling thread to run at suspend
Date: Fri,  8 Aug 2014 07:43:47 -0300
Message-Id: <1407494627-1555-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407494627-1555-1-git-send-email-m.chehab@samsung.com>
References: <1407494627-1555-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trying to make au0828 to suspend can do very bad things, as
the polling Kthread is not handled. We should disable it
during suspend, only re-enabling it at resume.

Still, analog and digital TV won't work, as we don't reinit
the settings at resume, but at least it won't hang.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 56025e689442..eb5f2b1b182b 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -285,13 +285,41 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	return retval;
 }
 
+static int au0828_suspend(struct usb_interface *interface,
+				pm_message_t message)
+{
+	struct au0828_dev *dev = usb_get_intfdata(interface);
+
+	if (!dev)
+		return 0;
+
+	au0828_rc_suspend(dev);
+
+	/* FIXME: should suspend also ATV/DTV */
+
+	return 0;
+}
+
+static int au0828_resume(struct usb_interface *interface)
+{
+	struct au0828_dev *dev = usb_get_intfdata(interface);
+	if (!dev)
+		return 0;
+
+	au0828_rc_resume(dev);
+
+	/* FIXME: should resume also ATV/DTV */
+
+	return 0;
+}
+
 static struct usb_driver au0828_usb_driver = {
 	.name		= DRIVER_NAME,
 	.probe		= au0828_usb_probe,
 	.disconnect	= au0828_usb_disconnect,
 	.id_table	= au0828_usb_id_table,
-
-	/* FIXME: Add suspend and resume functions */
+	.suspend	= au0828_suspend,
+	.resume		= au0828_resume,
 };
 
 static int __init au0828_init(void)
-- 
1.9.3

