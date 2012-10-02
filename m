Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2JBTFV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 15:05:21 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q92J5L3T028126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 2 Oct 2012 15:05:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] em28xx: regression fix: use DRX-K sync firmware requests on em28xx
Date: Tue,  2 Oct 2012 16:05:16 -0300
Message-Id: <1349204716-25971-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1349204716-25971-1-git-send-email-mchehab@redhat.com>
References: <1349204716-25971-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As em28xx-dvb will always be initialized asynchronously, there's
no need anymore for a separate thread to load the DRX-K firmware.

Fixes a known regression with kernel 3.6 with tda18271 driver
and asynchronous DRX-K firmware load.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 1662b70..913e522 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -318,6 +318,7 @@ static struct drxk_config terratec_h5_drxk = {
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 	.qam_demod_parameter_count = 2,
+	.load_firmware_sync = true,
 };
 
 static struct drxk_config hauppauge_930c_drxk = {
@@ -327,6 +328,7 @@ static struct drxk_config hauppauge_930c_drxk = {
 	.microcode_name = "dvb-usb-hauppauge-hvr930c-drxk.fw",
 	.chunk_size = 56,
 	.qam_demod_parameter_count = 2,
+	.load_firmware_sync = true,
 };
 
 struct drxk_config terratec_htc_stick_drxk = {
@@ -340,12 +342,14 @@ struct drxk_config terratec_htc_stick_drxk = {
 	.antenna_dvbt = true,
 	/* The windows driver uses the same. This will disable LNA. */
 	.antenna_gpio = 0x6,
+	.load_firmware_sync = true,
 };
 
 static struct drxk_config maxmedia_ub425_tc_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
+	.load_firmware_sync = true,
 };
 
 static struct drxk_config pctv_520e_drxk = {
@@ -356,6 +360,7 @@ static struct drxk_config pctv_520e_drxk = {
 	.chunk_size = 58,
 	.antenna_dvbt = true, /* disable LNA */
 	.antenna_gpio = (1 << 2), /* disable LNA */
+	.load_firmware_sync = true,
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
-- 
1.7.11.4

