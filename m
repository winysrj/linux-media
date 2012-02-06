Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50466 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2BFXFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 18:05:12 -0500
Received: by werb13 with SMTP id b13so4641897wer.19
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 15:05:11 -0800 (PST)
Message-ID: <1328569501.4855.3.camel@tvbox>
Subject: [PATCH] lmedm04 ver 1.96 Turn off PID filter by default.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 06 Feb 2012 23:05:01 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Problems with the PID setting stalling demux on applications like VDR and MythTV.

The PID filter is now defaulted to OFF.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index b3fe05b..a5ad561 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -104,8 +104,7 @@ MODULE_PARM_DESC(firmware, "set default firmware 0=Sharp7395 1=LG");
 
 static int pid_filter;
 module_param_named(pid, pid_filter, int, 0644);
-MODULE_PARM_DESC(pid, "set default 0=on 1=off");
-
+MODULE_PARM_DESC(pid, "set default 0=default 1=off 2=on");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -653,7 +652,7 @@ static int lme2510_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_description **desc,
 		int *cold)
 {
-	if (pid_filter > 0)
+	if (pid_filter != 2)
 		props->adapter[0].fe[0].caps &=
 			~DVB_USB_ADAP_NEED_PID_FILTERING;
 	*cold = 0;
@@ -1295,5 +1294,5 @@ module_usb_driver(lme2510_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.91");
+MODULE_VERSION("1.96");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3


