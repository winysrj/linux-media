Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57688 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3HaW0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 18:26:00 -0400
Received: by mail-ee0-f54.google.com with SMTP id e53so1605719eek.13
        for <linux-media@vger.kernel.org>; Sat, 31 Aug 2013 15:25:59 -0700 (PDT)
Message-ID: <52226D74.9050501@gmail.com>
Date: Sun, 01 Sep 2013 00:25:56 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local> <51D876DF.90507@gmail.com> <20130719202842.GC11823@valkosipuli.retiisi.org.uk> <51EC46BA.4050203@gmail.com> <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local> <51EF9EAD.4010804@samsung.com> <A683633ABCE53E43AFB0344442BF0F054C632AA7@server10.irisys.local>
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F054C632AA7@server10.irisys.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

I sincerely apologise for not having replied earlier. Looks like I'm
being pulled in too many directions. :/

On 08/06/2013 06:26 PM, Thomas Vajzovic wrote:
> On 24 July 2013 10:30 Sylwester Nawrocki wrote:
>> On 07/22/2013 10:40 AM, Thomas Vajzovic wrote:
>>> On 21 July 2013 21:38 Sylwester Nawrocki wrote:
>>>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>>>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>>
>>>>>>> The hardware reads AxB sensor pixels from its array, resamples
>>>>>>> them to CxD image pixels, and then compresses them to ExF bytes.
>>>
>>> If the sensor driver is only told the user's requested sizeimage, it
>>> can be made to factorize (ExF) into (E,F) itself, but then both the
>>> parallel interface and the 2D DMA peripheral need to be told the
>>> particular factorization that it has chosen.
>>>
>>> If the user requests sizeimage which cannot be satisfied (eg: a prime
>>> number) then it will need to return (E,F) to the bridge driver which
>>> does not multiply exactly to sizeimage.  Because of this the bridge
>>> driver must set the corrected value of sizeimage which it returns to
>>> userspace to the product ExF.
>>
>> Ok, let's consider following data structure describing the frame:
>>
>> struct v4l2_frame_desc_entry {
>>    u32 flags;
>>    u32 pixelcode;
>>    u32 samples_per_line;
>>    u32 num_lines;
>>    u32 size;
>> };
>>
>> I think we could treat the frame descriptor to be at lower lever in
>> the protocol stack than struct v4l2_mbus_framefmt.
>>
>> Then the bridge would set size and pixelcode and the subdev would
>> return (E, F) in (samples_per_frame, num_lines) and adjust size if
>> required. Number of bits per sample can be determined by pixelcode.
>>
>> It needs to be considered that for some sensor drivers it might not
>> be immediately clear what samples_per_line, num_lines values are.
>> In such case those fields could be left zeroed and bridge driver
>> could signal such condition as a more or less critical error. In
>> end of the day specific sensor driver would need to be updated to
>> interwork with a bridge that requires samples_per_line, num_lines.
>
> I think we ought to try to consider the four cases:
>
> 1D sensor and 1D bridge: already works
>
> 2D sensor and 2D bridge: my use case
>
> 1D sensor and 2D bridge, 2D sensor and 1D bridge:
> Perhaps both of these cases could be made to work by setting:
> num_lines = 1; samples_per_line = ((size * 8) / bpp);
>
> (Obviously this would also require the appropriate pull-up/down
> on the second sync input on a 2D bridge).

So to determine when this has to be done, e.g. we could see that either
num_lines or samples_per_line == 1 ?

> Since the frame descriptor interface is still new and used in so
> few drivers, is it reasonable to expect them all to be fixed to
> do this?

Certainly, I'll be happy to rework those drivers to whatever the
re-designed API, as long as it supports the current functionality.

>> Not sure if we need to add image width and height in pixels to the
>> above structure. It wouldn't make much sensor when single frame
>> carries multiple images, e.g. interleaved YUV and compressed image
>> data at different resolutions.
>
> If image size were here then we are duplicating get_fmt/set_fmt.
> But then, by having pixelcode here we are already duplicating part
> of get_fmt/set_fmt.  If the bridge changes pixelcode and calls
> set_frame_desc then is this equivalent to calling set_fmt?
> I would like to see as much data normalization as possible and
> eliminate the redundancy.

Perhaps we could replace pixelcode in the above struct by something
else that would have conveyed required data. But I'm not sure what it
would have been. Perhaps just bits_per_sample for starters ?

The frame descriptors were also supposed to cover interleaved image data.
Then we need something like pixelcode (MIPI CSI-2 Data Type) in each
frame_desc entry.

Not sure if it would have been sensible to put some of the above
information into struct v4l2_mbus_frame_desc rather than to struct
v4l2_mbus_frame_desc_entry.

>>> Whatever mechanism is chosen needs to have corresponding get/set/try
>>> methods to be used when the user calls
>>> VIDIOC_G_FMT/VIDIOC_S_FMT/VIDIOC_TRY_FMT.
>>
>> Agreed, it seems we need some sort of negotiation of those low
>> level parameters.
>
> Should there be set/get/try function pointers, or should the struct
> include an enum member like v4l2_subdev_format.which to determine
> which operation is to be perfomed?
>
> Personally I think that it is a bit ugly having two different
> function pointers for set_fmt/get_fmt but then a structure member
> to determine between set/try.  IMHO it should be three function
> pointers or one function with a three valued enum in the struct.

I'm fine either way, with a slight preference for three separate callbacks.

WRT to making frame_desc read-only, subdevices for which it doesn't make
sense to set anything could always adjust passed data to their fixed or
depending on other calls, like the pad level set_fmt op, values. And we
seem to have use cases already for at least try_frame_desc.

--
Regards,
Sylwester
