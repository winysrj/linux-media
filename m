Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:53800 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZJHGYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 02:24:15 -0400
Received: from epmmp1 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR600BO5N3DPF@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Oct 2009 15:23:37 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR600K6PN3206@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Oct 2009 15:23:37 +0900 (KST)
Date: Thu, 08 Oct 2009 08:21:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC] - Can we enhance the V4L2 API?
In-reply-to: <A69FA2915331DC488A831521EAE36FE4015546FBA6@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000001ca47df$a58e83a0$f0ab8ae0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <1254773653.10214.31.camel@violet.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E9655@dlee06.ent.ti.com>
 <001e01ca464d$87fcacb0$97f60610$%szyprowski@samsung.com>
 <A69FA2915331DC488A831521EAE36FE4015546FBA6@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, October 07, 2009 3:39 PM Karicheri, Muralidharan wrote:

> >> As we have seen in the discussion, this is not a streaming device, rather
> >> a transaction/conversion device which operate on a given frame to get a
> >desired output frame. Each
> >> transaction may have it's own set of configuration context which will be
> >applied to the hardware
> >> before starting the operation. This is unlike a streaming device, where
> >most of the configuration is
> >> done prior to starting the streaming.
> >
> >From the application point of view an instance of such a device still is a
> >streaming device. The application should not even know if
> >any other apps are using the device or not (well, it may only notice the
> >lower throughput or higher device latency, but this cannot
> >be avoided). Application can queue input and output buffers, stream on and
> >wait for the result.
> >
> In a typical capture or display side streaming, AFAIK, there is only one device io instance. While
> streaming is ON, if another application tries to do IO, driver returns -EBUSY. I believe this is true
> for all drivers (Correct me if this is not true).When you say the memory to memory device is able to
> allow multiple application to call STREAMON, this model is broken(Assuming what I said above is true).
> 
> May be I am missing something here. Is the following true? I think in your model, each application
> gets a device instance that has it's own scaling factors and other parameters. So streaming status is
> maintained for each IO instance. Each IO instance has it's own buffer queues. If this is true then you
> are right. Streaming model is not broken.

This is exactly what I mean. Typical capture or display devices are single instance from the definition (I cannot imagine more than
one application streaming _directly_ from the camera interface). However, a multi-instance support for mem2mem device perfectly
makes sense and heavily improves the usability of it. 

> So following scenario holds good concurrently (api call sequence).
> 
> App1 -> open() -> S_FMT -> STREAMON->QBUF/DQBUF(n times)->STREAMOFF->close()
> App2 -> open() -> S_FMT -> STREAMON->QBUF/DQBUF(n times)->STREAMOFF->close()
> ....
> App3 -> open() -> S_FMT -> STREAMON->QBUF/DQBUF(n times)->STREAMOFF->close()

Exactly.
 
> So internal to driver, if there are multiple concurrent streamon requests, and hardware is busy,
> subsequent requests waits until the first one is complete and driver schedules requests from multiple
> IO queues. So this is essentially what we have in our internal implementation (discussed during the
> linux plumbers mini summit) converted to v4l2 model.

Right, this is what we also have in our custom v4l2-incompatible drivers.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



