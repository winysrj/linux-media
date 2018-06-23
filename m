Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34945 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbeFWPg3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:29 -0400
Received: by mail-wm0-f65.google.com with SMTP id j15-v6so5644219wme.0
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:28 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 11/19] [media] ddbridge/mci: rename defines and fix i/q var types
Date: Sat, 23 Jun 2018 17:36:07 +0200
Message-Id: <20180623153615.27630-12-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Adjustments to match the FPGA firmware, and the signal I/Q values are
reported as s16 types from the card firmware.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c |  2 +-
 drivers/media/pci/ddbridge/ddbridge-mci.h | 56 +++++++++++++++----------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index 7d402861fa9e..fa0d7d0cc6f6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -342,7 +342,7 @@ static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (state->base->iq_mode) {
-		cmd.command = SX8_CMD_SELECT_IQOUT;
+		cmd.command = SX8_CMD_ENABLE_IQOUTPUT;
 		cmd.demod = state->demod;
 		cmd.output = 0;
 		mci_cmd(state, &cmd, NULL);
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 389f6376603b..2e74f0544717 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -51,40 +51,40 @@
 #define SX8_TSCONFIG_BURSTSIZE_8K           (0x00000020)
 #define SX8_TSCONFIG_BURSTSIZE_16K          (0x00000030)
 
-#define SX8_DEMOD_STOPPED       (0)
-#define SX8_DEMOD_IQ_MODE       (1)
-#define SX8_DEMOD_WAIT_SIGNAL   (2)
-#define SX8_DEMOD_WAIT_MATYPE   (3)
-#define SX8_DEMOD_TIMEOUT       (14)
-#define SX8_DEMOD_LOCKED        (15)
+#define SX8_DEMOD_STOPPED        (0)
+#define SX8_DEMOD_IQ_MODE        (1)
+#define SX8_DEMOD_WAIT_SIGNAL    (2)
+#define SX8_DEMOD_WAIT_MATYPE    (3)
+#define SX8_DEMOD_TIMEOUT        (14)
+#define SX8_DEMOD_LOCKED         (15)
 
-#define MCI_CMD_STOP            (0x01)
-#define MCI_CMD_GETSTATUS       (0x02)
-#define MCI_CMD_GETSIGNALINFO   (0x03)
-#define MCI_CMD_RFPOWER         (0x04)
+#define MCI_CMD_STOP             (0x01)
+#define MCI_CMD_GETSTATUS        (0x02)
+#define MCI_CMD_GETSIGNALINFO    (0x03)
+#define MCI_CMD_RFPOWER          (0x04)
 
-#define MCI_CMD_SEARCH_DVBS     (0x10)
+#define MCI_CMD_SEARCH_DVBS      (0x10)
 
-#define MCI_CMD_GET_IQSYMBOL    (0x30)
+#define MCI_CMD_GET_IQSYMBOL     (0x30)
 
-#define SX8_CMD_INPUT_ENABLE    (0x40)
-#define SX8_CMD_INPUT_DISABLE   (0x41)
-#define SX8_CMD_START_IQ        (0x42)
-#define SX8_CMD_STOP_IQ         (0x43)
-#define SX8_CMD_SELECT_IQOUT    (0x44)
-#define SX8_CMD_SELECT_TSOUT    (0x45)
+#define SX8_CMD_INPUT_ENABLE     (0x40)
+#define SX8_CMD_INPUT_DISABLE    (0x41)
+#define SX8_CMD_START_IQ         (0x42)
+#define SX8_CMD_STOP_IQ          (0x43)
+#define SX8_CMD_ENABLE_IQOUTPUT  (0x44)
+#define SX8_CMD_DISABLE_IQOUTPUT (0x45)
 
-#define SX8_ERROR_UNSUPPORTED   (0x80)
+#define MCI_ERROR_UNSUPPORTED    (0x80)
 
-#define SX8_SUCCESS(status)     (status < SX8_ERROR_UNSUPPORTED)
+#define MCI_SUCCESS(status)      (status < MCI_ERROR_UNSUPPORTED)
 
-#define SX8_CMD_DIAG_READ8      (0xE0)
-#define SX8_CMD_DIAG_READ32     (0xE1)
-#define SX8_CMD_DIAG_WRITE8     (0xE2)
-#define SX8_CMD_DIAG_WRITE32    (0xE3)
+#define SX8_CMD_DIAG_READ8       (0xE0)
+#define SX8_CMD_DIAG_READ32      (0xE1)
+#define SX8_CMD_DIAG_WRITE8      (0xE2)
+#define SX8_CMD_DIAG_WRITE32     (0xE3)
 
-#define SX8_CMD_DIAG_READRF     (0xE8)
-#define SX8_CMD_DIAG_WRITERF    (0xE9)
+#define SX8_CMD_DIAG_READRF      (0xE8)
+#define SX8_CMD_DIAG_WRITERF     (0xE9)
 
 struct mci_command {
 	union {
@@ -141,8 +141,8 @@ struct mci_result {
 			u32 ber_denominator;
 		} dvbs2_signal_info;
 		struct {
-			u8 i_symbol;
-			u8 q_symbol;
+			s16 i;
+			s16 q;
 		} dvbs2_signal_iq;
 	};
 	u32 version[4];
-- 
2.16.4
