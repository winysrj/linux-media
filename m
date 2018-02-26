Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40974 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbeBZNkR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 08:40:17 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/3] media: imx: Don't initialize vars that won't be used
Date: Mon, 26 Feb 2018 08:40:10 -0500
Message-Id: <52e17089d1850774d2ef583cdef2b060b84fca8c.1519652405.git.mchehab@s-opensource.com>
In-Reply-To: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
References: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
In-Reply-To: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
References: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by gcc:

  + drivers/staging/media/imx/imx-media-csi.c: warning: variable 'input_fi' set but not used [-Wunused-but-set-variable]:  => 671:33
  + drivers/staging/media/imx/imx-media-csi.c: warning: variable 'pinctrl' set but not used [-Wunused-but-set-variable]:  => 1742:18

input_fi is not used, so just remove it.

However, pinctrl should be used, as it devm_pinctrl_get_select_default()
is declared with attribute warn_unused_result. What's missing there
is an error handling code, in case it fails. Add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index eb7be5093a9d..49b57466e88d 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -668,11 +668,10 @@ static int csi_setup(struct csi_priv *priv)
 
 static int csi_start(struct csi_priv *priv)
 {
-	struct v4l2_fract *output_fi, *input_fi;
+	struct v4l2_fract *output_fi;
 	int ret;
 
 	output_fi = &priv->frame_interval[priv->active_output_pad];
-	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		ret = csi_idmac_start(priv);
@@ -1797,6 +1796,10 @@ static int imx_csi_probe(struct platform_device *pdev)
 	 */
 	priv->dev->of_node = pdata->of_node;
 	pinctrl = devm_pinctrl_get_select_default(priv->dev);
+	if (IS_ERR(pinctrl)) {
+		ret = PTR_ERR(priv->vdev);
+		goto free;
+	}
 
 	ret = v4l2_async_register_subdev(&priv->sd);
 	if (ret)
-- 
2.14.3
