Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37337 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbZJFQND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 12:13:03 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Tue, 6 Oct 2009 21:42:13 +0530
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <19F8576C6E063C45BE387C64729E73940436CF9278@dbde02.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
 <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
 <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
 <001d01ca464d$825316f0$86f944d0$%szyprowski@samsung.com>
In-Reply-To: <001d01ca464d$825316f0$86f944d0$%szyprowski@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
> Sent: Tuesday, October 06, 2009 11:53 AM
> To: Hiremath, Vaibhav; 'Ivan T. Ivanov'; linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak; Marek
> Szyprowski
> Subject: RE: Mem2Mem V4L2 devices [RFC]
> 
> Hello,
> 
> On Monday, October 05, 2009 8:27 PM Hiremath, Vaibhav wrote:
> 
> > > > [Hiremath, Vaibhav] IMO, this implementation is not streaming
> > > model, we are trying to fit mem-to-mem
> > > > forcefully to streaming.
> > >
> > > Why this does not fit streaming? I see no problems with
> streaming
> > > over mem2mem device with only one video node. You just queue
> input
> > > and output buffers (they are distinguished by 'type' parameter)
> on
> > > the same video node.
> > >
> > [Hiremath, Vaibhav] Do we create separate queue of buffers based
> on type? I think we don't.
> 
> Why not? I really see no problems implementing such driver,
> especially if this heavily increases the number of use cases where
> such
> device can be used.
> 
[Hiremath, Vaibhav] I thought of it and you are correct, it should be possible. I was kind of biased and thinking in only one direction. Now I don't see any reason why we should go for 2 device node approach. Earlier I was thinking of 2 device nodes for 2 queues, if it is possible with one device node then I think we should align to single device node approach.

Do you see any issues with it?

Thanks,
Vaibhav

> > App1		App2		App3		...		AppN
> >   |		 |		|		|		  |
> >    -----------------------------------------------
> > 				|
> > 			/dev/video0
> > 				|
> > 			Resizer Driver
> >
> > Everyone will be doing streamon, and in normal use case every
> application must be getting buffers from
> > another module (another driver, codecs, DSP, etc...) in multiple
> streams, 0, 1,2,3,4....N
<snip>
> case in which the operation can be performed in-place. Usually all
> other types of operations (like color space conversion or rotation)
> require 2 buffers. Please note that having only one video node
> would not mean that all operations must be done in-place. As Ivan
> stated you can perfectly queue 2 separate input and output buffers
> into the one video node and the driver can handle this correctly.
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 

