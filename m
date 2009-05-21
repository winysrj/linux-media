Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3319 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZEUMHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 08:07:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: About VIDIOC_G_OUTPUT/S_OUTPUT ?
Date: Thu, 21 May 2009 14:07:05 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10905200448n1ffc9d8s20317bbbba745e6a@mail.gmail.com>
In-Reply-To: <5e9665e10905200448n1ffc9d8s20317bbbba745e6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905211407.05354.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 20 May 2009 13:48:08 Dongsoo, Nathaniel Kim wrote:
> Hello everyone,
>
> Doing a new camera interface driver job of new AP from Samsung, a
> single little question doesn't stop making me confused.
> The camera IP in Samsung application processor supports for two of
> output paths, like "to memory" and "to LCD FIFO".
> It seems to be VIDIOC_G_OUTPUT/S_OUTPUT which I need to use (just
> guessing), but according to Hans's ivtv driver the "output" of
> G_OUTPUT/S_OUTPUT is supposed to mean an actually and physically
> separated real output path like Composite, S-Video and so on.
>
> Do you think that memory or LCD FIFO can be an "output" device in this
> case? Because in earlier version of my driver, I assumed that the "LCD
> FIFO" is a kind of "OVERLAY" device, so I didn't even need to use
> G_OUTPUT and S_OUTPUT to route output device. I'm just not sure about
> which idea makes sense. or maybe both of them could make sense
> indeed...

When you select "to memory", then the video from the camera is DMAed to the 
CPU, right? But selecting "to LCD" means that the video is routed 
internally to the LCD without any DMA to the CPU taking place, right?

This is similar to the "passthrough" mode of the ivtv driver.

This header: linux/dvb/video.h contains an ioctl called VIDEO_SELECT_SOURCE, 
which can be used to select either memory or a demuxer (or in this case, 
the camera) as the source of the output (the LCD in this case). It is 
probably the appropriate ioctl to implement for this.

The video.h header is shared between v4l and dvb and contains several ioctls 
meant to handle output. It is poorly documented and I think it should be 
merged into the v4l2 API and properly documented/cleaned up.

Note that overlays are meant for on-screen displays. Usually these are 
associated with a framebuffer device. Your hardware may implement such an 
OSD as well, but that is different from this passthrough feature.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
