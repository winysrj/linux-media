Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF76C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 19:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB2B6217FA
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 19:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfBQTlD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 14:41:03 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:48661 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfBQTlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 14:41:02 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 47680FF804;
        Sun, 17 Feb 2019 19:40:59 +0000 (UTC)
Date:   Sun, 17 Feb 2019 20:41:24 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: Use standby mode instead of resetting
Message-ID: <20190217194124.fziv3yfr2xlvvcib@uno.localdomain>
References: <20190216225638.7159-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6tlkpawbof6ptuzb"
Content-Disposition: inline
In-Reply-To: <20190216225638.7159-1-niklas.soderlund+renesas@ragnatech.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--6tlkpawbof6ptuzb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
   ah, ups, this was maybe the patch the other one I just reviewed was
   based on... sorry, I missed this one :)

On Sat, Feb 16, 2019 at 11:56:38PM +0100, Niklas S=C3=B6derlund wrote:
> Later versions of the datasheet updates the reset procedure to more
> closely resemble the standby mode. Update the driver to enter and exit
> the standby mode instead of resetting the hardware before and after
> streaming is started and stopped.
>
> While at it break out the full start and stop procedures from
> rcsi2_s_stream() into the existing helper functions.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 69 +++++++++++++--------
>  1 file changed, 42 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/=
platform/rcar-vin/rcar-csi2.c
> index f64528d2be3c95dd..f3099f3e536d808a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -14,6 +14,7 @@
>  #include <linux/of_graph.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/reset.h>
>  #include <linux/sys_soc.h>
>
>  #include <media/v4l2-ctrls.h>
> @@ -350,6 +351,7 @@ struct rcar_csi2 {
>  	struct device *dev;
>  	void __iomem *base;
>  	const struct rcar_csi2_info *info;
> +	struct reset_control *rstc;
>
>  	struct v4l2_subdev subdev;
>  	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> @@ -387,11 +389,19 @@ static void rcsi2_write(struct rcar_csi2 *priv, uns=
igned int reg, u32 data)
>  	iowrite32(data, priv->base + reg);
>  }
>
> -static void rcsi2_reset(struct rcar_csi2 *priv)
> +static void rcsi2_standby_mode(struct rcar_csi2 *priv, int on)
>  {
> -	rcsi2_write(priv, SRST_REG, SRST_SRST);
> +	if (!on) {

minor thing: if (!on) { "wakeup"; } is confusing. What if you call the
variable "standby" or just "off" ?

> +		pm_runtime_get_sync(priv->dev);
> +		reset_control_deassert(priv->rstc);
> +		return;
> +	}
> +
> +	rcsi2_write(priv, PHYCNT_REG, 0);
> +	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> +	reset_control_assert(priv->rstc);
>  	usleep_range(100, 150);
> -	rcsi2_write(priv, SRST_REG, 0);
> +	pm_runtime_put(priv->dev);
>  }
>
>  static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
> @@ -462,7 +472,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, un=
signed int bpp)
>  	return mbps;
>  }
>
> -static int rcsi2_start(struct rcar_csi2 *priv)
> +static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  {
>  	const struct rcar_csi2_format *format;
>  	u32 phycnt, vcdt =3D 0, vcdt2 =3D 0;
> @@ -506,7 +516,6 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>
>  	/* Init */
>  	rcsi2_write(priv, TREF_REG, TREF_TREF);
> -	rcsi2_reset(priv);
>  	rcsi2_write(priv, PHTC_REG, 0);
>
>  	/* Configure */
> @@ -564,19 +573,36 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>  	return 0;
>  }
>
> +static int rcsi2_start(struct rcar_csi2 *priv)
> +{
> +	int ret;
> +
> +	rcsi2_standby_mode(priv, 0);
> +
> +	ret =3D rcsi2_start_receiver(priv);
> +	if (ret) {
> +		rcsi2_standby_mode(priv, 1);
> +		return ret;
> +	}
> +
> +	ret =3D v4l2_subdev_call(priv->remote, video, s_stream, 1);

minor thing as well, but I feel this one was better where it was, so
that "rcsi2_start()" only handles the hardware, while s_stream handles
the pipeline. But then _start() and _stop() becomes very short... so
yeah, feel free to keep it the way it is.

> +	if (ret) {
> +		rcsi2_standby_mode(priv, 1);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static void rcsi2_stop(struct rcar_csi2 *priv)
>  {
> -	rcsi2_write(priv, PHYCNT_REG, 0);
> -
> -	rcsi2_reset(priv);
> -
> -	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> +	v4l2_subdev_call(priv->remote, video, s_stream, 0);
> +	rcsi2_standby_mode(priv, 1);
>  }
>
>  static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> -	struct v4l2_subdev *nextsd;
>  	int ret =3D 0;
>
>  	mutex_lock(&priv->lock);
> @@ -586,27 +612,12 @@ static int rcsi2_s_stream(struct v4l2_subdev *sd, i=
nt enable)
>  		goto out;
>  	}
>
> -	nextsd =3D priv->remote;
> -
>  	if (enable && priv->stream_count =3D=3D 0) {
> -		pm_runtime_get_sync(priv->dev);
> -
>  		ret =3D rcsi2_start(priv);
> -		if (ret) {
> -			pm_runtime_put(priv->dev);
> +		if (ret)
>  			goto out;
> -		}
> -
> -		ret =3D v4l2_subdev_call(nextsd, video, s_stream, 1);
> -		if (ret) {
> -			rcsi2_stop(priv);
> -			pm_runtime_put(priv->dev);
> -			goto out;
> -		}
>  	} else if (!enable && priv->stream_count =3D=3D 1) {
>  		rcsi2_stop(priv);
> -		v4l2_subdev_call(nextsd, video, s_stream, 0);
> -		pm_runtime_put(priv->dev);
>  	}
>
>  	priv->stream_count +=3D enable ? 1 : -1;
> @@ -936,6 +947,10 @@ static int rcsi2_probe_resources(struct rcar_csi2 *p=
riv,
>  	if (irq < 0)
>  		return irq;
>
> +	priv->rstc =3D devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(priv->rstc))
> +		return PTR_ERR(priv->rstc);
> +

I don't see 'resets' listed as a mandatory property of the rcar-csi2
bindings, shouldn't you fallback to software reset if not 'reset'
is specified? True that all mainline users have a reset property specified,
so you could also add 'resets' among the mandatory properties, could
that break out of tree implementations in your opinion?

Thanks
   j

>  	return 0;
>  }
>
> --
> 2.20.1
>

