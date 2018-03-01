Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:37587 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031763AbeCAQCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 11:02:18 -0500
MIME-Version: 1.0
In-Reply-To: <20180301040939.GA13274@embeddedgus>
References: <20180301040939.GA13274@embeddedgus>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 1 Mar 2018 13:02:17 -0300
Message-ID: <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
Subject: Re: [PATCH] staging/imx: Fix inconsistent IS_ERR and PTR_ERR
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 1, 2018 at 1:09 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
> The proper pointer to be passed as argument is pinctrl
> instead of priv->vdev.
>
> This issue was detected with the help of Coccinelle.
>
> Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 5a195f8..4f290a0 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1798,7 +1798,7 @@ static int imx_csi_probe(struct platform_device *pdev)
>         priv->dev->of_node = pdata->of_node;
>         pinctrl = devm_pinctrl_get_select_default(priv->dev);
>         if (IS_ERR(pinctrl)) {
> -               ret = PTR_ERR(priv->vdev);
> +               ret = PTR_ERR(pinctrl);
>                 goto free;

This patch is correct, but now I am seeing that
devm_pinctrl_get_select_default() always fails.

I added this debug line:

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1799,6 +1799,7 @@ static int imx_csi_probe(struct platform_device *pdev)
        pinctrl = devm_pinctrl_get_select_default(priv->dev);
        if (IS_ERR(pinctrl)) {
                ret = PTR_ERR(pinctrl);
+               pr_err("************ pinctrl failed\n");
                goto free;
        }

and this is what I get in imx6q-sabresd:

[    3.453905] imx-media: subdev ipu1_vdic bound
[    3.458601] imx-media: subdev ipu2_vdic bound
[    3.463341] imx-media: subdev ipu1_ic_prp bound
[    3.468924] ipu1_ic_prpenc: Registered ipu1_ic_prpenc capture as /dev/video0
[    3.476237] imx-media: subdev ipu1_ic_prpenc bound
[    3.481621] ipu1_ic_prpvf: Registered ipu1_ic_prpvf capture as /dev/video1
[    3.488805] imx-media: subdev ipu1_ic_prpvf bound
[    3.493659] imx-media: subdev ipu2_ic_prp bound
[    3.498839] ipu2_ic_prpenc: Registered ipu2_ic_prpenc capture as /dev/video2
[    3.505958] imx-media: subdev ipu2_ic_prpenc bound
[    3.511318] ipu2_ic_prpvf: Registered ipu2_ic_prpvf capture as /dev/video3
[    3.518335] imx-media: subdev ipu2_ic_prpvf bound
[    3.524622] ipu1_csi0: Registered ipu1_csi0 capture as /dev/video4
[    3.530902] imx-media: subdev ipu1_csi0 bound
[    3.535453] ************ pinctrl failed
[    3.539684] ************ pinctrl failed
[    3.543677] ************ pinctrl failed
[    3.548278] imx-media: subdev imx6-mipi-csi2 bound

So imx_csi_probe() does not succeed anymore since
devm_pinctrl_get_select_default() always fails.

Not sure I understand the comments that explain the need for pinctrl
handling inside the driver.

Can't we just get rid of it like this?

--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of_graph.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -1739,7 +1738,6 @@ static const struct v4l2_subdev_internal_ops
csi_internal_ops = {
 static int imx_csi_probe(struct platform_device *pdev)
 {
        struct ipu_client_platformdata *pdata;
-       struct pinctrl *pinctrl;
        struct csi_priv *priv;
        int ret;

@@ -1789,19 +1787,7 @@ static int imx_csi_probe(struct platform_device *pdev)
        v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
        priv->sd.ctrl_handler = &priv->ctrl_hdlr;

-       /*
-        * The IPUv3 driver did not assign an of_node to this
-        * device. As a result, pinctrl does not automatically
-        * configure our pin groups, so we need to do that manually
-        * here, after setting this device's of_node.
-        */
        priv->dev->of_node = pdata->of_node;
-       pinctrl = devm_pinctrl_get_select_default(priv->dev);
-       if (IS_ERR(pinctrl)) {
-               ret = PTR_ERR(pinctrl);
-               goto free;
-       }
-
        ret = v4l2_async_register_subdev(&priv->sd);
        if (ret)
                goto free;
