Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:52454 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab3GWQHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 12:07:50 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Tue, 23 Jul 2013 16:07:48 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F0536169EC7@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>,<51D876DF.90507@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F0536167CCB@server10.irisys.local>
 <51DDB97C.7060505@gmail.com>
 <A683633ABCE53E43AFB0344442BF0F05361689C0@server10.irisys.local>
 <51EDA87C.10800@gmail.com>
In-Reply-To: <51EDA87C.10800@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 22 July 2013 22:48 Sylwester Nawrocki wrote:
> On 07/15/2013 11:18 AM, Thomas Vajzovic wrote:
>> On 10 July 2013 20:44 Sylwester Nawrocki wrote:
>>> On 07/07/2013 10:18 AM, Thomas Vajzovic wrote:
>>>> On 06 July 2013 20:58 Sylwester Nawrocki wrote:
>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>>
>>>>>> The hardware reads AxB sensor pixels from its array, resamples
>>>>>> them to CxD image pixels, and then compresses them to ExF bytes.
>>>>
>>>> Yes you are correct that the sensor zero pads the compressed data to
>>>> a fixed size.  That size must be specified in two separate
>>>> registers, called spoof width and spoof height.  Above CxD is the
>>>> image size after binning/skipping and resizing, ExF is the spoof size.
>
> All right. We need to make it clear that the format on video node
> refers to data in memory, while media bus format/frame descriptor
> specifies how data is transmitted on the physical bus. When there is
> scaling, etc. involved on the bridge side relations between the two
> are not that straightforward. sizeimage / bytesperline needs to be
> translatable to frame descriptor/media bus format information and the
> other way around.

I'm not sure that translating them is reasonable.  The image width and
height are one thing, and the data size (whether 1D or 2D) is another
thing.  They just need to be expressed explicitly.

>> Secondly, the pair of numbers (E,F) in my case have exaclty the same
>> meaning and are used in exactly the same way as the single number
>> (sizeimage) which is used in the cameras that use the current API.
>> Logically the two numbers should be passed around and set and modified
>> in all the same places that sizeimage currently is, but as a tuple.
>> The two cannot be separated with one set using one API and the other a
>> different API.
>
> Sure, we just need to think of how to express (E, F) in the frame
> descriptors API and teach the bridge driver to use it. As Sakari
> mentioned width, height and bpp is probably going to be sufficient.

Bits-per-image-pixel is variable, but I assume you mean "average-
bits-per-image-pixel".  This is confusing and inexact:  What if the
user wants to compress 800x600 to 142kB? then bpp = 2.4234667.
This number doesn't really mean very much, and how would you express
it so that the bridge always get exact pair of integers that the sensor
chose without rounding error?  I suggest that the clean and sensible
solution is to explicitly express physical width, with physical-bits-
per-pixel = always 8 (assuming FMT_JPEG_1X8).

Many thanks for your time on this.  Please see also my reply at
Mon 22/07/2013 09:41.

> Your proposal above sounds sane, I've seen already 1D/2D DMA notations
> in some documentation. Is datasheet of your bridge device available
> publicly ? Which Blackfin processor is that ?

http://www.analog.com/static/imported-files/processor_manuals/ADSP-BF51x_hwr_rev1.2.pdf

Best regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk

Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
