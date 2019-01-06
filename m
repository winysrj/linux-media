Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7715DC43613
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E3920868
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 15:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfAFPyV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 10:54:21 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42793 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfAFPyV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 10:54:21 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8DFC660003;
        Sun,  6 Jan 2019 15:54:18 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 1/6] media: adv748x: Add is_txb()
Date:   Sun,  6 Jan 2019 16:54:08 +0100
Message-Id: <20190106155413.30666-2-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add small is_txb() macro to the existing is_txa() and use it where
appropriate.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
 drivers/media/i2c/adv748x/adv748x.h      | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 6ce21542ed48..b6b5d8c7ea7c 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -82,7 +82,7 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
 		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
 						  &state->hdmi.sd,
 						  ADV748X_HDMI_SOURCE);
-	if (!is_txa(tx) && is_afe_enabled(state))
+	if (is_txb(tx) && is_afe_enabled(state))
 		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
 						  &state->afe.sd,
 						  ADV748X_AFE_SOURCE);
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index b482c7fe6957..bc2da1b5ce29 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -89,8 +89,12 @@ struct adv748x_csi2 {
 
 #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
 #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
+
 #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
-#define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
+#define __is_tx(_tx, _ab) ((_tx) == &(_tx)->state->tx##_ab)
+#define is_txa(_tx) __is_tx(_tx, a)
+#define is_txb(_tx) __is_tx(_tx, b)
+
 #define is_afe_enabled(_state)					\
 	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
 	 (_state)->endpoints[ADV748X_PORT_AIN1] != NULL ||	\
-- 
2.20.1

