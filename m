Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37293 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1HQH5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 03:57:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
Date: Wed, 17 Aug 2011 09:57:15 +0200
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <4E303E5B.9050701@samsung.com> <201108161744.34749.laurent.pinchart@ideasonboard.com> <4E4AF0FC.4070104@redhat.com>
In-Reply-To: <4E4AF0FC.4070104@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108170957.15955.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 17 August 2011 00:36:44 Mauro Carvalho Chehab wrote:
> Em 16-08-2011 08:44, Laurent Pinchart escreveu:
> > On Tuesday 16 August 2011 17:30:47 Mauro Carvalho Chehab wrote:
> >> Em 16-08-2011 01:57, Laurent Pinchart escreveu:
> >>>>> My point is that the ISP driver developer can't know in advance which
> >>>>> sensor will be used systems that don't exist yet.
> >>>> 
> >>>> As far as such hardware is projected, someone will know. It is a
> >>>> simple trivial patch to associate a new hardware with a hardware
> >>>> profile at the platform data.
> >>> 
> >>> Platform data must contain hardware descriptions only, not policies.
> >>> This is even clearer now that ARM is moving away from board code to
> >>> the Device Tree.
> >> 
> >> Again, a cell phone with one frontal camera and one hear camera has two
> >> sensor inputs only. This is not a "policy". It is a hardware constraint.
> >> The driver should allow setting the pipeline for both sensors via
> >> S_INPUT, otherwise a V4L2 only userspace application won't work.
> >> 
> >> It is as simple as that.
> > 
> > When capturing from the main sensor on the OMAP3 ISP you need to capture
> > raw data to memory on a video node, feed it back to the hardware through
> > another video node, and finally capture it on a third video node. A
> > V4L2-only userspace application won't work. That's how the hardware is,
> > we can't do much about that.
> 
> The raw data conversion is one of the functions that libv4l should do. So,
> if you've already submitted the patches for libv4l to do the hardware
> loopback trick, or add a function there to convert the raw data into a
> common format, that should be ok. Otherwise, we have a problem, that needs
> to be fixed.

That's not what this is about. Bayer to YUV conversion needs to happen in 
hardware in this case for performance reasons. The hardware will also perform 
scaling on YUV, as well as many image processing tasks (white balance, defect 
pixel correction, gamma correction, noise filtering, ...).

> >>>> Also, on most cases, probing a sensor is as trivial as reading a
> >>>> sensor ID during device probe. This applies, for example, for all
> >>>> Omnivision sensors.
> >>>> 
> >>>> We do things like that all the times for PC world, as nobody knows
> >>>> what webcam someone would plug on his PC.
> >>> 
> >>> Sorry, but that's not related. You simply can't decide in an embedded
> >>> ISP driver how to deal with sensor controls, as the system will be
> >>> used in a too wide variety of applications and hardware
> >>> configurations. All controls need to be exposed, period.
> >> 
> >> We're not talking about controls. We're talking about providing the
> >> needed V4L2 support to allow an userspace application to access the
> >> hardware sensor.
> > 
> > OK, so we're discussing S_INPUT. Let's discuss controls later :-)
> > 
> >>>>>> I never saw an embedded hardware that allows physically changing the
> >>>>>> sensor.
> >>>>> 
> >>>>> Beagleboard + pluggable sensor board.
> >>>> 
> >>>> Development systems like beagleboard, pandaboard, Exynos SMDK, etc,
> >>>> aren't embeeded hardware. They're development kits.
> >>> 
> >>> People create end-user products based on those kits. That make them
> >>> first- class embedded hardware like any other.
> >> 
> >> No doubt they should be supported, but it doesn't make sense to create
> >> tons of input pipelines to be used for S_INPUT for each different type
> >> of possible sensor. Somehow, userspace needs to tell what's the sensor
> >> that he attached to the hardware, or the driver should suport
> >> auto-detecting it.
> > 
> > We're not creating tons of input pipelines. Look at
> > http://www.ideasonboard.org/media/omap3isp.ps , every video node (in
> > yellow) has its purpose.
> 
> Not sure if I it understood well. The subdevs 8-11 are the sensors, right?

et8ek8 and vs6555 are the sensors. ad5820 is the lens controller and adp1653 
the flash controller. All other subdevs (green blocks) are part of the ISP.

> >> In other words, I see 2 options for that:
> >> 	1) add hardware auto-detection at the sensor logic. At driver probe,
> >> 
> >> try to probe all sensors, if it is a hardware development kit;
> > 
> > We've worked quite hard to remove I2C device probing from the kernel,
> > let's not add it back.
> 
> We do I2C probing on several drivers. It is there for devices where
> the cards entry is not enough to identify the hardware. For example,
> two different devices with the same USB ID generally uses that.
> If the hardware information is not enough, there's nothing wrong
> on doing that.

Except that probing might destroy the hardware in the general case. We can 
only probe I2C devices on a bus that we know will not contain any other 
sensitive devices.

