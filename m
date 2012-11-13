Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58700 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2KML20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 06:28:26 -0500
Date: Tue, 13 Nov 2012 12:28:06 +0100
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
Subject: Re: [PATCH v8 4/6] fbmon: add of_videomode helpers
Message-ID: <20121113112806.GC30049@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-5-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-5-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 12, 2012 at 04:37:04PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/include/linux/fb.h b/include/linux/fb.h
[...]
> +extern int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb, int index);

Similarily this should get a dummy for the !CONFIG_OF_VIDEOMODE case,
right? Either that or the prototype should be protected by
CONFIG_OF_VIDEOMODE as well.

Thierry

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoi7GAAoJEN0jrNd/PrOhVjIP/36eOoKUDRNb6eN9INfsjTEx
Jgjo1dTXSOJ3MS/oLaqyCyEHFsJ7/Ykd7AQECwGNhZGMpk5rqlP6qbEFq6EHBSOl
lB4K5boKPsQskjEoycghzhS+cHmmGMNRyxRPoCOsw15+bRuuCZYokMZpTo2l6o5g
DxcMwRkggweQ9jCxkjasrzTheC5n3ORJGooxruJJRa53FtCY5YsdudejKJWbY42m
Rz09e4l44mAI1rTtSXSRpwtZs1all3Zl/whlDtdZLE78az48SobMVj4TQSwLrmay
NEOfgBLvKVfiKIZCGEKGFJcMpeZ+xbSnP1VyJ6NH0LQrI2KuSeFL6Ueljqi6+6Xe
BwVUk1cf7Qv38mkdlOtSOj0F0sLGW80VZ3sA3B87Z2ziY/TyDODs0KVat9T4LRPn
MNUbEFdwVZCXeAC9r62Jg5lv0nhxbZ+4+QZGXThnvjS21vzWm+gh8FTVWHGiMxg2
unjU1pEU/7k7alAZnXABOMNzzO0lALfZC277Rn87A9KROJ5Cc+51mo5ice2MJBaE
sgAlULYPCbXZYBkBkpPaHQ+CB3AhYuC63QJUoeYHuLrki6fIYp16T0trgHZAGasK
6ja7u6KndZIDhsrhyK/cxooBxZpaZNRxnpsmqoUhRP1/CafXYkamtkEMTc6mpT2N
EbuqVNtAeNkrjcYSuUe3
=pyCu
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
