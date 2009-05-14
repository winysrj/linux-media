Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231]:28814 "HELO
	web110808.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751244AbZENTbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:31:22 -0400
Message-ID: <422468.32142.qm@web110808.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:31:23 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_16] Siano: smscards - add gpio look-up table
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242326150 -10800
# Node ID dd2de98ad42c1328d24e7bf90903fab1e1368b0b
# Parent  0f7ae5e8b09ff516f35f299e81aacbba237ba038
[0905_16] Siano: smscards - add gpio look-up table

From: Uri Shkolnik <uris@siano-ms.com>

Add gpio look-up table for various requirements, any
target may select any gpio and assign it to a function

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 0f7ae5e8b09f -r dd2de98ad42c linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:30:45 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:35:50 2009 +0300
@@ -37,9 +37,43 @@
 #define SMS1XXX_BOARD_SIANO_NICE	11
 #define SMS1XXX_BOARD_SIANO_VENICE	12
 
+struct sms_board_gpio_cfg {
+	int lna_vhf_exist;
+	int lna_vhf_ctrl;
+	int lna_uhf_exist;
+	int lna_uhf_ctrl;
+	int lna_uhf_d_ctrl;
+	int lna_sband_exist;
+	int lna_sband_ctrl;
+	int lna_sband_d_ctrl;
+	int foreign_lna0_ctrl;
+	int foreign_lna1_ctrl;
+	int foreign_lna2_ctrl;
+	int rf_switch_vhf;
+	int rf_switch_uhf;
+	int rf_switch_sband;
+	int leds_power;
+	int led0;
+	int led1;
+	int led2;
+	int led3;
+	int led4;
+	int ir;
+	int eeprom_wp;
+	int mrc_sense;
+	int mrc_pdn_resetn;
+	int mrc_gp0; /* mrcs spi int */
+	int mrc_gp1;
+	int mrc_gp2;
+	int mrc_gp3;
+	int mrc_gp4;
+	int host_spi_gsp_ts_int;
+};
+
 struct sms_board {
 	enum sms_device_type_st type;
 	char *name, *fw[DEVICE_MODE_MAX];
+	struct sms_board_gpio_cfg board_cfg;
 
 	/* gpios */
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;



      
