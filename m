Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C085C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EEB621019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfCESwD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:03 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:44609 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfCESwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:02 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C58D520000A;
        Tue,  5 Mar 2019 18:51:59 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 23/31] adv748x: csi2: add translation from pixelcode to CSI-2 datatype
Date:   Tue,  5 Mar 2019 19:51:42 +0100
Message-Id: <20190305185150.20776-24-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Prepare to implement frame descriptors to support multiplexed streams by
adding a function to map pixelcode to CSI-2 datatype. This is needed to
properly be able to fill out the struct v4l2_mbus_frame_desc.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 2091cda50935..25798d723174 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -14,6 +14,28 @@
 
 #include "adv748x.h"
 
+struct adv748x_csi2_format {
+	unsigned int code;
+	unsigned int datatype;
+};
+
+static const struct adv748x_csi2_format adv748x_csi2_formats[] = {
+	{ .code = MEDIA_BUS_FMT_RGB888_1X24,    .datatype = 0x24, },
+	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,     .datatype = 0x1e, },
+	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,      .datatype = 0x1e, },
+	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,    .datatype = 0x1e, },
+};
+
+static unsigned int adv748x_csi2_code_to_datatype(unsigned int code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(adv748x_csi2_formats); i++)
+		if (adv748x_csi2_formats[i].code == code)
+			return adv748x_csi2_formats[i].datatype;
+	return 0;
+}
+
 static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
 					    unsigned int vc)
 {
-- 
2.20.1

