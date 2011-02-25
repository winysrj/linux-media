Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:54376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab1BYQ6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 11:58:38 -0500
Date: Fri, 25 Feb 2011 17:58:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <201102251105.06026.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1102251119410.23338@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
 <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
 <201102251105.06026.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent

On Fri, 25 Feb 2011, Laurent Pinchart wrote:

> Hi,
> 
> On Thursday 24 February 2011 18:57:22 Kim HeungJun wrote:
> > Hi Guennadi,
> > 
> > I think, it's maybe a good suggestion for current trend! ( I'm not sure
> > this express *trend* is right :))
> > 
> > But, the flash or strobe control connected with sensor can be controlled by
> > user application directly, not in the sensor subdev device. For example,
> > let's think that there is a Flash light application. Its function is just
> > power-up LED. So, in this case, if the flash control mechanism should be
> > used *only* in the V4L2 API belonging through S/G_PARM, this mechanism
> > might be a little complicated, nevertheless it's possible to control
> > led/strobe using S/G_PARM. I mean that we must check the camera must be in
> > the capture state or not, or another setting (like a FPS) should be
> > checked. Namely, for powering up LED, the more procedure is needed.
> > 
> > Also, we can think another case. Generally, the LED/STROBE/FLASH is
> > connected with camera sensor directly, but another case can be existed
> > that LED connected with Processor by controlling GPIO. So, In this case,
> > using LED framework look more better I guess, and then user application
> > access LED frame sysfs node eaisly.
> 
> The flash is usually handled by a dedicated I2C flash controller (such as the 
> ADP1653 used in the N900 - http://www.analog.com/static/imported-
> files/data_sheets/ADP1653.pdf), which is in that case mapped to a v4l2_subdev. 
> Simpler solutions of course exist, such as GPIO LEDs or LEDs connected 
> directly to the sensor. We need an API that can support all those hardware 
> options.

In principle - yes, and yes, I do realise, that the couple of controls, 
that I've proposed only cover a very minor subset of the whole flash 
function palette. The purposes of my RFC were:

1. get things started in the snapshot / flash direction;)
2. get access to dedicated snapshot / flash registers, present on many 
sensors and SoCs
3. get at least the very basic snapshot / flash functions, common to most 
hardware implementations, but trying to make it future-proof for further 
extensions
4. get a basis for a future detailed discussion

> Let's also not forget that, in addition to the flash LEDs itself, devices 
> often feature an indicator LED (a small low-power red LED used to indicate 
> that video capture is ongoing).

Well, this one doesn't seem too special to me? Wouldn't it suffice to just 
toggle it from user-space on streamon / streamoff?

> The flash LEDs can also be used during video 
> capture, and in focus assist mode (pre-flashing also comes to mind).

Sure, so, we have to design an API, that addresses the basic uses, we see 
immediately in sensors, but also try to make it extensible? Are there 
sensors, that do that pre-flashing automatically? If not, then you 
probably use some dedicated controller for that?

> In addition to the modes, flash controllers can generate strobe signals or 
> react on them. Durations are programmable, as well as current limits, and 
> sometimes PWM/current source mode selection. The device can usually detect 
> faults (such as over-current or over-temperature faults) that need to be 
> reported to the user. And we haven't even discussed Xenon flashes.
> 
> Given the wide variety of parameters, I think it would make sense to use V4L2 
> controls on the sub-device directly. If the flash LEDs are connected directly 
> to the sensor, controls on the sensor sub-device can be used to select the 
> flash parameters.

But you're not proposing to handle on-sensor flash controls from a 
separate subdevice? But isn't it possible, to have this functionality 
either attached to the sensor subdevice or to a dedicated flash subdevice? 
Maybe we could just add a flash capability indicator to the subdev API? 
And flash is not unique here, same holds for some other functions, e.g., 
shutter / exposure - you can either use on-chip electronic exposure 
control, or an external mechanical shutter, also possible controlled by a 
separate IC... Same for lenses, etc?

> This doesn't solve the flash/capture synchronization problem though. I don't 
> think we need a dedicated snapshot capture mode at the V4L2 level. A way to 
> configure the sensor to react on an external trigger provided by the flash 
> controller is needed, and that could be a control on the flash sub-device. 

