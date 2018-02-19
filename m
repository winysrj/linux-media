Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59469 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753336AbeBSRGp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 12:06:45 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 02/11] include: media: Add Renesas CEU driver interface
Date: Mon, 19 Feb 2018 17:59:35 +0100
Message-Id: <1519059584-30844-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add renesas-ceu header file.

Do not remove the existing sh_mobile_ceu.h one as long as the original
driver does not go away.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/drv-intf/renesas-ceu.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 include/media/drv-intf/renesas-ceu.h

diff --git a/include/media/drv-intf/renesas-ceu.h b/include/media/drv-intf/renesas-ceu.h
new file mode 100644
index 0000000..52841d1
--- /dev/null
+++ b/include/media/drv-intf/renesas-ceu.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * renesas-ceu.h - Renesas CEU driver interface
+ *
+ * Copyright 2017-2018 Jacopo Mondi <jacopo+renesas@jmondi.org>
+ */
+
+#ifndef __MEDIA_DRV_INTF_RENESAS_CEU_H__
+#define __MEDIA_DRV_INTF_RENESAS_CEU_H__
+
+#define CEU_MAX_SUBDEVS		2
+
+struct ceu_async_subdev {
+	unsigned long flags;
+	unsigned char bus_width;
+	unsigned char bus_shift;
+	unsigned int i2c_adapter_id;
+	unsigned int i2c_address;
+};
+
+struct ceu_platform_data {
+	unsigned int num_subdevs;
+	struct ceu_async_subdev subdevs[CEU_MAX_SUBDEVS];
+};
+
+#endif /* ___MEDIA_DRV_INTF_RENESAS_CEU_H__ */
-- 
2.7.4
