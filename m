Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:50796 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbcHCSDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:03:54 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: pxa_camera: convert to vb2
References: <1457543851-17823-1-git-send-email-robert.jarzmik@free.fr>
	<56E2BD79.9080405@xs4all.nl> <87k2fzxd42.fsf@belgarion.home>
	<bafc1ef7-8343-c208-3621-02cc95316dbc@xs4all.nl>
Date: Wed, 03 Aug 2016 19:55:17 +0200
In-Reply-To: <bafc1ef7-8343-c208-3621-02cc95316dbc@xs4all.nl> (Hans Verkuil's
	message of "Wed, 3 Aug 2016 09:39:12 +0200")
Message-ID: <87fuqlyby2.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/02/2016 08:03 PM, Robert Jarzmik wrote:
>> Hans Verkuil <hverkuil@xs4all.nl> writes:
>> [ 1509.773051] pxa27x-camera pxa27x-camera.0: s_fmt_vid_cap(pix=48x32:56595559)
>> [ 1509.777213] pxa27x-camera pxa27x-camera.0: current_fmt->fourcc: 0x56595559
>> 	RJK: Here we switch to 48x32 format
>> 
>> [ 1509.777386] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue_setup(vq=c312f290 nbufs=3 num_planes=0 size=614400)
>
> But this debug line indicates that pcdev->current_pix.sizeimage is still the old value: this
> should have been updated by the S_FMT call. You'd have to debug that a bit more, it looks like
> there is a bug somewhere in the driver.
>
> I suspect this line in pxac_vidioc_try_fmt_vid_cap:
> pix->sizeimage = max_t(u32, pix->sizeimage, ret);
>
> This should just be pix->sizeimage = ret.

Hi Hans and Laurent,

Thanks for pinpointing this one, that's exactly where the problem comes
from. I'm rerunning my capture tests as well as v4l2-compliance -s and
v4l2-compliance -f to be sure.

That leads me to a question for Laurent :
 - in the commit bed8d8033037 ("[media] soc-camera: Honor user-requested
 bytesperline and sizeimage")
 - in the hunk
   @@ -177,22 +178,22 @@ static int soc_camera_try_fmt(struct soc_camera_device *icd,
 - you added this:
   pix->sizeimage = max_t(u32, pix->sizeimage, ret);

As I blindly copied it from soc_camera.c to pxa_camera.c, I didn't pay attention
to it. I'd like to understand what this is for, why using the maximum of the
computed image size and imagesize instead of using directly the computed
imagesize, and if it is applicable to the pxa_camera case.

Thanks in advance.

--
Robert
