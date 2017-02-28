Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47588 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdB1WtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 17:49:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 3/3] v4l: vsp1: wpf: Implement rotation support
Date: Wed, 01 Mar 2017 00:23:04 +0200
Message-ID: <2151035.IRLLozJt72@avalon>
In-Reply-To: <20170228211334.GC3220@valkosipuli.retiisi.org.uk>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com> <20170228150320.10104-4-laurent.pinchart+renesas@ideasonboard.com> <20170228211334.GC3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 28 Feb 2017 23:13:34 Sakari Ailus wrote:
> On Tue, Feb 28, 2017 at 05:03:20PM +0200, Laurent Pinchart wrote:
> > Some WPF instances, on Gen3 devices, can perform 90=B0 rotation whe=
n
> > writing frames to memory. Implement support for this using the
> > V4L2_CID_ROTATE control.
> >=20
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >=20
> >  drivers/media/platform/vsp1/vsp1_rpf.c   |   2 +-
> >  drivers/media/platform/vsp1/vsp1_rwpf.c  |   5 +
> >  drivers/media/platform/vsp1/vsp1_rwpf.h  |   3 +-
> >  drivers/media/platform/vsp1/vsp1_video.c |  12 +-
> >  drivers/media/platform/vsp1/vsp1_wpf.c   | 205 ++++++++++++++++++-=
-------
> >  5 files changed, 175 insertions(+), 52 deletions(-)

[snip]

> > diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h
> > b/drivers/media/platform/vsp1/vsp1_rwpf.h index
> > 1c98aff3da5d..b4ffc38f48af 100644
> > --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> > +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> > @@ -56,9 +56,10 @@ struct vsp1_rwpf {
> >=20
> >  =09struct {
> >  =09=09spinlock_t lock;
> > -=09=09struct v4l2_ctrl *ctrls[2];
> > +=09=09struct v4l2_ctrl *ctrls[3];
>=20
> At least what comes to this patch --- having a field for each control=
 would
> look much nicer in the code. Is there a particular reason for having =
an
> array with all the controls in it?

Not really. I need to put the three controls in a cluster, so I stored =
them in=20
an array to make sure they would be properly contiguous in memory. I ca=
n also=20
use three separate pointers, it shouldn't hurt.

> >  =09=09unsigned int pending;
> >  =09=09unsigned int active;
> > +=09=09bool rotate;
> >  =09} flip;
> >  =09
> >  =09struct vsp1_rwpf_memory mem;

--=20
Regards,

Laurent Pinchart
