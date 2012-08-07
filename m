Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab2HGCrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:46 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:46 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 01/24] au8522: fix intermittent lockup of analog video decoder
Date: Mon,  6 Aug 2012 22:46:51 -0400
Message-Id: <1344307634-11673-2-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turns up the autodetection for the video standard in the au8522 is prone
to hanging the chip until a reset is performed.  This condition is trivial
to reproduce simply by tuning to a station and then rapidly unplugging/
replugging the coax feed.

Because we've never claimed to support anything other than NTSC-M, just
disable the video-standard autodetection logic and force it to always be
NTSC-M.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb/frontends/au8522_decoder.c |    6 +++-
 drivers/media/dvb/frontends/au8522_priv.h    |   28 +++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb/frontends/au8522_decoder.c
index 55b6390..f2e786b 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -257,9 +257,11 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 	au8522_writereg(state, AU8522_TVDED_DBG_MODE_REG060H,
 			AU8522_TVDED_DBG_MODE_REG060H_CVBS);
 	au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL1_REG061H,
-			AU8522_TVDEC_FORMAT_CTRL1_REG061H_CVBS13);
+			AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_525 |
+			AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_63_492 |
+			AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_MN);
 	au8522_writereg(state, AU8522_TVDEC_FORMAT_CTRL2_REG062H,
-			AU8522_TVDEC_FORMAT_CTRL2_REG062H_CVBS13);
+			AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_NTSC);
 	au8522_writereg(state, AU8522_TVDEC_VCR_DET_LLIM_REG063H,
 			AU8522_TVDEC_VCR_DET_LLIM_REG063H_CVBS);
 	au8522_writereg(state, AU8522_TVDEC_VCR_DET_HLIM_REG064H,
diff --git a/drivers/media/dvb/frontends/au8522_priv.h b/drivers/media/dvb/frontends/au8522_priv.h
index 6e4a438..9f44a7b 100644
--- a/drivers/media/dvb/frontends/au8522_priv.h
+++ b/drivers/media/dvb/frontends/au8522_priv.h
@@ -325,6 +325,31 @@ int au8522_led_ctrl(struct au8522_state *state, int led);
 
 /**************************************************************/
 
+/* Format control 1 */
+
+/* VCR Mode 7-6 */
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_VCR_MODE_YES		0x80
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_VCR_MODE_NO		0x40
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_VCR_MODE_AUTO		0x00
+/* Field len 5-4 */
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_625		0x20
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_525		0x10
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_FIELD_LEN_AUTO	0x00
+/* Line len (us) 3-2 */
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_64_000	0x0b
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_63_492	0x08
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_LINE_LEN_63_556	0x04
+/* Subcarrier freq 1-0 */
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_AUTO	0x03
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_443	0x02
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_MN	0x01
+#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_SUBCARRIER_NTSC_50	0x00
+
+/* Format control 2 */
+#define AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_AUTODETECT	0x00
+#define AU8522_TVDEC_FORMAT_CTRL2_REG062H_STD_NTSC		0x01
+
+
 #define AU8522_INPUT_CONTROL_REG081H_ATSC               	0xC4
 #define AU8522_INPUT_CONTROL_REG081H_ATVRF			0xC4
 #define AU8522_INPUT_CONTROL_REG081H_ATVRF13			0xC4
@@ -385,9 +410,6 @@ int au8522_led_ctrl(struct au8522_state *state, int led);
 #define AU8522_TVDEC_COMB_MODE_REG015H_CVBS			0x00
 #define AU8522_REG016H_CVBS					0x00
 #define AU8522_TVDED_DBG_MODE_REG060H_CVBS			0x00
-#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_CVBS			0x0B
-#define AU8522_TVDEC_FORMAT_CTRL1_REG061H_CVBS13		0x03
-#define AU8522_TVDEC_FORMAT_CTRL2_REG062H_CVBS13		0x00
 #define AU8522_TVDEC_VCR_DET_LLIM_REG063H_CVBS			0x19
 #define AU8522_REG0F9H_AUDIO					0x20
 #define AU8522_TVDEC_VCR_DET_HLIM_REG064H_CVBS			0xA7
-- 
1.7.1

