Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9986C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE3B20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BE3B20837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbeLGN4A (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:56:00 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58705 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbeLGNzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:55:54 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id A74C020745; Fri,  7 Dec 2018 14:55:52 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 7008C20894;
        Fri,  7 Dec 2018 14:55:42 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 02/10] phy: Add configuration interface
Date:   Fri,  7 Dec 2018 14:55:29 +0100
Message-Id: <8a8d7bf8a3d2bad492dd63e39fe3d490bdae5c80.1544190837.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The phy framework is only allowing to configure the power state of the PHY
using the init and power_on hooks, and their power_off and exit
counterparts.

While it works for most, simple, PHYs supported so far, some more advanced
PHYs need some configuration depending on runtime parameters. These PHYs
have been supported by a number of means already, often by using ad-hoc
drivers in their consumer drivers.

That doesn't work too well however, when a consumer device needs to deal
with multiple PHYs, or when multiple consumers need to deal with the same
PHY (a DSI driver and a CSI driver for example).

So we'll add a new interface, through two funtions, phy_validate and
phy_configure. The first one will allow to check that a current
configuration, for a given mode, is applicable. It will also allow the PHY
driver to tune the settings given as parameters as it sees fit.

phy_configure will actually apply that configuration in the phy itself.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/phy/phy-core.c  | 64 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/phy/phy.h | 58 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 122 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index df3d4ba516ab..19b05e824ee4 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -408,6 +408,70 @@ int phy_calibrate(struct phy *phy)
 EXPORT_SYMBOL_GPL(phy_calibrate);
 
 /**
+ * phy_configure() - Changes the phy parameters
+ * @phy: the phy returned by phy_get()
+ * @opts: New configuration to apply
+ *
+ * Used to change the PHY parameters. phy_init() must have been called
+ * on the phy. The configuration will be applied on the current phy
+ * mode, that can be changed using phy_set_mode().
+ *
+ * Returns: 0 if successful, an negative error code otherwise
+ */
+int phy_configure(struct phy *phy, union phy_configure_opts *opts)
+{
+	int ret;
+
+	if (!phy)
+		return -EINVAL;
+
+	if (!phy->ops->configure)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&phy->mutex);
+	ret = phy->ops->configure(phy, opts);
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_configure);
+
+/**
+ * phy_validate() - Checks the phy parameters
+ * @phy: the phy returned by phy_get()
+ * @mode: phy_mode the configuration is applicable to.
+ * @submode: PHY submode the configuration is applicable to.
+ * @opts: Configuration to check
+ *
+ * Used to check that the current set of parameters can be handled by
+ * the phy. Implementations are free to tune the parameters passed as
+ * arguments if needed by some implementation detail or
+ * constraints. It will not change any actual configuration of the
+ * PHY, so calling it as many times as deemed fit will have no side
+ * effect.
+ *
+ * Returns: 0 if successful, an negative error code otherwise
+ */
+int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
+		 union phy_configure_opts *opts)
+{
+	int ret;
+
+	if (!phy)
+		return -EINVAL;
+
+	if (!phy->ops->validate)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&phy->mutex);
+	ret = phy->ops->validate(phy, mode, submode, opts);
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_validate);
+
+/**
  * _of_phy_get() - lookup and obtain a reference to a phy by phandle
  * @np: device_node for which to get the phy
  * @index: the index of the phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 453f21834685..04476c026b5a 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -43,6 +43,12 @@ enum phy_mode {
 };
 
 /**
+ * union phy_configure_opts - Opaque generic phy configuration
+ */
+union phy_configure_opts {
+};
+
+/**
  * struct phy_ops - set of function pointers for performing phy operations
  * @init: operation to be performed for initializing phy
  * @exit: operation to be performed while exiting
@@ -59,6 +65,37 @@ struct phy_ops {
 	int	(*power_on)(struct phy *phy);
 	int	(*power_off)(struct phy *phy);
 	int	(*set_mode)(struct phy *phy, enum phy_mode mode, int submode);
+
+	/**
+	 * @configure:
+	 *
+	 * Optional.
+	 *
+	 * Used to change the PHY parameters. phy_init() must have
+	 * been called on the phy.
+	 *
+	 * Returns: 0 if successful, an negative error code otherwise
+	 */
+	int	(*configure)(struct phy *phy, union phy_configure_opts *opts);
+
+	/**
+	 * @validate:
+	 *
+	 * Optional.
+	 *
+	 * Used to check that the current set of parameters can be
+	 * handled by the phy. Implementations are free to tune the
+	 * parameters passed as arguments if needed by some
+	 * implementation detail or constraints. It must not change
+	 * any actual configuration of the PHY, so calling it as many
+	 * times as deemed fit by the consumer must have no side
+	 * effect.
+	 *
+	 * Returns: 0 if the configuration can be applied, an negative
+	 * error code otherwise
+	 */
+	int	(*validate)(struct phy *phy, enum phy_mode mode, int submode,
+			    union phy_configure_opts *opts);
 	int	(*reset)(struct phy *phy);
 	int	(*calibrate)(struct phy *phy);
 	struct module *owner;
@@ -165,6 +202,9 @@ int phy_power_off(struct phy *phy);
 int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode);
 #define phy_set_mode(phy, mode) \
 	phy_set_mode_ext(phy, mode, 0)
+int phy_configure(struct phy *phy, union phy_configure_opts *opts);
+int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
+		 union phy_configure_opts *opts);
 
 static inline enum phy_mode phy_get_mode(struct phy *phy)
 {
@@ -309,6 +349,24 @@ static inline int phy_calibrate(struct phy *phy)
 	return -ENOSYS;
 }
 
+static inline int phy_configure(struct phy *phy,
+				union phy_configure_opts *opts)
+{
+	if (!phy)
+		return 0;
+
+	return -ENOSYS;
+}
+
+static inline int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
+			       union phy_configure_opts *opts)
+{
+	if (!phy)
+		return 0;
+
+	return -ENOSYS;
+}
+
 static inline int phy_get_bus_width(struct phy *phy)
 {
 	return -ENOSYS;
-- 
git-series 0.9.1
