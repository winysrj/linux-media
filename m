Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:37716 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781Ab2CWLSB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 07:18:01 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	spear-devel <spear-devel@list.st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"sshtylyov@mvista.com" <sshtylyov@mvista.com>
Date: Fri, 23 Mar 2012 19:16:52 +0800
Subject: RE: [PATCH] usb: gadget/uvc: Remove non-required locking from
 'uvc_queue_next_buffer' routine
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA2E26BD3@EAPEX1MAIL1.st.com>
References: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
 <20120322144056.GG19835@kroah.com>
 <D5ECB3C7A6F99444980976A8C6D896384FA2E26B3C@EAPEX1MAIL1.st.com>
 <4488993.8IuHKQXWmM@avalon>
In-Reply-To: <4488993.8IuHKQXWmM@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, March 23, 2012 3:30 PM
> To: Bhupesh SHARMA
> Cc: balbi@ti.com; linux-usb@vger.kernel.org; spear-devel; linux-
> media@vger.kernel.org; Greg KH
> Subject: Re: [PATCH] usb: gadget/uvc: Remove non-required locking from
> 'uvc_queue_next_buffer' routine
> 
> Hi Bhupesh,
> 
> On Friday 23 March 2012 17:31:19 Bhupesh SHARMA wrote:
> > On Thursday, March 22, 2012 8:11 PM Gregg KH wrote:
> > > On Thu, Mar 22, 2012 at 10:20:37AM +0530, Bhupesh Sharma wrote:
> > > > This patch removes the non-required spinlock acquire/release
> calls on
> > > > 'queue_irqlock' from 'uvc_queue_next_buffer' routine.
> > > >
> > > > This routine is called from 'video->encode' function (which
> translates
> > > > to either 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in
> > > > 'uvc_video.c'. As, the 'video->encode' routines are called with
> > > > 'queue_irqlock' already held, so acquiring a 'queue_irqlock'
> again in
> > > > 'uvc_queue_next_buffer' routine causes a spin lock recursion.
> > > >
> > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > ---
> > > >
> > > >  drivers/usb/gadget/uvc_queue.c |    4 +---
> > > >  1 files changed, 1 insertions(+), 3 deletions(-)
> > >
> > > Please use scripts/get_maintainer.pl to determine who to send this
> to
> > > (hint, it's not me...)
> >
> > Can you please pick this USB webcam gadget/peripheral specific patch
> > in your tree?
> 
> Could you please first resubmit with the comments fix as asked by
> Sergei
> Shtylyov ? (s/queue_irqlock/queue->irqlock/)
> 

Ok. I will make the changes as suggested by Sergei and then resubmit
the patch..

Regards,
Bhupesh
