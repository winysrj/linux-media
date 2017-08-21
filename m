Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbdHUOBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 10:01:24 -0400
Date: Mon, 21 Aug 2017 11:01:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>
Subject: Re: [PATCH v2 1/2] docs-rst: media: Document s_stream() video op
 usage for MC enabled devices
Message-ID: <20170821110100.241c0adf@vela.lan>
In-Reply-To: <a6b68018-15fe-3241-e488-61f41f40b91d@xs4all.nl>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
        <1502886018-31488-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170819073552.08a0ea2b@vento.lan>
        <eb59fda5-ce07-22fa-2973-02fe33efc8d4@linux.intel.com>
        <20170821060844.579521a4@vento.lan>
        <17fc3226-9356-cf96-2857-895f1131b23a@xs4all.nl>
        <20170821090650.506f91b6@silica>
        <a6b68018-15fe-3241-e488-61f41f40b91d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Aug 2017 15:52:17 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/21/2017 02:07 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 21 Aug 2017 12:14:18 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >  =20
> >> On 08/21/2017 11:08 AM, Mauro Carvalho Chehab wrote: =20
> >>> Em Mon, 21 Aug 2017 09:36:49 +0300
> >>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >>>    =20
> >>>> Hi Mauro,
> >>>>
> >>>> Mauro Carvalho Chehab wrote:   =20
> >>>>> Hi Sakari,
> >>>>>
> >>>>> Em Wed, 16 Aug 2017 15:20:17 +0300
> >>>>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >>>>>     =20
> >>>>>> As we begin to add support for systems with Media controller pipel=
ines
> >>>>>> controlled by more than one device driver, it is essential that we
> >>>>>> precisely define the responsibilities of each component in the str=
eam
> >>>>>> control and common practices.
> >>>>>>
> >>>>>> Specifically, streaming control is done per sub-device and sub-dev=
ice
> >>>>>> drivers themselves are responsible for streaming setup in upstream
> >>>>>> sub-devices.     =20
> >>>>>
> >>>>> IMO, before this patch, we need something like this:
> >>>>> 	https://patchwork.linuxtv.org/patch/43325/     =20
> >>>>
> >>>> Thanks. I'll reply separately to that thread.
> >>>>   =20
> >>>>>     =20
> >>>>>>
> >>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>>>> Acked-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>
> >>>>>> ---
> >>>>>>  Documentation/media/kapi/v4l2-subdev.rst | 29 +++++++++++++++++++=
++++++++++
> >>>>>>  1 file changed, 29 insertions(+)
> >>>>>>
> >>>>>> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentat=
ion/media/kapi/v4l2-subdev.rst
> >>>>>> index e1f0b72..45088ad 100644
> >>>>>> --- a/Documentation/media/kapi/v4l2-subdev.rst
> >>>>>> +++ b/Documentation/media/kapi/v4l2-subdev.rst
> >>>>>> @@ -262,6 +262,35 @@ is called. After all subdevices have been loc=
ated the .complete() callback is
> >>>>>>  called. When a subdevice is removed from the system the .unbind()=
 method is
> >>>>>>  called. All three callbacks are optional.
> >>>>>>
> >>>>>> +Streaming control on Media controller enabled devices
> >>>>>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>>>>> +
> >>>>>> +Starting and stopping the stream are somewhat complex operations =
that
> >>>>>> +often require walking the media graph to enable streaming on
> >>>>>> +sub-devices which the pipeline consists of. This involves interac=
tion
> >>>>>> +between multiple drivers, sometimes more than two.     =20
> >>>>>
> >>>>> That's still not ok, as it creates a black hole for devnode-based
> >>>>> devices.
> >>>>>
> >>>>> I would change it to something like:
> >>>>>
> >>>>> 	Streaming control
> >>>>> 	^^^^^^^^^^^^^^^^^
> >>>>>
> >>>>> 	Starting and stopping the stream are somewhat complex operations t=
hat
> >>>>> 	often require to enable streaming on sub-devices which the pipeline
> >>>>> 	consists of. This involves interaction between multiple drivers, s=
ometimes
> >>>>> 	more than two.
> >>>>>
> >>>>> 	The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is respo=
nsible
> >>>>> 	for starting and stopping the stream on the sub-device it is called
> >>>>> 	on.
> >>>>>
> >>>>> 	Streaming control on devnode-centric devices
> >>>>> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>>>>
> >>>>> 	On **devnode-centric** devices, the main driver is responsible ena=
ble
> >>>>> 	stream all all sub-devices. On most cases, all the main driver need
> >>>>> 	to do is to broadcast s_stream to all connected sub-devices by cal=
ling
> >>>>> 	:c:func:`v4l2_device_call_all`, e. g.::
> >>>>>
> >>>>> 		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);     =
=20
> >>>>
> >>>> Looks good to me.
> >>>>   =20
> >>>>>
> >>>>> 	Streaming control on mc-centric devices
> >>>>> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>>>>
> >>>>> 	On **mc-centric** devices, it usually requires walking the media g=
raph
> >>>>> 	to enable streaming only at the sub-devices which the pipeline con=
sists
> >>>>> 	of.
> >>>>>
> >>>>> 	(place here the details for such scenario)     =20
> >>>>
> >>>> This part requires a more detailed description of the problem area. =
What=20
> >>>> makes a difference here is that there's a pipeline this pipeline may=
 be=20
