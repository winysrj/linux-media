Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110802.mail.gq1.yahoo.com ([67.195.13.225]:34883 "HELO
	web110802.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752439AbZELORJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 10:17:09 -0400
Message-ID: <23363.7021.qm@web110802.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 07:17:09 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_03] Siano: smsusb - remove old backward support
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242136071 -10800
# Node ID 126c0974c2db4e2777e5d9b068fa976fe3a59675
# Parent  697459f4baf6e95a906b852250699a18d1016724
[0905_03] Siano: smsusb - remove old backward support

From: Uri Shkolnik <uris@siano-ms.com>

Remove backward support for kernel versions
older than 2.6.19.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 697459f4baf6 -r 126c0974c2db linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 16:42:33 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 16:47:51 2009 +0300
@@ -60,11 +60,7 @@ static int smsusb_submit_urb(struct smsu
 static int smsusb_submit_urb(struct smsusb_device_t *dev,
 			     struct smsusb_urb_t *surb);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 static void smsusb_onresponse(struct urb *urb)
-#else
-static void smsusb_onresponse(struct urb *urb, struct pt_regs *regs)
-#endif
 {
 	struct smsusb_urb_t *surb = (struct smsusb_urb_t *) urb->context;
 	struct smsusb_device_t *dev = surb->dev;



      
