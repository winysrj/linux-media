Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51606 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbdLHTUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 14:20:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 11/28] rcar-vin: do not allow changing scaling and composing while streaming
Date: Fri, 08 Dec 2017 21:20:48 +0200
Message-ID: <1750592.qc2TZyzifv@avalon>
In-Reply-To: <20171208141423.GQ31989@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <14690079.PLADEzS7Fe@avalon> <20171208141423.GQ31989@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 8 December 2017 16:14:23 EET Niklas S=F6derlund wrote:
> On 2017-12-08 11:04:26 +0200, Laurent Pinchart wrote:
> > On Friday, 8 December 2017 03:08:25 EET Niklas S=F6derlund wrote:
> >> It is possible on Gen2 to change the registers controlling composing a=
nd
> >> scaling while the stream is running. It is however not a good idea to =
do
> >> so and could result in trouble. There are also no good reasons to allow
> >> this, remove immediate reflection in hardware registers from
> >> vidioc_s_selection and only configure scaling and composing when the
> >> stream starts.
> >=20
> > There is a good reason: digital zoom.
>=20
> OK, so you would recommend me to drop this patch to keep the current
> behavior?

Yes, unless you don't care about breaking use cases for Gen2, but in that c=
ase=20
I'd recommend dropping Gen2 support altogether :-)

> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
> >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
> >>  drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
> >>  3 files changed, 1 insertion(+), 7 deletions(-)

[snip]

=2D-=20
Regards,

Laurent Pinchart
