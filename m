Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:51097 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3GVIkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 04:40:51 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Mon, 22 Jul 2013 08:40:48 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F05361697BA@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
In-Reply-To: <51EC46BA.4050203@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 21 July 2013 21:38 Sylwester Nawrocki wrote:
>On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>
>>>> The hardware reads AxB sensor pixels from its array, resamples them
>>>> to CxD image pixels, and then compresses them to ExF bytes.
>>>
>>> I think you should use VIDIOC_S_FMT(width = C, height = D, sizeimage
>>> = ExF) for that. And s_frame_desc sudev op could be used to pass
>>> sizeimage to the sensor subdev driver.
>>
>> Agreed. Let me take this into account in the next RFC.


I agree that in my use case the user only needs to be able to specify
sizeimage, and then be told in response what the adjusted value of
sizeimage is.


>> Does the user need to specify ExF, for other purposes than limiting
>> the size of the image? I would leave this up to the sensor driver
>> (with reasonable alignment). The sensor driver would tell about this
>> to the receiver through
>
> AFAIU ExF is closely related to the memory buffer size, so the sensor
> driver itself wouldn't have enough information to fix up ExF, would
>  it ?


If the sensor driver is only told the user's requested sizeimage, it
can be made to factorize (ExF) into (E,F) itself, but then both the
parallel interface and the 2D DMA peripheral need to be told the
particular factorization that it has chosen.

Eg: if the user requests images of 8K, then the bridge needs to know
that they will come out as 10 lines of 800 bytes.

If the user requests sizeimage which cannot be satisfied (eg: a prime
number) then it will need to return (E,F) to the bridge driver which
does not multiply exactly to sizeimage.  Because of this the bridge
driver must set the corrected value of sizeimage which it returns
to userspace to the product ExF.

Eg: if the user requests sizeimage = 1601, then the sensor cannot
provide 1601x1 (width exceeds internal FIFO), it will have to tell
the bridge that it will give 800x2 or 801x2.  The userspace needs to
be told that sizeimage was adjusted to 1600 or 1602 because there are
data fields aligned to the end of the data.

(BTW, would you suggest rounding up or down in this case? If the user
knew how much memory that an embedded system had available and
specified sizeimage to the maximum, then rounding up might result in
failed allocation.  But then, if the user knows how much entropy-coded
JPEG data to expect, then rounding down might result in truncated
frames that have to be dropped.)


>> frame descriptors. (But still I don't think frame descriptors should
>> be settable; what sensors can support is fully sensor specific and the
>> parameters that typically need to be changed are quite limited in numbers.
>> So I'd go with e.g. controls, again.)
>
> I agree it would have been much more clear to have read only frame
> descriptors outside of the subdev. But the issue with controls is that
> it would have been difficult to define same parameter for multiple
> logical stream on the data bus. And data interleaving is a standard
> feature, it is well defined in the MIPI CSI-2 specification.

> So my feeling is that we would be better off with data structure and a
> callback, rather than creating multiple strange controls.

> However if we don't use media bus format callbacks, nor frame descriptor
> callbacks, then what ?... :) It sounds reasonable to me to have frame
> frame descriptor defined by the sensor (data source) based on media bus
> format, frame interval, link frequency, etc. Problematic seem to be
> parameters that are now handled on the video node side, like, e.g.
> buffer size.

I think that this is definitely not a candidate for using controls.
I think that whatever mechanism is used for setting sizemage on
JPEG sensors with 1D DMA, then the same mechanism needs to be extended
for this case.  Currently this is frame descriptors.

Whatever mechanism is chosen needs to have corresponding get/set/try
methods to be used when the user calls
VIDIOC_G_FMT/VIDIOC_S_FMT/VIDIOC_TRY_FMT.

Regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
