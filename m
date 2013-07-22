Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63442 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVVrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 17:47:48 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so2665543bkc.21
        for <linux-media@vger.kernel.org>; Mon, 22 Jul 2013 14:47:45 -0700 (PDT)
Message-ID: <51EDA87C.10800@gmail.com>
Date: Mon, 22 Jul 2013 23:47:40 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>,<51D876DF.90507@gmail.com> <A683633ABCE53E43AFB0344442BF0F0536167CCB@server10.irisys.local> <51DDB97C.7060505@gmail.com> <A683633ABCE53E43AFB0344442BF0F05361689C0@server10.irisys.local>
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F05361689C0@server10.irisys.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On 07/15/2013 11:18 AM, Thomas Vajzovic wrote:
> On 10 July 2013 20:44 Sylwester Nawrocki wrote:
>> On 07/07/2013 10:18 AM, Thomas Vajzovic wrote:
>>> On 06 July 2013 20:58 Sylwester Nawrocki wrote:
>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>
>>>>> I am writing a driver for the sensor MT9D131.  This device supports
>>>>> digital zoom and JPEG compression.
>>>>>
>>>>> The hardware reads AxB sensor pixels from its array, resamples them
>>>>> to CxD image pixels, and then compresses them to ExF bytes.
>>>
>>> Yes you are correct that the sensor zero pads the compressed data to a
>>> fixed size.  That size must be specified in two separate registers,
>>> called spoof width and spoof height.  Above CxD is the image size
>>> after binning/skipping and resizing, ExF is the spoof size.
>>>
>>> The reason for two numbers for the number of bytes is that as the
>>> sensor outputs the JPEG bytes the VSYNC and HSYNC lines behave as
>>> though they were still outputting a 2D image with 8bpp.  This means
>>> that no changes are required in the bridge hardware.  I am trying to
>>> make it so very few changes are required in the bridge driver too.
>>> As far as the bridge driver is concerned the only size is ExF, it is
>>> unconcerned with CxD.
>>>
>>> v4l2_pix_format.width        = C;
>>> v4l2_pix_format.height       = D;
>>> v4l2_pix_format.bytesperline = E;
>>> v4l2_pix_format.sizeimage    = (E * F);
>>>
>>> bytesperline<  width
>>> (sizeimage % bytesperline) == 0
>>> (sizeimage / bytesperline)<  height
>>
>> bytesperline has not much meaning for compressed formats at the video
>> device (DMA) driver side.
>
> This is not true for the platform I am using.
>
> The Blackfin has a 2D DMA peripheral, meaning that it does need to
> separately know bytesperline and (sizeimage / bytesperline).

All right. We need to make it clear that the format on video node
refers to data in memory, while media bus format/frame descriptor
specifies how data is transmitted on the physical bus. When there
is scaling, etc. involved on the bridge side relations between the
two are not that straightforward. sizeimage / bytesperline needs to
be translatable to frame descriptor/media bus format information
and the other way around.

> These values have a physical hardware meaning in terms of the signals
> on the sync lines even though they do not have a logical meaning
> because the data is compressed.

Sure, what I'm trying to say is that V4L2 API [1] specifies bytesperline
as
     "Distance in bytes between the leftmost pixels in two adjacent lines".

This is what bytesperline currently means for the user applications.
While sizeimage is defined as:

     "Size in bytes of the buffer to hold a complete image, set by the
     driver. Usually this is bytesperline times height. When the image
     consists of variable length compressed data this is the maximum
     number of bytes required to hold an image."

User space may set sizeimage to an incorrect value and it must be adjusted
to some sane value by the kernel. The capture DMA engine driver need to
be able to query size of the image memory buffer at the sensor driver,
taking into account what the user provided sizeimage was. And it's the
sensor driver that will likely only have sufficient information to
determine buffer size, based on image width, height, etc.

>> For compressed streams like JPEG size of the memory buffer to
>> allocate is normally determined by sizeimage.
>
> It is two numbers in my use case.
>
>> 'bytesperline' could be less than 'width', that means a "virtual"
>> bits-per-pixel factor is less than 8. But this factor could (should?)
>> be configurable e.g. indirectly through V4L2_CID_JPEG_QUALITY control,
>
> This is absolutely not a "virtual" width, it is a real physical property
> of the hardware signal.  The hardware signal always has exactly 8 bits
> per sample, but its height and width (ExF) are not related to the image
> height and width (CxD).
>
> It is not appropriate to group the hardware data size together with
> compression controls for two reasons:
>
> Firstly, the bridge driver would need to intercept the control and then
> pass it on to the bridge driver because they both need to know E and F.

