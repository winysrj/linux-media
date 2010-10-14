Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53222 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0JNTTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:19:43 -0400
Received: by pvc7 with SMTP id 7so619454pvc.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 12:19:43 -0700 (PDT)
Message-ID: <4CB757BD.1070302@gmail.com>
Date: Thu, 14 Oct 2010 12:19:25 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix av7110 driver name (resend)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 This patch simply changes the name of the av7110 driver to "av7110"
instead of the generic "dvb" it's set to currently.  Although it's
somewhat trivial, it still seems appropriate to fix the name to be
descriptive of the driver.

This patch was already ack'ed by other users but the original email
got mangled I guess so it was never submitted.  The original email
is: "[PATCH] Fix av7110 driver name"

Signed-off-by: Derek Kelly <user.vdr@gmail.com <mailto:user.vdr@gmail.com>>
----------
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/ttpci/av7110.c v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c
--- v4l-dvb.orig/linux/drivers/media/dvb/ttpci/av7110.c 2010-10-14 11:12:23.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c      2010-10-14 12:16:19.000000000 -0700
@@ -2893,7 +2893,7 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);


 static struct saa7146_extension av7110_extension_driver = {
-       .name           = "dvb",
+       .name           = "av7110",
        .flags          = SAA7146_USE_I2C_IRQ,

        .module         = THIS_MODULE,

