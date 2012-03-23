Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42143 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2CWJ7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 05:59:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	spear-devel <spear-devel@list.st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffer' routine
Date: Fri, 23 Mar 2012 11:00:08 +0100
Message-ID: <4488993.8IuHKQXWmM@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA2E26B3C@EAPEX1MAIL1.st.com>
References: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com> <20120322144056.GG19835@kroah.com> <D5ECB3C7A6F99444980976A8C6D896384FA2E26B3C@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Friday 23 March 2012 17:31:19 Bhupesh SHARMA wrote:
> On Thursday, March 22, 2012 8:11 PM Gregg KH wrote:
> > On Thu, Mar 22, 2012 at 10:20:37AM +0530, Bhupesh Sharma wrote:
> > > This patch removes the non-required spinlock acquire/release calls on
> > > 'queue_irqlock' from 'uvc_queue_next_buffer' routine.
> > > 
> > > This routine is called from 'video->encode' function (which translates
> > > to either 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in
> > > 'uvc_video.c'. As, the 'video->encode' routines are called with
> > > 'queue_irqlock' already held, so acquiring a 'queue_irqlock' again in
> > > 'uvc_queue_next_buffer' routine causes a spin lock recursion.
> > > 
> > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/usb/gadget/uvc_queue.c |    4 +---
> > >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > Please use scripts/get_maintainer.pl to determine who to send this to
> > (hint, it's not me...)
> 
> Can you please pick this USB webcam gadget/peripheral specific patch
> in your tree?

Could you please first resubmit with the comments fix as asked by Sergei 
Shtylyov ? (s/queue_irqlock/queue->irqlock/)

-- 
Regards,

Laurent Pinchart

