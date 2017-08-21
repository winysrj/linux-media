Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50469 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdHUMHX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 08:07:23 -0400
Date: Mon, 21 Aug 2017 09:07:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>
Subject: Re: [PATCH v2 1/2] docs-rst: media: Document s_stream() video op
 usage for MC enabled devices
Message-ID: <20170821090650.506f91b6@silica>
In-Reply-To: <17fc3226-9356-cf96-2857-895f1131b23a@xs4all.nl>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
        <1502886018-31488-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170819073552.08a0ea2b@vento.lan>
        <eb59fda5-ce07-22fa-2973-02fe33efc8d4@linux.intel.com>
        <20170821060844.579521a4@vento.lan>
        <17fc3226-9356-cf96-2857-895f1131b23a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Aug 2017 12:14:18 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/21/2017 11:08 AM, Mauro Carvalho Chehab wrote:
> > Em Mon, 21 Aug 2017 09:36:49 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >  =20
> >> Hi Mauro,
> >>
> >> Mauro Carvalho Chehab wrote: =20
> >>> Hi Sakari,
> >>>
> >>> Em Wed, 16 Aug 2017 15:20:17 +0300
> >>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >>>   =20
> >>>> As we begin to add support for systems with Media controller pipelin=
es
> >>>> controlled by more than one device driver, it is essential that we
> >>>> precisely define the responsibilities of each component in the stream
> >>>> control and common practices.
> >>>>
> >>>> Specifically, streaming control is done per sub-device and sub-device
> >>>> drivers themselves are responsible for streaming setup in upstream
> >>>> sub-devices.   =20
> >>>
> >>> IMO, before this patch, we need something like this:
> >>> 	https://patchwork.linuxtv.org/patch/43325/   =20
> >>
> >> Thanks. I'll reply separately to that thread.
> >> =20
> >>>   =20
> >>>>
> >>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>> Acked-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >>>> ---
> >>>>  Documentation/media/kapi/v4l2-subdev.rst | 29 +++++++++++++++++++++=
++++++++
> >>>>  1 file changed, 29 insertions(+)
> >>>>
> >>>> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentatio=
n/media/kapi/v4l2-subdev.rst
> >>>> index e1f0b72..45088ad 100644
> >>>> --- a/Documentation/media/kapi/v4l2-subdev.rst
> >>>> +++ b/Documentation/media/kapi/v4l2-subdev.rst
> >>>> @@ -262,6 +262,35 @@ is called. After all subdevices have been locat=
ed the .complete() callback is
> >>>>  called. When a subdevice is removed from the system the .unbind() m=
ethod is
> >>>>  called. All three callbacks are optional.
> >>>>
> >>>> +Streaming control on Media controller enabled devices
> >>>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>>> +
> >>>> +Starting and stopping the stream are somewhat complex operations th=
at
> >>>> +often require walking the media graph to enable streaming on
> >>>> +sub-devices which the pipeline consists of. This involves interacti=
on
> >>>> +between multiple drivers, sometimes more than two.   =20
> >>>
> >>> That's still not ok, as it creates a black hole for devnode-based
> >>> devices.
> >>>
> >>> I would change it to something like:
> >>>
> >>> 	Streaming control
> >>> 	^^^^^^^^^^^^^^^^^
> >>>
> >>> 	Starting and stopping the stream are somewhat complex operations that
> >>> 	often require to enable streaming on sub-devices which the pipeline
> >>> 	consists of. This involves interaction between multiple drivers, som=
etimes
> >>> 	more than two.
> >>>
> >>> 	The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is respons=
ible
> >>> 	for starting and stopping the stream on the sub-device it is called
> >>> 	on.
> >>>
> >>> 	Streaming control on devnode-centric devices
> >>> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>>
> >>> 	On **devnode-centric** devices, the main driver is responsible enable
> >>> 	stream all all sub-devices. On most cases, all the main driver need
> >>> 	to do is to broadcast s_stream to all connected sub-devices by calli=
ng
> >>> 	:c:func:`v4l2_device_call_all`, e. g.::
> >>>
> >>> 		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);   =20
> >>
> >> Looks good to me.
> >> =20
> >>>
> >>> 	Streaming control on mc-centric devices
> >>> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>>
> >>> 	On **mc-centric** devices, it usually requires walking the media gra=
ph
> >>> 	to enable streaming only at the sub-devices which the pipeline consi=
sts
> >>> 	of.
> >>>
> >>> 	(place here the details for such scenario)   =20
> >>
> >> This part requires a more detailed description of the problem area. Wh=
at=20
> >> makes a difference here is that there's a pipeline this pipeline may b=
e=20
> >> controlled more than one driver. (More elaborate discussion below.)
> >> =20
> >>>   =20
> >>>> +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is respon=
sible
> >>>> +for starting and stopping the stream on the sub-device it is called
> >>>> +on. A device driver is only responsible for calling the ``.s_stream=
()`` ops
> >>>> +of the adjacent sub-devices that are connected to its sink pads
> >>>> +through an enabled link. A driver may not call ``.s_stream()`` op
> >>>> +of any other sub-device further up in the pipeline, for instance.
> >>>> +
> >>>> +This means that a sub-device driver is thus in direct control of
> >>>> +whether the upstream sub-devices start (or stop) streaming before or
> >>>> +after the sub-device itself is set up for streaming.
> >>>> +
> >>>> +.. note::
> >>>> +
> >>>> +   As the ``.s_stream()`` callback is called recursively through the
> >>>> +   sub-devices along the pipeline, it is important to keep the
> >>>> +   recursion as short as possible. To this end, drivers are encoura=
ged
> >>>> +   to avoid recursively calling ``.s_stream()`` internally to reduce
> >>>> +   stack usage. Instead, the ``.s_stream()`` op of the directly
> >>>> +   connected sub-devices should come from the callback through which
> >>>> +   the driver was first called.
> >>>> +   =20
> >>>
> >>> That sounds too complex, and can lead into troubles, if the same
> >>> sub-device driver is used on completely different devices.
> >>>
> >>> IMHO, it should be up to the main driver to navigate at the MC
> >>> pipeline and call s_stream(), and not to the sub-drivers.   =20
> >>
> >> I would agree with the above statement *if* we had no devices that=20
> >> require doing this in a different way.
> >>
> >> Consider the following case:
> >>
> >> 	sensor   -> CSI-2 receiver -> ISP (DMA)
> >> 	subdev A -> subdev B	   -> video node =20
> >=20
> > Let me be clearer about the issue I see.
> >=20
> > In the above example, what subdevs are supposed to multicast the
> > s_stream() to their neighbors, and how they will know that they
> > need to multicast it.
> >=20
> > Let's say, that, in the first pipeline, it would be the sensor
> > and subdev A. How "sensor" and "subdev A" will know that they're
> > meant to broadcast s_stream(), and the other entities know they
> > won't? =20
>=20
> So my understanding is that the bridge driver (ISP) will call s_stream
> for the CSI-2 receiver, and that in turn calls s_stream of the sensor.

