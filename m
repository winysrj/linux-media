Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab0CKN1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 08:27:01 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2BDR0P5007897
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:27:00 -0500
Received: from pedra (vpn-234-51.phx2.redhat.com [10.3.234.51])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2BDQqex015794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:26:59 -0500
Date: Thu, 11 Mar 2010 10:26:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/7] V4L/DVB: tm6000: Replace all Req 8 group of regs with
 another naming convention
Message-ID: <20100311102646.73b1cd9b@pedra>
In-Reply-To: <cover.1268311636.git.mchehab@redhat.com>
References: <cover.1268311636.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According with the original patch that added the register names, those
are related to tm6010, so name it properly as such. Also, clearly
indicates when a register belongs to Request 0x08 and add its register
value at the name. This makes easier to double check if the proper
register is used along the driver.

This patch were made with the help of this simple perl script, applied
over the definitions of the last register groups:

if (m/define (TM6000_)([^\s]+)\s+0x([A-F0-9].)/) { $name=$2;
$val=$3; printf "s,$1$2,TM6010_REQ08_R%s_%s,g\n", $val, $name; }

And were manually adjusted to fix a few minor issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 321eb3f..00f7e04 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -478,64 +478,64 @@ enum {
 #define TM6000_U_DATA_FIFO15		0xFC
 
 /* Define TM6000/TM6010 Audio decoder registers */
-#define TM6000_A_VERSION		0x00
-#define TM6000_A_INIT			0x01
-#define TM6000_A_FIX_GAIN_CTRL		0x02
-#define TM6000_A_AUTO_GAIN_CTRL		0x03
-#define TM6000_A_SIF_AMP_CTRL		0x04
-#define TM6000_A_STANDARD_MOD		0x05
-#define TM6000_A_SOUND_MOD		0x06
-#define TM6000_A_LEFT_VOL		0x07
-#define TM6000_A_RIGHT_VOL		0x08
-#define TM6000_A_MAIN_VOL		0x09
-#define TM6000_A_I2S_MOD		0x0A
-#define TM6000_A_ASD_THRES1		0x0B
-#define TM6000_A_ASD_THRES2		0x0C
-#define TM6000_A_AMD_THRES		0x0D
-#define TM6000_A_MONO_THRES1		0x0E
-#define TM6000_A_MONO_THRES2		0x0F
-#define TM6000_A_MUTE_THRES1		0x10
-#define TM6000_A_MUTE_THRES2		0x11
-#define TM6000_A_AGC_U			0x12
-#define TM6000_A_AGC_ERR_T		0x13
-#define TM6000_A_AGC_GAIN_INIT		0x14
-#define TM6000_A_AGC_STEP_THR		0x15
-#define TM6000_A_AGC_GAIN_MAX		0x16
-#define TM6000_A_AGC_GAIN_MIN		0x17
-#define TM6000_A_TR_CTRL		0x18
-#define TM6000_A_FH_2FH_GAIN		0x19
-#define TM6000_A_NICAM_SER_MAX		0x1A
-#define TM6000_A_NICAM_SER_MIN		0x1B
-#define TM6000_A_GAIN_DEEMPH_OUT	0x1E
-#define TM6000_A_TEST_INTF_SEL		0x1F
-#define TM6000_A_TEST_PIN_SEL		0x20
-#define TM6000_A_AGC_ERR		0x21
-#define TM6000_A_AGC_GAIN		0x22
-#define TM6000_A_NICAM_INFO		0x23
-#define TM6000_A_SER			0x24
-#define TM6000_A_C1_AMP			0x25
-#define TM6000_A_C2_AMP			0x26
-#define TM6000_A_NOISE_AMP		0x27
-#define TM6000_A_AUDIO_MODE_RES		0x28
+#define TM6010_REQ08_R00_A_VERSION		0x00
+#define TM6010_REQ08_R01_A_INIT			0x01
+#define TM6010_REQ08_R02_A_FIX_GAIN_CTRL	0x02
+#define TM6010_REQ08_R03_A_AUTO_GAIN_CTRL	0x03
+#define TM6010_REQ08_R04_A_SIF_AMP_CTRL		0x04
+#define TM6010_REQ08_R05_A_STANDARD_MOD		0x05
+#define TM6010_REQ08_R06_A_SOUND_MOD		0x06
+#define TM6010_REQ08_R07_A_LEFT_VOL		0x07
+#define TM6010_REQ08_R08_A_RIGHT_VOL		0x08
+#define TM6010_REQ08_R09_A_MAIN_VOL		0x09
+#define TM6010_REQ08_R0A_A_I2S_MOD		0x0A
+#define TM6010_REQ08_R0B_A_ASD_THRES1		0x0B
+#define TM6010_REQ08_R0C_A_ASD_THRES2		0x0C
+#define TM6010_REQ08_R0D_A_AMD_THRES		0x0D
+#define TM6010_REQ08_R0E_A_MONO_THRES1		0x0E
+#define TM6010_REQ08_R0F_A_MONO_THRES2		0x0F
+#define TM6010_REQ08_R10_A_MUTE_THRES1		0x10
+#define TM6010_REQ08_R11_A_MUTE_THRES2		0x11
+#define TM6010_REQ08_R12_A_AGC_U		0x12
+#define TM6010_REQ08_R13_A_AGC_ERR_T		0x13
+#define TM6010_REQ08_R14_A_AGC_GAIN_INIT	0x14
+#define TM6010_REQ08_R15_A_AGC_STEP_THR		0x15
+#define TM6010_REQ08_R16_A_AGC_GAIN_MAX		0x16
+#define TM6010_REQ08_R17_A_AGC_GAIN_MIN		0x17
+#define TM6010_REQ08_R18_A_TR_CTRL		0x18
+#define TM6010_REQ08_R19_A_FH_2FH_GAIN		0x19
+#define TM6010_REQ08_R1A_A_NICAM_SER_MAX	0x1A
+#define TM6010_REQ08_R1B_A_NICAM_SER_MIN	0x1B
+#define TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT	0x1E
+#define TM6010_REQ08_R1F_A_TEST_INTF_SEL	0x1F
+#define TM6010_REQ08_R20_A_TEST_PIN_SEL		0x20
+#define TM6010_REQ08_R21_A_AGC_ERR		0x21
+#define TM6010_REQ08_R22_A_AGC_GAIN		0x22
+#define TM6010_REQ08_R23_A_NICAM_INFO		0x23
+#define TM6010_REQ08_R24_A_SER			0x24
+#define TM6010_REQ08_R25_A_C1_AMP		0x25
+#define TM6010_REQ08_R26_A_C2_AMP		0x26
+#define TM6010_REQ08_R27_A_NOISE_AMP		0x27
+#define TM6010_REQ08_R28_A_AUDIO_MODE_RES	0x28
 
 /* Define TM6000/TM6010 Video ADC registers */
-#define TM6000_ADC_REF			0xE0
-#define TM6000_DAC_CLMP			0xE1
-#define TM6000_POWER_DOWN_CTRL1		0xE2
-#define TM6000_ADC_IN1_SEL		0xE3
-#define TM6000_ADC_IN2_SEL		0xE4
-#define TM6000_GAIN_PARAM		0xE5
-#define TM6000_POWER_DOWN_CTRL2		0xE6
-#define TM6000_REG_GAIN_Y		0xE7
-#define TM6000_REG_GAIN_C		0xE8
-#define TM6000_BIAS_CTRL		0xE9
-#define TM6000_BUFF_DRV_CTRL		0xEA
-#define TM6000_SIF_GAIN_CTRL		0xEB
-#define TM6000_REVERSE_YC_CTRL		0xEC
-#define TM6000_GAIN_SEL			0xED
+#define TM6010_REQ08_RE0_ADC_REF		0xE0
+#define TM6010_REQ08_RE1_DAC_CLMP		0xE1
+#define TM6010_REQ08_RE2_POWER_DOWN_CTRL1	0xE2
+#define TM6010_REQ08_RE3_ADC_IN1_SEL		0xE3
+#define TM6010_REQ08_RE4_ADC_IN2_SEL		0xE4
+#define TM6010_REQ08_RE5_GAIN_PARAM		0xE5
+#define TM6010_REQ08_RE6_POWER_DOWN_CTRL2	0xE6
+#define TM6010_REQ08_RE7_REG_GAIN_Y		0xE7
+#define TM6010_REQ08_RE8_REG_GAIN_C		0xE8
+#define TM6010_REQ08_RE9_BIAS_CTRL		0xE9
+#define TM6010_REQ08_REA_BUFF_DRV_CTRL		0xEA
+#define TM6010_REQ08_REB_SIF_GAIN_CTRL		0xEB
+#define TM6010_REQ08_REC_REVERSE_YC_CTRL	0xEC
+#define TM6010_REQ08_RED_GAIN_SEL		0xED
 
 /* Define TM6000/TM6010 Audio ADC registers */
-#define TM6000_DAUDIO_INPUT_CONFIG	0xF0
-#define TM6000_AADC_POWER_DOWN		0xF1
-#define TM6000_LEFT_CHANNEL_VOL		0xF2
-#define TM6000_RIGHT_CHANNEL_VOL	0xF3
+#define TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG	0xF0
+#define TM6010_REQ08_RF1_AADC_POWER_DOWN	0xF1
+#define TM6010_REQ08_RF2_LEFT_CHANNEL_VOL	0xF2
+#define TM6010_REQ08_RF3_RIGHT_CHANNEL_VOL	0xF3
-- 
1.6.6.1