> >> 	2) add one new parameter at the driver: "sensors". If the hardware
> >> 
> >> is one of those kits, this parameter will allow the developer to specify
> >> the used sensors. It is the same logic as we do with userspace TV and
> >> grabber cards without eeprom or any other way to auto-detect the
> >> hardware.
> > 
> > This will likely be done through the Device Tree.
> 
> I don't mind much about the way it is implemented, but it should be there
> on a place where people can find it and use it.
> 
> Devices that requires the user to pass some parameters to the Kernel in
> order for the driver to find the hardware are economic class devices. A
> first class device should work as-is, after the driver is loaded.

I don't think there has ever been any disagreement on this, we can consider 
the matter settled.

> >>>> I don't mind if, for those kits the developer that is playing with it
> >>>> has to pass a mode parameter and/or run some open harware-aware small
> >>>> application that makes the driver to select the sensor type he is
> >>>> using, but, if the hardware is, instead, a N9 or a Galaxy Tab (or
> >>>> whatever embedded hardware), the driver should expose just the sensors
> >>>> that exists on such hardware. It shouldn't be ever allowed to change
> >>>> it on userspace, using whatever API on those hardware.
> >>> 
> >>> Who talked about changing sensors from userspace on those systems ?
> >>> Platform data (regardless of whether it comes from board code, device
> >>> tree, or something else) will contain a hardware description, and the
> >>> kernel will create the right devices and load the right drivers. The
> >>> issue we're discussing is how to expose controls for those devices to
> >>> userspace, and that needs to be done through subdev nodes.
> >> 
> >> The issue that is under discussion is the removal of S_INPUT from the
> >> samsung driver, and the comments at the patches that talks about
> >> removing V4L2 API support in favor of using a MC-only API for some
> >> fundamental things.
> >> 
> >> For example, with a patch like this one, only one sensor will be
> >> supported without the MC API (either the front or back sensor on a
> >> multi-sensor camera):
> >> http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/47751733a
> >> 32 2a241927f9238b8ab1441389c9c41
> >> 
> >> Look at the comment on this patch also:
> >> 	http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/c6fb462c
> >> 	38b
> >> 
> >> e60a45d16a29a9e56c886ee0aa08c
> >> 
> >> What is called "API compatibility mode" is not clear, but it transmitted
> >> me that the idea is to expose the controls only via subnodes.
> >> 
> >> Those are the rationale for those discussions: V4L2 API is not being
> >> deprecated in favor of MC API, e. g. controls shouldn't be hidden from
> >> the V4L2 API without a good reason.
> > 
> > Controls need to move to subdev nodes for embedded devices because
> > there's simply no way to expose multiple identical controls through a
> > video node. Please also have a look at the diagram I linked to above,
> > and tell me though which video node sensor controls should be exposed.
> > There's no simple answer to that.
> 
> Again, not sure if I understood well your diagram. What device will be
> controlling and receiving the video streaming from the sensor? /dev/video0?
> 
> If so, this is the one that should be exposing the controls for the
> selected input sensor.

When capturing data from the main sensor (et8ek8), a common pipeline is to 
capture data from /dev/video1, feed it back through /dev/video0 and capture 
the final result from /dev/video6. Another common alternative is to capture it 
from /dev/video2, feed it back to /dev/video3 and capture the final result 
from /dev/video6. Regardless of which above configuration is used, 
applications can also need to capture images on /dev/video4 and /dev/video6 
concurrently. This all depends on what kind of image the application wants and 
what hardware processing it wants to apply.

This isn't even a complex case, there are much more complex hardware out there 
that we want to support.

