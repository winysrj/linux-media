Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344F5C4360F
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 10:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07B2B218B0
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 10:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfCUKBO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:01:14 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:39423 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbfCUKBN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 06:01:13 -0400
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id B506F20001E;
        Thu, 21 Mar 2019 10:01:08 +0000 (UTC)
Date:   Thu, 21 Mar 2019 11:01:47 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Marco Felsch <m.felsch@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        afshin.nasser@gmail.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v4 4/7] media: v4l2-subdev: add stubs for
 v4l2_subdev_get_try_*
Message-ID: <20190321100147.eqfnbw6jjatqvfvw@uno.localdomain>
References: <20190129160757.2314-1-m.felsch@pengutronix.de>
 <20190129160757.2314-5-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="scx5thddibgfbxob"
Content-Disposition: inline
In-Reply-To: <20190129160757.2314-5-m.felsch@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--scx5thddibgfbxob
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Marco,

FYI we've been there already:
https://patchwork.kernel.org/patch/10703029/

and that ended with Hans' patch:
https://patchwork.linuxtv.org/patch/53370/
which didn't get far unfortunately.

On Tue, Jan 29, 2019 at 05:07:54PM +0100, Marco Felsch wrote:
> In case of missing CONFIG_VIDEO_V4L2_SUBDEV_API those helpers aren't
> available. So each driver have to add ifdefs around those helpers or
> add the CONFIG_VIDEO_V4L2_SUBDEV_API as dependcy.
>
> Make these helpers available in case of CONFIG_VIDEO_V4L2_SUBDEV_API
> isn't set to avoid ifdefs. This approach is less error prone too.
>
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  include/media/v4l2-subdev.h | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 47af609dc8f1..90c9a301d72a 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -916,8 +916,6 @@ struct v4l2_subdev_fh {
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>
> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> -
>  /**
>   * v4l2_subdev_get_try_format - ancillary routine to call
>   *	&struct v4l2_subdev_pad_config->try_fmt
> @@ -931,9 +929,13 @@ static inline struct v4l2_mbus_framefmt
>  			    struct v4l2_subdev_pad_config *cfg,
>  			    unsigned int pad)
>  {
> +#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	if (WARN_ON(pad >= sd->entity.num_pads))
>  		pad = 0;
>  	return &cfg[pad].try_fmt;
> +#else
> +	return NULL;

Since Hans' attempt didn't succeed, maybe we want to reconsider this
approach? I liked Lubomir's version better, but in any case, small
details...

Shouldn't you return ERR_PTR(-ENOTTY) here instead of NULL ?

+ Sakari, Hans:
Alternatively, what if we add CONFIG_VIDEO_V4L2_SUBDEV_API as a
dependency of all sensor drivers that still use the

#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
v4l2_subdev_get_try_format(sd, cfg, format->pad);
#else
-ENOTTY
#endif

pattern so we could remove that block #ifdef blocks and do not touch the
v4l2-subdev.h header? Should I send a patch?

Thanks
  j


> +#endif
>  }
>
>  /**
> @@ -949,9 +951,13 @@ static inline struct v4l2_rect
>  			  struct v4l2_subdev_pad_config *cfg,
>  			  unsigned int pad)
>  {
> +#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	if (WARN_ON(pad >= sd->entity.num_pads))
>  		pad = 0;
>  	return &cfg[pad].try_crop;
> +#else
> +	return NULL;
> +#endif
>  }
>
>  /**
> @@ -967,11 +973,14 @@ static inline struct v4l2_rect
>  			     struct v4l2_subdev_pad_config *cfg,
>  			     unsigned int pad)
>  {
> +#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	if (WARN_ON(pad >= sd->entity.num_pads))
>  		pad = 0;
>  	return &cfg[pad].try_compose;
> -}
> +#else
> +	return NULL;
>  #endif
> +}
>
>  extern const struct v4l2_file_operations v4l2_subdev_fops;
>
> --
> 2.20.1
>

--scx5thddibgfbxob
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyTYQsACgkQcjQGjxah
VjwM2RAAu3Nncurh6ZF1SDOXTxkD8M7HEd9gr32UNTfFGxSovsxxBMXFm5VKPMNN
IUM5W+Or0V38H17ZSgBQsqWjpUx/IrgSf9LKsFLAJAgf+wR/o4rfwL6x3uhzVT/1
P+MczexbLUZbNPdZPy6KovLGccCd5LuXIxX9icztpYtqAHA9jHt69AGP7U5OwPgt
PCyJrKrcySPTtSCd2MQGyMjwnfkPfdP7MFp/md0U4PdPwrVVmcf+uL2DW0f9MMSD
GGFtt+/WJJWZ6F9koLGdn31TbijevcsSNaTzw//wPQrgxDM2Je3ceTfgTK+zKODh
iEcSRlcn5t6N2TbHgHAMXyNxx9O+3n8Lw/PyVJZ6l9QGcGH0T+WYHyBmoShnrWmE
VtHuZ7J3e+674Ef9aIGrcwC8F64CvIcgik03gakrgB2ReIRNVer+r6B3LpsVvu1A
Bd6BtjeAlkoSkgazAsQkYhTkb2dIhEa05s3BDxGEKk20hIEm0pJe7VMLXB7PjPOm
ETQZARRJPix/NdJ8VSElNbEO0cvaif8gEShLFFijbJd98HhVmCRAw0K9Y6Q2ptzp
FkaIYDxHk0xtIhMS07FUvUWoNOd9BwByjLRG/tMXAcmPwaKq6S3mnVsJ8StBMFhP
zOSiUDSBhzeUHGQ84MZH4babdQVFiNl5WaURFmlhIQ76w3++5Eg=
=g0hY
-----END PGP SIGNATURE-----

--scx5thddibgfbxob--
