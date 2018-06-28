Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbeF1Ljk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 07:39:40 -0400
Date: Thu, 28 Jun 2018 08:39:36 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>
Subject: Re: [GIT PULL FOR v4.19] Convert last soc-camera users, rcar fixes,
 subdev std support
Message-ID: <20180628083936.1787dc67@coco.lan>
In-Reply-To: <37763018-a00b-806f-82b6-41835b2ea3ec@xs4all.nl>
References: <37763018-a00b-806f-82b6-41835b2ea3ec@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Jun 2018 16:39:43 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
>=20
> This pull requests converts the last users of soc-camera (thanks, Jacopo!=
),
> has a few rcar fixes and adds support for SDTV to v4l2-subdev (HDTV was
> supported, but not SDTV).
>=20
> Regards,
>=20
> 	Hans
>=20
> The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7=
ff:
>=20
>   media: omap2: fix compile-testing with FB_OMAP2=3Dm (2018-06-05 09:56:5=
6 -0400)
>=20
> are available in the Git repository at:
>=20
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.19b
>=20
> for you to fetch changes up to eae1c8802533c940e2a6ca55db4b3aa0a3d0759f:
>=20
>   v4l: Add support for STD ioctls on subdev nodes (2018-06-08 16:38:43 +0=
200)
>=20
> ----------------------------------------------------------------
> Jacopo Mondi (5):
>       media: i2c: Copy rj54n1cb0c soc_camera sensor driver
>       media: i2c: rj54n1: Remove soc_camera dependencies
>       arch: sh: kfr2r09: Use new renesas-ceu camera driver
>       arch: sh: ms7724se: Use new renesas-ceu camera driver
>       arch: sh: ap325rxa: Use new renesas-ceu camera driver
>=20
> Niklas S=C3=B6derlund (6):
>       media: dt-bindings: media: rcar_vin: add support for r8a77965
>       dt-bindings: media: rcar_vin: fix style for ports and endpoints
>       rcar-vin: sync which hardware buffer to start capture from
>       media: rcar-vin: enable support for r8a77965
>       v4l2-ioctl: create helper to fill in v4l2_standard for ENUMSTD

Patches applied, thanks!

>       v4l: Add support for STD ioctls on subdev nodes

Not convinced about this one. That requires further discussions.

I'm commenting about it at the patch's thread.

Thanks,
Mauro
