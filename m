Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36819
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754466AbdHVBNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 21:13:14 -0400
Date: Mon, 21 Aug 2017 22:13:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/2] docs-rst: media: Document s_stream() video op
 usage for MC enabled devices
Message-ID: <20170821221304.0e99c5c6@vento.lan>
In-Reply-To: <20170822004400.GC14873@bigcity.dyn.berto.se>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
        <1502886018-31488-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170819073552.08a0ea2b@vento.lan>
        <eb59fda5-ce07-22fa-2973-02fe33efc8d4@linux.intel.com>
        <20170821060844.579521a4@vento.lan>
        <17fc3226-9356-cf96-2857-895f1131b23a@xs4all.nl>
        <20170821090650.506f91b6@silica>
        <a6b68018-15fe-3241-e488-61f41f40b91d@xs4all.nl>
        <20170821110100.241c0adf@vela.lan>
        <20170822004400.GC14873@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Aug 2017 02:44:00 +0200
Niklas Söderlund <niklas.soderlund@ragnatech.se> escreveu:

> On 2017-08-21 11:01:00 -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 21 Aug 2017 15:52:17 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> > > On 08/21/2017 02:07 PM, Mauro Carvalho Chehab wrote:
> > > > Em Mon, 21 Aug 2017 12:14:18 +0200
> > > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > >   
> > > >> On 08/21/2017 11:08 AM, Mauro Carvalho Chehab wrote:  
> > > >>> Em Mon, 21 Aug 2017 09:36:49 +0300
> > > >>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > >>>     
> > > >>>> Hi Mauro,
> > > >>>>
> > > >>>> Mauro Carvalho Chehab wrote:    
> > > >>>>> Hi Sakari,
> > > >>>>>
> > > >>>>> Em Wed, 16 Aug 2017 15:20:17 +0300
> > > >>>>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > >>>>>      
> > > >>>>>> As we begin to add support for systems with Media controller pipelines
> > > >>>>>> controlled by more than one device driver, it is essential that we
> > > >>>>>> precisely define the responsibilities of each component in the stream
> > > >>>>>> control and common practices.
> > > >>>>>>
> > > >>>>>> Specifically, streaming control is done per sub-device and sub-device
> > > >>>>>> drivers themselves are responsible for streaming setup in upstream
> > > >>>>>> sub-devices.      
> > > >>>>>
> > > >>>>> IMO, before this patch, we need something like this:
> > > >>>>> 	https://patchwork.linuxtv.org/patch/43325/      
> > > >>>>
> > > >>>> Thanks. I'll reply separately to that thread.
> > > >>>>    
> > > >>>>>      
> > > >>>>>>
> > > >>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > >>>>>> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > >>>>>> ---
> > > >>>>>>  Documentation/media/kapi/v4l2-subdev.rst | 29 +++++++++++++++++++++++++++++
> > > >>>>>>  1 file changed, 29 insertions(+)
> > > >>>>>>
> > > >>>>>> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
> > > >>>>>> index e1f0b72..45088ad 100644
> > > >>>>>> --- a/Documentation/media/kapi/v4l2-subdev.rst
> > > >>>>>> +++ b/Documentation/media/kapi/v4l2-subdev.rst
> > > >>>>>> @@ -262,6 +262,35 @@ is called. After all subdevices have been located the .complete() callback is
> > > >>>>>>  called. When a subdevice is removed from the system the .unbind() method is
> > > >>>>>>  called. All three callbacks are optional.
> > > >>>>>>
> > > >>>>>> +Streaming control on Media controller enabled devices
> > > >>>>>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > >>>>>> +
> > > >>>>>> +Starting and stopping the stream are somewhat complex operations that
> > > >>>>>> +often require walking the media graph to enable streaming on
> > > >>>>>> +sub-devices which the pipeline consists of. This involves interaction
> > > >>>>>> +between multiple drivers, sometimes more than two.      
> > > >>>>>
> > > >>>>> That's still not ok, as it creates a black hole for devnode-based
> > > >>>>> devices.
> > > >>>>>
> > > >>>>> I would change it to something like:
> > > >>>>>
> > > >>>>> 	Streaming control
> > > >>>>> 	^^^^^^^^^^^^^^^^^
> > > >>>>>
> > > >>>>> 	Starting and stopping the stream are somewhat complex operations that
> > > >>>>> 	often require to enable streaming on sub-devices which the pipeline
> > > >>>>> 	consists of. This involves interaction between multiple drivers, sometimes
> > > >>>>> 	more than two.
> > > >>>>>
> > > >>>>> 	The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
> > > >>>>> 	for starting and stopping the stream on the sub-device it is called
> > > >>>>> 	on.
> > > >>>>>
> > > >>>>> 	Streaming control on devnode-centric devices
> > > >>>>> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >>>>>
> > > >>>>> 	On **devnode-centric** devices, the main driver is responsible enable
> > > >>>>> 	stream all all sub-devices. On most cases, all the main driver need
> > > >>>>> 	to do is to broadcast s_stream to all connected sub-devices by calling
> > > >>>>> 	:c:func:`v4l2_device_call_all`, e. g.::
> > > >>>>>
> > > >>>>> 		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);      
> > > >>>>
> > > >>>> Looks good to me.
> > > >>>>    
> > > >>>>>
> > > >>>>> 	Streaming control on mc-centric devices
> > > >>>>> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >>>>>
> > > >>>>> 	On **mc-centric** devices, it usually requires walking the media graph
> > > >>>>> 	to enable streaming only at the sub-devices which the pipeline consists
> > > >>>>> 	of.
> > > >>>>>
> > > >>>>> 	(place here the details for such scenario)      
> > > >>>>
> > > >>>> This part requires a more detailed description of the problem area. What 
> > > >>>> makes a difference here is that there's a pipeline this pipeline may be 
> > > >>>> controlled more than one driver. (More elaborate discussion below.)
> > > >>>>    
> > > >>>>>      
> > > >>>>>> +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
> > > >>>>>> +for starting and stopping the stream on the sub-device it is called
> > > >>>>>> +on. A device driver is only responsible for calling the ``.s_stream()`` ops
> > > >>>>>> +of the adjacent sub-devices that are connected to its sink pads
> > > >>>>>> +through an enabled link. A driver may not call ``.s_stream()`` op
> > > >>>>>> +of any other sub-device further up in the pipeline, for instance.
> > > >>>>>> +
> > > >>>>>> +This means that a sub-device driver is thus in direct control of
> > > >>>>>> +whether the upstream sub-devices start (or stop) streaming before or
> > > >>>>>> +after the sub-device itself is set up for streaming.
> > > >>>>>> +
> > > >>>>>> +.. note::
> > > >>>>>> +
> > > >>>>>> +   As the ``.s_stream()`` callback is called recursively through the
> > > >>>>>> +   sub-devices along the pipeline, it is important to keep the
> > > >>>>>> +   recursion as short as possible. To this end, drivers are encouraged
> > > >>>>>> +   to avoid recursively calling ``.s_stream()`` internally to reduce
> > > >>>>>> +   stack usage. Instead, the ``.s_stream()`` op of the directly
> > > >>>>>> +   connected sub-devices should come from the callback through which
> > > >>>>>> +   the driver was first called.
> > > >>>>>> +      
> > > >>>>>
> > > >>>>> That sounds too complex, and can lead into troubles, if the same
> > > >>>>> sub-device driver is used on completely different devices.
> > > >>>>>
> > > >>>>> IMHO, it should be up to the main driver to navigate at the MC
> > > >>>>> pipeline and call s_stream(), and not to the sub-drivers.      
> > > >>>>
> > > >>>> I would agree with the above statement *if* we had no devices that 
> > > >>>> require doing this in a different way.
> > > >>>>
> > > >>>> Consider the following case:
> > > >>>>
> > > >>>> 	sensor   -> CSI-2 receiver -> ISP (DMA)
> > > >>>> 	subdev A -> subdev B	   -> video node    
> > > >>>
> > > >>> Let me be clearer about the issue I see.
> > > >>>
> > > >>> In the above example, what subdevs are supposed to multicast the
> > > >>> s_stream() to their neighbors, and how they will know that they
> > > >>> need to multicast it.
> > > >>>
> > > >>> Let's say, that, in the first pipeline, it would be the sensor
> > > >>> and subdev A. How "sensor" and "subdev A" will know that they're
> > > >>> meant to broadcast s_stream(), and the other entities know they
> > > >>> won't?    
> > > >>
> > > >> So my understanding is that the bridge driver (ISP) will call s_stream
> > > >> for the CSI-2 receiver, and that in turn calls s_stream of the sensor.  
> > > > 
> > > > Alternatively, the ISP driver could call s_stream for both CSI-2 and
> > > > sensor.
> > > >   
> > > >> This should only be done for mc-centric devices, so we need a clear
> > > >> property telling a subdev whether it is part of an mc-centric pipeline
> > > >> or a devnode-centric pipeline. Since in the latter case it should not
> > > >> call s_stream in this way. For devnode-centric pipelines the bridge
> > > >> driver broadcasts s_stream to all subdevs.  
> > > > 
> > > > It would be easier to have a logic called by the ISP driver that would
> > > > get all elements from an active pipeline and call s_stream() there.
> > > > 
> > > > That would keep the flexibility that would be needed by devices with a
> > > > separate CSI-2 receiver, while preventing the addition of an extra
> > > > logic on every sub-device to teach them that s_stream() should be
> > > > called to communicate with some specific sub-device.
> > > > 
> > > > The thing is that, if you have a pipeline like:
> > > > 
> > > > source subdev -> subdev A -> subdev B -> subdev C -> subdev D -> DMA
> > > > 
> > > > due to PM constraints, all subdevs on such pipeline may require s_stream()
> > > > to control its power consumption. So, it is not just a CSI-2 device that
> > > > would need to enable power at the sensor, but an entire pipeline that
> > > > would need to receive s_stream() calls.  
> > > 
> > > So? If DMA calls s_stream for subdev D, which calls s_stream for subdev C, etc.
> > > until the source subdev's s_stream is called, then they are all powered up,
> > > aren't they?
> > > 
> > > I don't see the difference between this and the DMA calling s_stream for all
> > > subdevs.
> > > 
> > > One clear difference is (as Sakari mentioned) stack usage. There having the
> > > DMA call s_stream is clearly better. See below for more comments...
> > 
> > That's not the only difference. If we pass this to subdevs, they
> > need to know that they're working on a mc-centric way.
> 
> Another difference is that in a mc-centric driver more information might 
> be needed in the s_stream call then currently is available and would be 
> harder to do if the DMA driver calls s_stream on all subdevices. One 
> example of this is in the patch series '[PATCH 00/20] Add multiplexed 
> media pads to support CSI-2 virtual channels' which tries to add 
> multiplexed pads which can contain more then one stream.

