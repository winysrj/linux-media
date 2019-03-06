Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E4EC10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 11:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ABA820661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 11:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfCFL0g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 06:26:36 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47133 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfCFL0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 06:26:36 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id F2E0B240014;
        Wed,  6 Mar 2019 11:26:32 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
Date:   Wed,  6 Mar 2019 12:26:59 +0100
Message-Id: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When both the media links between AFE and HDMI and the two TX CSI-2 outputs
gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
TXA and TXB output to get disabled.

This causes some HDMI transmitters to stop working after both AFE and
HDMI links are disabled. Fix this by preventing writing 0 to
ADV748X_IO_10 register, which gets only updated when links are enabled
again.

Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
The issue presents itself only on some HDMI transmitters, and went unnoticed
during the development of:
"[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"

Patch intended to be applied on top of latest media-master, where the
"[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
series is applied.

The patch reports a "Fixes" tag, but should actually be merged with the above
mentioned series.

Thanks
   j
---
 drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index f57cd77a32fa..0e5a75eb6d75 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,

 	tx->src = enable ? rsd : NULL;

+	if (!enable)
+		return 0;
+
 	if (state->afe.tx) {
 		/* AFE Requires TXA enabled, even when output to TXB */
 		io10 |= ADV748X_IO_10_CSI4_EN;
--
2.20.1