I assume you meant "pass it on to the sensor driver".

What I meant was only that compression parameters have some influence
on the resulting image data size. There is no need to refer directly
to any control on the bridge side, as long as the bridge can get required
information by some other API.

> Secondly, the pair of numbers (E,F) in my case have exaclty the same
> meaning and are used in exactly the same way as the single number
> (sizeimage) which is used in the cameras that use the current API.
> Logically the two numbers should be passed around and set and modified
> in all the same places that sizeimage currently is, but as a tuple.
> The two cannot be separated with one set using one API and the other
> a different API.

Sure, we just need to think of how to express (E, F) in the frame
descriptors API and teach the bridge driver to use it. As Sakari
mentioned width, height and bpp is probably going to be sufficient.

>> and the bridge can query it from the sensor through g_frame_desc subdev
>> op.  The bridge has normally no clue what the compression ratio at the
>> sensor side is.  It could hard code some default "bpp", but then it
>> needs to be ensured the sensor doesn't transmit more data than the size
>> of allocated buffer.
>
> It has no idea what the true compression ratio size is, but it does have
> to know the padded size.  The sensor will always send exactly that size.
>
>>> But the question now is how does the bridge device communicate this to
>>> the I2C subdevice?  v4l2_mbus_framefmt doesn't have bytesperline or
>>> sizeimage, and v4l2_mbus_frame_desc_entry has only length (which I
>>> presume is sizeimage) but not both dimensions.
>>
>> That's a good question. The frame descriptors really need more discussion
>> and improvement, to also cover use cases as your JPEG sensor.
>> Currently it is pretty pre-eliminary stuff, used by just a few drivers.
>> Here is the original RFC from Sakari [1].
>
> The version that has made it to kernel.org is much watered down from this
> proposal.  It could be suitable for doing what I need if an extra member
> were added, or preferably there should be something like:
>
> enum
> {
>    DMA_1D,
>    DMA_2D,
> };
>
> union {
>    struct {  // Valid if DMA_1D
>      u32 size;
>    };
>    struct {  // Valid if DMA_2D
>      u32 width;
>      u32 height;
>    };
> };

I guess size could be computed from width, height and additional bpp field,
when DMA doesn't care much about HSYNC/VSYNC layout. Then we could get rid
of size (length), only bpp/pixelcode relation would need to be clarified.

>> Since we can't add bytesperline/sizeimage to struct v4l2_mbus_framefmt
>
> Isn't this a sensible case for using some of those reserved bytes?

I tried to add framesamples field to this data structure [2], but it wasn't
well received. The downside of such additions is that user space gets 
involved
in passing those additional parameters between subdevs like image sensor,
MIPI CIS-2 receiver and others.

In some cases one would want to add horizontal/vertical blanking 
information,
pixel clock frequency or other parameters that are best handled internally
in the kernel.

Your proposal above sounds sane, I've seen already 1D/2D DMA notations
in some documentation. Is datasheet of your bridge device available
publicly ? Which Blackfin processor is that ?

> If not, why are they there?
>
>> I think struct v4l2_mbus_frame_desc_entry needs to be extended and
>> interaction between subdev ops like video.{s,g}_mbus_fmt,
>> pad.{set,get}_fmt needs to be specified.
>
> Failing adding to v4l2_mbus_framefmt, I agree.

There are reasons for not adding such hardware specific information to
this user visible data structure. Let's leave it alone and try to explore
other possibilities.

> I notice also that there is only set_frame_desc and get_frame_desc, and
> no try_frame_desc.
>
> In the only bridge driver that currently uses this interface,
> fimc-capture, when the user calls VIDIOC_TRY_FMT, then this is
> translated to a call to subdev.set_frame_desc.  Isn't this wrong?  I
> thought that TRY_* was never meant to modify the actual hardware, but
> only fill out the passed structure with what the device would be able
> to do, so don't we need also try_frame_desc?

Yes, you're right. set_frame_desc should never be called from
VIDIOC_TRY_FMT. try_frame_desc could be added and we probably need
to specify some sort of priority which operation (s_frame_desc, set_fmt)
is allowed to freely modify which parameters and what parts of the
frame descriptor data structure should be adjusted to currently set
parameters by some other (user) API.

That might not sound like an ideal solution, but we now have a situation
where some parameters needs to be configured in the kernel while others
are configurable by user, and all those parameters are more or less
dependant on each other.

--
Regards,
Sylwester

[1] http://linuxtv.org/downloads/v4l-dvb-apis/pixfmt.html#v4l2-pix-format
[2] http://www.spinics.net/lists/linux-media/msg41788.html
