Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54219 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032923AbeCAQ1U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 11:27:20 -0500
Message-ID: <1519921628.3034.5.camel@pengutronix.de>
Subject: Re: [PATCH] staging/imx: Fix inconsistent IS_ERR and PTR_ERR
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Date: Thu, 01 Mar 2018 17:27:08 +0100
In-Reply-To: <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
References: <20180301040939.GA13274@embeddedgus>
         <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-03-01 at 13:02 -0300, Fabio Estevam wrote:
> On Thu, Mar 1, 2018 at 1:09 AM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
> > Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
> > The proper pointer to be passed as argument is pinctrl
> > instead of priv->vdev.
> > 
> > This issue was detected with the help of Coccinelle.
> > 
> > Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> >  drivers/staging/media/imx/imx-media-csi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> > index 5a195f8..4f290a0 100644
> > --- a/drivers/staging/media/imx/imx-media-csi.c
> > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > @@ -1798,7 +1798,7 @@ static int imx_csi_probe(struct platform_device *pdev)
> >         priv->dev->of_node = pdata->of_node;
> >         pinctrl = devm_pinctrl_get_select_default(priv->dev);
> >         if (IS_ERR(pinctrl)) {
> > -               ret = PTR_ERR(priv->vdev);
> > +               ret = PTR_ERR(pinctrl);
> >                 goto free;
> 
> This patch is correct, but now I am seeing that
> devm_pinctrl_get_select_default() always fails.
> 
> I added this debug line:
> 
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1799,6 +1799,7 @@ static int imx_csi_probe(struct platform_device *pdev)
>         pinctrl = devm_pinctrl_get_select_default(priv->dev);
>         if (IS_ERR(pinctrl)) {
>                 ret = PTR_ERR(pinctrl);
> +               pr_err("************ pinctrl failed\n");
>                 goto free;
>         }
> 
> and this is what I get in imx6q-sabresd:
> 
> [    3.453905] imx-media: subdev ipu1_vdic bound
> [    3.458601] imx-media: subdev ipu2_vdic bound
> [    3.463341] imx-media: subdev ipu1_ic_prp bound
> [    3.468924] ipu1_ic_prpenc: Registered ipu1_ic_prpenc capture as /dev/video0
> [    3.476237] imx-media: subdev ipu1_ic_prpenc bound
> [    3.481621] ipu1_ic_prpvf: Registered ipu1_ic_prpvf capture as /dev/video1
> [    3.488805] imx-media: subdev ipu1_ic_prpvf bound
> [    3.493659] imx-media: subdev ipu2_ic_prp bound
> [    3.498839] ipu2_ic_prpenc: Registered ipu2_ic_prpenc capture as /dev/video2
> [    3.505958] imx-media: subdev ipu2_ic_prpenc bound
> [    3.511318] ipu2_ic_prpvf: Registered ipu2_ic_prpvf capture as /dev/video3
> [    3.518335] imx-media: subdev ipu2_ic_prpvf bound
> [    3.524622] ipu1_csi0: Registered ipu1_csi0 capture as /dev/video4
> [    3.530902] imx-media: subdev ipu1_csi0 bound
> [    3.535453] ************ pinctrl failed
> [    3.539684] ************ pinctrl failed
> [    3.543677] ************ pinctrl failed
> [    3.548278] imx-media: subdev imx6-mipi-csi2 bound
> 
> So imx_csi_probe() does not succeed anymore since
> devm_pinctrl_get_select_default() always fails.
> 
> Not sure I understand the comments that explain the need for pinctrl
> handling inside the driver.

Oh, this only works for csi ports that have pinctrl in their csi port
node, like:

&ipu1_csi0 {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_ipu1_csi0>;
};

For all other ports it fails. So we indeed have to silently continue if
there is no pinctrl in the port node.

> Can't we just get rid of it like this?

pinctrl would have to be moved out of the csi port nodes, for example
into their parent ipu nodes, or maybe more correctly, into the video mux
nodes in each device tree.

regards
Philipp
> 
