Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3709 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1BXMkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 07:40:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Thu, 24 Feb 2011 13:40:13 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241340.14060.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, February 24, 2011 13:18:39 Guennadi Liakhovetski wrote:
> Agenda.
> =======
> 
> In a recent RFC [1] I proposed V4L2 API extensions to support fast switching
> between multiple capture modes or data formats. However, this is not sufficient
> to efficiently leverage snapshot capabilities of existing hardware - sensors and
> SoCs, and to satisfy user-space needs, a few more functions have to be
> implemented.
> 
> Snapshot and strobe / flash capabilities vary significantly between sensors.
> Some of them only capture a single image upon trigger activation, some can
> capture several images, readout and exposure capabilities vary too. Not all
> sensors support a strobe signal, and those, that support it, also offer very
> different options to select strobe beginning and duration. This proposal is
> trying to select a minimum API, that can be reasonably supported by many
> systems and provide a reasonable functionality set to the user.
> 
> Proposed implementation.
> ========================
> 
> 1. Switch the interface into the snapshot mode. This is required in addition to
> simply configuring the interface with a different format to activate hardware-
> specific support for triggered single image capture. It is proposed to use the
> VIDIOC_S_PARM ioctl() with a new V4L2_MODE_SNAPSHOT value for the
> struct v4l2_captureparm::capturemode and ::capability fields. Further
> hardware-specific details can be passed in ::extendedmode, ::readbuffers can be
> used to specify the exact number of frames to be captured. Similarly,
> VIDIOC_G_PARM shall return supported and current capture modes.
> 
> Many sensors provide the ability to trigger snapshot capture either from an
> external source or from a control register. Usually, however, there is no
> possibility to select the trigger source, either of them can be used at any
> time.

I'd rather see a new VIDIOC_G/S_SNAPSHOT ioctl then adding stuff to G/S_PARM.
Those G/S_PARM ioctls should never have been added to V4L2 in the current form.

AFAIK the only usable field is timeperframe, all others are either not used at
all or driver specific.

I am very much in favor of freezing the G/S_PARM ioctls.

> 2. Specify a flash mode. Define new capture capabilities to be used with
> struct v4l2_captureparm::capturemode:
> 
> V4L2_MODE_FLASH_SYNC	/* synchronise flash with image capture */
> V4L2_MODE_FLASH_ON	/* turn on - "torch-mode" */
> V4L2_MODE_FLASH_OFF	/* turn off */
> 
> Obviously, the above synchronous operation does not exactly define beginning and
> duration of the strobe signal. It is proposed to leave the specific flash timing
> configuration to the driver itself and, possibly, to driver-specific extended
> mode flags.

Isn't this something that can be done quite well with controls?
 
> 3. Add a sensor-subdev operation
> 
> 	int (*snapshot_trigger)(struct v4l2_subdev *sd)
> 
> to start capturing the next frame in the snapshot mode.

You might need a 'count' argument if you want to have multiple frames in snapshot
mode.

Regards,

	Hans

> 
> References.
> ===========
> 
> [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/29357
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
