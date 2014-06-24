Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47423 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaFXVtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 17:49:41 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so6890671wib.17
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 14:49:40 -0700 (PDT)
Date: Tue, 24 Jun 2014 23:49:37 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Denis Carikli <denis@eukrea.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devel@driverdev.osuosl.org,
	Russell King <linux@arm.linux.org.uk>,
	Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 08/10] drm/panel: Add Eukrea mbimxsd51 displays.
Message-ID: <20140624214926.GA30039@mithrandir>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
 <1402913484-25910-8-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <1402913484-25910-8-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 12:11:22PM +0200, Denis Carikli wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt
[...]
> @@ -0,0 +1,7 @@
> +Eukrea DVI-SVGA (800x600 pixels) DVI output.
[...]
> diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt
[...]
> @@ -0,0 +1,7 @@
> +Eukrea DVI-VGA (640x480 pixels) DVI output.

DVI outputs shouldn't be using the panel framework and this binding at
all. DVI usually has the means to determine all of this by itself. Why
do you need to represent this as a panel in device tree?

Thierry

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTqfJuAAoJEN0jrNd/PrOhlI8QAMDaRzzfXm3U9guoTcbiCsPk
lK1bKIQWs6XBtbVovlTPX/vzYxiGz/VaGLjploRhN0bHJv28p2lCT1N5zrIA9vPU
2j5dSzs1TdBSEX7wkj/IaBJxajEKYo212m2jA12nB+YbCRdlF2tq+foxi5sdZ9QF
s0LFTFy6oGqI0z3UR3DMvyohcPIalY9sqtUzT/yipgqsYhMs93rhq1GOtny/TTmP
jtLDrhYEXtezNRAbaDSa3F+Fnl33DEknV1/mbEIHFcddu4nBqvgTue2T22ZOHZyN
hJqmXpUPqYbGaHhGZg4B6t5VZz9FJJYU0TbbHgKko6uMZKgX7CQi66xcRdXYEP7l
8NhnAGD4h4sF5kWvZoISIgR3Aa3gL3vqtqx22dDqFH6nwMQ50al+c9vm5iLRBca2
74Q4R9s0u440fNSMiZ++TdTtdj18/RfVky+YYuObBDn7XNkMrCC8nyg1QTKuTXlU
79Fft/IqvQL2RpuJgURXLcUfyUivPZh0zG7NbS9XIewvm9E9MS5aCqW01tt93GY1
oyRPbhzJzr23rQpDl4BSz/ndnt11oWELKBCo97UNOxH0GaMsTDnCTOV3rV/rKisJ
N/WvqZkTM5TSFJyJoAfAMkqqnR6so9PUX7EjnSz+kuVXsnBIt7adCzHOhOhzaJug
t3LzA7+lPC0z3OrZ5o5F
=+j5Q
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
