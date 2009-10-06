Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:50720 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbZJFMe2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Oct 2009 08:34:28 -0400
Subject: RE: Mem2Mem V4L2 devices [RFC]
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
In-Reply-To: <001d01ca464d$825316f0$86f944d0$%szyprowski@samsung.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
	 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
	 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
	 <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
	 <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
	 <001d01ca464d$825316f0$86f944d0$%szyprowski@samsung.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 15:33:44 +0300
Message-Id: <1254832424.5261.93.camel@iivanov.int.mm-sol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

On Tue, 2009-10-06 at 08:23 +0200, Marek Szyprowski wrote:
> Hello,
> 
> On Monday, October 05, 2009 8:27 PM Hiremath, Vaibhav wrote:
> 
> > > > [Hiremath, Vaibhav] IMO, this implementation is not streaming
> > > model, we are trying to fit mem-to-mem
> > > > forcefully to streaming.
> > >
> > > Why this does not fit streaming? I see no problems with streaming
> > > over mem2mem device with only one video node. You just queue input
> > > and output buffers (they are distinguished by 'type' parameter) on
> > > the same video node.
> > >
> > [Hiremath, Vaibhav] Do we create separate queue of buffers based on type? I think we don't.
> 
> Why not? I really see no problems implementing such driver, especially if this heavily increases the number of use cases where such
> device can be used.
> 
> > App1		App2		App3		...		AppN
> >   |		 |		|		|		  |
> >    -----------------------------------------------
> > 				|
> > 			/dev/video0
> > 				|
> > 			Resizer Driver
> > 
> > Everyone will be doing streamon, and in normal use case every application must be getting buffers from
> > another module (another driver, codecs, DSP, etc...) in multiple streams, 0, 1,2,3,4....N
> 
> Right.
> 
> > Every application will start streaming with (mostly) fixed scaling factor which mostly never changes.
> 
> Right. The driver can store the scaling factors and other parameters in the private data of each opened instance of the /dev/video0
> device.
> 
> > This one video node approach is possible only with constraint that, the application will always queue
> > only 2 buffers with one CAPTURE and one with OUTPUT type. He has to wait till first/second gets
> > finished, you can't queue multiple buffers (input and output) simultaneously.
> 
> Why do you think you cannot queue multiple buffers? IMHO can perfectly queue more than one input buffer, then queue the same number
> of output buffers and then the device will process all the buffers.
> 
> > I do agree here with you that we need to investigate on whether we really have such use-case. Does it
> > make sense to put such constraint on application?
> 
> What constraint?
> 
> > What is the impact? Again in case of down-scaling,
> > application may want to use same buffer as input, which is easily possible with single node approach.
> 
> Right. But take into account that down-scaling is the one special case in which the operation can be performed in-place. Usually all
> other types of operations (like color space conversion or rotation) require 2 buffers. Please note that having only one video node
> would not mean that all operations must be done in-place. As Ivan stated you can perfectly queue 2 separate input and output buffers
> into the one video node and the driver can handle this correctly.
> 

 i agree with you Marek.

 can i made one suggestion. as we all know some hardware can do in-place
 processing. i think it will be not too bad if user put same buffer 
 as input and output, or with some spare space between start address of
 input and output. from driver point of view there is no 
 difference, it will see 2 different buffers. in this case we also 
 can save time from mapping virtual to physical addresses.

 but in general, i think separate input and output buffers 
 (even overlapped), and single device node will simplify design 
 and implementation of such drivers. Also this will be more clear 
 and easily manageable from user space point of view.

 iivanov



> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