Well... Sensors call this a "snapshot mode." I don't care that much how we 
_call_ it, but I do think, that we should be able to use it.

Hm, don't think only the "flash subdevice" has to know about this. First, 
you have to switch the sensor into that mode. Second, it might be either 
external trigger from the flash controller, or a programmed trigger and a 
flash strobe from the sensor to the flash (controller). Third, well, not 
quite sure, but doesn't the host have to know about the snapshot mode? 
What would host have to know about? A different format? It can and shall 
be configured by standard means. Number of frames? Not sure, if it needs 
to know about it, maybe not. But at least both the sensor and the flash 
(if separate) do.

> What we would probably miss is a way to issue a STREAMON with a number of 
> frames to capture. A new ioctl is probably needed there. Maybe that would be 
> an opportunity to create a new stream-control ioctl that could replace 
> STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream 
> operation, and easily map STREAMON and STREAMOFF to the new ioctl in 
> video_ioctl2 internally).

Not sure, if we need this. Could you elaborate why in your opinion it is 
needed?

Thanks
Guennadi

> > So, IMHO, probably it's the better option for now to make another CID like
> > V4L2_CID_STROBE clearly, then in the case connected directly with sensor,
> > we control using I2C or another command method for sensor in the
> > V4L2_CID_STROBE, OR in the case connected directly with process, we also
> > using V4L2_CID_STROBE, but the led framework code is in the CID control
> > functions.
> > 
> > Actually, because I also think deeply same issue for a long time, so I
> > wanna very talk about this issues.
> > 
> > How about dealing with this?
> > 
> > Regards,
> > Heungjun Kim
> > 
> > 2011. 2. 25., ¿ÀÀü 1:07, Guennadi Liakhovetski wrote:
> > > Hi Hans
> > > 
> > > Thanks for the review. Perhaps, I should have mentioned it in the
> > > original post, I've written down this RFC to have a basis for a
> > > discussion. The specific API proposals in it are nothing solid, of
> > > course, so, we can freely discuss it here now, or, maybe we get a chance
> > > to discuss it together with the earlier one, concerning multiple queues,
> > > if and when we meet personally next time;) Concerning your specific
> > > comments:
> > > 
> > > On Thu, 24 Feb 2011, Hans Verkuil wrote:
> > >> On Thursday, February 24, 2011 13:18:39 Guennadi Liakhovetski wrote:
> > >>> Agenda.
> > >>> =======
> > >>> 
> > >>> In a recent RFC [1] I proposed V4L2 API extensions to support fast
> > >>> switching between multiple capture modes or data formats. However,
> > >>> this is not sufficient to efficiently leverage snapshot capabilities
> > >>> of existing hardware - sensors and SoCs, and to satisfy user-space
> > >>> needs, a few more functions have to be implemented.
> > >>> 
> > >>> Snapshot and strobe / flash capabilities vary significantly between
> > >>> sensors. Some of them only capture a single image upon trigger
> > >>> activation, some can capture several images, readout and exposure
> > >>> capabilities vary too. Not all sensors support a strobe signal, and
> > >>> those, that support it, also offer very different options to select
> > >>> strobe beginning and duration. This proposal is trying to select a
> > >>> minimum API, that can be reasonably supported by many systems and
> > >>> provide a reasonable functionality set to the user.
> > >>> 
> > >>> Proposed implementation.
> > >>> ========================
> > >>> 
> > >>> 1. Switch the interface into the snapshot mode. This is required in
> > >>> addition to simply configuring the interface with a different format
> > >>> to activate hardware- specific support for triggered single image
> > >>> capture. It is proposed to use the VIDIOC_S_PARM ioctl() with a new
> > >>> V4L2_MODE_SNAPSHOT value for the struct v4l2_captureparm::capturemode
> > >>> and ::capability fields. Further hardware-specific details can be
> > >>> passed in ::extendedmode, ::readbuffers can be used to specify the
> > >>> exact number of frames to be captured. Similarly, VIDIOC_G_PARM shall
> > >>> return supported and current capture modes.
> > >>> 
> > >>> Many sensors provide the ability to trigger snapshot capture either
> > >>> from an external source or from a control register. Usually, however,
> > >>> there is no possibility to select the trigger source, either of them
> > >>> can be used at any time.
> > >> 
> > >> I'd rather see a new VIDIOC_G/S_SNAPSHOT ioctl then adding stuff to
> > >> G/S_PARM. Those G/S_PARM ioctls should never have been added to V4L2 in
> > >> the current form.
> > >> 
> > >> AFAIK the only usable field is timeperframe, all others are either not
> > >> used at all or driver specific.
> > >> 
> > >> I am very much in favor of freezing the G/S_PARM ioctls.
> > > 
> > > Ic, of course, I knew nothing about this status of G/S_PARM. As it
> > > stands, it seemed a pretty good fit for what I want to do, but, yes, I
> > > agree, that this ioctl() as such is not very pretty, so, sure, we can
> > > use a new one. But first, in principle you agree, that adding this
> > > functionality to V4L2 makes sense instead of relying exclusively on
> > > STREAMON / STREAMOFF for still images? But in fact, streaming vs.
> > > snapshot does fit under the same category as fps setting, IMHO, doesn't
> > > it? So, I think it would make sense to group them together if possible.
> > > One could even say: 0fps means manual trigger, i.e., snapshot mode...
> > > But anyway, if we want to freeze / kill it - will create a new ioctl().
> > > 
> > > Now, my proposal above put the snapshot mode parallel to the continuous
> > > streaming mode. In this regard, maybe it would make sense to add a new
> > > capability V4L2_CAP_VIDEO_SNAPSHOT? Next, additionally to the standard
> > > streamon / qbuf / dqbuf / streamoff flow we want to add an operation to
> > > switch to the snapshot mode and another one to query the current mode and
> > > its parameters. I agree, that there's currently no suitable ioctl(), that
> > > could be extended to manage the snapshot mode, apart from G/S_PARM. My
> > > question then is: shall we just add G/S_SNAPSHOT, or domething more
> > > generic, like G/S_CAPMODE with STREAMING and SNAPSHOT as possible values,
> > > STREAMING being the default. This would make sense if there were any
> > > other modes, that could eventually be added? No, I cannot think of any
> > > personally atm.
> > > 
> > > So, if we go for G/S_SNAPSHOT, shall they have on / off and number of
> > > frames per trigger as two parameters?
> > > 
> > >>> 2. Specify a flash mode. Define new capture capabilities to be used
> > >>> with struct v4l2_captureparm::capturemode:
> > >>> 
> > >>> V4L2_MODE_FLASH_SYNC	/* synchronise flash with image capture */
> > >>> V4L2_MODE_FLASH_ON	/* turn on - "torch-mode" */
> > >>> V4L2_MODE_FLASH_OFF	/* turn off */
> > >>> 
> > >>> Obviously, the above synchronous operation does not exactly define
> > >>> beginning and duration of the strobe signal. It is proposed to leave
> > >>> the specific flash timing configuration to the driver itself and,
> > >>> possibly, to driver-specific extended mode flags.
> > >> 
> > >> Isn't this something that can be done quite well with controls?
> > > 
> > > In principle - yes, I guess, I just wanted to group them together with
> > > the snapshot mode explicitly, because they are usually bound together.
> > > Although, one could use the torch-mode with preview. So, yes, if we
> > > prefer them independent from snapshot, then controls will do the job.
> > > 
> > >>> 3. Add a sensor-subdev operation
> > >>> 
> > >>> 	int (*snapshot_trigger)(struct v4l2_subdev *sd)
> > >>> 
> > >>> to start capturing the next frame in the snapshot mode.
> > >> 
> > >> You might need a 'count' argument if you want to have multiple frames in
> > >> snapshot mode.
> > > 
> > > Right, I wasn't sure whether we should issue this for each frame, but I
> > > think - yes - it is better to fire one per trigger set.
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > >> Regards,
> > >> 
> > >> 	Hans
> > >> 	
> > >>> References.
> > >>> ===========
> > >>> 
> > >>> [1]
> > >>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure
> > >>> /29357
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
