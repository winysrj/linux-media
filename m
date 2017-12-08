Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47151 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbdLHItD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 03:49:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 03/28] rcar-vin: unregister video device on driver removal
Date: Fri, 08 Dec 2017 10:49:21 +0200
Message-ID: <54029260.JIJzBDirQh@avalon>
In-Reply-To: <8e7dc5cf-06ef-8bc8-a767-6b5ac46a5876@xs4all.nl>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <1762416.X4GW5MWmCZ@avalon> <8e7dc5cf-06ef-8bc8-a767-6b5ac46a5876@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday, 8 December 2017 10:46:34 EET Hans Verkuil wrote:
> On 12/08/2017 08:54 AM, Laurent Pinchart wrote:
> > On Friday, 8 December 2017 03:08:17 EET Niklas S=F6derlund wrote:
> >> If the video device was registered by the complete() callback it should
> >> be unregistered when the driver is removed.
> >=20
> > The .remove() operation indicates device removal, not driver removal (o=
r,
> > the be more precise, it indicates that the device is unbound from the
> > driver). I'd update the commit message accordingly.
> >=20
> >> Protect from printing an uninitialized video device node name by addin=
g a
> >> check in rvin_v4l2_unregister() to identify that the video device is
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
> >> *pdev)>>=20
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
> >=20
> > Hans, I still would like to hear your opinion on how this should be
> > solved. You've voiced a few weeks ago that register video devices at
> > probe() time isn't a good idea but you've never explained how we should
> > fix the problem. I still firmly believe that video devices should be
> > registered at probe time, and we need to reach an agreement on a techni=
cal
> > solution to this problem.
>=20
> I have tentatively planned to look into this next week. What will very
> likely have to happen is that we need to split off allocation from the
> registration, just as is done in most other subsystems. Allocation can be
> done at probe time, but the final registration step should likely be in t=
he
> complete().
>=20
> To what extent that will resolve this specific issue I don't know. It will
> take me time to understand this in more detail.

I believe that splitting initialization from registration is a good idea, b=
ut=20
I still believe that video nodes should be registered at probe time=20
nonetheless. Let's discuss it again after next week when you'll have had ti=
me=20
to think about it.

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
> >>=20
> >>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
> >>  		  video_device_node_name(&vin->vdev));

=2D-=20
Regards,

Laurent Pinchart
