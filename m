Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:61941 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbZJFGZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 02:25:38 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR20004RXTPZW@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 15:25:01 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR200JEBXTKOK@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 15:25:01 +0900 (KST)
Date: Tue, 06 Oct 2009 08:23:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC] - Can we enhance the V4L2 API?
In-reply-to: <A69FA2915331DC488A831521EAE36FE401553E9655@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001e01ca464d$87fcacb0$97f60610$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <1254773653.10214.31.camel@violet.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E9655@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On October 06, 2009 12:31 AM Karicheri, Muralidharan wrote:

> Are we constrained to use the QBUF/DQBUF/STREAMON/STREAMOFF model for this specific device (memory to
> memory)? What about adding new IOCTLs that can be used for this specific device type that possibly can
> simplify the implementation?

Don't forget about the simplest V4L2 io model based on read() and write() calls. This io model fits very well into
transaction/conversion like device. There is an issue with blocking calls, as the applications would need to use threads in order to
do simple image conversion, but this can be easily avoided with non-blocking io and poll().

> As we have seen in the discussion, this is not a streaming device, rather
> a transaction/conversion device which operate on a given frame to get a desired output frame. Each
> transaction may have it's own set of configuration context which will be applied to the hardware
> before starting the operation. This is unlike a streaming device, where most of the configuration is
> done prior to starting the streaming.

>From the application point of view an instance of such a device still is a streaming device. The application should not even know if
any other apps are using the device or not (well, it may only notice the lower throughput or higher device latency, but this cannot
be avoided). Application can queue input and output buffers, stream on and wait for the result.

> The changes done during streaming are controls like brightness,
> contrast, gain etc. The frames received by application are either synchronized to an input source
> timing or application output frame based on a display timing. Also a single IO instance is usually
> maintained at the driver where as in the case of memory to memory device, hardware needs to switch
> contexts between operations. So we might need a different approach than capture/output device.

All this is internal to the device driver, which can hide it from the application.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


