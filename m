Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422696Ab2KNMDj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:03:39 -0500
Date: Wed, 14 Nov 2012 13:03:20 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 1/6] video: add display_timing and videomode
Message-ID: <20121114120320.GB2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-2-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 12:43:18PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/include/linux/videomode.h b/include/linux/videomode.h
[...]
> +int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
> +			  unsigned int index);
> +#endif

Nit: should have a blank line before the #endif.

Thierry

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo4iIAAoJEN0jrNd/PrOht+gQAJkiyHXQntl61lfk0YIlIdgV
NRt7JONL/qNvqUqj0fXaQTcZIRP9R8IiNzjqw5o0niiC1YDAYDETksyy+ipm0dIp
41KyzS0pRScWzJL3YBM8elMHTRiKD8vHT/3q5t5a9FeVPdIVk91Y0FXMx/14D90v
aSu99wY7FfARdMEzkEdy4EhTKRd7TUTnFsSds69dd4XK62hUMtemKcm7T3ekK75k
WbHAr8hYj/+b3IuR0EmdWf6QAIWPEol67IdBH3HI5MH7HlLmD1JSrtgwL+EGNh2U
BtFAieO7P6/3RybRmQXj0/LIHg2ylfdHSaT7qf13xn4m0ZS66A8+Y0BXJD1CRG+0
qQAB/ypKX/6opMCNS4s4XCr7Q1G7o/Hd5/tqSXx/JFP8U29hZlqZ3tLpLsJnsSwB
rmBhNOStY8Y77tdVmXeG/Q+se4QE5kt6Fg0zcGCREGipCZkIwFqqkFlqNrXhZ/t4
es5pJ8GcboyZAGDUqNxhPqCdA7GmsQ8n3KU2rPG5PLL1/j+DD5FcHfReSjifLlai
FcD9qHUF7erGmQP9whnD5x4I/LoYBsWasKugKDXuF+axc1BRHS37GNjYsVNn9iuK
dAUSC+9rBYGIP7LMPLKw7W+BdHLKs2J1zkAM/8UecfPQ+MXt4w4k8yy+zc1xxgXJ
KdFK4l73br9LAWx8Qh8w
=NCno
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
