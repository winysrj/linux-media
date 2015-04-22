Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45930 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbbDVXDi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 19:03:38 -0400
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	"Srinivas Kandagatla" <srinivas.kandagatla@linaro.org>,
	Masanari Iida <standby24x7@gmail.com>,
	David Mosberger <davidm@egauge.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kevin Hao <haokexin@gmail.com>,
	"Jean Delvare" <jdelvare@suse.de>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	<bcm-kernel-feedback-list@broadcom.com>,
	Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Subject: [PATCHv3 2/4] phy: core: Add devm_of_phy_get_by_index to phy-core
Date: Wed, 22 Apr 2015 16:04:11 -0700
Message-ID: <1429743853-10254-3-git-send-email-arun.ramamurthy@broadcom.com>
In-Reply-To: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some generic drivers, such as ehci, may use multiple phys and for such
drivers referencing phy(s) by name(s) does not make sense. Instead of
inventing new naming schemes and using custom code to iterate through them,
such drivers are better of using nameless phy bindings and using this newly
introduced API to iterate through them.

Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 Documentation/phy.txt   |  7 ++++++-
 drivers/phy/phy-core.c  | 32 ++++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |  8 ++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/phy.txt b/Documentation/phy.txt
index 371361c..b388c5a 100644
--- a/Documentation/phy.txt
+++ b/Documentation/phy.txt
@@ -76,6 +76,8 @@ struct phy *phy_get(struct device *dev, const char *string);
 struct phy *phy_optional_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_optional_get(struct device *dev, const char *string);
+struct phy *devm_of_phy_get_by_index(struct device *dev, struct device_node *np,
+				     int index);
 
 phy_get, phy_optional_get, devm_phy_get and devm_phy_optional_get can
 be used to get the PHY. In the case of dt boot, the string arguments
@@ -86,7 +88,10 @@ successful PHY get. On driver detach, release function is invoked on
 the the devres data and devres data is freed. phy_optional_get and
 devm_phy_optional_get should be used when the phy is optional. These
 two functions will never return -ENODEV, but instead returns NULL when
-the phy cannot be found.
+the phy cannot be found.Some generic drivers, such as ehci, may use multiple
+phys and for such drivers referencing phy(s) by name(s) does not make sense. In
+this case, devm_of_phy_get_by_index can be used to get a phy reference based on
+the index.
 
 It should be noted that NULL is a valid phy reference. All phy
 consumer calls on the NULL phy become NOPs. That is the release calls,
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 3791838..964a84d 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -623,6 +623,38 @@ struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
 EXPORT_SYMBOL_GPL(devm_of_phy_get);
 
 /**
+ * devm_of_phy_get_by_index() - lookup and obtain a reference to a phy by index.
+ * @dev: device that requests this phy
+ * @np: node containing the phy
+ * @index: index of the phy
+ *
+ * Gets the phy using _of_phy_get(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ *
+ */
+struct phy *devm_of_phy_get_by_index(struct device *dev, struct device_node *np,
+				     int index)
+{
+	struct phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy = _of_phy_get(np, index);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(devm_of_phy_get_by_index);
+
+/**
  * phy_create() - create a new phy
  * @dev: device that is creating the new phy
  * @node: device node of the phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index a0197fa..978d5af 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -133,6 +133,8 @@ struct phy *devm_phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_optional_get(struct device *dev, const char *string);
 struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
 			    const char *con_id);
+struct phy *devm_of_phy_get_by_index(struct device *dev, struct device_node *np,
+				     int index);
 void phy_put(struct phy *phy);
 void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_get(struct device_node *np, const char *con_id);
@@ -261,6 +263,12 @@ static inline struct phy *devm_of_phy_get(struct device *dev,
 	return ERR_PTR(-ENOSYS);
 }
 
+struct phy *devm_of_phy_get_by_index(struct device *dev, struct device_node *np,
+				     int index);
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void phy_put(struct phy *phy)
 {
 }
-- 
2.3.4

