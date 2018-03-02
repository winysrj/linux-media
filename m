Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55137 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423905AbeCBKzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 05:55:07 -0500
Message-ID: <1519988099.16239.5.camel@pengutronix.de>
Subject: Re: [PATCH] staging/imx: Fix inconsistent IS_ERR and PTR_ERR
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Date: Fri, 02 Mar 2018 11:54:59 +0100
In-Reply-To: <CAOMZO5C93iuJSPw48vare5qCHwZiDDOva6X0bZ=xVTr1XJRPbg@mail.gmail.com>
References: <20180301040939.GA13274@embeddedgus>
         <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
         <1519921628.3034.5.camel@pengutronix.de>
         <CAOMZO5C93iuJSPw48vare5qCHwZiDDOva6X0bZ=xVTr1XJRPbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Thu, 2018-03-01 at 13:43 -0300, Fabio Estevam wrote:
> On Thu, Mar 1, 2018 at 1:27 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > Oh, this only works for csi ports that have pinctrl in their csi port
> > node, like:
> > 
> > &ipu1_csi0 {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_ipu1_csi0>;
> > };
> 
> This is the case for imx6qdl-sabresd.dtsi and even in this case
> devm_pinctrl_get_select_default() fails
> 
> > pinctrl would have to be moved out of the csi port nodes, for example
> > into their parent ipu nodes, or maybe more correctly, into the video mux
> > nodes in each device tree.
> 
> Tried it like this:
> 
> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> @@ -154,12 +154,9 @@
>  };
> 
>  &ipu1_csi0_mux_from_parallel_sensor {
> -       remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
> -};
> -
> -&ipu1_csi0 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_ipu1_csi0>;
> +       remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
>  };
> 
>  &mipi_csi {
> 
> 
> but still get the devm_pinctrl_get_select_default() failure.

Yes, this would still require to ignore the pinctrl error in the CSI
driver.

I just think that this is might be more correct, since the external pins
are directly connected to the mux input port.

> I was not able to change the dts so that
> devm_pinctrl_get_select_default() succeeds.
> 
> If you agree I can send the following change:
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c
> b/drivers/staging/media/imx/imx-media-csi.c
> index 5a195f8..c40f786 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1797,11 +1797,8 @@ static int imx_csi_probe(struct platform_device *pdev)
>          */
>         priv->dev->of_node = pdata->of_node;
>         pinctrl = devm_pinctrl_get_select_default(priv->dev);
> -       if (IS_ERR(pinctrl)) {
> -               ret = PTR_ERR(priv->vdev);
> -               goto free;
> -       }
> -
> +       if (IS_ERR(pinctrl))
> +               dev_dbg(priv->dev, "pintrl_get_select_default() failed\n");

I would add the error code to the debug print.

>         ret = v4l2_async_register_subdev(&priv->sd);
>         if (ret)
>                 goto free;
> 
> So that the error is ignored and we still can change the pinctrl values via dts.
> 
> What do you think?

Maybe we should still throw the error if it is anything other than
-ENODEV (which we expect in case there is no pinctrl property in the csi
port node):

	if (IS_ERR(pinctrl)) {
		ret = PTR_ERR(pinctrl);
		dev_dbg(priv->dev, "pinctrl_get_select_default() failed: %d\n",
			ret);
		if (ret != -ENODEV)
			goto free;
	}

regards
Philipp
