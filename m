Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:41703 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZJETKW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 15:10:22 -0400
Subject: RE: Mem2Mem V4L2 devices [RFC]
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436CF8FEC@dbde02.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
	 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
	 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
	 <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
	 <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
	 <1254769004.10214.12.camel@violet.int.mm-sol.com>
	 <19F8576C6E063C45BE387C64729E73940436CF8FEC@dbde02.ent.ti.com>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 22:09:25 +0300
Message-Id: <1254769765.10214.17.camel@violet.int.mm-sol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-10-06 at 00:31 +0530, Hiremath, Vaibhav wrote:
> > -----Original Message-----
> > From: Ivan T. Ivanov [mailto:iivanov@mm-sol.com]
> > Sent: Tuesday, October 06, 2009 12:27 AM
> > To: Hiremath, Vaibhav
> > Cc: Marek Szyprowski; linux-media@vger.kernel.org;
> > kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak
> > Subject: RE: Mem2Mem V4L2 devices [RFC]
> > 
> > 
> <snip>
> > > > > > last thing which should be done is to QBUF 2 buffers and
> > call
> > > > > > STREAMON.
> > > > > >
> > > > > [Hiremath, Vaibhav] IMO, this implementation is not streaming
> > > > model, we are trying to fit mem-to-mem
> > > > > forcefully to streaming.
> > > >
> > > > Why this does not fit streaming? I see no problems with
> > streaming
> > > > over mem2mem device with only one video node. You just queue
> > input
> > > > and output buffers (they are distinguished by 'type' parameter)
> > on
> > > > the same video node.
> > > >
> > > [Hiremath, Vaibhav] Do we create separate queue of buffers based
> > on type? I think we don't.
> > >
> > > App1		App2		App3		...		AppN
> > >   |		 |		|		|		  |
> > >    -----------------------------------------------
> > > 				|
> > > 			/dev/video0
> > > 				|
> > > 			Resizer Driver
> > 
> >  why not? they can be per file handler input/output queue. and we
> >  can do time sharing use of resizer driver like Marek suggests.
> > 
> [Hiremath, Vaibhav] Ivan,
> File handle based queue and buffer type based queue are two different terms. 

really? ;)

> 
> Yes, definitely we have to create separate queues for each file handle to support multiple channels. But my question was for buffer type, CAPTURE and OUTPUT.
> 

let me see. you concern is that for very big frames 1X Mpix, managing
separate buffers for input and output will be waste of space
for operations like downs calling. i know that such operations can be
done in-place ;). but what about up-scaling. this also should 
be possible, but with some very dirty hacks.

iivanov

> Thanks,
> Vaibhav
> 
> > 
> > >
> > > Everyone will be doing streamon, and in normal use case every
> > application must be getting buffers from another module (another
> > driver, codecs, DSP, etc...) in multiple streams, 0, 1,2,3,4....N
> > >
> > > Every application will start streaming with (mostly) fixed scaling
> > factor which mostly never changes. This one video node approach is
> > possible only with constraint that, the application will always
> > queue only 2 buffers with one CAPTURE and one with OUTPUT type.
> > 
> > i don't see how 2 device node approach can help with this case.
> > even in "normal" video capture device you should stop streaming
> > when change buffer sizes.
> > 
> > > He has to wait till first/second gets finished, you can't queue
> > multiple buffers (input and output) simultaneously.
> > 
> > actually this should be possible.
> > 
> > iivanov
> > 
> > >
> > > I do agree here with you that we need to investigate on whether we
> > really have such use-case. Does it make sense to put such constraint
> > on application? What is the impact? Again in case of down-scaling,
> > application may want to use same buffer as input, which is easily
> > possible with single node approach.
> > >
> > > Thanks,
> > > Vaibhav
> > >
> > > > > We have to put some constraints -
> > > > >
> > > > > 	- Driver will treat index 0 as input always,
> > irrespective of
> > > > number of buffers queued.
> > > > > 	- Or, application should not queue more that 2 buffers.
> > > > > 	- Multi-channel use-case????
> > > > >
> > > > > I think we have to have 2 device nodes which are capable of
> > > > streaming multiple buffers, both are
> > > > > queuing the buffers.
> > > >
> > > > In one video node approach there can be 2 buffer queues in one
> > video
> > > > node, for input and output respectively.
> > > >
> > > > > The constraint would be the buffers must be mapped one-to-one.
> > > >
> > > > Right, each queued input buffer must have corresponding output
> > > > buffer.
> > > >
> > > > Best regards
> > > > --
> > > > Marek Szyprowski
> > > > Samsung Poland R&D Center
> > > >
> > > >
> > >
> > 
> 

