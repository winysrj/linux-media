Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110801.mail.gq1.yahoo.com ([67.195.13.224]:35199 "HELO
	web110801.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751342AbZELNi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 09:38:58 -0400
Message-ID: <192225.84847.qm@web110801.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 06:38:58 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_01_1] Siano: Makefile - add smsendian to build
To: LinuxML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242135753 -10800
# Node ID 697459f4baf6e95a906b852250699a18d1016724
# Parent  26c02c133d7e1f9932c1968f669ab0bfaf2761fa
[0905_01_1] Siano: Makefile - add smsendian to build

From: Uri Shkolnik <uris@siano-ms.com>

Add smsendian component to the module build

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 26c02c133d7e -r 697459f4baf6 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Tue May 12 14:27:06 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Tue May 12 16:42:33 2009 +0300
@@ -1,4 +1,4 @@ sms1xxx-objs := smscoreapi.o sms-cards.o
-sms1xxx-objs := smscoreapi.o sms-cards.o
+sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o
 
 obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
 obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o



      
