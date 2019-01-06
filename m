Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1217DC43444
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1FB20868
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfAFPyX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 10:54:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40351 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfAFPyW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 10:54:22 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id BFFEA60004;
        Sun,  6 Jan 2019 15:54:19 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 2/6] media: adv748x: Rename reset procedures
Date:   Sun,  6 Jan 2019 16:54:09 +0100
Message-Id: <20190106155413.30666-3-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Rename the chip reset procedure as they configure the CP (HDMI) and SD
(AFE) cores.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index d94c63cb6a2e..ad4e6424753a 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -353,9 +353,8 @@ static const struct adv748x_reg_value adv748x_sw_reset[] = {
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };
 
-/* Supported Formats For Script Below */
-/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
-static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
+/* Initialize CP Core with RGB888 format. */
+static const struct adv748x_reg_value adv748x_init_hdmi[] = {
 	/* Disable chip powerdown & Enable HDMI Rx block */
 	{ADV748X_PAGE_IO, 0x00, 0x40},
 
@@ -399,10 +398,8 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };
 
-/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
-/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
-static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
-
+/* Initialize AFE core with YUV8 format. */
+static const struct adv748x_reg_value adv748x_init_afe[] = {
 	{ADV748X_PAGE_IO, 0x00, 0x30},	/* Disable chip powerdown Rx */
 	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
 
@@ -445,19 +442,18 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret < 0)
 		return ret;
 
-	/* Init and power down TXA */
-	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
+	/* Initialize CP and AFE cores. */
+	ret = adv748x_write_regs(state, adv748x_init_hdmi);
 	if (ret)
 		return ret;
 
-	adv748x_tx_power(&state->txa, 1);
-	adv748x_tx_power(&state->txa, 0);
-
-	/* Init and power down TXB */
-	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
+	ret = adv748x_write_regs(state, adv748x_init_afe);
 	if (ret)
 		return ret;
 
+	/* Reset TXA and TXB */
+	adv748x_tx_power(&state->txa, 1);
+	adv748x_tx_power(&state->txa, 0);
 	adv748x_tx_power(&state->txb, 1);
 	adv748x_tx_power(&state->txb, 0);
 
-- 
2.20.1

