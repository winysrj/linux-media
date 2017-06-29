Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51501 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752172AbdF2JNx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 05:13:53 -0400
Message-ID: <1498727623.14476.22.camel@pengutronix.de>
Subject: Re: [PATCH] [media] staging/imx: remove confusing IS_ERR_OR_NULL
 usage
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Jun 2017 11:13:43 +0200
In-Reply-To: <20170628201435.3237712-1-arnd@arndb.de>
References: <20170628201435.3237712-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

thank you for the cleanup. I see two issues below:

On Wed, 2017-06-28 at 22:13 +0200, Arnd Bergmann wrote:
> While looking at a compiler warning, I noticed the use of
> IS_ERR_OR_NULL, which is generally a sign of a bad API design
> and should be avoided.
> 
> In this driver, this is fairly easy, we can simply stop storing
> error pointers in persistent structures, and change the one
> function that might return either a NULL pointer or an error
> code to consistently return error pointers when failing.
> 
> Fixes: e130291212df ("[media] media: Add i.MX media core driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I can't reproduce the original warning any more, but this
> patch still makes sense by itself.
> ---
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 41 ++++++++++++++++-------------
>  drivers/staging/media/imx/imx-media-csi.c   | 29 +++++++++++---------
>  drivers/staging/media/imx/imx-media-dev.c   |  2 +-
>  drivers/staging/media/imx/imx-media-of.c    |  2 +-
>  drivers/staging/media/imx/imx-media-vdic.c  | 37 ++++++++++++++------------
>  5 files changed, 61 insertions(+), 50 deletions(-)
> 
[...]
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index a2d26693912e..a4b3c305dcc8 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -122,11 +122,11 @@ static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
>  
>  static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
>  {
> -	if (!IS_ERR_OR_NULL(priv->idmac_ch))
> +	if (priv->idmac_ch)
>  		ipu_idmac_put(priv->idmac_ch);
>  	priv->idmac_ch = NULL;
>  
> -	if (!IS_ERR_OR_NULL(priv->smfc))
> +	if (priv->smfc)
>  		ipu_smfc_put(priv->smfc);
>  	priv->smfc = NULL;
>  }
> @@ -134,23 +134,26 @@ static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
>  static int csi_idmac_get_ipu_resources(struct csi_priv *priv)
>  {
>  	int ch_num, ret;
> +	struct ipu_smfc *smfc, *idmac_ch;

This should be

+	struct ipuv3_channel *idmac_ch;
+	struct ipu_smfc *smfc;

instead.

[...]
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 48cbc7716758..c58ff0831890 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -91,7 +91,7 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
>  	if (imx_media_find_async_subdev(imxmd, np, devname)) {
>  		dev_dbg(imxmd->md.dev, "%s: already added %s\n",
>  			__func__, np ? np->name : devname);
> -		imxsd = NULL;
> +		imxsd = ERR_PTR(-EEXIST);

And since this returns -EEXIST now, ...

>  		goto out;
>  	}
>  
> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
> index b026fe66467c..4aac42cb79a4 100644
> --- a/drivers/staging/media/imx/imx-media-of.c
> +++ b/drivers/staging/media/imx/imx-media-of.c
> @@ -115,7 +115,7 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
>  
>  	/* register this subdev with async notifier */
>  	imxsd = imx_media_add_async_subdev(imxmd, sd_np, NULL);
> -	if (IS_ERR_OR_NULL(imxsd))
> +	if (IS_ERR(imxsd))
>  		return imxsd;

... this changes behaviour:

    imx-media: imx_media_of_parse failed with -17
    imx-media: probe of capture-subsystem failed with error -17

We must continue to return NULL here if imxsd == -EEXIST:

-		return imxsd;
+		return PTR_ERR(imxsd) == -EEXIST ? NULL : imxsd;

or change the code where of_parse_subdev is called (from
imx_media_of_parse, and recursively from of_parse_subdev) to not handle
the -EEXIST return value as an error.

With those fixed,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