Alternatively, the ISP driver could call s_stream for both CSI-2 and
sensor.

> This should only be done for mc-centric devices, so we need a clear
> property telling a subdev whether it is part of an mc-centric pipeline
> or a devnode-centric pipeline. Since in the latter case it should not
> call s_stream in this way. For devnode-centric pipelines the bridge
> driver broadcasts s_stream to all subdevs.

It would be easier to have a logic called by the ISP driver that would
get all elements from an active pipeline and call s_stream() there.

That would keep the flexibility that would be needed by devices with a
separate CSI-2 receiver, while preventing the addition of an extra
logic on every sub-device to teach them that s_stream() should be
called to communicate with some specific sub-device.

The thing is that, if you have a pipeline like:

source subdev -> subdev A -> subdev B -> subdev C -> subdev D -> DMA

due to PM constraints, all subdevs on such pipeline may require s_stream()
to control its power consumption. So, it is not just a CSI-2 device that
would need to enable power at the sensor, but an entire pipeline that
would need to receive s_stream() calls.

IMO, the best would be a logic similar to media_entity_pipeline_start() tha=
t,
for each entity at the pipeline, s_stream() would be called, e. g. something
like:

	v4l2_subdev_pipeline_call()

> For the record, I am not aware of any subdevs that are used by both
> mc and devnode-centric scenarios AND that can sit in the middle of a
> pipeline. Sensors/video receiver subdevs can certainly be used in both
> scenarios, but they don't have to propagate a s_stream call.

em28xx has a bunch of sensors that are also used on embedded drivers.
It also has a tvp5150, with is also used by omap3.

On the only OMAP3 board whose has a DT upstream, the tvp5150 has both source
pads connected to S-Video connectors, but nothing prevents that someone
would add a tuner before it. I remember someone mentioned that such device
exists (although its DT is not upstream).

On an embedded device with both tvp5150 and a tuner, s_stream() should be
called by both.

