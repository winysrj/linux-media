Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2147 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZCTHLR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 03:11:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: v4l2-subdev missing video ops
Date: Fri, 20 Mar 2009 08:11:31 +0100
Cc: linux-media@vger.kernel.org
References: <1237506920.5572.13.camel@pete-desktop>
In-Reply-To: <1237506920.5572.13.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903200811.31533.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 March 2009 00:55:20 Pete Eberlein wrote:
> Hello Hans,
>
> I'm looking at converting the go7007 staging driver to use the subdev
> API. 

Hoorah! :-)

> I don't see any v4l2_subdev_video_ops for VIDIOC_S_INPUT nor 
> VIDIOC_S_STD.  Were those overlooked, or should I use the generic
> v4l2_subdev_core_ops->ioctl?  (The chip in particular does not have a
> tuner, but it does have multiple inputs (svidio, composite) and supports
> NTSC or PAL.)

S_STD exists, but it is in tuner_ops. I know, I know, that's the wrong 
place. I'll move it to video_ops once all conversions are done.

S_INPUT must not be used in subdevices. S_INPUT deals with user-level inputs 
(e.g. "Composite", "S-Video", "Tuner"), not with the sub-device-level 
inputs/outputs (e.g. PIN-X, PIN-Y). Sub-devices know nothing about the 
user-level since that's a board-level informations. Sub-devices only know 
about their own input and output pins. The adapter driver is responsible 
for mapping an S_INPUT ioctl to video/s_routing and audio/s_routing subdev 
ops. These routing commands tell the sub-device on what pin(s) it receives 
its input data and what pin(s) are used for the output.

What values you put in the v4l2_routing struct is sub-device dependent and 
is defined in the include/media/<subdev>.h header.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
