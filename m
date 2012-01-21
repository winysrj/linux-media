Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4jq3023691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 25/35] [media] drxk: add support for Mpeg output clock drive strength config
Date: Sat, 21 Jan 2012 14:04:27 -0200
Message-Id: <1327161877-16784-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-25-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c      |    3 +--
 drivers/media/dvb/frontends/drxk.h      |    4 +++-
 drivers/media/dvb/frontends/drxk_hard.c |   12 ++++++------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 00a0bf1..bf8d201 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -69,6 +69,7 @@ static struct drxk_config terratec_h7_drxk = {
 	.single_master = true,
 	.no_i2c_bridge = false,
 	.chunk_size = 64,
+	.mpeg_out_clk_strength = 0x02,
 	.microcode_name = "dvb-usb-terratec-h7-az6007.fw",
 };
 
@@ -278,12 +279,10 @@ static int az6007_led_on_off(struct usb_interface *intf, int onoff)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	int ret;
-
 	/* TS through */
 	ret = az6007_write(udev, AZ6007_POWER, onoff, 0, NULL, 0);
 	if (ret < 0)
 		err("%s failed with error %d", __func__, ret);
-
 	return ret;
 }
 
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 6b0fd2c..ca921c7 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -17,6 +17,7 @@
  * @antenna_gpio:	GPIO bit used to control the antenna
  * @antenna_dvbt:	GPIO bit for changing antenna to DVB-C. A value of 1
  *			means that 1=DVBC, 0 = DVBT. Zero means the opposite.
+ * @mpeg_out_clk_strength: DRXK Mpeg output clock drive strength.
  * @microcode_name:	Name of the firmware file with the microcode
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
@@ -32,7 +33,8 @@ struct drxk_config {
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
 
-	int    chunk_size;
+	u8	mpeg_out_clk_strength;
+	int	chunk_size;
 
 	const char *microcode_name;
 };
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 6570396..d25b0d2 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -91,10 +91,6 @@ bool IsA1WithRomCode(struct drxk_state *state)
 #define DRXK_MPEG_PARALLEL_OUTPUT_PIN_DRIVE_STRENGTH (0x03)
 #endif
 
-#ifndef DRXK_MPEG_OUTPUT_CLK_DRIVE_STRENGTH
-#define DRXK_MPEG_OUTPUT_CLK_DRIVE_STRENGTH (0x06)
-#endif
-
 #define DEFAULT_DRXK_MPEG_LOCK_TIMEOUT 700
 #define DEFAULT_DRXK_DEMOD_LOCK_TIMEOUT 500
 
@@ -659,7 +655,6 @@ static int init_state(struct drxk_state *state)
 	u32 ulGPIOCfg = 0x0113;
 	u32 ulInvertTSClock = 0;
 	u32 ulTSDataStrength = DRXK_MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH;
-	u32 ulTSClockkStrength = DRXK_MPEG_OUTPUT_CLK_DRIVE_STRENGTH;
 	u32 ulDVBTBitrate = 50000000;
 	u32 ulDVBCBitrate = DRXK_QAM_SYMBOLRATE_MAX * 8;
 
@@ -820,7 +815,6 @@ static int init_state(struct drxk_state *state)
 	state->m_DVBCBitrate = ulDVBCBitrate;
 
 	state->m_TSDataStrength = (ulTSDataStrength & 0x07);
-	state->m_TSClockkStrength = (ulTSClockkStrength & 0x07);
 
 	/* Maximum bitrate in b/s in case static clockrate is selected */
 	state->m_mpegTsStaticBitrate = 19392658;
@@ -6394,6 +6388,12 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 		state->m_DVBCStaticCLK = 1;
 	}
 
+
+	if (config->mpeg_out_clk_strength)
+		state->m_TSClockkStrength = config->mpeg_out_clk_strength & 0x07;
+	else
+		state->m_TSClockkStrength = 0x06;
+
 	if (config->parallel_ts)
 		state->m_enableParallel = true;
 	else
-- 
1.7.8

