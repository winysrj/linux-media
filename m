Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43354 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZJEWbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 18:31:13 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Mon, 5 Oct 2009 17:30:30 -0500
Subject: Mem2Mem V4L2 devices [RFC] - Can we enhance the V4L2 API?
Message-ID: <A69FA2915331DC488A831521EAE36FE401553E9655@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
	 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
	 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <1254773653.10214.31.camel@violet.int.mm-sol.com>
In-Reply-To: <1254773653.10214.31.camel@violet.int.mm-sol.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Are we constrained to use the QBUF/DQBUF/STREAMON/STREAMOFF model for this specific device (memory to memory)? What about adding new IOCTLs that can be used for this specific device type that possibly can simplify the implementation? As we have seen in the discussion, this is not a streaming device, rather a transaction/conversion device which operate on a given frame to get a desired output frame. Each transaction may have it's own set of configuration context which will be applied to the hardware before starting the operation. This is unlike a streaming device, where most of the configuration is done prior to starting the streaming. The changes done during streaming are controls like brightness, contrast, gain etc. The frames received by application are either synchronized to an input source timing or application output frame based on a display timing. Also a single IO instance is usually maintained at the driver where as in the case of memory to memory device, hardware needs to switch contexts between operations. So we might need a different approach than capture/output device. 

Just a thought to see if others think in the same way. Once we know we are free to enhance the API to support this new device, I am sure there will be better ideas to implement the same.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Ivan T. Ivanov [mailto:iivanov@mm-sol.com]
>Sent: Monday, October 05, 2009 4:14 PM
>To: Karicheri, Muralidharan
>Cc: Marek Szyprowski; linux-media@vger.kernel.org;
>kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak
>Subject: RE: Mem2Mem V4L2 devices [RFC]
>
>Hi,
>
>
>On Mon, 2009-10-05 at 15:02 -0500, Karicheri, Muralidharan wrote:
>>
>> >>
>> >> 1. How to set different color space or size for input and output
>buffer
>> >> each? It could be solved by adding a set of ioctls to get/set source
>> >> image format and size, while the existing v4l2 ioctls would only refer
>> >> to the output buffer. Frankly speaking, we don't like this idea.
>> >
>> >I think that is not unusual one video device to define that it can
>> >support at the same time input and output operation.
>> >
>> >Lets take as example resizer device. it is always possible that it
>> >inform user space application that
>> >
>> >struct v4l2_capability.capabilities ==
>> >		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT)
>> >
>> >User can issue S_FMT ioctl supplying
>> >
>> >struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE
>> >		  .pix  = width x height
>> >
>> >which will instruct this device to prepare its output for this
>> >resolution. after that user can issue S_FMT ioctl supplying
>> >
>> >struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT
>> >   		  .pix  = width x height
>> >
>> >using only these ioctls should be enough to device driver
>> >to know down/up scale factor required.
>> >
>> >regarding color space struct v4l2_pix_format have field 'pixelformat'
>> >which can be used to define input and output buffers content.
>> >so using only existing ioctl's user can have working resizer device.
>> >
>> >also please note that there is VIDIOC_S_CROP which can add additional
>> >flexibility of adding cropping on input or output.
>> >
>> >last thing which should be done is to QBUF 2 buffers and call STREAMON.
>> >
>> >i think this will simplify a lot buffer synchronization.
>> >
>>
>> Ivan,
>>
>> There is another use case where there are two Resizer hardware working on
>the same input frame and give two different output frames of different
>resolution. How do we handle this using the one video device approach you
>> just described here?
>
> what is the difference?
>
>- you can have only one resizer device driver which will hide that
>  they are actually 2 hardware resizers. just operations will be
>  faster ;).
>
>- they are two device drivers (nodes) with similar characteristics.
>
>in both cases input buffer can be the same.
>
>iivanov
>
>
>
>>
>> Murali
>

