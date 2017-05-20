Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37698 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751813AbdETU6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 May 2017 16:58:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 14/16] rcar-vin: make use of video_device_alloc() and video_device_release()
Date: Sat, 20 May 2017 23:58:48 +0300
Message-ID: <4954058.rm2Lj8L8cO@avalon>
In-Reply-To: <20170520182741.GA15392@bigcity.dyn.berto.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <2171480.vKAhxxIE6q@avalon> <20170520182741.GA15392@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Saturday 20 May 2017 20:27:41 Niklas S=F6derlund wrote:
> On 2017-05-10 16:36:03 +0300, Laurent Pinchart wrote:
> > On Tuesday 14 Mar 2017 19:59:55 Niklas S=F6derlund wrote:
> >> Make use of the helper functions video_device_alloc() and
> >> video_device_release() to control the lifetime of the struct
> >> video_device.
> >=20
> > It's nice to see you considering lifetime management issues, but th=
is
> > isn't enough. The rvin_release() function accesses the rvin_dev str=
ucture,
> > so you need to keep this around until all references to the video d=
evice
> > have been dropped. This patch won't do so.
>=20
> I see your point, and it's a good catch I missed!
>=20
> > I would instead keep the video_device instance embedded in rvin_dev=
, and
> > implement a custom release handler that will kfree() the rvin_dev
> > instance. You will obviously need to replace devm_kzalloc() with kz=
alloc()
> > to allocate the rvin_dev.
>=20
> Would it not be simpler to remove the usage of the video device from
> rvin_release()? When I check the code the only usage of vin->vdev in
> paths from the rvin_release() is in relation to pm_runtime_* calls li=
ke:
>=20
> pm_runtime_suspend(&vin->vdev->dev);
> pm_runtime_disable(&vin->vdev->dev);
>=20
> And those can just as easily (and probably should) be called like:
>=20
> pm_runtime_suspend(&vin->dev);
> pm_runtime_disable(&vin->dev);
>=20
> I had plan to fix the usage of the PM calls at a later time when also=

> addressing suspend/resume for this driver, but cleaning up the PM cal=
ls
> can just as easily be done now.

You would still access the vin structure, so you need to refcount that =
one=20
anyway. Refcounting of video_device then comes for free if you embed it=
 in the=20
vin structure. It's actually simpler to embed the video_device instance=
 than=20
managing its lifetime separately.

> I think it's better to use the helper functions to manage the video
> device if its possible, do you agree with this?

Only when it makes sense :-) The video_device_release_empty() and=20
video_device_release() functions were bad idea, they completely circumv=
ent=20
lifetime management. We need to go in the other direction in the V4L2 c=
ore.

> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 44 ++++++++++++----=
------
> >>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 +-
> >>  2 files changed, 25 insertions(+), 21 deletions(-)


--=20
Regards,

Laurent Pinchart
