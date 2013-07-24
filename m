Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22048 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3GXJaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 05:30:25 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQF0057MOY99230@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Jul 2013 10:30:22 +0100 (BST)
Message-id: <51EF9EAD.4010804@samsung.com>
Date: Wed, 24 Jul 2013 11:30:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com> <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local>
In-reply-to: <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On 07/22/2013 10:40 AM, Thomas Vajzovic wrote:
> On 21 July 2013 21:38 Sylwester Nawrocki wrote:
>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>
>>>>> The hardware reads AxB sensor pixels from its array, resamples them
>>>>> to CxD image pixels, and then compresses them to ExF bytes.
>>>>
>>>> I think you should use VIDIOC_S_FMT(width = C, height = D, sizeimage
>>>> = ExF) for that. And s_frame_desc sudev op could be used to pass
>>>> sizeimage to the sensor subdev driver.
>>>
>>> Agreed. Let me take this into account in the next RFC.
> 
> 
> I agree that in my use case the user only needs to be able to specify
> sizeimage, and then be told in response what the adjusted value of
> sizeimage is.
> 
> 
>>> Does the user need to specify ExF, for other purposes than limiting
>>> the size of the image? I would leave this up to the sensor driver
>>> (with reasonable alignment). The sensor driver would tell about this
>>> to the receiver through
>>
>> AFAIU ExF is closely related to the memory buffer size, so the sensor
>> driver itself wouldn't have enough information to fix up ExF, would
>>  it ?
> 
> 
> If the sensor driver is only told the user's requested sizeimage, it
> can be made to factorize (ExF) into (E,F) itself, but then both the
> parallel interface and the 2D DMA peripheral need to be told the
> particular factorization that it has chosen.
> 
> Eg: if the user requests images of 8K, then the bridge needs to know
> that they will come out as 10 lines of 800 bytes.
> 
> If the user requests sizeimage which cannot be satisfied (eg: a prime
> number) then it will need to return (E,F) to the bridge driver which
> does not multiply exactly to sizeimage.  Because of this the bridge
> driver must set the corrected value of sizeimage which it returns
> to userspace to the product ExF.
> 
> Eg: if the user requests sizeimage = 1601, then the sensor cannot
> provide 1601x1 (width exceeds internal FIFO), it will have to tell
> the bridge that it will give 800x2 or 801x2.  The userspace needs to
> be told that sizeimage was adjusted to 1600 or 1602 because there are
> data fields aligned to the end of the data.

Ok, let's consider following data structure describing the frame:

struct v4l2_frame_desc_entry {
	u32 flags;
	u32 pixelcode;
	u32 samples_per_line;
	u32 num_lines;
	u32 size;
};	

I think we could treat the frame descriptor to be at lower lever
in the protocol stack than struct v4l2_mbus_framefmt.

Then the bridge would set size and pixelcode and the subdev would
return (E, F) in (samples_per_frame, num_lines) and adjust size
if required. Number of bits per sample can be determined by
pixelcode.

It needs to be considered that for some sensor drivers it might not
be immediately clear what samples_per_line, num_lines values are.
In such case those fields could be left zeroed and bridge driver
could signal such condition as a more or less critical error. In
end of the day specific sensor driver would need to be updated to
interwork with a bridge that requires samples_per_line, num_lines.

Not sure if we need to add image width and height in pixels to the
above structure. It wouldn't make much sensor when single frame
carries multiple images, e.g. interleaved YUV and compressed image
data at different resolutions.

> (BTW, would you suggest rounding up or down in this case? If the user
> knew how much memory that an embedded system had available and
> specified sizeimage to the maximum, then rounding up might result in
> failed allocation.  But then, if the user knows how much entropy-coded
> JPEG data to expect, then rounding down might result in truncated
> frames that have to be dropped.)

I think the sensor should always round up, the bridge can then apply
any upper limits. I wouldn't rely too much on what sizeimage user
space provides in VIDIOC_S_FMT.

>>> frame descriptors. (But still I don't think frame descriptors should
>>> be settable; what sensors can support is fully sensor specific and the
>>> parameters that typically need to be changed are quite limited in numbers.
>>> So I'd go with e.g. controls, again.)
>>
>> I agree it would have been much more clear to have read only frame
>> descriptors outside of the subdev. But the issue with controls is that
>> it would have been difficult to define same parameter for multiple
>> logical stream on the data bus. And data interleaving is a standard
>> feature, it is well defined in the MIPI CSI-2 specification.
> 
>> So my feeling is that we would be better off with data structure and a
>> callback, rather than creating multiple strange controls.
> 
>> However if we don't use media bus format callbacks, nor frame descriptor
>> callbacks, then what ?... :) It sounds reasonable to me to have frame
>> frame descriptor defined by the sensor (data source) based on media bus
>> format, frame interval, link frequency, etc. Problematic seem to be
>> parameters that are now handled on the video node side, like, e.g.
>> buffer size.
> 
> I think that this is definitely not a candidate for using controls.
> I think that whatever mechanism is used for setting sizemage on
> JPEG sensors with 1D DMA, then the same mechanism needs to be extended
> for this case.  Currently this is frame descriptors.
> 
> Whatever mechanism is chosen needs to have corresponding get/set/try
> methods to be used when the user calls
> VIDIOC_G_FMT/VIDIOC_S_FMT/VIDIOC_TRY_FMT.

Agreed, it seems we need some sort of negotiation of those low level
parameters.

--
Regards,
Sylwester
