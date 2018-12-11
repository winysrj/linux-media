Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35185C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3D820851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:16:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF3D820851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbeLKPQf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:16:35 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42649 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbeLKPQe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:16:34 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id D4DA2C000E;
        Tue, 11 Dec 2018 15:16:31 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/5] media: adv748x: Rework reset procedure
Date:   Tue, 11 Dec 2018 16:16:09 +0100
Message-Id: <1544541373-30044-2-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Re-work the chip reset procedure to configure the CP (HDMI) and SD (AFE) cores
before resetting the MIPI CSI-2 TXs.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index d94c63cb6a2e..5495dc7891e8 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -353,9 +353,8 @@ static const struct adv748x_reg_value adv748x_sw_reset[] = {
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };

-/* Supported Formats For Script Below */
-/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
-static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
+/* Initialize CP Core. */
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
+/* Initialize AFE core. */
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
2.7.4

