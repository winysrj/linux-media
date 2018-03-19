Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12510 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbeCSFdS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 01:33:18 -0400
From: Ji-Hun Kim <ji_hun.kim@samsung.com>
To: mchehab@kernel.org, dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, arvind.yadav.cs@gmail.com,
        ji_hun.kim@samsung.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] staging: media: davinci_vpfe: add error handling on
 kmalloc failure
Date: Mon, 19 Mar 2018 14:32:57 +0900
Message-id: <1521437577-8168-1-git-send-email-ji_hun.kim@samsung.com>
References: <CGME20180319053315epcas2p3c61bd9a1bec8d67cde77765842a3205c@epcas2p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no failure checking on the param value which will be allocated
memory by kmalloc. Add a null pointer checking statement. Then goto error:
and return -ENOMEM error code when kmalloc is failed.

Signed-off-by: Ji-Hun Kim <ji_hun.kim@samsung.com>
---
Changes since v1:
  - Return with -ENOMEM directly, instead of goto error: then return.

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 6a3434c..ffcd86d 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1280,6 +1280,9 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 			params = kmalloc(sizeof(struct ipipe_module_params),
 					 GFP_KERNEL);
+			if (!params)
+				return -ENOMEM;
+
 			to = (void *)params + module_if->param_offset;
 			size = module_if->param_size;
 
@@ -1323,6 +1326,9 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 			params =  kmalloc(sizeof(struct ipipe_module_params),
 						GFP_KERNEL);
+			if (!params)
+				return -ENOMEM;
+
 			from = (void *)params + module_if->param_offset;
 			size = module_if->param_size;
 
-- 
1.9.1
