Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:42626 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2IPQtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 12:49:03 -0400
Message-ID: <505602FC.90502@unixsol.org>
Date: Sun, 16 Sep 2012 19:49:00 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: How to set pixelaspect in struct v4l2_cropcap returned by VIDIOC_CROPCAP?
References: <5055F124.8020507@unixsol.org> <201209161828.44984.hverkuil@xs4all.nl>
In-Reply-To: <201209161828.44984.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/16/12 7:28 PM, Hans Verkuil wrote:
> On Sun September 16 2012 17:32:52 Georgi Chorbadzhiyski wrote:
>> Guys I'm adding v4l2 output device support for VLC/ffmpeg/libav (I'm using
>> v4l2loopback [1] driver for testing) but I have a problem which I can't seem
>> to find a solution.
>>
>> VLC [2] uses VIDIOC_CROPCAP [3] to detect the pixelaspect ratio of the input
>> it receives from v4l2 device. But I can't seem to find a way to set struct
>> v4l2_cropcap.pixelaspect when I'm outputting data to the device and the
>> result is that VLC assumes pixelaspect is 1:1.
>>
>> I was hoping that VIDIOC_S_CROP [4] would allow setting pixelaspect but
>> according to docs that is not case. What am I missing?
>
> The pixelaspect ratio returned by CROPCAP depends on the current video standard
> of the video receiver or transmitter.
>
> So for video capture the pixelaspect depends on the standard (50 vs 60 Hz) and
> the horizontal sampling frequency of the video receiver (hardware specific).
>
> For video output the pixelaspect depends also on the standard and on how the
> transmitter goes from digital to analog pixels (the reverse of what a receiver
> does).
>
> It is *not* the pixelaspect of the video data itself. For output it is the
> pixel aspect that the transmitter expects. Any difference between the two will
> need to be resolved somehow, typically by software or hardware scaling.

Since I'm using virtual output v4l2 loopback device this means I have to set the
standard somehow, right?

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
