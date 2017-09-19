Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37573 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdISKsX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 06:48:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 01/25] v4l: fwnode: Move KernelDoc documentation to the header
Date: Tue, 19 Sep 2017 13:48:27 +0300
Message-ID: <9077921.hsjkiRftLf@avalon>
In-Reply-To: <20170915141724.23124-2-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <20170915141724.23124-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 15 September 2017 17:17:00 EEST Sakari Ailus wrote:
> In V4L2 the practice is to have the KernelDoc documentation in the header
> and not in .c source code files. This consequently makes the V4L2 fwnode
> function documentation part of the Media documentation build.
>=20
> Also correct the link related function and argument naming in
> documentation.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

I'm still very opposed to this. In addition to increasing the risk of=20
documentation becoming stale, it also makes review more difficult. I'm=20
reviewing patch 05/25 of this series and I have to jump around the patch to=
=20
verify that the documentation matches the implementation, it's really=20
annoying.

We should instead move all function documentation from header files to sour=
ce=20
files.

> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 75 -----------------------------=
=2D--
> include/media/v4l2-fwnode.h            | 81 +++++++++++++++++++++++++++++=
++-
> 2 files changed, 80 insertions(+), 76 deletions(-)

[snip]

=2D-=20
Regards,

Laurent Pinchart