> >>>>>>> Even if you did, fine image quality tuning requires accessing
> >>>>>>> pretty much all controls individually anyway.
> >>>>>> 
> >>>>>> The same is also true for non-embedded hardware. The only situation
> >>>>>> where V4L2 API is not enough is when there are two controls of the
> >>>>>> same type active. For example, 2 active volume controls, one at the
> >>>>>> audio demod, and another at the bridge. There may have some cases
> >>>>>> where you can do the same thing at the sensor or at a DSP block.
> >>>>>> This is where MC API gives an improvement, by allowing changing
> >>>>>> both, instead of just one of the controls.
> >>>>> 
> >>>>> To be precise it's the V4L2 subdev userspace API that allows that,
> >>>>> not the MC API.
> >>>>> 
> >>>>>>>>> This is a hack...sorry, just joking ;-) Seriously, I think the
> >>>>>>>>> situation with the userspace subdevs is a bit different. Because
> >>>>>>>>> with one API we directly expose some functionality for
> >>>>>>>>> applications, with other we code it in the kernel, to make the
> >>>>>>>>> devices appear uniform at user space.
> >>>>>>>> 
> >>>>>>>> Not sure if I understood you. V4L2 export drivers functionality to
> >>>>>>>> userspace in an uniform way. MC api is for special applications
> >>>>>>>> that might need to access some internal functions on embedded
> >>>>>>>> devices.
> >>>>>>>> 
> >>>>>>>> Of course, there are some cases where it doesn't make sense to
> >>>>>>>> export a subdev control via V4L2 API.
> >>>>>>>> 
> >>>>>>>>>>> Also, the sensor subdev can be configured in the video node
> >>>>>>>>>>> driver as well as through the subdev device node. Both APIs can
> >>>>>>>>>>> do the same thing but in order to let the subdev API work as
> >>>>>>>>>>> expected the video node driver must be forbidden to configure
> >>>>>>>>>>> the subdev.
> >>>>>>>>>> 
> >>>>>>>>>> Why? For the sensor, a V4L2 API call will look just like a
> >>>>>>>>>> bridge driver call. The subdev will need a mutex anyway, as two
> >>>>>>>>>> MC applications may be opening it simultaneously. I can't see
> >>>>>>>>>> why it should forbid changing the control from the bridge
> >>>>>>>>>> driver call.
> >>>>>>>>> 
> >>>>>>>>> Please do not forget there might be more than one subdev to
> >>>>>>>>> configure and that the bridge itself is also a subdev (which
> >>>>>>>>> exposes a scaler interface, for instance). A situation pretty
> >>>>>>>>> much like in Figure 4.4 [1] (after the scaler there is also a
> >>>>>>>>> video node to configure, but we may assume that pixel resolution
> >>>>>>>>> at the scaler pad 1 is same as at the video node). Assuming the
> >>>>>>>>> format and crop configuration flow is from sensor to host scaler
> >>>>>>>>> direction, if we have tried to configure _all_ subdevs when the
> >>>>>>>>> last stage of the pipeline is configured (i.e. video node) the
> >>>>>>>>> whole scaler and crop/composition
> >>>>>>>>> configuration we have been destroyed at that time. And there is
> >>>>>>>>> more to configure than
> >>>>>>>>> VIDIOC_S_FMT can do.
> >>>>>>>> 
> >>>>>>>> Think from users perspective: all user wants is to see a video of
> >>>>>>>> a given resolution. S_FMT (and a few other VIDIOC_* calls) have
> >>>>>>>> everything that the user wants: the desired resolution, framerate
> >>>>>>>> and format.
> >>>>>>>> 
> >>>>>>>> Specialized applications indeed need more, in order to get the
> >>>>>>>> best images for certain types of usages. So, MC is there.
> >>>>>>>> 
> >>>>>>>> Such applications will probably need to know exactly what's the
> >>>>>>>> sensor, what are their bugs, how it is connected, what are the DSP
> >>>>>>>> blocks in the patch, how the DSP algorithms are implemented, etc,
> >>>>>>>> in order to obtain the the perfect image.
> >>>>>>>> 
> >>>>>>>> Even on embedded devices like smartphones and tablets, I predict
> >>>>>>>> that both types of applications will be developed and used: people
> >>>>>>>> may use a generic application like flash player, and an
> >>>>>>>> specialized application provided by the manufacturer. Users can
> >>>>>>>> even develop their own applications generic apps using V4L2
> >>>>>>>> directly, at the devices that allow that.
> >>>>>>>> 
> >>>>>>>> As I said before: both application types are welcome. We just need
> >>>>>>>> to warrant that a pure V4L application will work reasonably well.
> >>>>>>> 
> >>>>>>> That's why we have libv4l. The driver simply doesn't receive enough
> >>>>>>> information to configure the hardware correctly from the VIDIOC_*
> >>>>>>> calls. And as mentioned above, 3A algorithms, required by "simple"
> >>>>>>> V4L2 applications, need to be implemented in userspace anyway.
> >>>>>> 
> >>>>>> It is OK to improve users experience via libv4l. What I'm saying is
> >>>>>> that it is NOT OK to remove V4L2 API support from the driver,
> >>>>>> forcing users to use some hardware plugin at libv4l.
> >>>>> 
> >>>>> Let me be clear on this. I'm *NOT* advocating removing V4L2 API
> >>>>> support from any driver (well, on the drivers I can currently think
> >>>>> of, if you show me a wifi driver that implements a V4L2 interface I
> >>>>> might change my mind :-)).
> >>>> 
> >>>> This thread is all about a patch series partially removing V4L2 API
> >>>> support.
> >>> 
> >>> Because that specific part of the API doesn't make sense for this use
> >>> case. You wouldn't object to removing S_INPUT support from a video
> >>> output driver, as it wouldn't make sense either.
> >> 
> >> A device with two sensors input where just one node can be switched to
> >> use either input is a typical case where S_INPUT needs to be provided.
> > 
> > No. S_INPUT shouldn't be use to select between sensors. The hardware
> > pipeline is more complex than just that. We can't make it all fit in the
> > S_INPUT API.
> > 
> > For instance, when switching between a b&w and a color sensor you will
> > need to reconfigure the whole pipeline to select the right gamma table,
> > white balance parameters, color conversion matrix, ... That's not
> > something we want to hardcode in the kernel. This needs to be done from
> > userspace.
> 
> This is something that, if it is not written somehwere, no userspace
> applications not developed by the hardware vendor will ever work.
> 
> I don't see any code for that any at the kernel or at libv4l. Am I missing
> something?

Code for that needs to be written in libv4l. It's not there yet as I don't 
think we have any hardware for this particular example at the moment :-)

-- 
Regards,

Laurent Pinchart
