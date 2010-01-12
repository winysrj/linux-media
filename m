Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:39234 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754038Ab0ALUXj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 15:23:39 -0500
Message-ID: <4B4CDA40.9030102@panicking.kicks-ass.org>
Date: Tue, 12 Jan 2010 21:23:28 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Sergio Aguirre <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC PATCH] Fix and invalid array indexing in isp_csi2_complexio_lanes_config
Content-Type: multipart/mixed;
 boundary="------------050607040105010405090108"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050607040105010405090108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------050607040105010405090108
Content-Type: text/x-diff;
 name="invalid_pos_data.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="invalid_pos_data.patch"

Fix and invalid array indexing when refcfg->data[i].pos is equal to 0.
The code access an invalid location.

Signed-off-by: Michael Trimarchi <michael@panicking.kicks-ass.org>
cc: akari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: Sergio Aguirre <saaguirre@ti.com>

---
diff --git a/drivers/media/video/isp/ispcsi2.c b/drivers/media/video/isp/ispcsi2.c
index fb0f44f..cc8fa39 100644
--- a/drivers/media/video/isp/ispcsi2.c
+++ b/drivers/media/video/isp/ispcsi2.c
@@ -85,8 +85,10 @@ int isp_csi2_complexio_lanes_config(struct isp_csi2_device *isp_csi2,
 			       " parameters for data lane #%d\n", i);
 			goto err_einval;
 		}
-		if (pos_occupied[reqcfg->data[i].pos - 1] &&
-		    reqcfg->data[i].pos > 0) {
+		if (!reqcfg->data[i].pos)
+			continue;
+
+		if (pos_occupied[reqcfg->data[i].pos - 1]) {
 			printk(KERN_ERR "Lane #%d already occupied\n",
 			       reqcfg->data[i].pos);
 			goto err_einval;

--------------050607040105010405090108--
