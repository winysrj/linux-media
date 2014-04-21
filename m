Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39189 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaDUN71 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 09:59:27 -0400
Received: from avalon.ideasonboard.com (147.20-200-80.adsl-dyn.isp.belgacom.be [80.200.20.147])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7F54F359FA
	for <linux-media@vger.kernel.org>; Mon, 21 Apr 2014 15:57:15 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] omap4iss: Relax usleep ranges
Date: Mon, 21 Apr 2014 15:59:31 +0200
Message-Id: <1398088771-6375-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398088771-6375-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398088771-6375-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow the system to merge CPU wakeups by specifying different minimum
and maximum usleep values.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c      | 2 +-
 drivers/staging/media/omap4iss/iss_csi2.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 217d719..2e422dd 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -741,7 +741,7 @@ static int iss_reset(struct iss_device *iss)
 
 	timeout = iss_poll_condition_timeout(
 		!(iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_SYSCONFIG) &
-		ISS_HL_SYSCONFIG_SOFTRESET), 1000, 10, 10);
+		ISS_HL_SYSCONFIG_SOFTRESET), 1000, 10, 100);
 	if (timeout) {
 		dev_err(iss->dev, "ISS reset timeout\n");
 		return -ETIMEDOUT;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 3296115..bf8a657 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -500,7 +500,7 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 
 	timeout = iss_poll_condition_timeout(
 		iss_reg_read(csi2->iss, csi2->regs1, CSI2_SYSSTATUS) &
-		CSI2_SYSSTATUS_RESET_DONE, 500, 100, 100);
+		CSI2_SYSSTATUS_RESET_DONE, 500, 100, 200);
 	if (timeout) {
 		dev_err(csi2->iss->dev, "CSI2: Soft reset timeout!\n");
 		return -EBUSY;
@@ -511,7 +511,7 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 
 	timeout = iss_poll_condition_timeout(
 		iss_reg_read(csi2->iss, csi2->phy->phy_regs, REGISTER1) &
-		REGISTER1_RESET_DONE_CTRLCLK, 10000, 100, 100);
+		REGISTER1_RESET_DONE_CTRLCLK, 10000, 100, 500);
 	if (timeout) {
 		dev_err(csi2->iss->dev, "CSI2: CSI2_96M_FCLK reset timeout!\n");
 		return -EBUSY;
-- 
1.8.3.2

