Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:59569 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934165AbeGDJBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 05:01:23 -0400
Date: Wed, 4 Jul 2018 11:01:18 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 0/2] media: i2c: mt9v111 sensor driver
Message-ID: <20180704090118.GC4463@w540>
References: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Content-Disposition: inline
In-Reply-To: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello linux-media list,

On Mon, Jun 11, 2018 at 05:17:31PM +0200, Jacopo Mondi wrote:
> Hello,
>    this is a sensor level driver for Aptina MT9V111.
>
> The driver supports YUYV_2X8 output formats and VGA,QVGA,QQVGA,CIF and QCIF
> resolution.
>
> The driver allows control of frame rate through s_frame_interval or
> V4L2_CID_H/VBLANK control. In order to allow manual frame control, the chip
> is initialized with auto-exposure control, auto white balancing and flickering
> control disabled.
>
> Tested VGA, QVGA QQVGA resolutions at 5, 10, 15 and 30 frame per second.

Gentle ping for this driver, as I have now sent a patch to add a user
for it
https://patchwork.kernel.org/patch/10505175/

Thanks
   j

>
> Thanks
>    j
>
> Jacopo Mondi (2):
>   dt-bindings: media: i2c: Document MT9V111 bindings
>   media: i2c: Add driver for Aptina MT9V111
>
>  .../bindings/media/i2c/aptina,mt9v111.txt          |   46 +
>  MAINTAINERS                                        |    8 +
>  drivers/media/i2c/Kconfig                          |   12 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/mt9v111.c                        | 1297 ++++++++++++++++++++
>  5 files changed, 1364 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
>  create mode 100644 drivers/media/i2c/mt9v111.c
>
> --
> 2.7.4
>

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPIzeAAoJEHI0Bo8WoVY8MzAP/254585/SldQw+B3ZHU50Q9B
nNGDfkMUOki6Y+nfOUuSHuErPrdYbCQo1JOXy7t7Yun2l5Ctb8qnQX2cohbPwHqV
2IDewGNmPxmNIzAmhDw6TbjvDvkTY3+K5axnAVSF0VAe8bisHtTwPPpzyFr5rPgJ
a56gSvu/F9+LJG4zaKnFyWt+CMT/UnuR7+VXC0CS8llX0qhe54gK4S+njC5CTICN
S4hrSA24IcKFGZCzArDyndT3obxdUh0Wk9ipzHgrtIIBZyOfky+a2h9g7JtGeHr+
DOb+l3l5kTkHJtR1CufRB93GrGDCkBFpBcsT7KerhThSZpGSAofX7ViiHgI/Ze2/
8UlkwQUem5hFd/hq6CISQ7H5nEsijIIOjjOsYKv6Sv9aEr2vJhHYlr5PkY2oS333
DyAssMrjSwbafEokI5hMxudCVaN/b40JhymSmPL9bVgkeOhvgFdzQ3OpgMaes0so
6ni2QSZe8BHitJ4AH8QJOEivGlA0YI+4ABOz9TiBH2oZJzQyG8aM4JDGM6irnv4G
JtYyMZ7HCZRzixCb9VuujNod/bOhcDEtPl+JyanG5k7aVEycnmetpuTk7LO54MPJ
uJb2X8RIoWt57/qYT9KwOI+BWzErQIT3aBslLvfUYf/gX14VkCsW9hAsRBWU8B8z
yUWow718UGGlQvFJjJnO
=j6DM
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
