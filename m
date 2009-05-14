Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230]:37984 "HELO
	web110807.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752047AbZENTkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:40:08 -0400
Message-ID: <992118.47326.qm@web110807.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:34:59 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_21] Siano: smscards - assign gpio to HPG targets
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242328393 -10800
# Node ID 71c60eec8001438fee7e9f2e220a101576d6a219
# Parent  9341c85c499e5052022ffd4ad154e912bffabe59
[0905_21] Siano: smscards - assign gpio to HPG targets

From: Uri Shkolnik <uris@siano-ms.com>

Assign using the new gpio structures, i/o for exist HPG
targets, without removing the old implementation.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 9341c85c499e -r 71c60eec8001 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:06:52 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:13:13 2009 +0300
@@ -113,6 +113,9 @@ static struct sms_board sms_boards[] = {
 		.name	= "Hauppauge WinTV MiniStick",
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.board_cfg.leds_power = 26,
+		.board_cfg.led0 = 27,
+		.board_cfg.led1 = 28,
 		.led_power = 26,
 		.led_lo    = 27,
 		.led_hi    = 28,
@@ -122,7 +125,9 @@ static struct sms_board sms_boards[] = {
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
 		.lna_ctrl  = 29,
+		.board_cfg.foreign_lna0_ctrl = 29,
 		.rf_switch = 17,
+		.board_cfg.rf_switch_uhf = 17,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2] = {
 		.name	= "Hauppauge WinTV MiniCard",



      
