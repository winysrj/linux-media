Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37633 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdISLHD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:07:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v13 01/25] v4l: fwnode: Move KernelDoc documentation to the header
Date: Tue, 19 Sep 2017 14:07:08 +0300
Message-ID: <15064920.NAWzJTdLf5@avalon>
In-Reply-To: <29354478-ec46-278b-c457-4e6f3cc6848c@xs4all.nl>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <9077921.hsjkiRftLf@avalon> <29354478-ec46-278b-c457-4e6f3cc6848c@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday, 19 September 2017 14:04:36 EEST Hans Verkuil wrote:
> On 09/19/17 12:48, Laurent Pinchart wrote:
> > On Friday, 15 September 2017 17:17:00 EEST Sakari Ailus wrote:
> >> In V4L2 the practice is to have the KernelDoc documentation in the hea=
der
> >> and not in .c source code files. This consequently makes the V4L2 fwno=
de
> >> function documentation part of the Media documentation build.
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
> >=20
> > We should instead move all function documentation from header files to
> > source files.
>=20
> I disagree with this. Yes, it makes reviewing harder, but when you have to
> *use* these functions as e.g. a driver developer, then having it in the
> header is much more convenient.

When writing a driver you can use the compiled documentation. We're lacking=
=20
reviewers in V4L2, we should make their life easier if we want to attract=20
more.

=46urthermore, if documentation becomes stale, it will become useless for d=
river=20
authors, regardless of where it's stored.

> >> ---
> >>=20
> >>  drivers/media/v4l2-core/v4l2-fwnode.c | 75 --------------------------=
=2D--
> >>  include/media/v4l2-fwnode.h           | 81 ++++++++++++++++++++++++++=
+-
> >>  2 files changed, 80 insertions(+), 76 deletions(-)

=2D-=20
Regards,

Laurent Pinchart
