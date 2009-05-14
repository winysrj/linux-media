Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110805.mail.gq1.yahoo.com ([67.195.13.228]:21655 "HELO
	web110805.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752824AbZENTdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:33:36 -0400
Message-ID: <886941.10625.qm@web110805.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:33:37 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_19] Siano: smscards - fix wrong firmware assignment
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242327843 -10800
# Node ID ccbe8d7a70064b1552f2034b958551b8fc294d8e
# Parent  fdfd103426e8aeabb18aaa1e117238e3ca450d0e
[0905_19] Siano: smscards - fix wrong firmware assignment

From: Uri Shkolnik <uris@siano-ms.com>

Remove wrong firmware assignments for Nova, Stellar

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r fdfd103426e8 -r ccbe8d7a7006 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:00:53 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:04:03 2009 +0300
@@ -81,17 +81,14 @@ static struct sms_board sms_boards[] = {
 	[SMS1XXX_BOARD_SIANO_STELLAR] = {
 		.name	= "Siano Stellar Digital Receiver",
 		.type	= SMS_STELLAR,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
 	},
 	[SMS1XXX_BOARD_SIANO_NOVA_A] = {
 		.name	= "Siano Nova A Digital Receiver",
 		.type	= SMS_NOVA_A0,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
 	},
 	[SMS1XXX_BOARD_SIANO_NOVA_B] = {
 		.name	= "Siano Nova B Digital Receiver",
 		.type	= SMS_NOVA_B0,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
 	},
 	[SMS1XXX_BOARD_SIANO_VEGA] = {
 		.name	= "Siano Vega Digital Receiver",



      
