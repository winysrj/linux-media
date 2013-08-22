Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:65341 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3HVQIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 12:08:14 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Thu, 22 Aug 2013 16:08:11 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F054C634E6B@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local>
 <51EF9EAD.4010804@samsung.com>
 <A683633ABCE53E43AFB0344442BF0F054C632AA7@server10.irisys.local>
 <20130821133413.GF20717@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130821133413.GF20717@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 21 August 2013 14:34, Sakari Ailus wrote:
> On Tue, Aug 06, 2013 at 04:26:56PM +0000, Thomas Vajzovic wrote:
>> On 24 July 2013 10:30 Sylwester Nawrocki wrote:
>>> On 07/22/2013 10:40 AM, Thomas Vajzovic wrote:
>>>> On 21 July 2013 21:38 Sylwester Nawrocki wrote:
>>>>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>>>>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>>>
>>>>>>>> The hardware reads AxB sensor pixels from its array, resamples
>>>>>>>> them to CxD image pixels, and then compresses them to ExF bytes.
>>>>
>>>> If the sensor driver is only told the user's requested sizeimage,
>>>> it can be made to factorize (ExF) into (E,F) itself, but then both
>>>> the parallel interface and the 2D DMA peripheral need to be told
>>>> the particular factorization that it has chosen.
>>>>
>>>> If the user requests sizeimage which cannot be satisfied (eg: a
>>>> prime
>>>> number) then it will need to return (E,F) to the bridge driver
>>>> which does not multiply exactly to sizeimage.  Because of this the
>>>> bridge driver must set the corrected value of sizeimage which it
>>>> returns to userspace to the product ExF.
>>>
>>> Ok, let's consider following data structure describing the frame:
>>>
>>> struct v4l2_frame_desc_entry {
>>>   u32 flags;
>>>   u32 pixelcode;
>>>   u32 samples_per_line;
>>>   u32 num_lines;
>>>   u32 size;
>>> };
>>>
>>> I think we could treat the frame descriptor to be at lower lever in
>>> the protocol stack than struct v4l2_mbus_framefmt.
>>>
>>> Then the bridge would set size and pixelcode and the subdev would
>>> return (E, F) in (samples_per_frame, num_lines) and adjust size if
>>> required. Number of bits per sample can be determined by pixelcode.
>>>
>>> It needs to be considered that for some sensor drivers it might not
>>> be immediately clear what samples_per_line, num_lines values are.
>>> In such case those fields could be left zeroed and bridge driver
>>> could signal such condition as a more or less critical error. In end
>>> of the day specific sensor driver would need to be updated to
>>> interwork with a bridge that requires samples_per_line, num_lines.
>>
>> I think we ought to try to consider the four cases:
>>
>> 1D sensor and 1D bridge: already works
>>
>> 2D sensor and 2D bridge: my use case
>>
>> 1D sensor and 2D bridge, 2D sensor and 1D bridge:
>
> Are there any bridge devices that CANNOT receive 2D images? I've
> never seen any.

I meant "bridge with 1D DMA".

>> Perhaps both of these cases could be made to work by setting:
>> num_lines = 1; samples_per_line = ((size * 8) / bpp);
>>
>> (Obviously this would also require the appropriate pull-up/down on the
>> second sync input on a 2D bridge).
>
> And typically also 2D-only bridges have very limited maximum image
> width which is unsuitable for any decent images. I'd rather like to
> only support cases that we actually have right now.

That makes sense.  I would make a small change though:

I think your proposed structure and protocol has redundant data
which could lead to ambiguity.

Perhaps the structure should only have size and samples_per_line.
If the subdev supports 2D output of a compressed stream then it examines
size, and sets samples_per_line and adjusts size.  If not then it
may still adjust size but leaves samples_per_line zeroed.  As you said
if the bridge finds samples_per_line still zeroed and it needs it then
it will have to give up.  If it has a non-zero samples_per_line then it
can divide to find num_lines.

>>> Not sure if we need to add image width and height in pixels to the
>>> above structure. It wouldn't make much sensor when single frame
>>> carries multiple images, e.g. interleaved YUV and compressed image
>>> data at different resolutions.
>>
>> If image size were here then we are duplicating get_fmt/set_fmt.
>> But then, by having pixelcode here we are already duplicating part of
>> get_fmt/set_fmt.  If the bridge changes pixelcode and calls
>
> Pixelcode would be required to tell which other kind of data is
> produced by the device. But I agree in principle --- there could
> (theoretically) be multiple pixelcodes that you might want to
> configure on a sensor. We don't have a way to express that currently.

I wasn't thinking that set_frame_desc should be able to configure
currently unselected pixelcodes, quite the contrary, I would expect
that the pad should have a selected pixelcode, set by set_mbus_fmt,
so having pixelcode in frame_desc_entry is extra duplication, I don't
know why it is there.

> Do you have an example of something you'd like to set (or try) in frame
> descriptors outside struct v4l2_subdev_format?

I only have a need to try/set the buffersize which is tried/set by
userspace.


Best regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
