Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110801.mail.gq1.yahoo.com ([67.195.13.224]:38329 "HELO
	web110801.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753004AbZELO2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 10:28:41 -0400
Message-ID: <77989.12979.qm@web110801.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 07:28:41 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_05] Siano: smsusb - lost buffers bug fix
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242138741 -10800
# Node ID ae0f17b305e7762643a9bc7f43c302c11f7b55b5
# Parent  db8bfae234d4730f18823ca0686762a13e7997c9
[0905_05] Siano: smsusb - lost buffers bug fix

From: Uri Shkolnik <uris@siano-ms.com>

This patch fixes a problem were protocol buffers
have been lost during USB disconnect events.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r db8bfae234d4 -r ae0f17b305e7 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 17:19:30 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 17:32:21 2009 +0300
@@ -65,14 +65,14 @@ static void smsusb_onresponse(struct urb
 	struct smsusb_urb_t *surb = (struct smsusb_urb_t *) urb->context;
 	struct smsusb_device_t *dev = surb->dev;
 
-	if (urb->status < 0) {
-		sms_err("error, urb status %d, %d bytes",
+	if (urb->status == -ESHUTDOWN) {
+		sms_err("error, urb status %d (-ESHUTDOWN), %d bytes",
 			urb->status, urb->actual_length);
 		return;
 	}
 
-	if (urb->actual_length > 0) {
-		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) surb->cb->p;
+	if ((urb->actual_length > 0) && (urb->status == 0)) {
+		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)surb->cb->p;
 
 		smsendian_handle_message_header(phdr);
 		if (urb->actual_length >= phdr->msgLength) {
@@ -111,7 +111,10 @@ static void smsusb_onresponse(struct urb
 				"msglen %d actual %d",
 				phdr->msgLength, urb->actual_length);
 		}
-	}
+	} else
+		sms_err("error, urb status %d, %d bytes",
+			urb->status, urb->actual_length);
+
 
 exit_and_resubmit:
 	smsusb_submit_urb(dev, surb);



      
