Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33030 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3GJToA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 15:44:00 -0400
Received: by mail-bk0-f49.google.com with SMTP id mz10so2999734bkb.8
        for <linux-media@vger.kernel.org>; Wed, 10 Jul 2013 12:43:59 -0700 (PDT)
Message-ID: <51DDB97C.7060505@gmail.com>
Date: Wed, 10 Jul 2013 21:43:56 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>,<51D876DF.90507@gmail.com> <A683633ABCE53E43AFB0344442BF0F0536167CCB@server10.irisys.local>
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F0536167CCB@server10.irisys.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On 07/07/2013 10:18 AM, Thomas Vajzovic wrote:
> On 06 July 2013 20:58 Sylwester Nawrocki wrote:
>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>
>>> I am writing a driver for the sensor MT9D131.  This device supports
>>> digital zoom and JPEG compression.
>>>
>>> The hardware reads AxB sensor pixels from its array, resamples them
>>> to CxD image pixels, and then compresses them to ExF bytes.
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
>> I think you should use VIDIOC_S_FMT(width = C, height = D,
>> sizeimage = ExF) for that. And s_frame_desc sudev op could be used to
>> pass sizeimage to the sensor subdev driver.
>
> Yes you are correct that the sensor zero pads the compressed data to a
> fixed size.  That size must be specified in two separate registers,
> called spoof width and spoof height.  Above CxD is the image size after
> binning/skipping and resizing, ExF is the spoof size.
>
> The reason for two numbers for the number of bytes is that as the
> sensor outputs the JPEG bytes the VSYNC and HSYNC lines behave as
> though they were still outputting a 2D image with 8bpp.  This means
> that no changes are required in the bridge hardware.  I am trying to
> make it so very few changes are required in the bridge driver too.
> As far as the bridge driver is concerned the only size is ExF, it is
> unconcerned with CxD.

OK, that sounds good.

> I somehow overlooked the member sizeimage.  Having re-read the
> documentation I think that in the user<->bridge device the interface
> is clear:
>
> v4l2_pix_format.width        = C;
> v4l2_pix_format.height       = D;
> v4l2_pix_format.bytesperline = E;
> v4l2_pix_format.sizeimage    = (E * F);
>
> bytesperline<  width
> (sizeimage % bytesperline) == 0
> (sizeimage / bytesperline)<  height

bytesperline has not much meaning for compressed formats at the video
device (DMA) driver side. For compressed streams like JPEG size of the
memory buffer to allocate is normally determined by sizeimage.

'bytesperline' could be less than 'width', that means a "virtual"
bits-per-pixel factor is less than 8. But this factor could (should?) be
configurable e.g. indirectly through V4L2_CID_JPEG_QUALITY control, and
the bridge can query it from the sensor through g_frame_desc subdev op.
The bridge has normally no clue what the compression ratio at the sensor
side is. It could hard code some default "bpp", but then it needs to be
ensured the sensor doesn't transmit more data than the size of allocated
buffer.

> But the question now is how does the bridge device communicate this to
> the I2C subdevice?  v4l2_mbus_framefmt doesn't have bytesperline or
> sizeimage, and v4l2_mbus_frame_desc_entry has only length (which I
> presume is sizeimage) but not both dimensions.

That's a good question. The frame descriptors really need more discussion
and improvement, to also cover use cases as your JPEG sensor.
Currently it is pretty pre-eliminary stuff, used by just a few drivers.
Here is the original RFC from Sakari [1].

Since we can't add bytesperline/sizeimage to struct v4l2_mbus_framefmt
I think struct v4l2_mbus_frame_desc_entry needs to be extended and
interaction between subdev ops like video.{s,g}_mbus_fmt, pad.{set,get}_fmt
needs to be specified.

As a side note, looking at the MT9D131 sensor datasheet I can see it has
preview (Mode A) and capture (Mode B) modes. Are you also planning adding
proper support for switching between those modes ? I'm interested in
supporting this in standard way in V4L2, as lot's of sensors I have been
working with also support such modes.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg43530.html

--
Regards,
Sylwester
