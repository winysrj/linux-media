Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19762 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbeCUEjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 00:39:21 -0400
From: Ji-Hun Kim <ji_hun.kim@samsung.com>
To: dan.carpenter@oracle.com, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, arvind.yadav.cs@gmail.com,
        ji_hun.kim@samsung.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v3 2/2] staging: media: davinci_vpfe: add kfree() on goto
 err statement
Date: Wed, 21 Mar 2018 13:39:10 +0900
Message-id: <1521607150-31307-2-git-send-email-ji_hun.kim@samsung.com>
In-reply-to: <1521607150-31307-1-git-send-email-ji_hun.kim@samsung.com>
References: <1521607150-31307-1-git-send-email-ji_hun.kim@samsung.com>
        <CGME20180321043918epcas2p3d7cc4cf4c6377171c53af63ff3aa2a9a@epcas2p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It needs to free of allocated params value in the goto error statement.

Signed-off-by: Ji-Hun Kim <ji_hun.kim@samsung.com>
---
Changes since v2:
  - add kfree(params) on the error case of the function
  - rename unclear goto statement name
  - declare the params value at start of the function, so it can be free
    end of the function

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index ffcd86d..735d8b5 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1263,6 +1263,7 @@ static int ipipe_get_cgs_params(struct vpfe_ipipe_device *ipipe, void *param)
 static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct ipipe_module_params *params;
 	unsigned int i;
 	int rval = 0;
 
@@ -1272,7 +1273,6 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 		if (cfg->flag & bit) {
 			const struct ipipe_module_if *module_if =
 						&ipipe_modules[i];
-			struct ipipe_module_params *params;
 			void __user *from = *(void * __user *)
 				((void *)cfg + module_if->config_offset);
 			size_t size;
@@ -1289,26 +1289,30 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 			if (to && from && size) {
 				if (copy_from_user(to, from, size)) {
 					rval = -EFAULT;
-					break;
+					goto err_free_params;
 				}
 				rval = module_if->set(ipipe, to);
 				if (rval)
-					goto error;
+					goto err_free_params;
 			} else if (to && !from && size) {
 				rval = module_if->set(ipipe, NULL);
 				if (rval)
-					goto error;
+					goto err_free_params;
 			}
 			kfree(params);
 		}
 	}
-error:
+	return 0;
+
+err_free_params:
+	kfree(params);
 	return rval;
 }
 
 static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct ipipe_module_params *params;
 	unsigned int i;
 	int rval = 0;
 
@@ -1318,7 +1322,6 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 		if (cfg->flag & bit) {
 			const struct ipipe_module_if *module_if =
 						&ipipe_modules[i];
-			struct ipipe_module_params *params;
 			void __user *to = *(void * __user *)
 				((void *)cfg + module_if->config_offset);
 			size_t size;
@@ -1335,16 +1338,19 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 			if (to && from && size) {
 				rval = module_if->get(ipipe, from);
 				if (rval)
-					goto error;
+					goto err_free_params;
 				if (copy_to_user(to, from, size)) {
 					rval = -EFAULT;
-					break;
+					goto err_free_params;
 				}
 			}
 			kfree(params);
 		}
 	}
-error:
+	return 0;
+
+err_free_params:
+	kfree(params);
 	return rval;
 }
 
-- 
1.9.1
