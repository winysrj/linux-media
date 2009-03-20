Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63427 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbZCTAVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 20:21:40 -0400
Subject: Re: v4l2-subdev missing video ops
From: Andy Walls <awalls@radix.net>
To: Pete Eberlein <pete@sensoray.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <1237506920.5572.13.camel@pete-desktop>
References: <1237506920.5572.13.camel@pete-desktop>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 20:22:55 -0400
Message-Id: <1237508575.3278.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-19 at 16:55 -0700, Pete Eberlein wrote:
> Hello Hans,
> 
> I'm looking at converting the go7007 staging driver to use the subdev
> API.  I don't see any v4l2_subdev_video_ops for VIDIOC_S_INPUT

I believe you want

v4l2_subdev_video_ops.s_routing
and
v4l2_subdev_audio_ops.s_routing

to effect an input change.


>  nor
> VIDIOC_S_STD. 

The cx25840 module and the cx18 driver use

v4l2_subdev_tuner_ops.s_std

for the digitizer, whether or not it's a tuner input for which the
standard is being set.

A quick grep in linux/drivers/media/video:

$ grep -R -B3  '\.s_std[^_]' *

shows this is likely the case for quite a driver modules.

Regards,
Andy

>  Were those overlooked, or should I use the generic
> v4l2_subdev_core_ops->ioctl?
>   (The chip in particular does not have a
> tuner, but it does have multiple inputs (svidio, composite) and supports
> NTSC or PAL.)
>
> Thanks.

