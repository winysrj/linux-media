Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3738 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0BILW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 06:22:59 -0500
Message-ID: <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1002091053470.4585@axis700.grange>
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
    <4B7012D1.40605@redhat.com>
    <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
    <4B705216.7040907@redhat.com>
    <Pine.LNX.4.64.1002091053470.4585@axis700.grange>
Date: Tue, 9 Feb 2010 12:22:09 +0100
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for
 subdevices
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-pm@lists.linux-foundation.org,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Valentin Longchamp" <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:
>
>> In fact, on all drivers, there are devices that needs to be turn on only
>> when
>> streaming is happening: sensors, analog TV/audio demods, digital demods.
>> Also,
>> a few devices (for example: TV tuners) could eventually be on power off
>> when
>> no device is opened.
>>
>> As the V4L core knows when this is happening (due to
>> open/close/poll/streamon/reqbuf/qbuf/dqbuf hooks, I think the runtime
>> management
>> can happen at V4L core level.
>
> Well, we can move it up to v4l core. Should it get any more complicated
> than adding
>
> 	ret = pm_runtime_resume(&vdev->dev);
> 	if (ret < 0 && ret != -ENOSYS)
> 		return ret;
>
> to v4l2_open() and
>
> 	pm_runtime_suspend(&vdev->dev);
>
> to v4l2_release()?

My apologies if I say something stupid as I know little about pm: are you
assuming here that streaming only happens on one device node? That may be
true for soc-camera, but other devices can have multiple streaming nodes
(video, vbi, mpeg, etc). So the call to v4l2_release does not necessarily
mean that streaming has stopped.

Regards,

      Hans

> And to agree, that video drivers may set a device type
> to implement runtime PM, and that the v4l core shouldn't touch it? Then,
> for example, a bridge driver could implement such a device type instance
> and suspend or resume all related components?
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


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