--6tlkpawbof6ptuzb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxpuOQACgkQcjQGjxah
VjxiBw/+M5ZZw0U5CzL1Wv2wrbOla6utNDi2e8SwAIwJqmmYDhE6AZGZCM7e5xXc
Zq8o8dbWFE2qCqj4Nc480mDcDAE/v4IHxg/NheqA+34p7miuelTsA9C2MpuiTFLD
WCfO1eySCPStSrdR6FVqNqgVbcevlDUTHql+z71W8QW4HjfcCxLZ3pjqEF4lSZAy
GkI3TbLdJjernj1w1yZQU9qI32ah+2wHZTPunqGce8uTC6qBBSpXqxZ2mFYhvj4c
7K0QqoLCKUYbl5Fsbk5nfe4qdTJPby4wDBgdfkurU7Ou/zt76o9kxafLo1Uu31Ad
oAcz58zH+DGnAr4y1D+rsoLZU9L7ly3l5VELswfk4JHxzNu/ygT16US97GTJYKRv
zLHPOFVFUMn1Y+DirtLXIcOneuRvE2uxiDHAo29GB3dUNGJDk0kVY25zd90+UQWx
qNfekb3tBo+/P6UErVLNJpUo4w8Zwr4tuhMK8QSacutCWBiERmCBiNxgzyYSV16U
UqyJ2Zc66pjhTnShZmgAYL4DJz4/yLj4loRuHzCUp3lHo/SAQG9+tYgUvbOJ3T8z
3IPf8+nluDDoZLMycWmiqSrjR5+mRHgRnW3odKcE1KKNyqq4RfVq6iu9HDUSBi8Q
gTO5OLZ0sHiCsoDO16BXF6isCp3BIIrYP3IuM3FM6vF69yNgxvA=
=/ZfF
-----END PGP SIGNATURE-----

--6tlkpawbof6ptuzb--
