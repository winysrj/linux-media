Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37529 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbbLKRQ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:16:59 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 02/10] [media] omap3isp: remove pads prefix from isp_create_pads_links()
Date: Fri, 11 Dec 2015 14:16:28 -0300
Message-Id: <1449854196-13296-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function that creates the links between ISP internal and external
entities is called isp_create_pads_links() but the "pads" prefix is
redundant since the driver doesn't handle any other kind of link so
it can just be removed.

While being there, fix the function's kernel-doc since is not using
a proper format.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses 2 remaining issues Laurent pointed in patch [0]:

1- Rename isp_create_pads_links() to isp_create_links().
2- Fix kernel-doc for the same function.

[0]: https://patchwork.linuxtv.org/patch/31147/

 drivers/media/platform/omap3isp/isp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 40aee11805c7..fb17746e4209 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1932,11 +1932,15 @@ done:
 }
 
 /*
- * isp_create_pads_links - Pads links creation for the subdevices
+ * isp_create_links() - Create links for internal and external ISP entities
  * @isp : Pointer to ISP device
- * return negative error code or zero on success
+ *
+ * This function creates all links between ISP internal and external entities.
+ *
+ * Return: A negative error code on failure or zero on success. Possible error
+ * codes are those returned by media_create_pad_link().
  */
-static int isp_create_pads_links(struct isp_device *isp)
+static int isp_create_links(struct isp_device *isp)
 {
 	int ret;
 
@@ -2527,7 +2531,7 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
-	ret = isp_create_pads_links(isp);
+	ret = isp_create_links(isp);
 	if (ret < 0)
 		goto error_register_entities;
 
-- 
2.4.3