>=20
> It would be very helpful if we have a good description of these two
> scenarios in our documentation, and a capability indicating mc-centric
> behavior for devnodes. And also for v4l2-subdevs internally (i.e.
> am I used in a mc-centric scenario or not?).
>=20
> Then this documentation will start to make more sense as well.
>=20
> > Also, the same sensor may be used on a device whose CSI-2 is
> > integrated at the ISP driver (the main driver). That's why
> > I think that such logic should be started by the main driver, as
> > it is the only part of the pipeline that it is aware about
> > what it is needed. Also, as the DMA engines are controlled by
> > the main driver (via its associated video devnodes), it is the only
> > part of the pipeline that knows when a stream starts. =20
>=20
> Yes, and this driver is the one that calls s_stream on the
> adjacent subdevs. But just those and not all.
>=20
> >  =20
> >> Assume that the CSI-2 receiver requires hardware setup both *before an=
d=20
> >> after* streaming has been enabled on the sensor. =20
> >=20
> > calling s_stream() before and after seems to be an abuse of it. =20
>=20
> I think you misunderstand what Sakari tries to say.
>=20
> In the scenario above the bridge driver calls s_stream for the
> CSI receiver. That in turn has code like this:
>=20
> s_stream(bool enable)
> {
> 	... initialize CSI ...
> 	if error initializing CSI
> 		return error
> 	call s_stream for adjacent source subdev (i.e. sensor)
> 	if success
> 		return 0
> 	... de-initialize CSI
> 	return error
> }
>=20
> This makes a lot of sense for mc-centric devices and is also much more
> precise than the broadcast that a devnode-centric device would do.
>=20
> In the very unlikely case that this CSI subdev would also be used in
> a devnode-centric scenario the s_stream implementation would just
> return 0 after it initializes the CSI hardware. It will depend on
> the hardware whether that works or not.
>=20
> subdevs used in devnode-centric scenarios tend to be pretty simple
> and are able to handle this.

If I understand well, you're basically concerned about error handling, righ=
t?

That could easily be handled with something like:

	ret =3D v4l2_subdev_pipeline_call(source_entity, video, s_stream, 1);
	if (ret < 0) {
		v4l2_subdev_pipeline_call(source_entity, video, s_stream, 0);
		return ret;
	}


>=20
> Regards,
>=20
> 	Hans
>=20
> >=20
> > This callback is meant to be called just once, and there's no
> > requirement if it should be called before or after: both should
> > work.
> >  =20
> >>
> >> In previous cases the CSI-2 receiver and the ISP have been part of the=
=20
> >> same device. This is not universally the case anymore. You'll also get=
=20
> >> the same when you add adv748x to the pipeline, and the upstream device=
=20
> >> in the pipeline before the adv748x is represented as a sub-device (and=
=20
> >> is thus controlled by its sub-device driver).
> >>
> >> This is addressable by moving the control of the upstream sub-device  =
=20
> >=20
> > what is the "upstream sub-device"? This term is new for me.
> >  =20
> >> streaming state to the driver which is next to it, and what the patch=
=20
> >> also documents. Note that there is no difference if you have a=20
> >> sub-device without sink pads (or in general case, a sub-device that on=
ly=20
> >> has one kind of pads). =20
> >=20
> >  =20
> >> What comes to compatibility between MC-centric and devnode-centric=20
> >> drivers --- on an MC-centric device you have a pipeline and you=20
> >> typically have multiple pads on the sub-devices along the pipeline.=20
> >> Drivers that are devnode-centric generally aren't aware of pads, and s=
o=20
> >> cannot configure sub-devices with multiple pads to begin with.
> >>
> >> You could do that in principle, but you'll start running into the same=
=20
> >> problems which were addressed by introducing the Media controller inte=
rface. =20
> >=20
> > I'm not concerned about compatibility. Yet, the same sub-device may
> > be there on a pipeline that it is mc-centric or devnode-centric.
> >=20
> > I'm mainly concerned with introducing hacks on some entities due to some
> > specific arrangements between them that are required for an specific=20
> > board layout to work.
> >  =20
> >> Note that this is not a commonplace. The difference will be only be=20
> >> there *if and only if* you have a sub-device with sink pads in a=20
> >> pipeline. There are not many of those, and that difference is not=20
> >> introduced by this patch: it is a property of hardware. =20
> >=20
> > What do you mean? most pipelines have sub-devices with sink pads.
> >  =20
> >>
> >> I'm definitely open to improving the wording as well as other solution=
s=20
> >> that can address this.
> >>
> >> Cc Niklas.
> >> =20
> >=20
> >=20
> >=20
> > Thanks,
> > Mauro
> >  =20
>=20
