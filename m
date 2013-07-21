Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50038 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3GUUiX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 16:38:23 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so2235993bkc.30
        for <linux-media@vger.kernel.org>; Sun, 21 Jul 2013 13:38:21 -0700 (PDT)
Message-ID: <51EC46BA.4050203@gmail.com>
Date: Sun, 21 Jul 2013 22:38:18 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local> <51D876DF.90507@gmail.com> <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/19/2013 10:28 PM, Sakari Ailus wrote:
> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>> Hello,
>>>
>>> I am writing a driver for the sensor MT9D131.  This device supports
>>> digital zoom and JPEG compression.
>>>
>>> Although I am writing it for my company's internal purposes, it will
>>> be made open-source, so I would like to keep the API as portable as
>>> possible.
>>>
>>> The hardware reads AxB sensor pixels from its array, resamples them
>>> to CxD image pixels, and then compresses them to ExF bytes.
>>>
>>> The subdevice driver sets size AxB to the value it receives from
>>> v4l2_subdev_video_ops.s_crop().
>>>
>>> To enable compression then v4l2_subdev_video_ops.s_mbus_fmt() is
>>> called with fmt->code=V4L2_MBUS_FMT_JPEG_1X8.
>>>
>>> fmt->width and fmt->height then ought to specify the size of the
>>> compressed image ExF, that is, the size specified is the size in the
>>> format specified (the number of JPEG_1X8), not the size it would be
>>> in a raw format.
>>
>> In VIDIOC_S_FMT 'sizeimage' specifies size of the buffer for the
>> compressed frame at the bridge driver side. And width/height should
>> specify size of the re-sampled (binning, skipping ?) frame - CxD,
>> if I understand what  you are saying correctly.
>>
>> I don't quite what transformation is done at CxD ->  ExF. Why you are
>> using ExF (two numbers) to specify number of bytes ? And how can you
>> know exactly beforehand what is the frame size after compression ?
>> Does the sensor transmit fixed number of bytes per frame, by adding
>> some padding bytes if required to the compressed frame data ?
>>
>> Is it something like:
>>
>> sensor matrix (AxB pixels) ->  binning/skipping (CxD pixels) ->
>> ->  JPEG compresion (width = C, height = D, sizeimage ExF bytes)
>>
>> ?
>>> This allows the bridge driver to be compression agnostic.  It gets
>>> told how many bytes to allocate per buffer and it reads that many
>>> bytes.  It doesn't have to understand that the number of bytes isn't
>>> directly related to the number of pixels.
>>>
>>> So how does the user tell the driver what size image to capture
>>> before compression, CxD?
>>
>> I think you should use VIDIOC_S_FMT(width = C, height = D, sizeimage = ExF)
>> for that. And s_frame_desc sudev op could be used to pass sizeimage to the
>> sensor subdev driver.
>
> Agreed. Let me take this into account in the next RFC.

Thanks.

>>> (or alternatively, if you disagree and think CxD should be specified
>>> by s_fmt(), then how does the user specify ExF?)
>
> Does the user need to specify ExF, for other purposes than limiting the size
> of the image? I would leave this up to the sensor driver (with reasonable
> alignment). The sensor driver would tell about this to the receiver through

AFAIU ExF is closely related to the memory buffer size, so the sensor driver
itself wouldn't have enough information to fix up ExF, would it ?

> frame descriptors. (But still I don't think frame descriptors should be
> settable; what sensors can support is fully sensor specific and the
> parameters that typically need to be changed are quite limited in numbers.
> So I'd go with e.g. controls, again.)

I agree it would have been much more clear to have read only frame 
descriptors
outside of the subdev. But the issue with controls is that it would have
been difficult to define same parameter for multiple logical stream on the
data bus. And data interleaving is a standard feature, it is well 
defined in
the MIPI CSI-2 specification.

So my feeling is that we would be better off with data structure and
a callback, rather than creating multiple strange controls.

However if we don't use media bus format callbacks, nor frame descriptor
callbacks, then what ?... :) It sounds reasonable to me to have frame
frame descriptor defined by the sensor (data source) based on media bus
format, frame interval, link frequency, etc. Problematic seem to be
parameters that are now handled on the video node side, like, e.g. buffer
size.

--
Regards,
Sylwester
