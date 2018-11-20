Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:60976 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbeKTWAk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 17:00:40 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ioannis Valasakis <code@wizofe.uk>,
        Irenge Jules Bashizi <jbi.octave@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Michelle Darcy <mdarcy137@gmail.com>,
        Mamta Shukla <mamtashukla555@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] media: davinci_vpfe: bail out if kmalloc failed
Date: Tue, 20 Nov 2018 12:25:29 +0100
Message-Id: <1542713129-14110-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 The kmalloc is passed indirectly to  from  but with an offset
which if not 0 will cause the null check if (to && from && size) 
to succeed. An explicit !NULL check is thus added for params here.

 ipipe_s_config and ipipe_g_config - both fail to check kmalloc
are called from ipipe_ioctl where a negative return is a valid
indication of error so simply setting rval = -ENOMEM seems ok.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: da43b6ccadcf ("[media] davinci: vpfe: dm365: add IPIPE support for media controller driver")
---

Problem located with experimental coccinelle patch

Patch was compile tested with: davinci_all_defconfig + SAGING=y,
STAGING_MEDIA=y, MEDIA_SUPPORT=m, MEDIA_CONTROLLER=y,
VIDEO_V4L2_SUBDEV_API=y, VIDEO_DAVINCI_VPBE_DISPLAY=m,
VIDEO_DM365_VPFE=m
(with some coccicheck findings unrelated to the proposed change)

Patch is against 4.20-rc3 (localversion-next is next-20181120)

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 3d910b8..0150aed 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1266,6 +1266,11 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 		params = kmalloc(sizeof(struct ipipe_module_params),
 				 GFP_KERNEL);
+		if (!params) {
+			rval = -ENOMEM;
+			goto error;
+		}
+
 		to = (void *)params + module_if->param_offset;
 		size = module_if->param_size;
 
@@ -1308,6 +1313,11 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 		params = kmalloc(sizeof(struct ipipe_module_params),
 				 GFP_KERNEL);
+		if (!params) {
+			rval = -ENOMEM;
+			goto error;
+		}
+
 		from = (void *)params + module_if->param_offset;
 		size = module_if->param_size;
 
-- 
2.1.4