I'll try to take a look on such patch series later this week.

> 
> In that series the s_stream() operation is extended to carry information 
> about both which pad and which stream the s_stream() operation intends 
> to start.

If you change it, it won't likely work anymore for existing devices, as, 
on all currently implemented usecases, s_stream() doesn't care about pads. 
The hole idea behind the original implementations for s_stream() is to
actually power on the device as a hole.

Also, I can't see how this would work on broadcast mode[1].

[1] On devnode-centric devices, s_stream() is just broadcasted to all
audio and video devices, in order to wake them up.

Btw, devnode-centric may even be compiled with MC disabled - so, there
won't be a MC graph with pads information.

So, it sounds that we'll need to have a different callback instead of
changing s_stream() - something like s_stream_subdev() or s_stream_pad().

> Then each subdevice is responsible to call s_stream() on it's 
> neighbor providing which pad and stream of the remote it wants to start 
> based on which of its own pads and possibly stream s_stream() as called 
> up on itself. This propagation by each subdevice then becomes much more 
> useful as it's only the subdevice itself that knows about the internal 
> subdevice routing from its sink to source pad(s). Maybe this can also be 
> covered by some generic v4l2 helper to start the stream, but it feels 
> like such implementations could become complex.

Even with a new callback, recursion can be very bad. The pipeline might
have a loop. Even if it doesn't, some protection may be needed to avoid
too long pipelines that could cause stack overflow.

Thanks,
Mauro
