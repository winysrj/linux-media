Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37687 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdISLOf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:14:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 01/25] v4l: fwnode: Move KernelDoc documentation to the header
Date: Tue, 19 Sep 2017 14:14:39 +0300
Message-ID: <20634394.E3nNBE0rok@avalon>
In-Reply-To: <20170919111036.5va2unwqh2vymojr@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <9077921.hsjkiRftLf@avalon> <20170919111036.5va2unwqh2vymojr@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 14:10:37 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 01:48:27PM +0300, Laurent Pinchart wrote:
> > On Friday, 15 September 2017 17:17:00 EEST Sakari Ailus wrote:
> >> In V4L2 the practice is to have the KernelDoc documentation in the
> >> header and not in .c source code files. This consequently makes the V4=
L2
> >> fwnode function documentation part of the Media documentation build.
> >>=20
> >> Also correct the link related function and argument naming in
> >> documentation.
> >>=20
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Reviewed-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Acked-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > I'm still very opposed to this. In addition to increasing the risk of
> > documentation becoming stale, it also makes review more difficult. I'm
> > reviewing patch 05/25 of this series and I have to jump around the patch
> > to verify that the documentation matches the implementation, it's really
> > annoying.
>=20
> I'd like to have this discussion separately from the patchset, which is
> right now in its 13th version. This patch simply makes the current state
> consistent; V4L2 async was the only part of V4L2 with KernelDoc
> documentation in .c files.

But there's no need to move the documentation at this point until we reach =
an=20
agreement, is there ?

=2D-=20
Regards,

Laurent Pinchart
