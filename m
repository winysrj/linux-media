Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44524 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbeFWPgd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:33 -0400
Received: by mail-wr0-f193.google.com with SMTP id p12-v6so7790581wrn.11
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:33 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 16/19] [media] ddbridge/mci: add more MCI status codes, improve MCI_SUCCESS macro
Date: Sat, 23 Jun 2018 17:36:12 +0200
Message-Id: <20180623153615.27630-17-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The MCI can report the command status more finegrained, so, add more
status code defines and update the MCI_SUCCESS macro.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index f02bc76e3c98..600a8bc642c4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -74,9 +74,13 @@
 #define SX8_CMD_ENABLE_IQOUTPUT  (0x44)
 #define SX8_CMD_DISABLE_IQOUTPUT (0x45)
 
-#define MCI_ERROR_UNSUPPORTED    (0x80)
+#define MCI_STATUS_OK            (0x00)
+#define MCI_STATUS_UNSUPPORTED   (0x80)
+#define MCI_STATUS_RETRY         (0xFD)
+#define MCI_STATUS_NOT_READY     (0xFE)
+#define MCI_STATUS_ERROR         (0xFF)
 
-#define MCI_SUCCESS(status)      (status < MCI_ERROR_UNSUPPORTED)
+#define MCI_SUCCESS(status)      ((status & MCI_STATUS_UNSUPPORTED) == 0)
 
 #define SX8_CMD_DIAG_READ8       (0xE0)
 #define SX8_CMD_DIAG_READ32      (0xE1)
-- 
2.16.4
