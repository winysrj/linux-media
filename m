Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34383 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753487AbdBFQAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 11:00:43 -0500
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
To: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net>
 <f7f6bed9-b6c9-48cd-814d-9a2f4afe0a8b@xs4all.nl>
 <4cb2ee48-0033-b5ac-bbed-80aa119ee9f5@destevenson.freeserve.co.uk>
 <2cf0d891-55a1-4917-8411-b216ca7544a0@xs4all.nl>
 <05af3466-704f-6beb-7650-208d548a5bbc@destevenson.freeserve.co.uk>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <92d0017b-0156-06ab-1884-59708ad1b91a@xs4all.nl>
Date: Mon, 6 Feb 2017 17:00:33 +0100
MIME-Version: 1.0
In-Reply-To: <05af3466-704f-6beb-7650-208d548a5bbc@destevenson.freeserve.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2017 04:21 PM, Dave Stevenson wrote:
> Hi Hans.
> 
> On 06/02/17 12:58, Hans Verkuil wrote:
>> On 02/06/2017 12:37 PM, Dave Stevenson wrote:
>>> Hi Hans.
>>>
>>> On 06/02/17 09:08, Hans Verkuil wrote:
>>>> Hi Eric,
>>>>
>>>> Great to see this driver appearing for upstream merging!
>>>>
>>>> See below for my review comments, focusing mostly on V4L2 specifics.
>>>>
> 
> <snip>
> 
>>>>> +	f->fmt.pix.pixelformat = dev->capture.fmt->fourcc;
>>>>> +	f->fmt.pix.bytesperline = dev->capture.stride;
>>>>> +	f->fmt.pix.sizeimage = dev->capture.buffersize;
>>>>> +
>>>>> +	if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_RGB24)
>>>>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>>>>> +	else if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_JPEG)
>>>>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>>>>> +	else
>>>>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>>>>
>>>> Colorspace has nothing to do with the pixel format. It should come from the
>>>> sensor/video receiver.
>>>>
>>>> If this information is not available, then COLORSPACE_SRGB is generally a
>>>> good fallback.
>>>
>>> I would if I could, but then I fail v4l2-compliance on V4L2_PIX_FMT_JPEG
>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-formats.cpp#n329
>>> The special case for JPEG therefore has to remain.
>>
>> Correct. Sorry, my fault, I forgot about that.
>>
>>>
>>> It looks like I tripped over the subtlety between V4L2_COLORSPACE_,
>>> V4L2_XFER_FUNC_, V4L2_YCBCR_ENC_, and V4L2_QUANTIZATION_, and Y'CbCr
>>> encoding vs colourspace.
>>>
>>> The ISP coefficients are set up for BT601 limited range, and any
>>> conversion back to RGB is done based on that. That seemed to fit
>>> SMPTE170M rather than SRGB.
>>
>> Colorspace refers to the primary colors + whitepoint that are used to
>> create the colors (basically this answers the question to which colors
>> R, G and B exactly refer to). The SMPTE170M has different primaries
>> compared to sRGB (and a different default transfer function as well).
>>
>> RGB vs Y'CbCr is just an encoding and it doesn't change the underlying
>> colorspace. Unfortunately, the term 'colorspace' is often abused to just
>> refer to RGB vs Y'CbCr.
>>
>> If the colorspace is SRGB, then when the pixelformat is a Y'CbCr encoding,
>> then the BT601 limited range encoding is implied, unless overridden via
>> the ycbcr_enc and/or quantization fields in struct v4l2_pix_format.
>>
>> In other words, this does already the right thing.
> 
> https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-007.html#colorspace-srgb-v4l2-colorspace-srgb
> "The default transfer function is V4L2_XFER_FUNC_SRGB. The default 
> Y’CbCr encoding is V4L2_YCBCR_ENC_601. The default Y’CbCr quantization 
> is full range."
> So full range or limited?

Ah, good catch. The default range for SRGB is full range, so the documentation
is correct. This is according to the sYCC standard.

This means that you need to set the quantization field to limited range in this driver.

Sorry for the confusion I caused.

Interesting, I should take a look at other drivers since I suspect that this is
signaled wrong elsewhere as well. It used to be limited range but I changed it
to full range (as per the sYCC spec). But in practice it is limited range in most
cases.

I'll take another look at this on Friday.

I recommend that you leave the code as is for now.

Regards,

	Hans

>>> Test input 0:
>>>
>>> 	Control ioctls:
>>> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>> 		test VIDIOC_QUERYCTRL: OK
>>> 		test VIDIOC_G/S_CTRL: OK
>>> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>> 		Standard Controls: 33 Private Controls: 0
>>>
>>> 	Format ioctls:
>>> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>> 		test VIDIOC_G/S_PARM: OK
>>> 		test VIDIOC_G_FBUF: OK
>>> 		test VIDIOC_G_FMT: OK
>>> 		test VIDIOC_TRY_FMT: OK
>>> 		test VIDIOC_S_FMT: OK
>>> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>> 		test Cropping: OK (Not Supported)
>>> 		test Composing: OK (Not Supported)
>>> 		test Scaling: OK
>>
>> Is scaling supported? Just checking.
> 
> The cropping/composing/scaling API is not currently supported.
> The hardware can do it, but I need to work out how it should be set up, 
> and what resolutions to quote via V4L2_SEL_TGT_CROP_BOUNDS and similar. 
> It just needs a bit of time.

OK. This needs some attention before it can be moved out of staging.

Regards,

	Hans

> 
>>>
>>> 	Codec ioctls:
>>> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>>
>>> 	Buffer ioctls:
>>> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>> 		test VIDIOC_EXPBUF: OK (Not Supported)
>>>
>>> Test input 0:
>>>
>>>
>>> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
>>
>> Note that v4l2-compliance does very limited testing of overlay handling.
>> You should test this manually to make sure it functions properly.
> 
> OK, thanks for the heads up. It's not one that gets used that often in 
> the wild either from what I can tell.
> 
>> Regards,
>>
>> 	Hans
> 
> Thanks,
>    Dave
> 

