Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34944 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032944AbeCAQnX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 11:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <1519921628.3034.5.camel@pengutronix.de>
References: <20180301040939.GA13274@embeddedgus> <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
 <1519921628.3034.5.camel@pengutronix.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 1 Mar 2018 13:43:22 -0300
Message-ID: <CAOMZO5C93iuJSPw48vare5qCHwZiDDOva6X0bZ=xVTr1XJRPbg@mail.gmail.com>
Subject: Re: [PATCH] staging/imx: Fix inconsistent IS_ERR and PTR_ERR
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 1, 2018 at 1:27 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> Oh, this only works for csi ports that have pinctrl in their csi port
> node, like:
>
> &ipu1_csi0 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_ipu1_csi0>;
> };

This is the case for imx6qdl-sabresd.dtsi and even in this case
devm_pinctrl_get_select_default() fails

> pinctrl would have to be moved out of the csi port nodes, for example
> into their parent ipu nodes, or maybe more correctly, into the video mux
> nodes in each device tree.

Tried it like this:

--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -154,12 +154,9 @@
 };

 &ipu1_csi0_mux_from_parallel_sensor {
-       remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
-};
-
-&ipu1_csi0 {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_ipu1_csi0>;
+       remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
 };

 &mipi_csi {


but still get the devm_pinctrl_get_select_default() failure.

I was not able to change the dts so that
devm_pinctrl_get_select_default() succeeds.

If you agree I can send the following change:

diff --git a/drivers/staging/media/imx/imx-media-csi.c
b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f8..c40f786 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1797,11 +1797,8 @@ static int imx_csi_probe(struct platform_device *pdev)
         */
        priv->dev->of_node = pdata->of_node;
        pinctrl = devm_pinctrl_get_select_default(priv->dev);
-       if (IS_ERR(pinctrl)) {
-               ret = PTR_ERR(priv->vdev);
-               goto free;
-       }
-
+       if (IS_ERR(pinctrl))
+               dev_dbg(priv->dev, "pintrl_get_select_default() failed\n");
        ret = v4l2_async_register_subdev(&priv->sd);
        if (ret)
                goto free;

So that the error is ignored and we still can change the pinctrl values via dts.

What do you think?
