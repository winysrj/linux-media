Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53797 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1BXR5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 12:57:30 -0500
Received: by pzk35 with SMTP id 35so121822pzk.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 09:57:29 -0800 (PST)
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=euc-kr
From: Kim HeungJun <riverful@gmail.com>
In-Reply-To: <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
Date: Fri, 25 Feb 2011 02:57:22 +0900
Cc: Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <201102241340.14060.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

I think, it's maybe a good suggestion for current trend! ( I'm not sure this express *trend* is right :))

But, the flash or strobe control connected with sensor can be controlled by user application
directly, not in the sensor subdev device. For example, let's think that there is a Flash light
application. Its function is just power-up LED. So, in this case, if the flash control mechanism
should be used *only* in the V4L2 API belonging through S/G_PARM, this mechanism
might be a little complicated, nevertheless it's possible to control led/strobe using S/G_PARM.
I mean that we must check the camera must be in the capture state or not, or another setting
(like a FPS) should be checked. Namely, for powering up LED, the more procedure is needed.

Also, we can think another case. Generally, the LED/STROBE/FLASH is connected with camera
sensor directly, but another case can be existed that LED connected with Processor by controlling
GPIO. So, In this case, using LED framework look more better I guess, and then user application
access LED frame sysfs node eaisly.

So, IMHO, probably it's the better option for now to make another CID like V4L2_CID_STROBE clearly,
then in the case connected directly with sensor, we control using I2C or another command method for
sensor in the V4L2_CID_STROBE, OR in the case connected directly with process, we also using
V4L2_CID_STROBE, but the led framework code is in the CID control functions.

Actually, because I also think deeply same issue for a long time, so I wanna very talk about this issues.

How about dealing with this?

Regards,
Heungjun Kim


2011. 2. 25., 오전 1:07, Guennadi Liakhovetski 작성:

