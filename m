Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44F2C282DB
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F6DF20869
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfBBMKY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 07:10:24 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38877 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbfBBMKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2019 07:10:24 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7i-0008DA-5W; Sat, 02 Feb 2019 13:10:14 +0100
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7e-0002On-3u; Sat, 02 Feb 2019 13:10:10 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     robh+dt@kernel.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 1/5] dt-bindings: connector: analog: add tv norms property
Date:   Sat,  2 Feb 2019 13:10:00 +0100
Message-Id: <20190202121004.9014-2-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190202121004.9014-1-m.felsch@pengutronix.de>
References: <20190202121004.9014-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some connectors no matter if in- or output supports only a limited
range of tv norms. It doesn't matter if the hardware behind that
connector supports more than the listed formats since the users are
restriced by a label e.g. to plug only a camera into this connector
which uses the PAL format.

This patch adds the capability to describe such limitation within the
firmware. There are no format restrictions if the property isn't
present, so it's completely backward compatible.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 .../display/connector/analog-tv-connector.txt |  4 ++
 include/dt-bindings/media/tvnorms.h           | 42 +++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 include/dt-bindings/media/tvnorms.h

diff --git a/Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt b/Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt
index 0c0970c210ab..346f8937a0b7 100644
--- a/Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt
+++ b/Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt
@@ -6,6 +6,9 @@ Required properties:
 
 Optional properties:
 - label: a symbolic name for the connector
+- tvnorms: limit the supported tv norms on a connector to the given ones else
+           all tv norms are allowed. Possible video standards are defined in
+           include/dt-bindings/media/tvnorms.h.
 
 Required nodes:
 - Video port for TV input
@@ -16,6 +19,7 @@ Example
 tv: connector {
 	compatible = "composite-video-connector";
 	label = "tv";
+	tvnorms = <(TVNORM_PAL_M | TVNORM_NTSC_M)>;
 
 	port {
 		tv_connector_in: endpoint {
diff --git a/include/dt-bindings/media/tvnorms.h b/include/dt-bindings/media/tvnorms.h
new file mode 100644
index 000000000000..ec3b414a7a00
--- /dev/null
+++ b/include/dt-bindings/media/tvnorms.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only or X11 */
+/*
+ * Copyright 2019 Pengutronix, Marco Felsch <kernel@pengutronix.de>
+ */
+
+#ifndef _DT_BINDINGS_MEDIA_TVNORMS_H
+#define _DT_BINDINGS_MEDIA_TVNORMS_H
+
+/* one bit for each */
+#define TVNORM_PAL_B          0x00000001
+#define TVNORM_PAL_B1         0x00000002
+#define TVNORM_PAL_G          0x00000004
+#define TVNORM_PAL_H          0x00000008
+#define TVNORM_PAL_I          0x00000010
+#define TVNORM_PAL_D          0x00000020
+#define TVNORM_PAL_D1         0x00000040
+#define TVNORM_PAL_K          0x00000080
+
+#define TVNORM_PAL_M          0x00000100
+#define TVNORM_PAL_N          0x00000200
+#define TVNORM_PAL_Nc         0x00000400
+#define TVNORM_PAL_60         0x00000800
+
+#define TVNORM_NTSC_M         0x00001000	/* BTSC */
+#define TVNORM_NTSC_M_JP      0x00002000	/* EIA-J */
+#define TVNORM_NTSC_443       0x00004000
+#define TVNORM_NTSC_M_KR      0x00008000	/* FM A2 */
+
+#define TVNORM_SECAM_B        0x00010000
+#define TVNORM_SECAM_D        0x00020000
+#define TVNORM_SECAM_G        0x00040000
+#define TVNORM_SECAM_H        0x00080000
+#define TVNORM_SECAM_K        0x00100000
+#define TVNORM_SECAM_K1       0x00200000
+#define TVNORM_SECAM_L        0x00400000
+#define TVNORM_SECAM_LC       0x00800000
+
+/* ATSC/HDTV */
+#define TVNORM_ATSC_8_VSB     0x01000000
+#define TVNORM_ATSC_16_VSB    0x02000000
+
+#endif /* _DT_BINDINGS_MEDIA_TVNORMS_H */
-- 
2.20.1

