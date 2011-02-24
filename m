Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:61727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1BXQHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 11:07:31 -0500
Date: Thu, 24 Feb 2011 17:07:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <201102241340.14060.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <201102241340.14060.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans

Thanks for the review. Perhaps, I should have mentioned it in the original 
post, I've written down this RFC to have a basis for a discussion. The 
specific API proposals in it are nothing solid, of course, so, we can 
freely discuss it here now, or, maybe we get a chance to discuss it 
together with the earlier one, concerning multiple queues, if and when we 
meet personally next time;) Concerning your specific comments:

On Thu, 24 Feb 2011, Hans Verkuil wrote:

> On Thursday, February 24, 2011 13:18:39 Guennadi Liakhovetski wrote:
> > Agenda.
> > =======
> > 
> > In a recent RFC [1] I proposed V4L2 API extensions to support fast switching
> > between multiple capture modes or data formats. However, this is not sufficient
> > to efficiently leverage snapshot capabilities of existing hardware - sensors and
> > SoCs, and to satisfy user-space needs, a few more functions have to be
> > implemented.
> > 
> > Snapshot and strobe / flash capabilities vary significantly between sensors.
> > Some of them only capture a single image upon trigger activation, some can
> > capture several images, readout and exposure capabilities vary too. Not all
> > sensors support a strobe signal, and those, that support it, also offer very
> > different options to select strobe beginning and duration. This proposal is
> > trying to select a minimum API, that can be reasonably supported by many
> > systems and provide a reasonable functionality set to the user.
> > 
> > Proposed implementation.
> > ========================
> > 
> > 1. Switch the interface into the snapshot mode. This is required in addition to
> > simply configuring the interface with a different format to activate hardware-
> > specific support for triggered single image capture. It is proposed to use the
> > VIDIOC_S_PARM ioctl() with a new V4L2_MODE_SNAPSHOT value for the
> > struct v4l2_captureparm::capturemode and ::capability fields. Further
> > hardware-specific details can be passed in ::extendedmode, ::readbuffers can be
> > used to specify the exact number of frames to be captured. Similarly,
> > VIDIOC_G_PARM shall return supported and current capture modes.
> > 
> > Many sensors provide the ability to trigger snapshot capture either from an
> > external source or from a control register. Usually, however, there is no
> > possibility to select the trigger source, either of them can be used at any
> > time.
> 
> I'd rather see a new VIDIOC_G/S_SNAPSHOT ioctl then adding stuff to G/S_PARM.
> Those G/S_PARM ioctls should never have been added to V4L2 in the current form.
> 
> AFAIK the only usable field is timeperframe, all others are either not used at
> all or driver specific.
> 
> I am very much in favor of freezing the G/S_PARM ioctls.

Ic, of course, I knew nothing about this status of G/S_PARM. As it stands, 
it seemed a pretty good fit for what I want to do, but, yes, I agree, that 
this ioctl() as such is not very pretty, so, sure, we can use a new one. 
But first, in principle you agree, that adding this functionality to V4L2 
makes sense instead of relying exclusively on STREAMON / STREAMOFF for 
still images? But in fact, streaming vs. snapshot does fit under the same 
category as fps setting, IMHO, doesn't it? So, I think it would make sense 
to group them together if possible. One could even say: 0fps means manual 
trigger, i.e., snapshot mode... But anyway, if we want to freeze / kill it 
- will create a new ioctl().

Now, my proposal above put the snapshot mode parallel to the continuous 
streaming mode. In this regard, maybe it would make sense to add a new 
capability V4L2_CAP_VIDEO_SNAPSHOT? Next, additionally to the standard 
streamon / qbuf / dqbuf / streamoff flow we want to add an operation to 
switch to the snapshot mode and another one to query the current mode and 
its parameters. I agree, that there's currently no suitable ioctl(), that 
could be extended to manage the snapshot mode, apart from G/S_PARM. My 
question then is: shall we just add G/S_SNAPSHOT, or domething more 
generic, like G/S_CAPMODE with STREAMING and SNAPSHOT as possible values, 
STREAMING being the default. This would make sense if there were any other 
modes, that could eventually be added? No, I cannot think of any 
personally atm.

So, if we go for G/S_SNAPSHOT, shall they have on / off and number of 
frames per trigger as two parameters?

> > 2. Specify a flash mode. Define new capture capabilities to be used with
> > struct v4l2_captureparm::capturemode:
> > 
> > V4L2_MODE_FLASH_SYNC	/* synchronise flash with image capture */
> > V4L2_MODE_FLASH_ON	/* turn on - "torch-mode" */
> > V4L2_MODE_FLASH_OFF	/* turn off */
> > 
> > Obviously, the above synchronous operation does not exactly define beginning and
> > duration of the strobe signal. It is proposed to leave the specific flash timing
> > configuration to the driver itself and, possibly, to driver-specific extended
> > mode flags.
> 
> Isn't this something that can be done quite well with controls?

In principle - yes, I guess, I just wanted to group them together with the 
snapshot mode explicitly, because they are usually bound together. 
Although, one could use the torch-mode with preview. So, yes, if we 
prefer them independent from snapshot, then controls will do the job.

> > 3. Add a sensor-subdev operation
> > 
> > 	int (*snapshot_trigger)(struct v4l2_subdev *sd)
> > 
> > to start capturing the next frame in the snapshot mode.
> 
> You might need a 'count' argument if you want to have multiple frames in snapshot
> mode.

Right, I wasn't sure whether we should issue this for each frame, but I 
think - yes - it is better to fire one per trigger set.

Thanks
Guennadi

> 
> Regards,
> 
> 	Hans
> 
> > 
> > References.
> > ===========
> > 
> > [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/29357
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by Cisco
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
