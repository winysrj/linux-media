Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4353 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422895Ab3DFNTF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 09:19:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: Question regarding developing V4L2 device driver and Streaming IO in v4l2-ctl
Date: Sat, 6 Apr 2013 15:18:50 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>
References: <CAEvN+1iN_fZ-Gu904LTLYf8CZs9ZfZm03bfuE4Ev3frEgOLShg@mail.gmail.com>
In-Reply-To: <CAEvN+1iN_fZ-Gu904LTLYf8CZs9ZfZm03bfuE4Ev3frEgOLShg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304061518.50347.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat April 6 2013 14:28:12 Tzu-Jung Lee wrote:
> Hi,
> 
> I'm writing device v4l2 driver for our video codec, which can be configured to:
> 
>     1. decode bitstream and output to TV (output device)
>     2. capture video input, and generate encoded bitstream. (capture device)
>     3. transcode input bitstream to another format output bitstream.
> (mem2mem device)
> 
> And I got some questions regarding the GENERIC way to handle the "end
> of stream" when doing STREAM I/O.
> (Perhaps these questions are only relevant to bitstream data instead of frames?)
> 
>     1. Capture path: how does the device driver notify the user
> program the end of captured bitstream?
>     2. Output path: how does user program tells the the driver the end
> of output bitstream?
> 
>     Based on the http://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html,
>     I wrote a program, which can do the stream I/O with our V4L2 driver.
> 
>     For capture path: if the device has stopped, the program will get
> a zero-size (bytesused = 0) buffer when it DQBUF.

One example is the Samsung MFC driver: drivers/media/platform/s5p-mfc.
Basically the application will get an EOS event. It is also possible to
command the encoder to stop by calling VIDIOC_ENCODER_CMD.

>     For output path: If the program has read the EOF of input file, it
> QBUF a zero-size buffer to notify the driver.

Use VIDIOC_DECODER_CMD with the stop comment and a pts value of 0.

>     However, this is just the "vendor-specific" way. And I'm wondering
> what is the "generic" way to this?
> 
> 
> 
> The v4l2-ctl is really handy, and helps me to develop the "control" of
> drivers. I'd like to use it for testing STREAM I/O functions as well.
> 
> But I have questions regarding Streaming I/O in v4l2-ctl.
> 
>     v4l-utils/utils/v4l2-ctl/v4l2-ctl.cpp:
> 
>     1. For the path of "--stream-out-mmap", isn't it supposed to set
> the payload size (buf->bytesused) after filling data read from STDIN
> or file?

Yes, it should. I'll fix this. Until now I've only used this with uncompressed
video and those output drivers just ignore bytesused. I'm not sure whether
that's a feature or a bug :-) For compressed data bytesused definitely needs
to be set.

>     2. For capture path, user programs have to initially QBUF empty
> buffers for drivers to fill data.
>         However, for output path, do we need to QBUF empty buffers
> before the filling loop start?
>         Or we only QBUF filled buffers when the loop starts.

You need to queue filled buffers in the output case.

> It seems to me drivers can't use the buffer length to distinguish if
> the queued buffer are empty or filled ones, right.

No, the buffer length is the actual buffer size and that is fixed.

Regards,

	Hans
