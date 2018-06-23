Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32870 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbeFWPgg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:36 -0400
Received: by mail-wr0-f193.google.com with SMTP id k16-v6so9439768wro.0
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:35 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 19/19] [media] ddbridge/mci: add SX8 I/Q mode remark and remove DIAG CMD defines
Date: Sat, 23 Jun 2018 17:36:15 +0200
Message-Id: <20180623153615.27630-20-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Take note that the SX8 IQ mode is only available on a single tuner, and
remove the MCI/SX8 DIAG CMD defines.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.h | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 600a8bc642c4..24241111c634 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -42,6 +42,22 @@
 #define SX8_TSCONFIG_MODE_NORMAL            (0x00000001)
 #define SX8_TSCONFIG_MODE_IQ                (0x00000003)
 
+/*
+ * IQMode is only available on MaxSX8 on a single tuner
+ *
+ * IQ_MODE_SAMPLES
+ *       sampling rate is 1550/24 MHz (64.583 MHz)
+ *       channel agc is frozen, to allow stitching the FFT results together
+ *
+ * IQ_MODE_VTM
+ *       sampling rate is the supplied symbolrate
+ *       channel agc is active
+ *
+ * in both cases down sampling is done with a RRC Filter (currently fixed to
+ * alpha = 0.05) which causes some (ca 5%) aliasing at the edges from
+ * outside the spectrum
+ */
+
 #define SX8_TSCONFIG_TSHEADER               (0x00000004)
 #define SX8_TSCONFIG_BURST                  (0x00000008)
 
@@ -82,14 +98,6 @@
 
 #define MCI_SUCCESS(status)      ((status & MCI_STATUS_UNSUPPORTED) == 0)
 
-#define SX8_CMD_DIAG_READ8       (0xE0)
-#define SX8_CMD_DIAG_READ32      (0xE1)
-#define SX8_CMD_DIAG_WRITE8      (0xE2)
-#define SX8_CMD_DIAG_WRITE32     (0xE3)
-
-#define SX8_CMD_DIAG_READRF      (0xE8)
-#define SX8_CMD_DIAG_WRITERF     (0xE9)
-
 struct mci_command {
 	union {
 		u32 command_word;
-- 
2.16.4
