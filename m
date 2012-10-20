Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2JTK6h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:58:37 -0400
Date: Sat, 20 Oct 2012 12:58:26 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Rob Herring <robherring2@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
Message-ID: <20121020105826.GC12545@avionic-0098.mockup.avionic-design.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 04, 2012 at 07:59:19PM +0200, Steffen Trumtrar wrote:
[...]
> diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
> new file mode 100644
> index 0000000..1ad719e
> --- /dev/null
> +++ b/include/linux/of_display_timings.h
> @@ -0,0 +1,85 @@
> +/*
> + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> + *
> + * description of display timings
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#ifndef __LINUX_OF_DISPLAY_TIMINGS_H
> +#define __LINUX_OF_DISPLAY_TIMINGS_H

This file needs to include linux/slab.h because it uses kfree() in the
inline functions. Alternatively I think I'd rather see the inline
functions moved out of the header, with the exception of the
signal_timing_get_value() function perhaps.

Moreover there should be a forward declaration of struct display_node
to avoid the need to include linux/of.h.

Thierry

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgoPSAAoJEN0jrNd/PrOhqjEQAJLn09qkLTvFk7LDazjFziI3
THkGF3Vh3mO0uEJ63BOnQOrbmozP9cTNtlHinMfk12DkmDP7FrPnhSdSatVbmxX+
jMBgQYK31ugyn264qExW2SxbRLkG6bxxADvtOMLLzgV4HUThUeBKQMisBIQFmXjF
DOLZ780BNXPEf/DWnLDgWrWX+MXNK0aB86ynGFyegoFvkPhXdpd4a9MEMelZ93Pc
wkzQ6TNGb5gymN+KhIalJ8+KaEPb3KcXMrqjT56j67TSj75Txmfia6mDC7KvLgJI
QnUx3SGhafTlV7Nh0DbcpZH9GD4BZ6LDQJcE5psH6OIoOIOrJpZLAf2eI5dTF70l
raj4fSVMnCbmCZhn/cL4lNHXdbq9DKOvLBilvZxpKdgWU7FUQaLTwkfyZktHbdTb
wWY8I099P0SHfpfuHKCe8NNmKqrFF2On+oQhwnH23gRaURZzeT/HWvVfuJ3c58Tt
CzgXGtb51G7SeKYoKwU3aPr9Khhv5UezCZ132qrt4ulyR/zevWgPQkSy5DKsA33e
CnnOWv/osbDbKjebWYZVlziGK1Wp7veNDlTMY80yi3WcLpXDuCoQCOL5JNVCussa
GFtpB8HhyeXNMS5dREqeW+JHXXlIP4frjjL2DRbQmPShcxkLRJQ4DeDtw6WVATe+
2CXlYRQx66//+ByryINx
=yhUC
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
