Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25838 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbZJFGZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 02:25:51 -0400
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR2004FPXTFGD@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 15:24:51 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR200K4OXTB1L@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 15:24:51 +0900 (KST)
Date: Tue, 06 Oct 2009 08:23:20 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
To: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001d01ca464d$825316f0$86f944d0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
 <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
 <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, October 05, 2009 8:27 PM Hiremath, Vaibhav wrote:

> > > [Hiremath, Vaibhav] IMO, this implementation is not streaming
> > model, we are trying to fit mem-to-mem
> > > forcefully to streaming.
> >
> > Why this does not fit streaming? I see no problems with streaming
> > over mem2mem device with only one video node. You just queue input
> > and output buffers (they are distinguished by 'type' parameter) on
> > the same video node.
> >
> [Hiremath, Vaibhav] Do we create separate queue of buffers based on type? I think we don't.

Why not? I really see no problems implementing such driver, especially if this heavily increases the number of use cases where such
device can be used.

> App1		App2		App3		...		AppN
>   |		 |		|		|		  |
>    -----------------------------------------------
> 				|
> 			/dev/video0
> 				|
> 			Resizer Driver
> 
> Everyone will be doing streamon, and in normal use case every application must be getting buffers from
> another module (another driver, codecs, DSP, etc...) in multiple streams, 0, 1,2,3,4....N

Right.

> Every application will start streaming with (mostly) fixed scaling factor which mostly never changes.

Right. The driver can store the scaling factors and other parameters in the private data of each opened instance of the /dev/video0
device.

> This one video node approach is possible only with constraint that, the application will always queue
> only 2 buffers with one CAPTURE and one with OUTPUT type. He has to wait till first/second gets
> finished, you can't queue multiple buffers (input and output) simultaneously.

Why do you think you cannot queue multiple buffers? IMHO can perfectly queue more than one input buffer, then queue the same number
of output buffers and then the device will process all the buffers.

> I do agree here with you that we need to investigate on whether we really have such use-case. Does it
> make sense to put such constraint on application?

What constraint?

> What is the impact? Again in case of down-scaling,
> application may want to use same buffer as input, which is easily possible with single node approach.

Right. But take into account that down-scaling is the one special case in which the operation can be performed in-place. Usually all
other types of operations (like color space conversion or rotation) require 2 buffers. Please note that having only one video node
would not mean that all operations must be done in-place. As Ivan stated you can perfectly queue 2 separate input and output buffers
into the one video node and the driver can handle this correctly.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

