Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56700 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3GFT61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jul 2013 15:58:27 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so1383670bkb.33
        for <linux-media@vger.kernel.org>; Sat, 06 Jul 2013 12:58:25 -0700 (PDT)
Message-ID: <51D876DF.90507@gmail.com>
Date: Sat, 06 Jul 2013 21:58:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Cc: Sakari and Laurent

On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
> Hello,
>
> I am writing a driver for the sensor MT9D131.  This device supports
> digital zoom and JPEG compression.
>
> Although I am writing it for my company's internal purposes, it will
>be made open-source, so I would like to keep the API as portable as
> possible.
>
> The hardware reads AxB sensor pixels from its array, resamples them
>to CxD image pixels, and then compresses them to ExF bytes.
>
> The subdevice driver sets size AxB to the value it receives from
>v4l2_subdev_video_ops.s_crop().
>
> To enable compression then v4l2_subdev_video_ops.s_mbus_fmt() is
>called with fmt->code=V4L2_MBUS_FMT_JPEG_1X8.
>
> fmt->width and fmt->height then ought to specify the size of the
>compressed image ExF, that is, the size specified is the size in the
>format specified (the number of JPEG_1X8), not the size it would be
>in a raw format.

In VIDIOC_S_FMT 'sizeimage' specifies size of the buffer for the
compressed frame at the bridge driver side. And width/height should
specify size of the re-sampled (binning, skipping ?) frame - CxD,
if I understand what  you are saying correctly.

I don't quite what transformation is done at CxD -> ExF. Why you are
using ExF (two numbers) to specify number of bytes ? And how can you
know exactly beforehand what is the frame size after compression ?
Does the sensor transmit fixed number of bytes per frame, by adding
some padding bytes if required to the compressed frame data ?

Is it something like:

sensor matrix (AxB pixels) -> binning/skipping (CxD pixels) ->
-> JPEG compresion (width = C, height = D, sizeimage ExF bytes)

?
> This allows the bridge driver to be compression agnostic.  It gets
>told how many bytes to allocate per buffer and it reads that many
>bytes.  It doesn't have to understand that the number of bytes isn't
>directly related to the number of pixels.
>
> So how does the user tell the driver what size image to capture
>before compression, CxD?

I think you should use VIDIOC_S_FMT(width = C, height = D, sizeimage = ExF)
for that. And s_frame_desc sudev op could be used to pass sizeimage to the
sensor subdev driver.

> (or alternatively, if you disagree and think CxD should be specified
>by s_fmt(), then how does the user specify ExF?)

Regards,
Sylwester