> >>>> controlled more than one driver. (More elaborate discussion below.)
> >>>>   =20
> >>>>>     =20
> >>>>>> +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is resp=
onsible
> >>>>>> +for starting and stopping the stream on the sub-device it is call=
ed
> >>>>>> +on. A device driver is only responsible for calling the ``.s_stre=
am()`` ops
> >>>>>> +of the adjacent sub-devices that are connected to its sink pads
> >>>>>> +through an enabled link. A driver may not call ``.s_stream()`` op
> >>>>>> +of any other sub-device further up in the pipeline, for instance.
> >>>>>> +
> >>>>>> +This means that a sub-device driver is thus in direct control of
> >>>>>> +whether the upstream sub-devices start (or stop) streaming before=
 or
> >>>>>> +after the sub-device itself is set up for streaming.
> >>>>>> +
> >>>>>> +.. note::
> >>>>>> +
> >>>>>> +   As the ``.s_stream()`` callback is called recursively through =
the
> >>>>>> +   sub-devices along the pipeline, it is important to keep the
> >>>>>> +   recursion as short as possible. To this end, drivers are encou=
raged
> >>>>>> +   to avoid recursively calling ``.s_stream()`` internally to red=
uce
> >>>>>> +   stack usage. Instead, the ``.s_stream()`` op of the directly
> >>>>>> +   connected sub-devices should come from the callback through wh=
ich
> >>>>>> +   the driver was first called.
> >>>>>> +     =20
> >>>>>
> >>>>> That sounds too complex, and can lead into troubles, if the same
> >>>>> sub-device driver is used on completely different devices.
> >>>>>
> >>>>> IMHO, it should be up to the main driver to navigate at the MC
> >>>>> pipeline and call s_stream(), and not to the sub-drivers.     =20
> >>>>
> >>>> I would agree with the above statement *if* we had no devices that=20
> >>>> require doing this in a different way.
> >>>>
> >>>> Consider the following case:
> >>>>
> >>>> 	sensor   -> CSI-2 receiver -> ISP (DMA)
> >>>> 	subdev A -> subdev B	   -> video node   =20
> >>>
> >>> Let me be clearer about the issue I see.
> >>>
> >>> In the above example, what subdevs are supposed to multicast the
> >>> s_stream() to their neighbors, and how they will know that they
> >>> need to multicast it.
> >>>
> >>> Let's say, that, in the first pipeline, it would be the sensor
> >>> and subdev A. How "sensor" and "subdev A" will know that they're
> >>> meant to broadcast s_stream(), and the other entities know they
> >>> won't?   =20
> >>
> >> So my understanding is that the bridge driver (ISP) will call s_stream
> >> for the CSI-2 receiver, and that in turn calls s_stream of the sensor.=
 =20
> >=20
> > Alternatively, the ISP driver could call s_stream for both CSI-2 and
> > sensor.
> >  =20
> >> This should only be done for mc-centric devices, so we need a clear
> >> property telling a subdev whether it is part of an mc-centric pipeline
> >> or a devnode-centric pipeline. Since in the latter case it should not
> >> call s_stream in this way. For devnode-centric pipelines the bridge
> >> driver broadcasts s_stream to all subdevs. =20
> >=20
> > It would be easier to have a logic called by the ISP driver that would
> > get all elements from an active pipeline and call s_stream() there.
> >=20
> > That would keep the flexibility that would be needed by devices with a
> > separate CSI-2 receiver, while preventing the addition of an extra
> > logic on every sub-device to teach them that s_stream() should be
> > called to communicate with some specific sub-device.
> >=20
> > The thing is that, if you have a pipeline like:
> >=20
> > source subdev -> subdev A -> subdev B -> subdev C -> subdev D -> DMA
> >=20
> > due to PM constraints, all subdevs on such pipeline may require s_strea=
m()
> > to control its power consumption. So, it is not just a CSI-2 device that
> > would need to enable power at the sensor, but an entire pipeline that
> > would need to receive s_stream() calls. =20
>=20
> So? If DMA calls s_stream for subdev D, which calls s_stream for subdev C=
, etc.
> until the source subdev's s_stream is called, then they are all powered u=
p,
> aren't they?
>=20
> I don't see the difference between this and the DMA calling s_stream for =
all
> subdevs.
>=20
> One clear difference is (as Sakari mentioned) stack usage. There having t=
he
> DMA call s_stream is clearly better. See below for more comments...

