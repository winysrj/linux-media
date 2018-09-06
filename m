Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:57699 "EHLO
        homiemail-a119.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727104AbeIGBpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 21:45:19 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mkrufky@linuxtv.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/2] au0828: Fix incorrect error messages
Date: Thu,  6 Sep 2018 16:07:49 -0500
Message-Id: <1536268069-25435-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1536268069-25435-1-git-send-email-brad@nextdimension.cc>
References: <1536268069-25435-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correcting red herring error messages.

Where appropriate, replaces au0282_dev_register with:
- au0828_analog_register
- au0828_dvb_register

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 257ae0d..5abab1eb 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -626,7 +626,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Analog TV */
 	retval = au0828_analog_register(dev, interface);
 	if (retval) {
-		pr_err("%s() au0282_dev_register failed to register on V4L2\n",
+		pr_err("%s() au0828_analog_register failed to register on V4L2\n",
 			__func__);
 		mutex_unlock(&dev->lock);
 		goto done;
@@ -635,7 +635,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Digital TV */
 	retval = au0828_dvb_register(dev);
 	if (retval)
-		pr_err("%s() au0282_dev_register failed\n",
+		pr_err("%s() au0828_dvb_register failed\n",
 		       __func__);
 
 	/* Remote controller */
-- 
2.7.4
