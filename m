Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46365
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbcGLOF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 10:05:29 -0400
Date: Tue, 12 Jul 2016 11:05:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/20] [media] lirc.h: remove several unused ioctls
Message-ID: <20160712110524.57e2b674@recife.lan>
In-Reply-To: <20160712135438.GA11183@gofer.mess.org>
References: <cover.1468327191.git.mchehab@s-opensource.com>
	<d55f09abe24b4dfadab246b6f217da547361cdb6.1468327191.git.mchehab@s-opensource.com>
	<20160712131406.GB10242@gofer.mess.org>
	<20160712102300.3bb0e6c4@recife.lan>
	<20160712133555.GA10904@gofer.mess.org>
	<20160712135438.GA11183@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Jul 2016 14:54:38 +0100
Sean Young <sean@mess.org> escreveu:

> On Tue, Jul 12, 2016 at 02:35:56PM +0100, Sean Young wrote:
> > On Tue, Jul 12, 2016 at 10:23:00AM -0300, Mauro Carvalho Chehab wrote:  
> > > Em Tue, 12 Jul 2016 14:14:06 +0100
> > > Sean Young <sean@mess.org> escreveu:  
> > > > On Tue, Jul 12, 2016 at 09:41:57AM -0300, Mauro Carvalho Chehab wrote:  
> > -snip-  
> > > > > -#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)    
> > > > 
> > > > Also remove LIRC_CAN_SET_REC_DUTY_CYCLE and 
> > > > LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE.  
> > > 
> > > Removing the "LIRC_CAN" macros can break userspace, as some app could
> > > be using it to print the LIRC features. That's why I opted to keep
> > > them, but to document that those features are unused - this is at
> > > the next patch (04/20).  
> > 
> > How is that different from removing the ioctls? Might as well go the whole
> > hog.  

If someone implemented LIRC_GET_FEATURES and handled all flags, such
program would break, as the API change.

> 
> Ah you meant that if someone later adds a new feature then we might reuse
> an existing bit. Oops, sorry.

Yes, this is another possibility. In such case, the ABI will also 
break, with is more severe than a pure API change.

Removing the ioctl declarations will still work for compiled programs,
as they'll still receive an error code when the ioctl is issued.

> 
> > Also note that LIRC_CAN_SET_REC_DUTY_CYCLE has the same value as
> > LIRC_CAN_MEASURE_CARRIER, so if some userspace program uses this it might
> > end up in the mistaken belief its supports LIRC_CAN_SET_REC_DUTY_CYCLE.  
> 
> So there is an argument for removing LIRC_CAN_SET_REC_DUTY_CYCLE, but
> that should be a separate patch.

Yes. Yet, IMHO, the best would be to put those unused LIRC_CAN into a:

#ifndef __KERNEL

macro block, to:

1) avoid the risk of breaking userspace;
2) be clear that those are deprecated stuff and should not be used on
   newer programs;
3) Reserve the bits for not be used, to avoid possible conflicts.

Regards,
Mauro
