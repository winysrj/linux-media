Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43962 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760248AbcKDIAy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 04:00:54 -0400
From: Maninder Singh <maninder.s2@samsung.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel@stlinux.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Ravikant Bijendra Sharma <ravikant.s2@samsung.com>,
        Maninder Singh <maninder.s2@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: st-cec: add parentheses around complex macros
Date: Fri, 04 Nov 2016 13:28:31 +0530
Message-id: <1478246311-15944-1-git-send-email-maninder.s2@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the following checkpatch.pl error:
ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Maninder Singh <maninder.s2@samsung.com>
---
 drivers/staging/media/st-cec/stih-cec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
index 2143448..b22394a 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -108,11 +108,11 @@
 
 /* Constants for CEC_BIT_TOUT_THRESH register */
 #define CEC_SBIT_TOUT_47MS BIT(1)
-#define CEC_SBIT_TOUT_48MS BIT(0) | BIT(1)
+#define CEC_SBIT_TOUT_48MS (BIT(0) | BIT(1))
 #define CEC_SBIT_TOUT_50MS BIT(2)
 #define CEC_DBIT_TOUT_27MS BIT(0)
 #define CEC_DBIT_TOUT_28MS BIT(1)
-#define CEC_DBIT_TOUT_29MS BIT(0) | BIT(1)
+#define CEC_DBIT_TOUT_29MS (BIT(0) | BIT(1))
 
 /* Constants for CEC_BIT_PULSE_THRESH register */
 #define CEC_BIT_LPULSE_03MS BIT(1)
-- 
1.7.9.5

