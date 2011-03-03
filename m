Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:54022 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1CCHJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 02:09:52 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHG00DZOZWEN270@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Mar 2011 16:09:50 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHG003DRZWEFI@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Mar 2011 16:09:50 +0900 (KST)
Date: Thu, 03 Mar 2011 16:09:50 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-reply-to: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Reply-to: riverful.kim@samsung.com
Message-id: <4D6F3EBE.6070404@samsung.com>
Content-transfer-encoding: 8BIT
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

I have another question about capture, not related with exact this topic.

Dose the sensor which you use make EXIF information in itself while capturing??

If it is right, how to deliver EXIF information from v4l2(subdev or media driver)
to userapplication?

Regards,
Heungjun Kim



2011-02-24 오후 9:18, Guennadi Liakhovetski 쓴 글:
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
> 
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
> 
> 3. Add a sensor-subdev operation
> 
> 	int (*snapshot_trigger)(struct v4l2_subdev *sd)
> 
> to start capturing the next frame in the snapshot mode.
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

