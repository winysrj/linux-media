Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3.utsp.utwente.nl ([130.89.2.14]:33609 "EHLO mx.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbZCTJRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 05:17:50 -0400
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Message-Id: <6EDD6EAA-E1DC-4F71-BB6E-01574AC2D968@student.utwente.nl>
From: Koen Kooi <k.kooi@student.utwente.nl>
To: Hardik Shah <hardik.shah@ti.com>
In-Reply-To: <1237526408-14249-1-git-send-email-hardik.shah@ti.com>
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-1--612872052"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
Date: Fri, 20 Mar 2009 10:04:09 +0100
References: <1237526408-14249-1-git-send-email-hardik.shah@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-1--612872052
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit


Op 20 mrt 2009, om 06:20 heeft Hardik Shah het volgende geschreven:
>
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -711,6 +711,26 @@ config VIDEO_CAFE_CCIC
> 	  CMOS camera controller.  This is the controller found on first-
> 	  generation OLPC systems.
>
> +#config VIDEO_OMAP3
> +#        tristate "OMAP 3 Camera support"
> +#	select VIDEOBUF_GEN
> +#	select VIDEOBUF_DMA_SG
> +#	depends on VIDEO_V4L2 && ARCH_OMAP34XX
> +#	---help---
> +#	  Driver for an OMAP 3 camera controller.
> +
> +config VIDEO_OMAP3
> +	bool "OMAP2/OMAP3 Camera and V4L2-DSS drivers"
> +	select VIDEOBUF_GEN
> +	select VIDEOBUF_DMA_SG
> +	select OMAP2_DSS
> +	depends on VIDEO_DEV && (ARCH_OMAP24XX || ARCH_OMAP34XX)
> +	default y
> +	---help---
> +        V4L2 DSS and Camera driver support for OMAP2/3 based boards.


Copy/paste error?

regards,

Koen

--Apple-Mail-1--612872052
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: Dit deel van het bericht is digitaal ondertekend
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)

iD8DBQFJw1wsMkyGM64RGpERAlwNAJoDzeCXNmE0Iw9F4YJgOP93oijB/QCbBW/u
E052eL1WVVentwBVT1YhAKw=
=VKTM
-----END PGP SIGNATURE-----

--Apple-Mail-1--612872052--
