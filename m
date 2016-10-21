Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55756
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932807AbcJUNBO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 09:01:14 -0400
Date: Fri, 21 Oct 2016 11:01:04 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Subject: Re: [PATCH v5 3/9] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
Message-ID: <20161021110104.5733240e@vento.lan>
In-Reply-To: <1472818800-22558-4-git-send-email-tiffany.lin@mediatek.com>
References: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
        <1472818800-22558-2-git-send-email-tiffany.lin@mediatek.com>
        <1472818800-22558-3-git-send-email-tiffany.lin@mediatek.com>
        <1472818800-22558-4-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 2 Sep 2016 20:19:54 +0800
Tiffany Lin <tiffany.lin@mediatek.com> escreveu:

> Add v4l2 layer decoder driver for MT8173
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

> +int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
> +{
> +	int ret = 0;
> +
> +	switch (fourcc) {
> +	case V4L2_PIX_FMT_H264:
> +	case V4L2_PIX_FMT_VP8:
> +	default:
> +		return -EINVAL;
> +	}

Did you ever test this driver? The above code will *always* return
-EINVAL, with will cause vidioc_vdec_s_fmt() to always fail!

I suspect that what you wanted to do, instead, is:

	switch (fourcc) {
	case V4L2_PIX_FMT_H264:
	case V4L2_PIX_FMT_VP8:
		break;
	default:
		return -EINVAL;

Btw, this patch series has also several issues that were pointed by
checkpatch. Please *always* run checkpatch when submitting your work.

You should take a look at the Kernel documentation about how to
submit patches, at:
	https://mchehab.fedorapeople.org/kernel_docs/process/index.html

PS.: this time, I fixed the checkpatch issues for you. So, let me know
if the patch below is OK, and I'll merge it at media upstream,
assuming that the other patches in this series are ok.

-- 
Thanks,
Mauro

[PATCH] mtk-vcodec: fix some smatch warnings

Fix this bug:
	drivers/media/platform/mtk-vcodec/vdec_drv_if.c:38 vdec_if_init() info: ignoring unreachable code.

With is indeed a real problem that prevents the driver to work!

While here, also remove an used var, as reported by smatch:

	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c: In function 'mtk_vcodec_init_dec_pm':
	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:29:17: warning: variable 'dev' set but not used [-Wunused-but-set-variable]
	  struct device *dev;
	                 ^~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
index 18182f5676d8..79ca03ac449c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -26,14 +26,12 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
 {
 	struct device_node *node;
 	struct platform_device *pdev;
-	struct device *dev;
 	struct mtk_vcodec_pm *pm;
 	int ret = 0;
 
 	pdev = mtkdev->plat_dev;
 	pm = &mtkdev->pm;
 	pm->mtkdev = mtkdev;
-	dev = &pdev->dev;
 	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
 	if (!node) {
 		mtk_v4l2_err("of_parse_phandle mediatek,larb fail!");
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
index 3cb04ef45144..9813b2ffd5fa 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
@@ -31,6 +31,7 @@ int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 	switch (fourcc) {
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_VP8:
+		break;
 	default:
 		return -EINVAL;
 	}


