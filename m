Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1IGQ5b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:57:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 2D77318B03B
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 17:13:07 +0200 (CEST)
Date: Wed, 7 Sep 2011 17:13:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L: soc-camera: split a function into two
In-Reply-To: <Pine.LNX.4.64.1109071706550.14818@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109071712010.14818@axis700.grange>
References: <Pine.LNX.4.64.1109071706550.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The soc_camera_power_set() function processes two cases: power on anf off.
These two cases don't share and common code, and the function is always
called with a constant power on / off argument. Splitting this function
into two removes a condition check, reduces indentation levels and makes
the code look cleaner.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   65 ++++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 5943235..de374da 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -50,49 +50,52 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
-static int soc_camera_power_set(struct soc_camera_device *icd,
-				struct soc_camera_link *icl,
-				int power_on)
+static int soc_camera_power_on(struct soc_camera_device *icd,
+			       struct soc_camera_link *icl)
 {
 	int ret;
 
-	if (power_on) {
-		ret = regulator_bulk_enable(icl->num_regulators,
-					    icl->regulators);
-		if (ret < 0) {
-			dev_err(icd->pdev, "Cannot enable regulators\n");
-			return ret;
-		}
+	ret = regulator_bulk_enable(icl->num_regulators,
+				    icl->regulators);
+	if (ret < 0) {
+		dev_err(icd->pdev, "Cannot enable regulators\n");
+		return ret;
+	}
 
-		if (icl->power)
-			ret = icl->power(icd->pdev, power_on);
+	if (icl->power) {
+		ret = icl->power(icd->pdev, 1);
 		if (ret < 0) {
 			dev_err(icd->pdev,
 				"Platform failed to power-on the camera.\n");
 
 			regulator_bulk_disable(icl->num_regulators,
 					       icl->regulators);
-			return ret;
 		}
-	} else {
-		ret = 0;
-		if (icl->power)
-			ret = icl->power(icd->pdev, 0);
+	}
+
+	return ret;
+}
+
+static int soc_camera_power_off(struct soc_camera_device *icd,
+				struct soc_camera_link *icl)
+{
+	int ret;
+
+	if (icl->power) {
+		ret = icl->power(icd->pdev, 0);
 		if (ret < 0) {
 			dev_err(icd->pdev,
 				"Platform failed to power-off the camera.\n");
 			return ret;
 		}
-
-		ret = regulator_bulk_disable(icl->num_regulators,
-					     icl->regulators);
-		if (ret < 0) {
-			dev_err(icd->pdev, "Cannot disable regulators\n");
-			return ret;
-		}
 	}
 
-	return 0;
+	ret = regulator_bulk_disable(icl->num_regulators,
+				     icl->regulators);
+	if (ret < 0)
+		dev_err(icd->pdev, "Cannot disable regulators\n");
+
+	return ret;
 }
 
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
@@ -502,7 +505,7 @@ static int soc_camera_open(struct file *file)
 			},
 		};
 
-		ret = soc_camera_power_set(icd, icl, 1);
+		ret = soc_camera_power_on(icd, icl);
 		if (ret < 0)
 			goto epower;
 
@@ -555,7 +558,7 @@ esfmt:
 eresume:
 	ici->ops->remove(icd);
 eiciadd:
-	soc_camera_power_set(icd, icl, 0);
+	soc_camera_power_off(icd, icl);
 epower:
 	icd->use_count--;
 	module_put(ici->ops->owner);
@@ -579,7 +582,7 @@ static int soc_camera_close(struct file *file)
 		if (ici->ops->init_videobuf2)
 			vb2_queue_release(&icd->vb2_vidq);
 
-		soc_camera_power_set(icd, icl, 0);
+		soc_camera_power_off(icd, icl);
 	}
 
 	if (icd->streamer == file)
@@ -1086,7 +1089,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto ereg;
 
-	ret = soc_camera_power_set(icd, icl, 1);
+	ret = soc_camera_power_on(icd, icl);
 	if (ret < 0)
 		goto epower;
 
@@ -1163,7 +1166,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	ici->ops->remove(icd);
 
-	soc_camera_power_set(icd, icl, 0);
+	soc_camera_power_off(icd, icl);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -1185,7 +1188,7 @@ eadddev:
 evdc:
 	ici->ops->remove(icd);
 eadd:
-	soc_camera_power_set(icd, icl, 0);
+	soc_camera_power_off(icd, icl);
 epower:
 	regulator_bulk_free(icl->num_regulators, icl->regulators);
 ereg:
-- 
1.7.2.5

