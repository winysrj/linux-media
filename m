Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1041 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2IPQ2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 12:28:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Subject: Re: How to set pixelaspect in struct v4l2_cropcap returned by VIDIOC_CROPCAP?
Date: Sun, 16 Sep 2012 18:28:44 +0200
Cc: linux-media@vger.kernel.org
References: <5055F124.8020507@unixsol.org>
In-Reply-To: <5055F124.8020507@unixsol.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209161828.44984.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun September 16 2012 17:32:52 Georgi Chorbadzhiyski wrote:
> Guys I'm adding v4l2 output device support for VLC/ffmpeg/libav (I'm using
> v4l2loopback [1] driver for testing) but I have a problem which I can't seem
> to find a solution.
> 
> VLC [2] uses VIDIOC_CROPCAP [3] to detect the pixelaspect ratio of the input
> it receives from v4l2 device. But I can't seem to find a way to set struct
> v4l2_cropcap.pixelaspect when I'm outputting data to the device and the
> result is that VLC assumes pixelaspect is 1:1.
> 
> I was hoping that VIDIOC_S_CROP [4] would allow setting pixelaspect but
> according to docs that is not case. What am I missing?

The pixelaspect ratio returned by CROPCAP depends on the current video standard
of the video receiver or transmitter.

So for video capture the pixelaspect depends on the standard (50 vs 60 Hz) and
the horizontal sampling frequency of the video receiver (hardware specific).

For video output the pixelaspect depends also on the standard and on how the
transmitter goes from digital to analog pixels (the reverse of what a receiver
does).

It is *not* the pixelaspect of the video data itself. For output it is the
pixel aspect that the transmitter expects. Any difference between the two will
need to be resolved somehow, typically by software or hardware scaling.

Regards,

	Hans

> 
> How to set pixelaspect values returned by VIDIOC_CROPCAP?
> 
> [1]: https://github.com/umlaeute/v4l2loopback
> [2]: http://git.videolan.org/?p=vlc.git;a=blob;f=modules/access/v4l2/demux.c;hb=HEAD#l248
> [3]: http://www.linuxtv.org/downloads/v4l-dvb-apis/vidioc-cropcap.html
> [4]: http://www.kernel.org/doc/htmldocs/media/vidioc-g-crop.html
> 
> 
