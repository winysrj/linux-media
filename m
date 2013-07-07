Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:58586 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3GGISb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 04:18:31 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Sun, 7 Jul 2013 08:18:25 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F0536167CCB@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>,<51D876DF.90507@gmail.com>
In-Reply-To: <51D876DF.90507@gmail.com>
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 06 July 2013 20:58 Sylwester Nawrocki wrote:
> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>
>> I am writing a driver for the sensor MT9D131.  This device supports
>> digital zoom and JPEG compression.
>>
>> The hardware reads AxB sensor pixels from its array, resamples them
>> to CxD image pixels, and then compresses them to ExF bytes.
>>
>> fmt->width and fmt->height then ought to specify the size of the
>> compressed image ExF, that is, the size specified is the size in the
>> format specified (the number of JPEG_1X8), not the size it would be
>> in a raw format.
>
> In VIDIOC_S_FMT 'sizeimage' specifies size of the buffer for the
> compressed frame at the bridge driver side. And width/height should
> specify size of the re-sampled (binning, skipping ?) frame - CxD,
> if I understand what  you are saying correctly.
>
> I don't quite what transformation is done at CxD -> ExF. Why you are
> using ExF (two numbers) to specify number of bytes ? And how can you
> know exactly beforehand what is the frame size after compression ?
> Does the sensor transmit fixed number of bytes per frame, by adding
> some padding bytes if required to the compressed frame data ?
>
> Is it something like:
>
> sensor matrix (AxB pixels) -> binning/skipping (CxD pixels) ->
> -> JPEG compresion (width = C, height = D, sizeimage ExF bytes)
>
> I think you should use VIDIOC_S_FMT(width = C, height = D,
> sizeimage = ExF) for that. And s_frame_desc sudev op could be used to
> pass sizeimage to the sensor subdev driver.

Yes you are correct that the sensor zero pads the compressed data to a
fixed size.  That size must be specified in two separate registers,
called spoof width and spoof height.  Above CxD is the image size after
binning/skipping and resizing, ExF is the spoof size.

The reason for two numbers for the number of bytes is that as the
sensor outputs the JPEG bytes the VSYNC and HSYNC lines behave as
though they were still outputting a 2D image with 8bpp.  This means
that no changes are required in the bridge hardware.  I am trying to
make it so very few changes are required in the bridge driver too.
As far as the bridge driver is concerned the only size is ExF, it is
unconcerned with CxD.

I somehow overlooked the member sizeimage.  Having re-read the
documentation I think that in the user<->bridge device the interface
is clear:

v4l2_pix_format.width        = C;
v4l2_pix_format.height       = D;
v4l2_pix_format.bytesperline = E;
v4l2_pix_format.sizeimage    = (E * F);

bytesperline < width
(sizeimage % bytesperline) == 0
(sizeimage / bytesperline) < height

But the question now is how does the bridge device communicate this to
the I2C subdevice?  v4l2_mbus_framefmt doesn't have bytesperline or
sizeimage, and v4l2_mbus_frame_desc_entry has only length (which I
presume is sizeimage) but not both dimensions.

Thanks,
Tom
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
