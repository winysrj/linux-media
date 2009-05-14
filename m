Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110812.mail.gq1.yahoo.com ([67.195.13.235]:26527 "HELO
	web110812.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751512AbZENT1P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:27:15 -0400
Message-ID: <759177.40329.qm@web110812.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:27:16 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_11] Siano: smsusb - add big endien support
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242323662 -10800
# Node ID 483a3656a227acbceb26da96b02bebd0058a3961
# Parent  f93a86c6f9785cb60e015e811ddfca6850135887
[0905_11] Siano: smsusb - add big endien support

From: Uri Shkolnik <uris@siano-ms.com>

Add support for big endien target hosts, which
use USB interface.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r f93a86c6f978 -r 483a3656a227 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Thu May 14 20:49:10 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Thu May 14 20:54:22 2009 +0300
@@ -78,6 +78,7 @@ static void smsusb_onresponse(struct urb
 	if ((urb->actual_length > 0) && (urb->status == 0)) {
 		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)surb->cb->p;
 
+		smsendian_handle_message_header(phdr);
 		if (urb->actual_length >= phdr->msgLength) {
 			surb->cb->size = phdr->msgLength;
 



      
