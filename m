Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.irisys.co.uk ([195.12.16.217]:65117 "EHLO
	mail.irisys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3HFPZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 11:25:25 -0400
From: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: width and height of JPEG compressed images
Date: Tue, 6 Aug 2013 15:25:20 +0000
Message-ID: <A683633ABCE53E43AFB0344442BF0F054C632A50@server10.irisys.local>
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com>
 <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <20130723222106.GB12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F053616A13A@server10.irisys.local>
 <51EF92AF.7040205@samsung.com>
 <20130726090646.GJ12281@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130726090646.GJ12281@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26 July 2013 10:07 Sakari Ailus wrote:
> On Wed, Jul 24, 2013 at 10:39:11AM +0200, Sylwester Nawrocki wrote:
>> On 07/24/2013 09:47 AM, Thomas Vajzovic wrote:
>>> On 23 July 2013 23:21 Sakari Ailus wrote:
>>>> On Sun, Jul 21, 2013 at 10:38:18PM +0200, Sylwester Nawrocki wrote:
>>>>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>>>>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>>>
>>>>>>>> The hardware reads AxB sensor pixels from its array, resamples
>>>>>>>> them to CxD image pixels, and then compresses them to ExF bytes.
>>>>>>>>
>>>>>>> sensor matrix (AxB pixels) ->  binning/skipping (CxD pixels) ->
>>>>>>> ->  JPEG compresion (width = C, height = D, sizeimage ExF bytes)
>>>>>>
>>>>>> Does the user need to specify ExF, for other purposes than
>>>>>> limiting the size of the image? I would leave this up to the
>>>>>> sensor driver (with reasonable alignment). The sensor driver
>>>>>> would tell about this to the receiver through
>>>>>
>>>>> AFAIU ExF is closely related to the memory buffer size, so the
>>>>> sensor driver itself wouldn't have enough information to fix up ExF, would it ?
>>>>
>>>> If the desired sizeimage is known, F can be calculated if E is
>>>> fixed, say
>>>> 1024 should probably work for everyone, shoulnd't it?
>>>
>>> It's a nice clean idea (and I did already consider it) but it
>>> reduces the flexibility of the system as a whole.
>>>
>>> Suppose an embedded device wants to send the compressed image over a
>>> network in packets of 1500 bytes, and they want to allow 3 packets
>>> per frame.  Your proposal limits sizeimage to a multiple of 1K, so
>>> they have to set sizeimage to 4K when they want 4.5K, meaning that
>>> they waste 500 bytes of bandwidth every frame.
>>>
>>> You could say "tough luck, extra overhead like this is something you
>>> should expect if you want to use a general purpose API like V4L2",
>>> but why make it worse if we can make it better?
>>
>> I entirely agree with that. Other issue with fixed number of samples
>> per line is that internal (FIFO) line buffer size of the transmitter
>> devices will vary, and for example some devices might have line buffer
>> smaller than the value we have arbitrarily chosen. I'd expect the
>> optimal number of samples per line to vary among different devices and
>> use cases.
>
> I guess the sensor driver could factor the size as well (provided it
> can choose an arbitrary size) but then to be fully generic, I think
> alignment must also be taken care of. Many receivers might require
> width to be even but some might have tighter requirements. They have
> a minimum width, too.

> To make this working in a generic case might not be worth the time
> and effort of being able to shave up to 1 kiB off of video buffer
> allocations.

I think that a good enough solution here is that the code within each
sensor driver that does the factorization has to be written to account
for whatever reasonable restrictions that a bridge might require.

Eg: if the userspace requests 49 bytes, it doesn't give back 7x7,
because it knows that some bridges don't like odd numbers.

A sensor driver author would have to do a quick survey of bridges to
see what was likely to be problematic.  A bit of common sense would
solve the vast majority of cases.  After that if the bridge didn't
like what the sensor set, then the whole operation would fail.  The
user would then have to make a feature request to the sensor driver
author saying "can you please tweak it to work with such-a-bridge".

This solution is only slightly more complicated than picking a fixed
width, and I think that the advantage is worth the extra complication.

> Remember v4l2_buffer.length is different from
>  v4l2_pix_format.sizeimage.
> Hmm. Yes --- so to the sensor goes desired maximum size, and back
> you'd get ExF (i.e. buffer length) AND the size of the image.

I really don't understand this last paragraph. Try adding coffee ;-)

Best regards,
Tom

--
Mr T. Vajzovic
Software Engineer
Infrared Integrated Systems Ltd
Visit us at www.irisys.co.uk
Disclaimer: This e-mail message is confidential and for use by the addressee only. If the message is received by anyone other than the addressee, please return the message to the sender by replying to it and then delete the original message and the sent message from your computer. Infrared Integrated Systems Limited Park Circle Tithe Barn Way Swan Valley Northampton NN4 9BG Registration Number: 3186364.
