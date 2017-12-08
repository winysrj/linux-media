Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51582 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbdLHTIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 14:08:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 03/28] rcar-vin: unregister video device on driver removal
Date: Fri, 08 Dec 2017 21:07:59 +0200
Message-ID: <7105914.vch11FvaiR@avalon>
In-Reply-To: <20171208130921.GN31989@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <1762416.X4GW5MWmCZ@avalon> <20171208130921.GN31989@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 8 December 2017 15:09:21 EET Niklas S=F6derlund wrote:
> On 2017-12-08 09:54:31 +0200, Laurent Pinchart wrote:
> > On Friday, 8 December 2017 03:08:17 EET Niklas S=F6derlund wrote:
> >> If the video device was registered by the complete() callback it should
> >> be unregistered when the driver is removed.
> >=20
> > The .remove() operation indicates device removal, not driver removal (o=
r,
> > the be more precise, it indicates that the device is unbound from the
> > driver). I'd update the commit message accordingly.
>=20
> I'm not sure I fully understand this comment.
>=20
> My take is that .remove() indicates that the device is removed and not
> the driver itself, as the driver might be used by multiple devices and
> the .remove() function is therefor not an indication that the driver is
> being unloaded.
>=20
> So if I understood you correctly the following would be a better to go
> in the commit message:
>=20
> "If the video device was registered by the complete() callback it should
> be unregistered when a device is unbound from the driver."

Perfect :-)

> >> Protect from printing an uninitialized video device node name by adding
> >> a check in rvin_v4l2_unregister() to identify that the video device is
> >> registered.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
> >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
> >>  2 files changed, 5 insertions(+)
> >>=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> >> b/drivers/media/platform/rcar-vin/rcar-core.c index
> >> f7a4c21909da6923..6d99542ec74b49a7 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> >> @@ -272,6 +272,8 @@ static int rcar_vin_remove(struct platform_device
> >> *pdev)> >=20
> >>  	pm_runtime_disable(&pdev->dev);
> >>=20
> >> +	rvin_v4l2_unregister(vin);
> >=20
> > Unless I'm mistaken, you're unregistering the video device both here and
> > in the unbound() function. That's messy, but it's not really your fault,
> > the V4L2 core is very messy in the first place, and registering video
> > devices in the complete() handler is a bad idea. As that can't be fixed
> > for now,
> >=20
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> Big thanks for this :-)
>=20
> > Hans, I still would like to hear your opinion on how this should be
> > solved.
> > You've voiced a few weeks ago that register video devices at probe() ti=
me
> > isn't a good idea but you've never explained how we should fix the
> > problem. I still firmly believe that video devices should be registered
> > at probe time, and we need to reach an agreement on a technical solution
> > to this problem.
> >=20
> >>  	v4l2_async_notifier_unregister(&vin->notifier);
> >>  	v4l2_async_notifier_cleanup(&vin->notifier);
> >>=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> >> 178aecc94962abe2..32a658214f48fa49 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> @@ -841,6 +841,9 @@ static const struct v4l2_file_operations rvin_fops=
 =3D
> >> {
> >>=20
> >>  void rvin_v4l2_unregister(struct rvin_dev *vin)
> >>  {
> >> +	if (!video_is_registered(&vin->vdev))
> >> +		return;
> >> +
> >>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
> >>  		  video_device_node_name(&vin->vdev));

=2D-=20
Regards,

Laurent Pinchart