> Hi Hans
> 
> Thanks for the review. Perhaps, I should have mentioned it in the original 
> post, I've written down this RFC to have a basis for a discussion. The 
> specific API proposals in it are nothing solid, of course, so, we can 
> freely discuss it here now, or, maybe we get a chance to discuss it 
> together with the earlier one, concerning multiple queues, if and when we 
> meet personally next time;) Concerning your specific comments:
> 
> On Thu, 24 Feb 2011, Hans Verkuil wrote:
> 
>> On Thursday, February 24, 2011 13:18:39 Guennadi Liakhovetski wrote:
>>> Agenda.
>>> =======
>>> 
>>> In a recent RFC [1] I proposed V4L2 API extensions to support fast switching
>>> between multiple capture modes or data formats. However, this is not sufficient
>>> to efficiently leverage snapshot capabilities of existing hardware - sensors and
>>> SoCs, and to satisfy user-space needs, a few more functions have to be
>>> implemented.
>>> 
>>> Snapshot and strobe / flash capabilities vary significantly between sensors.
>>> Some of them only capture a single image upon trigger activation, some can
>>> capture several images, readout and exposure capabilities vary too. Not all
>>> sensors support a strobe signal, and those, that support it, also offer very
>>> different options to select strobe beginning and duration. This proposal is
>>> trying to select a minimum API, that can be reasonably supported by many
>>> systems and provide a reasonable functionality set to the user.
>>> 
>>> Proposed implementation.
>>> ========================
>>> 
>>> 1. Switch the interface into the snapshot mode. This is required in addition to
>>> simply configuring the interface with a different format to activate hardware-
>>> specific support for triggered single image capture. It is proposed to use the
>>> VIDIOC_S_PARM ioctl() with a new V4L2_MODE_SNAPSHOT value for the
>>> struct v4l2_captureparm::capturemode and ::capability fields. Further
>>> hardware-specific details can be passed in ::extendedmode, ::readbuffers can be
>>> used to specify the exact number of frames to be captured. Similarly,
>>> VIDIOC_G_PARM shall return supported and current capture modes.
>>> 
>>> Many sensors provide the ability to trigger snapshot capture either from an
>>> external source or from a control register. Usually, however, there is no
>>> possibility to select the trigger source, either of them can be used at any
>>> time.
>> 
>> I'd rather see a new VIDIOC_G/S_SNAPSHOT ioctl then adding stuff to G/S_PARM.
>> Those G/S_PARM ioctls should never have been added to V4L2 in the current form.
>> 
>> AFAIK the only usable field is timeperframe, all others are either not used at
>> all or driver specific.
>> 
>> I am very much in favor of freezing the G/S_PARM ioctls.
> 
> Ic, of course, I knew nothing about this status of G/S_PARM. As it stands, 
> it seemed a pretty good fit for what I want to do, but, yes, I agree, that 
> this ioctl() as such is not very pretty, so, sure, we can use a new one. 
> But first, in principle you agree, that adding this functionality to V4L2 
> makes sense instead of relying exclusively on STREAMON / STREAMOFF for 
> still images? But in fact, streaming vs. snapshot does fit under the same 
> category as fps setting, IMHO, doesn't it? So, I think it would make sense 
> to group them together if possible. One could even say: 0fps means manual 
> trigger, i.e., snapshot mode... But anyway, if we want to freeze / kill it 
> - will create a new ioctl().
> 
> Now, my proposal above put the snapshot mode parallel to the continuous 
> streaming mode. In this regard, maybe it would make sense to add a new 
> capability V4L2_CAP_VIDEO_SNAPSHOT? Next, additionally to the standard 
> streamon / qbuf / dqbuf / streamoff flow we want to add an operation to 
> switch to the snapshot mode and another one to query the current mode and 
> its parameters. I agree, that there's currently no suitable ioctl(), that 
> could be extended to manage the snapshot mode, apart from G/S_PARM. My 
> question then is: shall we just add G/S_SNAPSHOT, or domething more 
> generic, like G/S_CAPMODE with STREAMING and SNAPSHOT as possible values, 
> STREAMING being the default. This would make sense if there were any other 
> modes, that could eventually be added? No, I cannot think of any 
> personally atm.
> 
> So, if we go for G/S_SNAPSHOT, shall they have on / off and number of 
> frames per trigger as two parameters?
> 
>>> 2. Specify a flash mode. Define new capture capabilities to be used with
>>> struct v4l2_captureparm::capturemode:
>>> 
>>> V4L2_MODE_FLASH_SYNC	/* synchronise flash with image capture */
>>> V4L2_MODE_FLASH_ON	/* turn on - "torch-mode" */
>>> V4L2_MODE_FLASH_OFF	/* turn off */
>>> 
>>> Obviously, the above synchronous operation does not exactly define beginning and
>>> duration of the strobe signal. It is proposed to leave the specific flash timing
>>> configuration to the driver itself and, possibly, to driver-specific extended
>>> mode flags.
>> 
>> Isn't this something that can be done quite well with controls?
> 
> In principle - yes, I guess, I just wanted to group them together with the 
> snapshot mode explicitly, because they are usually bound together. 
> Although, one could use the torch-mode with preview. So, yes, if we 
> prefer them independent from snapshot, then controls will do the job.
> 
>>> 3. Add a sensor-subdev operation
>>> 
>>> 	int (*snapshot_trigger)(struct v4l2_subdev *sd)
>>> 
>>> to start capturing the next frame in the snapshot mode.
>> 
>> You might need a 'count' argument if you want to have multiple frames in snapshot
>> mode.
> 
> Right, I wasn't sure whether we should issue this for each frame, but I 
> think - yes - it is better to fire one per trigger set.
> 
> Thanks
> Guennadi
> 
>> 
>> Regards,
>> 
>> 	Hans
>> 
>>> 
>>> References.
>>> ===========
>>> 
>>> [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/29357
>>> 
>>> Thanks
>>> Guennadi
>>> ---
>>> Guennadi Liakhovetski, Ph.D.
>>> Freelance Open-Source Software Developer
>>> http://www.open-technology.de/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>>> 
>> 
>> -- 
>> Hans Verkuil - video4linux developer - sponsored by Cisco
>> 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

