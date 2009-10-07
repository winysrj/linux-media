Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36033 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbZJGNjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2009 09:39:44 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Wed, 7 Oct 2009 08:39:02 -0500
Subject: RE: Mem2Mem V4L2 devices [RFC] - Can we enhance the V4L2 API?
Message-ID: <A69FA2915331DC488A831521EAE36FE4015546FBA6@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <1254773653.10214.31.camel@violet.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E9655@dlee06.ent.ti.com>
 <001e01ca464d$87fcacb0$97f60610$%szyprowski@samsung.com>
In-Reply-To: <001e01ca464d$87fcacb0$97f60610$%szyprowski@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marek,

>
>> As we have seen in the discussion, this is not a streaming device, rather
>> a transaction/conversion device which operate on a given frame to get a
>desired output frame. Each
>> transaction may have it's own set of configuration context which will be
>applied to the hardware
>> before starting the operation. This is unlike a streaming device, where
>most of the configuration is
>> done prior to starting the streaming.
>
>From the application point of view an instance of such a device still is a
>streaming device. The application should not even know if
>any other apps are using the device or not (well, it may only notice the
>lower throughput or higher device latency, but this cannot
>be avoided). Application can queue input and output buffers, stream on and
>wait for the result.
>
In a typical capture or display side streaming, AFAIK, there is only one device io instance. While streaming is ON, if another application tries to do IO, driver returns -EBUSY. I believe this is true for all drivers (Correct me if this is not true).When you say the memory to memory device is able to allow multiple application to call STREAMON, this model is broken(Assuming what I said above is true).

May be I am missing something here. Is the following true? I think in your model, each application gets a device instance that has it's own scaling factors and other parameters. So streaming status is maintained for each IO instance. Each IO instance has it's own buffer queues. If this is true then you are right. Streaming model is not broken.

So following scenario holds good concurrently (api call sequence).

App1 -> open() -> S_FMT -> STREAMON->QBUF/DQBUF(n times)->STREAMOFF->close()
App2 -> open() -> S_FMT -> STREAMON->QBUF/DQBUF(n times)->STREAMOFF->close()
....
App3 -> open() -> S_FMT -> STREAMON->QBUF/DQBUF(n times)->STREAMOFF->close()

So internal to driver, if there are multiple concurrent streamon requests, and hardware is busy, subsequent requests waits until the first one is complete and driver schedules requests from multiple IO queues. So this is essentially what we have in our internal implementation (discussed during the linux plumbers mini summit) converted to v4l2 model.

>> The changes done during streaming are controls like brightness,
>> contrast, gain etc. The frames received by application are either
>synchronized to an input source
>> timing or application output frame based on a display timing. Also a
>single IO instance is usually
>> maintained at the driver where as in the case of memory to memory device,
>hardware needs to switch
>> contexts between operations. So we might need a different approach than
>capture/output device.
>
>All this is internal to the device driver, which can hide it from the
>application.
>
>Best regards
>--
>Marek Szyprowski
>Samsung Poland R&D Center
>
>

