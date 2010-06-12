Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64607 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0FLDK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 23:10:29 -0400
Received: by pvg16 with SMTP id 16so1118590pvg.19
        for <linux-media@vger.kernel.org>; Fri, 11 Jun 2010 20:10:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 11 Jun 2010 20:10:28 -0700
Message-ID: <AANLkTilYElPyhhej6XYF15D9wwBtkiMWrmkTvsviCI3W@mail.gmail.com>
Subject: [PATCH] Fix av7110 driver name
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Cc: Oliver Endriss <o.endriss@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch simply changes the name of the av7110 driver to "AV7110"
instead of the generic "dvb" it's set to currently.  Although it's
somewhat trivial, it still seems appropriate to fix the name to be
descriptive of the driver.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>
----------

--- v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c      2010-06-11
13:24:29.000000000 -0700
+++ v4l-dvb.orig/linux/drivers/media/dvb/ttpci/av7110.c 2010-06-11
12:49:50.000000000 -0700
@@ -2893,7 +2893,7 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);


 static struct saa7146_extension av7110_extension_driver = {
-       .name           = "AV7110",
+       .name           = "dvb",
        .flags          = SAA7146_USE_I2C_IRQ,

        .module         = THIS_MODULE,