That's not the only difference. If we pass this to subdevs, they
need to know that they're working on a mc-centric way.

There is another problem, with is more serious, and it is somewhat
related to stack usage: what happens if there's a loop inside a
pipeline? That would cause a Kernel crash. I can't see any easy
way to avoid that (nor stack starving, if the pipeline is too big).

>=20
> > IMO, the best would be a logic similar to media_entity_pipeline_start()=
 that,
> > for each entity at the pipeline, s_stream() would be called, e. g. some=
thing
> > like:
> >=20
> > 	v4l2_subdev_pipeline_call()
> >  =20
> >> For the record, I am not aware of any subdevs that are used by both
> >> mc and devnode-centric scenarios AND that can sit in the middle of a
> >> pipeline. Sensors/video receiver subdevs can certainly be used in both
> >> scenarios, but they don't have to propagate a s_stream call. =20
> >=20
> > em28xx has a bunch of sensors that are also used on embedded drivers.
> > It also has a tvp5150, with is also used by omap3.
> >=20
> > On the only OMAP3 board whose has a DT upstream, the tvp5150 has both s=
ource
> > pads connected to S-Video connectors, but nothing prevents that someone
> > would add a tuner before it. I remember someone mentioned that such dev=
ice
> > exists (although its DT is not upstream).
> >=20
> > On an embedded device with both tvp5150 and a tuner, s_stream() should =
be
> > called by both.
> >  =20
> >>
> >> It would be very helpful if we have a good description of these two
> >> scenarios in our documentation, and a capability indicating mc-centric
> >> behavior for devnodes. And also for v4l2-subdevs internally (i.e.
> >> am I used in a mc-centric scenario or not?).
> >>
> >> Then this documentation will start to make more sense as well.
> >> =20
> >>> Also, the same sensor may be used on a device whose CSI-2 is
> >>> integrated at the ISP driver (the main driver). That's why
> >>> I think that such logic should be started by the main driver, as
> >>> it is the only part of the pipeline that it is aware about
> >>> what it is needed. Also, as the DMA engines are controlled by
> >>> the main driver (via its associated video devnodes), it is the only
> >>> part of the pipeline that knows when a stream starts.   =20
> >>
> >> Yes, and this driver is the one that calls s_stream on the
> >> adjacent subdevs. But just those and not all.
> >> =20
> >>>    =20
> >>>> Assume that the CSI-2 receiver requires hardware setup both *before =
and=20
> >>>> after* streaming has been enabled on the sensor.   =20
> >>>
> >>> calling s_stream() before and after seems to be an abuse of it.   =20
> >>
> >> I think you misunderstand what Sakari tries to say.
> >>
> >> In the scenario above the bridge driver calls s_stream for the
> >> CSI receiver. That in turn has code like this:
> >>
> >> s_stream(bool enable)
> >> {
> >> 	... initialize CSI ...
> >> 	if error initializing CSI
> >> 		return error
> >> 	call s_stream for adjacent source subdev (i.e. sensor)
> >> 	if success
> >> 		return 0
> >> 	... de-initialize CSI
> >> 	return error
> >> }
> >>
> >> This makes a lot of sense for mc-centric devices and is also much more
> >> precise than the broadcast that a devnode-centric device would do.
> >>
> >> In the very unlikely case that this CSI subdev would also be used in
> >> a devnode-centric scenario the s_stream implementation would just
> >> return 0 after it initializes the CSI hardware. It will depend on
> >> the hardware whether that works or not.
> >>
> >> subdevs used in devnode-centric scenarios tend to be pretty simple
> >> and are able to handle this. =20
> >=20
> > If I understand well, you're basically concerned about error handling, =
right?
> >=20
> > That could easily be handled with something like:
> >=20
> > 	ret =3D v4l2_subdev_pipeline_call(source_entity, video, s_stream, 1);
> > 	if (ret < 0) {
> > 		v4l2_subdev_pipeline_call(source_entity, video, s_stream, 0);
> > 		return ret;
> > 	} =20
>=20
> That's not it. It is that some subdevs need to execute initialization code
> first before you can call s_stream on the sensor.
>=20
> If you want to use a pipeline_call you would need to introduce stream_pre=
pare
> and stream_unprepare ops to achieve the same (idea stolen from the clk AP=
I).
>=20
> I'm not sure if this would fully resolve Sakari's issue.

If the problem is with initialization, all we need to enforce is
that the graph traversal will happen at the reverse order, e. g.
from subdev D to subdev A.

But yeah, if it is more complex, we may need a stream_prepare ops.

>=20
> Sakari, what is your opinion on having the DMA call a stream_prepare foll=
owed
> by s_stream(1)? It avoids the stack recursion issue, and it allows for HW
> initialization.
>=20
> Regards,
>=20
> 	Hans




Cheers,
Mauro
