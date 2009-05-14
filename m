Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110803.mail.gq1.yahoo.com ([67.195.13.226]:35431 "HELO
	web110803.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752693AbZENTeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:34:18 -0400
Message-ID: <380479.64791.qm@web110803.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:34:19 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_20] Siano: smscards - add table entities to new cards
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242328012 -10800
# Node ID 9341c85c499e5052022ffd4ad154e912bffabe59
# Parent  ccbe8d7a70064b1552f2034b958551b8fc294d8e
[0905_20] Siano: smscards - add table entities to new cards

From: Uri Shkolnik <uris@siano-ms.com>

Add new board descriptions to table, for Venice and Vega

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r ccbe8d7a7006 -r 9341c85c499e linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:04:03 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:06:52 2009 +0300
@@ -129,6 +129,16 @@ static struct sms_board sms_boards[] = {
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
 		.lna_ctrl  = -1,
+	},
+	[SMS1XXX_BOARD_SIANO_NICE] = {
+	/* 11 */
+		.name = "Siano Nice Digital Receiver",
+		.type = SMS_NOVA_B0,
+	},
+	[SMS1XXX_BOARD_SIANO_VENICE] = {
+	/* 12 */
+		.name = "Siano Venice Digital Receiver",
+		.type = SMS_VEGA,
 	},
 };
 



      
