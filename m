Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45929 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0JPTd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 15:33:59 -0400
Received: by pxi16 with SMTP id 16so276132pxi.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 12:33:59 -0700 (PDT)
Message-ID: <4CB9FE21.4060303@gmail.com>
Date: Sat, 16 Oct 2010 12:33:53 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: o.endriss@gmx.de
Subject: [PATCH] av7110: Fix driver name (against git)
Content-Type: multipart/mixed;
 boundary="------------080500090003030806010402"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------080500090003030806010402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 This patch changes the name of the av7110  driver from the
generic "dvb" to "av7110", to be descriptive of the driver.

I've included Oliver Endriss's ack from the original post, which
contained a mangled patch.  The content of the patch is unchanged.

Signed-off-by: Derek Kelly <user.vdr@gmail.com <mailto:user.vdr@gmail.com>>
Acked-by: Oliver Endriss <o.endriss@gmx.de <mailto:o.endriss@gmx.de>>

--------------080500090003030806010402
Content-Type: text/plain;
 name="av7110-fix_driver_name.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="av7110-fix_driver_name.diff"

--- v4l-dvb.orig/drivers/media/dvb/ttpci/av7110.c	2010-10-16 09:10:18.000000000 -0700
+++ v4l-dvb/drivers/media/dvb/ttpci/av7110.c	2010-10-16 12:20:10.000000000 -0700
@@ -2890,7 +2890,7 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 
 static struct saa7146_extension av7110_extension_driver = {
-	.name		= "dvb",
+	.name		= "av7110",
 	.flags		= SAA7146_USE_I2C_IRQ,
 
 	.module		= THIS_MODULE,

--------------080500090003030806010402--
