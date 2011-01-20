Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55202 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1ATGEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 01:04:21 -0500
Received: by eye27 with SMTP id 27so90890eye.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 22:04:19 -0800 (PST)
Date: Thu, 20 Jan 2011 15:05:08 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] tm6000: add/rework reg.defines
Message-ID: <20110120150508.53c9b55e@glory.local>
In-Reply-To: <4D0BFF4B.3060001@redhat.com>
References: <4CAD5A78.3070803@redhat.com>
	<20101008150301.2e3ceaff@glory.local>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
	<20101217104633.7c9d10d7@glory.local>
	<4D0AF2A7.6080100@arcor.de>
	<20101217160854.16a1f754@glory.local>
	<4D0BFF4B.3060001@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Pck/8dM_UcOpS_Vz_.MUozh"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/Pck/8dM_UcOpS_Vz_.MUozh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Rework registers defines. Add TM6000 specific registers defines.
Add marks and comments for TM6010 specific registers.

diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 1f0ced8..5375a83 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -97,6 +97,34 @@ enum {
 	TM6000_URB_MSG_ERR,
 };
 
+/* Define specific TM6000 Video decoder registers */
+#define TM6000_REQ07_RD8_TEST_SEL			0x07, 0xd8
+#define TM6000_REQ07_RD9_A_SIM_SEL			0x07, 0xd9
+#define TM6000_REQ07_RDA_CLK_SEL			0x07, 0xda
+#define TM6000_REQ07_RDB_OUT_SEL			0x07, 0xdb
+#define TM6000_REQ07_RDC_NSEL_I2S			0x07, 0xdc
+#define TM6000_REQ07_RDD_GPIO2_MDRV			0x07, 0xdd
+#define TM6000_REQ07_RDE_GPIO1_MDRV			0x07, 0xde
+#define TM6000_REQ07_RDF_PWDOWN_ACLK			0x07, 0xdf
+#define TM6000_REQ07_RE0_VADC_REF_CTL			0x07, 0xe0
+#define TM6000_REQ07_RE1_VADC_DACLIMP			0x07, 0xe1
+#define TM6000_REQ07_RE2_VADC_STATUS_CTL		0x07, 0xe2
+#define TM6000_REQ07_RE3_VADC_INP_LPF_SEL1		0x07, 0xe3
+#define TM6000_REQ07_RE4_VADC_TARGET1			0x07, 0xe4
+#define TM6000_REQ07_RE5_VADC_INP_LPF_SEL2		0x07, 0xe5
+#define TM6000_REQ07_RE6_VADC_TARGET2			0x07, 0xe6
+#define TM6000_REQ07_RE7_VADC_AGAIN_CTL			0x07, 0xe7
+#define TM6000_REQ07_RE8_VADC_PWDOWN_CTL		0x07, 0xe8
+#define TM6000_REQ07_RE9_VADC_INPUT_CTL1		0x07, 0xe9
+#define TM6000_REQ07_REA_VADC_INPUT_CTL2		0x07, 0xea
+#define TM6000_REQ07_REB_VADC_AADC_MODE			0x07, 0xeb
+#define TM6000_REQ07_REC_VADC_AADC_LVOL			0x07, 0xec
+#define TM6000_REQ07_RED_VADC_AADC_RVOL			0x07, 0xed
+#define TM6000_REQ07_REE_VADC_CTRL_SEL_CONTROL		0x07, 0xee
+#define TM6000_REQ07_REF_VADC_GAIN_MAP_CTL		0x07, 0xef
+#define TM6000_REQ07_RFD_BIST_ERR_VST_LOW		0x07, 0xfd
+#define TM6000_REQ07_RFE_BIST_ERR_VST_HIGH		0x07, 0xfe
+
 /* Define TM6000/TM6010 Video decoder registers */
 #define TM6010_REQ07_R00_VIDEO_CONTROL0			0x07, 0x00
 #define TM6010_REQ07_R01_VIDEO_CONTROL1			0x07, 0x01
