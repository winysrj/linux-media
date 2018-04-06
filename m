Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54367 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756614AbeDFOXa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 10/21] media: davinci_vpfe: fix __user annotations
Date: Fri,  6 Apr 2018 10:23:11 -0400
Message-Id: <ade06504215107ab328675fbf4df011280e08ae0.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __user annotations on this driver are wrong, causing lots
of warnings:

    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1269:22: warning: incorrect type in assignment (different address spaces)
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1269:22:    expected void [noderef] <asn:1>*from
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1269:22:    got void *[noderef] <asn:1><noident>
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1313:20: warning: incorrect type in assignment (different address spaces)
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1313:20:    expected void [noderef] <asn:1>*to
    drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1313:20:    got void *[noderef] <asn:1><noident>
    drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:424:41: warning: incorrect type in initializer (different address spaces)
    drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:424:41:    expected struct ipipeif_params *config
    drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:424:41:    got void [noderef] <asn:1>*arg
    drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:474:46: warning: incorrect type in argument 2 (different address spaces)
    drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:474:46:    expected void [noderef] <asn:1>*arg
    drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:474:46:    got void *arg
    drivers/staging/media/davinci_vpfe/dm365_resizer.c:922:32: warning: incorrect type in argument 2 (different address spaces)
    drivers/staging/media/davinci_vpfe/dm365_resizer.c:922:32:    expected void const [noderef] <asn:1>*from
    drivers/staging/media/davinci_vpfe/dm365_resizer.c:922:32:    got struct vpfe_rsz_config_params *config
    drivers/staging/media/davinci_vpfe/dm365_resizer.c:945:27: warning: incorrect type in argument 1 (different address spaces)
    drivers/staging/media/davinci_vpfe/dm365_resizer.c:945:27:    expected void [noderef] <asn:1>*to
    drivers/staging/media/davinci_vpfe/dm365_resizer.c:945:27:    got void *<noident>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 15 ++++++---------
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  9 +++++----
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index a7043865cf06..4373e1ea81e6 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1258,16 +1258,14 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 	for (i = 0; i < ARRAY_SIZE(ipipe_modules); i++) {
 		const struct ipipe_module_if *module_if;
 		struct ipipe_module_params *params;
-		void __user *from;
+		void *from, *to;
 		size_t size;
-		void *to;
 
 		if (!(cfg->flag & BIT(i)))
 			continue;
 
 		module_if = &ipipe_modules[i];
-		from = *(void * __user *)
-			((void *)cfg + module_if->config_offset);
+		from = *(void **)((void *)cfg + module_if->config_offset);
 
 		params = kmalloc(sizeof(struct ipipe_module_params),
 					GFP_KERNEL);
@@ -1275,7 +1273,7 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 		size = module_if->param_size;
 
 		if (to && from && size) {
-			if (copy_from_user(to, from, size)) {
+			if (copy_from_user(to, (void __user *)from, size)) {
 				rval = -EFAULT;
 				break;
 			}
@@ -1302,15 +1300,14 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 	for (i = 1; i < ARRAY_SIZE(ipipe_modules); i++) {
 		const struct ipipe_module_if *module_if;
 		struct ipipe_module_params *params;
-		void __user *to;
+		void *from, *to;
 		size_t size;
-		void *from;
 
 		if (!(cfg->flag & BIT(i)))
 			continue;
 
 		module_if = &ipipe_modules[i];
-		to = *(void * __user *)((void *)cfg + module_if->config_offset);
+		to = *(void **)((void *)cfg + module_if->config_offset);
 
 		params =  kmalloc(sizeof(struct ipipe_module_params),
 					GFP_KERNEL);
@@ -1321,7 +1318,7 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 			rval = module_if->get(ipipe, from);
 			if (rval)
 				goto error;
-			if (copy_to_user(to, from, size)) {
+			if (copy_to_user((void __user *)to, from, size)) {
 				rval = -EFAULT;
 				break;
 			}
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index cf91f8842d35..11c9edfbdbe3 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -418,7 +418,7 @@ ipipeif_set_config(struct v4l2_subdev *sd, struct ipipeif_params *config)
 }
 
 static int
-ipipeif_get_config(struct v4l2_subdev *sd, void __user *arg)
+ipipeif_get_config(struct v4l2_subdev *sd, void *arg)
 {
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct ipipeif_params *config = arg;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 1e478755fe2f..df6d55e9554d 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -919,7 +919,8 @@ resizer_set_configuration(struct vpfe_resizer_device *resizer,
 		resizer_set_default_configuration(resizer);
 	else
 		if (copy_from_user(&resizer->config.user_config,
-		    chan_config->config, sizeof(struct vpfe_rsz_config_params)))
+				   (void __user *)chan_config->config,
+				   sizeof(struct vpfe_rsz_config_params)))
 			return -EFAULT;
 
 	return 0;
@@ -942,9 +943,9 @@ resizer_get_configuration(struct vpfe_resizer_device *resizer,
 		return -EINVAL;
 	}
 
-	if (copy_to_user((void *)chan_config->config,
-	   (void *)&resizer->config.user_config,
-	   sizeof(struct vpfe_rsz_config_params))) {
+	if (copy_to_user((void __user *)chan_config->config,
+			 (void *)&resizer->config.user_config,
+			 sizeof(struct vpfe_rsz_config_params))) {
 		dev_err(dev, "resizer_get_configuration: Error in copy to user\n");
 		return -EFAULT;
 	}
-- 
2.14.3
