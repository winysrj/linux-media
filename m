Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:60896 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3HFQ1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 12:27:01 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Tue, 6 Aug 2013 16:26:56 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F054C632AA7@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local>
 <51EF9EAD.4010804@samsung.com>
In-Reply-To: <51EF9EAD.4010804@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 24 July 2013 10:30 Sylwester Nawrocki wrote:
> On 07/22/2013 10:40 AM, Thomas Vajzovic wrote:
>> On 21 July 2013 21:38 Sylwester Nawrocki wrote:
>>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>
>>>>>> The hardware reads AxB sensor pixels from its array, resamples
>>>>>> them to CxD image pixels, and then compresses them to ExF bytes.
>>
>> If the sensor driver is only told the user's requested sizeimage, it
>> can be made to factorize (ExF) into (E,F) itself, but then both the
>> parallel interface and the 2D DMA peripheral need to be told the
>> particular factorization that it has chosen.
>>
>> If the user requests sizeimage which cannot be satisfied (eg: a prime
>> number) then it will need to return (E,F) to the bridge driver which
>> does not multiply exactly to sizeimage.  Because of this the bridge
>> driver must set the corrected value of sizeimage which it returns to
>> userspace to the product ExF.
>
> Ok, let's consider following data structure describing the frame:
>
> struct v4l2_frame_desc_entry {
>   u32 flags;
>   u32 pixelcode;
>   u32 samples_per_line;
>   u32 num_lines;
>   u32 size;
> };
>
> I think we could treat the frame descriptor to be at lower lever in
> the protocol stack than struct v4l2_mbus_framefmt.
>
> Then the bridge would set size and pixelcode and the subdev would
> return (E, F) in (samples_per_frame, num_lines) and adjust size if
> required. Number of bits per sample can be determined by pixelcode.
>
> It needs to be considered that for some sensor drivers it might not
> be immediately clear what samples_per_line, num_lines values are.
> In such case those fields could be left zeroed and bridge driver
> could signal such condition as a more or less critical error. In
> end of the day specific sensor driver would need to be updated to
> interwork with a bridge that requires samples_per_line, num_lines.

I think we ought to try to consider the four cases:

1D sensor and 1D bridge: already works

2D sensor and 2D bridge: my use case

1D sensor and 2D bridge, 2D sensor and 1D bridge:
Perhaps both of these cases could be made to work by setting:
num_lines = 1; samples_per_line = ((size * 8) / bpp);

(Obviously this would also require the appropriate pull-up/down
on the second sync input on a 2D bridge).

Since the frame descriptor interface is still new and used in so
few drivers, is it reasonable to expect them all to be fixed to
do this?

> Not sure if we need to add image width and height in pixels to the
> above structure. It wouldn't make much sensor when single frame
> carries multiple images, e.g. interleaved YUV and compressed image
> data at different resolutions.

If image size were here then we are duplicating get_fmt/set_fmt.
But then, by having pixelcode here we are already duplicating part
of get_fmt/set_fmt.  If the bridge changes pixelcode and calls
set_frame_desc then is this equivalent to calling set_fmt?
I would like to see as much data normalization as possible and
eliminate the redundancy.

>> Whatever mechanism is chosen needs to have corresponding get/set/try
>> methods to be used when the user calls
>> VIDIOC_G_FMT/VIDIOC_S_FMT/VIDIOC_TRY_FMT.
>
> Agreed, it seems we need some sort of negotiation of those low
> level parameters.

Should there be set/get/try function pointers, or should the struct
include an enum member like v4l2_subdev_format.which to determine
which operation is to be perfomed?

Personally I think that it is a bit ugly having two different
function pointers for set_fmt/get_fmt but then a structure member
to determine between set/try.  IMHO it should be three function
pointers or one function with a three valued enum in the struct.

Best regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