@@ -241,6 +269,7 @@ enum {
 #define TM6010_REQ07_RC9_VEND1				0x07, 0xc9
 #define TM6010_REQ07_RCA_VEND0				0x07, 0xca
 #define TM6010_REQ07_RCB_DELAY				0x07, 0xcb
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RCC_ACTIVE_VIDEO_IF		0x07, 0xcc
 #define TM6010_REQ07_RD0_USB_PERIPHERY_CONTROL		0x07, 0xd0
 #define TM6010_REQ07_RD1_ADDR_FOR_REQ1			0x07, 0xd1
@@ -250,32 +279,59 @@ enum {
 #define TM6010_REQ07_RD5_POWERSAVE			0x07, 0xd5
 #define TM6010_REQ07_RD6_ENDP_REQ1_REQ2			0x07, 0xd6
 #define TM6010_REQ07_RD7_ENDP_REQ3_REQ4			0x07, 0xd7
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR				0x07, 0xd8
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_BSIZE			0x07, 0xd9
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_WAKEUP_SEL			0x07, 0xda
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_WAKEUP_ADD			0x07, 0xdb
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_LEADER1			0x07, 0xdc
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_LEADER0			0x07, 0xdd
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_PULSE_CNT1			0x07, 0xde
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_PULSE_CNT0			0x07, 0xdf
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE0_DVIDEO_SOURCE			0x07, 0xe0
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE0_DVIDEO_SOURCE_IF		0x07, 0xe1
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE2_OUT_SEL2			0x07, 0xe2
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE3_OUT_SEL1			0x07, 0xe3
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE4_OUT_SEL0			0x07, 0xe4
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE5_REMOTE_WAKEUP			0x07, 0xe5
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE7_PUB_GPIO			0x07, 0xe7
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE8_TYPESEL_MOS_I2S		0x07, 0xe8
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE9_TYPESEL_MOS_TS			0x07, 0xe9
+/* ONLY for TM6010 */
 #define TM6010_REQ07_REA_TYPESEL_MOS_CCIR		0x07, 0xea
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF0_BIST_CRC_RESULT0		0x07, 0xf0
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF1_BIST_CRC_RESULT1		0x07, 0xf1
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF2_BIST_CRC_RESULT2		0x07, 0xf2
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF3_BIST_CRC_RESULT3		0x07, 0xf3
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF4_BIST_ERR_VST2			0x07, 0xf4
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF5_BIST_ERR_VST1			0x07, 0xf5
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF6_BIST_ERR_VST0			0x07, 0xf6
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF7_BIST				0x07, 0xf7
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RFE_POWER_DOWN			0x07, 0xfe
 #define TM6010_REQ07_RFF_SOFT_RESET			0x07, 0xff
 
@@ -477,7 +533,8 @@ enum {
 #define TM6010_REQ05_RC4_DATA_FIFO14		0x05, 0xf8
 #define TM6010_REQ05_RC4_DATA_FIFO15		0x05, 0xfc
 
-/* Define TM6000/TM6010 Audio decoder registers */
+/* Define TM6010 Audio decoder registers */
+/* This core available only in TM6010 */
 #define TM6010_REQ08_R00_A_VERSION		0x08, 0x00
 #define TM6010_REQ08_R01_A_INIT			0x08, 0x01
 #define TM6010_REQ08_R02_A_FIX_GAIN_CTRL	0x08, 0x02
@@ -518,7 +575,7 @@ enum {
 #define TM6010_REQ08_R27_A_NOISE_AMP		0x08, 0x27
 #define TM6010_REQ08_R28_A_AUDIO_MODE_RES	0x08, 0x28
 
-/* Define TM6000/TM6010 Video ADC registers */
+/* Define TM6010 Video ADC registers */
 #define TM6010_REQ08_RE0_ADC_REF		0x08, 0xe0
 #define TM6010_REQ08_RE1_DAC_CLMP		0x08, 0xe1
 #define TM6010_REQ08_RE2_POWER_DOWN_CTRL1	0x08, 0xe2
@@ -534,7 +591,7 @@ enum {
 #define TM6010_REQ08_REC_REVERSE_YC_CTRL	0x08, 0xec
 #define TM6010_REQ08_RED_GAIN_SEL		0x08, 0xed
 
-/* Define TM6000/TM6010 Audio ADC registers */
+/* Define TM6010 Audio ADC registers */
 #define TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG	0x08, 0xf0
 #define TM6010_REQ08_RF1_AADC_POWER_DOWN	0x08, 0xf1
 #define TM6010_REQ08_RF2_LEFT_CHANNEL_VOL	0x08, 0xf2

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/Pck/8dM_UcOpS_Vz_.MUozh
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_reg_defines.patch

diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 1f0ced8..5375a83 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -97,6 +97,34 @@ enum {
 	TM6000_URB_MSG_ERR,
 };
 
+/* Define specific TM6000 Video decoder registers */
+#define TM6000_REQ07_RD8_TEST_SEL			0x07, 0xd8
+#define TM6000_REQ07_RD9_A_SIM_SEL			0x07, 0xd9
+#define TM6000_REQ07_RDA_CLK_SEL			0x07, 0xda
+#define TM6000_REQ07_RDB_OUT_SEL			0x07, 0xdb
+#define TM6000_REQ07_RDC_NSEL_I2S			0x07, 0xdc
+#define TM6000_REQ07_RDD_GPIO2_MDRV			0x07, 0xdd
+#define TM6000_REQ07_RDE_GPIO1_MDRV			0x07, 0xde
+#define TM6000_REQ07_RDF_PWDOWN_ACLK			0x07, 0xdf
+#define TM6000_REQ07_RE0_VADC_REF_CTL			0x07, 0xe0
+#define TM6000_REQ07_RE1_VADC_DACLIMP			0x07, 0xe1
+#define TM6000_REQ07_RE2_VADC_STATUS_CTL		0x07, 0xe2
+#define TM6000_REQ07_RE3_VADC_INP_LPF_SEL1		0x07, 0xe3
+#define TM6000_REQ07_RE4_VADC_TARGET1			0x07, 0xe4
+#define TM6000_REQ07_RE5_VADC_INP_LPF_SEL2		0x07, 0xe5
+#define TM6000_REQ07_RE6_VADC_TARGET2			0x07, 0xe6
+#define TM6000_REQ07_RE7_VADC_AGAIN_CTL			0x07, 0xe7
+#define TM6000_REQ07_RE8_VADC_PWDOWN_CTL		0x07, 0xe8
+#define TM6000_REQ07_RE9_VADC_INPUT_CTL1		0x07, 0xe9
+#define TM6000_REQ07_REA_VADC_INPUT_CTL2		0x07, 0xea
+#define TM6000_REQ07_REB_VADC_AADC_MODE			0x07, 0xeb
+#define TM6000_REQ07_REC_VADC_AADC_LVOL			0x07, 0xec
+#define TM6000_REQ07_RED_VADC_AADC_RVOL			0x07, 0xed
+#define TM6000_REQ07_REE_VADC_CTRL_SEL_CONTROL		0x07, 0xee
+#define TM6000_REQ07_REF_VADC_GAIN_MAP_CTL		0x07, 0xef
+#define TM6000_REQ07_RFD_BIST_ERR_VST_LOW		0x07, 0xfd
+#define TM6000_REQ07_RFE_BIST_ERR_VST_HIGH		0x07, 0xfe
+
 /* Define TM6000/TM6010 Video decoder registers */
 #define TM6010_REQ07_R00_VIDEO_CONTROL0			0x07, 0x00
 #define TM6010_REQ07_R01_VIDEO_CONTROL1			0x07, 0x01
@@ -241,6 +269,7 @@ enum {
 #define TM6010_REQ07_RC9_VEND1				0x07, 0xc9
 #define TM6010_REQ07_RCA_VEND0				0x07, 0xca
 #define TM6010_REQ07_RCB_DELAY				0x07, 0xcb
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RCC_ACTIVE_VIDEO_IF		0x07, 0xcc
 #define TM6010_REQ07_RD0_USB_PERIPHERY_CONTROL		0x07, 0xd0
 #define TM6010_REQ07_RD1_ADDR_FOR_REQ1			0x07, 0xd1
@@ -250,32 +279,59 @@ enum {
 #define TM6010_REQ07_RD5_POWERSAVE			0x07, 0xd5
 #define TM6010_REQ07_RD6_ENDP_REQ1_REQ2			0x07, 0xd6
 #define TM6010_REQ07_RD7_ENDP_REQ3_REQ4			0x07, 0xd7
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR				0x07, 0xd8
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_BSIZE			0x07, 0xd9
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_WAKEUP_SEL			0x07, 0xda
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_WAKEUP_ADD			0x07, 0xdb
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_LEADER1			0x07, 0xdc
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_LEADER0			0x07, 0xdd
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_PULSE_CNT1			0x07, 0xde
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RD8_IR_PULSE_CNT0			0x07, 0xdf
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE0_DVIDEO_SOURCE			0x07, 0xe0
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE0_DVIDEO_SOURCE_IF		0x07, 0xe1
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE2_OUT_SEL2			0x07, 0xe2
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE3_OUT_SEL1			0x07, 0xe3
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE4_OUT_SEL0			0x07, 0xe4
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE5_REMOTE_WAKEUP			0x07, 0xe5
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE7_PUB_GPIO			0x07, 0xe7
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE8_TYPESEL_MOS_I2S		0x07, 0xe8
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RE9_TYPESEL_MOS_TS			0x07, 0xe9
+/* ONLY for TM6010 */
 #define TM6010_REQ07_REA_TYPESEL_MOS_CCIR		0x07, 0xea
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF0_BIST_CRC_RESULT0		0x07, 0xf0
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF1_BIST_CRC_RESULT1		0x07, 0xf1
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF2_BIST_CRC_RESULT2		0x07, 0xf2
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF3_BIST_CRC_RESULT3		0x07, 0xf3
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF4_BIST_ERR_VST2			0x07, 0xf4
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF5_BIST_ERR_VST1			0x07, 0xf5
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF6_BIST_ERR_VST0			0x07, 0xf6
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RF7_BIST				0x07, 0xf7
+/* ONLY for TM6010 */
 #define TM6010_REQ07_RFE_POWER_DOWN			0x07, 0xfe
 #define TM6010_REQ07_RFF_SOFT_RESET			0x07, 0xff
 
@@ -477,7 +533,8 @@ enum {
 #define TM6010_REQ05_RC4_DATA_FIFO14		0x05, 0xf8
 #define TM6010_REQ05_RC4_DATA_FIFO15		0x05, 0xfc
 
-/* Define TM6000/TM6010 Audio decoder registers */
+/* Define TM6010 Audio decoder registers */
+/* This core available only in TM6010 */
 #define TM6010_REQ08_R00_A_VERSION		0x08, 0x00
 #define TM6010_REQ08_R01_A_INIT			0x08, 0x01
 #define TM6010_REQ08_R02_A_FIX_GAIN_CTRL	0x08, 0x02
@@ -518,7 +575,7 @@ enum {
 #define TM6010_REQ08_R27_A_NOISE_AMP		0x08, 0x27
 #define TM6010_REQ08_R28_A_AUDIO_MODE_RES	0x08, 0x28
 
-/* Define TM6000/TM6010 Video ADC registers */
+/* Define TM6010 Video ADC registers */
 #define TM6010_REQ08_RE0_ADC_REF		0x08, 0xe0
 #define TM6010_REQ08_RE1_DAC_CLMP		0x08, 0xe1
 #define TM6010_REQ08_RE2_POWER_DOWN_CTRL1	0x08, 0xe2
@@ -534,7 +591,7 @@ enum {
 #define TM6010_REQ08_REC_REVERSE_YC_CTRL	0x08, 0xec
 #define TM6010_REQ08_RED_GAIN_SEL		0x08, 0xed
 
-/* Define TM6000/TM6010 Audio ADC registers */
+/* Define TM6010 Audio ADC registers */
 #define TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG	0x08, 0xf0
 #define TM6010_REQ08_RF1_AADC_POWER_DOWN	0x08, 0xf1
 #define TM6010_REQ08_RF2_LEFT_CHANNEL_VOL	0x08, 0xf2

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/Pck/8dM_UcOpS_Vz_.MUozh--
