Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37545 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbbLKRRI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:08 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 05/10] [media] staging: omap4iss: remove pads prefix from *_create_pads_links()
Date: Fri, 11 Dec 2015 14:16:31 -0300
Message-Id: <1449854196-13296-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions that create ISS internal and external entities links are
called *_create_pads_links() but the "pads" prefix is redundant since
the driver doesn't handle any other kind of link so it can be removed.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses an issue Laurent pointed in patch [0]:

- Could you please s/pads_links/links/ and s/pads links/links/

[0]: https://lkml.org/lkml/2015/12/5/256

 drivers/staging/media/omap4iss/iss.c         | 12 ++++++------
 drivers/staging/media/omap4iss/iss_csi2.c    |  4 ++--
 drivers/staging/media/omap4iss/iss_csi2.h    |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c |  4 ++--
 drivers/staging/media/omap4iss/iss_ipipeif.h |  2 +-
 drivers/staging/media/omap4iss/iss_resizer.c |  4 ++--
 drivers/staging/media/omap4iss/iss_resizer.h |  2 +-
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 28e4d16544eb..7209b92b1f86 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1273,28 +1273,28 @@ done:
 }
 
 /*
- * iss_create_pads_links() - Pads links creation for the subdevices
+ * iss_create_links() - Pads links creation for the subdevices
  * @iss : Pointer to ISS device
  *
  * return negative error code or zero on success
  */
-static int iss_create_pads_links(struct iss_device *iss)
+static int iss_create_links(struct iss_device *iss)
 {
 	int ret;
 
-	ret = omap4iss_csi2_create_pads_links(iss);
+	ret = omap4iss_csi2_create_links(iss);
 	if (ret < 0) {
 		dev_err(iss->dev, "CSI2 pads links creation failed\n");
 		return ret;
 	}
 
-	ret = omap4iss_ipipeif_create_pads_links(iss);
+	ret = omap4iss_ipipeif_create_links(iss);
 	if (ret < 0) {
 		dev_err(iss->dev, "ISP IPIPEIF pads links creation failed\n");
 		return ret;
 	}
 
-	ret = omap4iss_resizer_create_pads_links(iss);
+	ret = omap4iss_resizer_create_links(iss);
 	if (ret < 0) {
 		dev_err(iss->dev, "ISP RESIZER pads links creation failed\n");
 		return ret;
@@ -1491,7 +1491,7 @@ static int iss_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
-	ret = iss_create_pads_links(iss);
+	ret = iss_create_links(iss);
 	if (ret < 0)
 		goto error_entities;
 
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index f0fa037ce173..aaca39d751a5 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1339,12 +1339,12 @@ int omap4iss_csi2_init(struct iss_device *iss)
 }
 
 /*
- * omap4iss_csi2_create_pads_links() - CSI2 pads links creation
+ * omap4iss_csi2_create_links() - CSI2 pads links creation
  * @iss: Pointer to ISS device
  *
  * return negative error code or zero on success
  */
-int omap4iss_csi2_create_pads_links(struct iss_device *iss)
+int omap4iss_csi2_create_links(struct iss_device *iss)
 {
 	struct iss_csi2_device *csi2a = &iss->csi2a;
 	struct iss_csi2_device *csi2b = &iss->csi2b;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.h b/drivers/staging/media/omap4iss/iss_csi2.h
index 1d5a0d8222a9..24ab378d469f 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.h
+++ b/drivers/staging/media/omap4iss/iss_csi2.h
@@ -151,7 +151,7 @@ struct iss_csi2_device {
 void omap4iss_csi2_isr(struct iss_csi2_device *csi2);
 int omap4iss_csi2_reset(struct iss_csi2_device *csi2);
 int omap4iss_csi2_init(struct iss_device *iss);
-int omap4iss_csi2_create_pads_links(struct iss_device *iss);
+int omap4iss_csi2_create_links(struct iss_device *iss);
 void omap4iss_csi2_cleanup(struct iss_device *iss);
 void omap4iss_csi2_unregister_entities(struct iss_csi2_device *csi2);
 int omap4iss_csi2_register_entities(struct iss_csi2_device *csi2,
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 88b22f7f8b13..23de8330731d 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -815,12 +815,12 @@ int omap4iss_ipipeif_init(struct iss_device *iss)
 }
 
 /*
- * omap4iss_ipipeif_create_pads_links() - IPIPEIF pads links creation
+ * omap4iss_ipipeif_create_links() - IPIPEIF pads links creation
  * @iss: Pointer to ISS device
  *
  * return negative error code or zero on success
  */
-int omap4iss_ipipeif_create_pads_links(struct iss_device *iss)
+int omap4iss_ipipeif_create_links(struct iss_device *iss)
 {
 	struct iss_ipipeif_device *ipipeif = &iss->ipipeif;
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.h b/drivers/staging/media/omap4iss/iss_ipipeif.h
index dd906b41cf9b..bad32b1d6ad8 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.h
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.h
@@ -78,7 +78,7 @@ struct iss_ipipeif_device {
 struct iss_device;
 
 int omap4iss_ipipeif_init(struct iss_device *iss);
-int omap4iss_ipipeif_create_pads_links(struct iss_device *iss);
+int omap4iss_ipipeif_create_links(struct iss_device *iss);
 void omap4iss_ipipeif_cleanup(struct iss_device *iss);
 int omap4iss_ipipeif_register_entities(struct iss_ipipeif_device *ipipeif,
 				       struct v4l2_device *vdev);
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index fe7b253bb0d3..f1d352c711d5 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -857,12 +857,12 @@ int omap4iss_resizer_init(struct iss_device *iss)
 }
 
 /*
- * omap4iss_resizer_create_pads_links() - RESIZER pads links creation
+ * omap4iss_resizer_create_links() - RESIZER pads links creation
  * @iss: Pointer to ISS device
  *
  * return negative error code or zero on success
  */
-int omap4iss_resizer_create_pads_links(struct iss_device *iss)
+int omap4iss_resizer_create_links(struct iss_device *iss)
 {
 	struct iss_resizer_device *resizer = &iss->resizer;
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.h b/drivers/staging/media/omap4iss/iss_resizer.h
index 98ab950253d0..8b7c5fe9ffed 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.h
+++ b/drivers/staging/media/omap4iss/iss_resizer.h
@@ -61,7 +61,7 @@ struct iss_resizer_device {
 struct iss_device;
 
 int omap4iss_resizer_init(struct iss_device *iss);
-int omap4iss_resizer_create_pads_links(struct iss_device *iss);
+int omap4iss_resizer_create_links(struct iss_device *iss);
 void omap4iss_resizer_cleanup(struct iss_device *iss);
 int omap4iss_resizer_register_entities(struct iss_resizer_device *resizer,
 				       struct v4l2_device *vdev);
-- 
2.4.3

