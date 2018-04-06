Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36574 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756352AbeDFOXa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 09/21] media: davinci_vpfe: cleanup ipipe_[g|s]_config logic
Date: Fri,  6 Apr 2018 10:23:10 -0400
Message-Id: <3200bc234f8732c14a5e31d44b8e9f3262df4fb4.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reduce one ident level inside those functions and use BIT()
macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 98 ++++++++++++------------
 1 file changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index b3a193ddd778..a7043865cf06 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/bitops.h>
 
 #include "dm365_ipipe.h"
 #include "dm365_ipipe_hw.h"
@@ -1255,37 +1256,38 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 	int rval = 0;
 
 	for (i = 0; i < ARRAY_SIZE(ipipe_modules); i++) {
-		unsigned int bit = 1 << i;
+		const struct ipipe_module_if *module_if;
+		struct ipipe_module_params *params;
+		void __user *from;
+		size_t size;
+		void *to;
 
-		if (cfg->flag & bit) {
-			const struct ipipe_module_if *module_if =
-						&ipipe_modules[i];
-			struct ipipe_module_params *params;
-			void __user *from = *(void * __user *)
-				((void *)cfg + module_if->config_offset);
-			size_t size;
-			void *to;
+		if (!(cfg->flag & BIT(i)))
+			continue;
 
-			params = kmalloc(sizeof(struct ipipe_module_params),
-					 GFP_KERNEL);
-			to = (void *)params + module_if->param_offset;
-			size = module_if->param_size;
+		module_if = &ipipe_modules[i];
+		from = *(void * __user *)
+			((void *)cfg + module_if->config_offset);
 
-			if (to && from && size) {
-				if (copy_from_user(to, from, size)) {
-					rval = -EFAULT;
-					break;
-				}
-				rval = module_if->set(ipipe, to);
-				if (rval)
-					goto error;
-			} else if (to && !from && size) {
-				rval = module_if->set(ipipe, NULL);
-				if (rval)
-					goto error;
+		params = kmalloc(sizeof(struct ipipe_module_params),
+					GFP_KERNEL);
+		to = (void *)params + module_if->param_offset;
+		size = module_if->param_size;
+
+		if (to && from && size) {
+			if (copy_from_user(to, from, size)) {
+				rval = -EFAULT;
+				break;
 			}
-			kfree(params);
+			rval = module_if->set(ipipe, to);
+			if (rval)
+				goto error;
+		} else if (to && !from && size) {
+			rval = module_if->set(ipipe, NULL);
+			if (rval)
+				goto error;
 		}
+		kfree(params);
 	}
 error:
 	return rval;
@@ -1298,33 +1300,33 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 	int rval = 0;
 
 	for (i = 1; i < ARRAY_SIZE(ipipe_modules); i++) {
-		unsigned int bit = 1 << i;
+		const struct ipipe_module_if *module_if;
+		struct ipipe_module_params *params;
+		void __user *to;
+		size_t size;
+		void *from;
 
-		if (cfg->flag & bit) {
-			const struct ipipe_module_if *module_if =
-						&ipipe_modules[i];
-			struct ipipe_module_params *params;
-			void __user *to = *(void * __user *)
-				((void *)cfg + module_if->config_offset);
-			size_t size;
-			void *from;
+		if (!(cfg->flag & BIT(i)))
+			continue;
 
-			params =  kmalloc(sizeof(struct ipipe_module_params),
-						GFP_KERNEL);
-			from = (void *)params + module_if->param_offset;
-			size = module_if->param_size;
+		module_if = &ipipe_modules[i];
+		to = *(void * __user *)((void *)cfg + module_if->config_offset);
 
-			if (to && from && size) {
-				rval = module_if->get(ipipe, from);
-				if (rval)
-					goto error;
-				if (copy_to_user(to, from, size)) {
-					rval = -EFAULT;
-					break;
-				}
+		params =  kmalloc(sizeof(struct ipipe_module_params),
+					GFP_KERNEL);
+		from = (void *)params + module_if->param_offset;
+		size = module_if->param_size;
+
+		if (to && from && size) {
+			rval = module_if->get(ipipe, from);
+			if (rval)
+				goto error;
+			if (copy_to_user(to, from, size)) {
+				rval = -EFAULT;
+				break;
 			}
-			kfree(params);
 		}
+		kfree(params);
 	}
 error:
 	return rval;
-- 
2.14.3
