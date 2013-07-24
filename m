Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17226 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3GXIjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 04:39:14 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQF00JD6MN7OF20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Jul 2013 09:39:12 +0100 (BST)
Message-id: <51EF92AF.7040205@samsung.com>
Date: Wed, 24 Jul 2013 10:39:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: width and height of JPEG compressed images
References: <A683633ABCE53E43AFB0344442BF0F0536167B8A@server10.irisys.local>
 <51D876DF.90507@gmail.com> <20130719202842.GC11823@valkosipuli.retiisi.org.uk>
 <51EC46BA.4050203@gmail.com>
 <20130723222106.GB12281@valkosipuli.retiisi.org.uk>
 <A683633ABCE53E43AFB0344442BF0F053616A13A@server10.irisys.local>
In-reply-to: <A683633ABCE53E43AFB0344442BF0F053616A13A@server10.irisys.local>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/24/2013 09:47 AM, Thomas Vajzovic wrote:
>  On 23 July 2013 23:21 Sakari Ailus wrote:
>> On Sun, Jul 21, 2013 at 10:38:18PM +0200, Sylwester Nawrocki wrote:
>>> On 07/19/2013 10:28 PM, Sakari Ailus wrote:
>>>> On Sat, Jul 06, 2013 at 09:58:23PM +0200, Sylwester Nawrocki wrote:
>>>>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
>>>>>
>>>>>> The hardware reads AxB sensor pixels from its array, resamples them
>>>>>> to CxD image pixels, and then compresses them to ExF bytes.
>>>>>>
>>>>> sensor matrix (AxB pixels) ->  binning/skipping (CxD pixels) ->
>>>>> ->  JPEG compresion (width = C, height = D, sizeimage ExF bytes)
>>>>
>>>> Does the user need to specify ExF, for other purposes than limiting
>>>> the size of the image? I would leave this up to the sensor driver
>>>> (with reasonable alignment). The sensor driver would tell about this
>>>> to the receiver through
>>>
>>> AFAIU ExF is closely related to the memory buffer size, so the sensor
>>> driver itself wouldn't have enough information to fix up ExF, would it ?
>>
>> If the desired sizeimage is known, F can be calculated if E is fixed, say
>> 1024 should probably work for everyone, shoulnd't it?
> 
> It's a nice clean idea (and I did already consider it) but it reduces the
> flexibility of the system as a whole.
> 
> Suppose an embedded device wants to send the compressed image over a
> network in packets of 1500 bytes, and they want to allow 3 packets per
> frame.  Your proposal limits sizeimage to a multiple of 1K, so they have
> to set sizeimage to 4K when they want 4.5K, meaning that they waste 500
> bytes of bandwidth every frame.
> 
> You could say "tough luck, extra overhead like this is something you should
> expect if you want to use a general purpose API like V4L2", but why make
> it worse if we can make it better?

I entirely agree with that. Other issue with fixed number of samples
per line is that internal (FIFO) line buffer size of the transmitter
devices will vary, and for example some devices might have line buffer
smaller than the value we have arbitrarily chosen. I'd expect the
optimal number of samples per line to vary among different devices
and use cases.


Regards,
Sylwester
