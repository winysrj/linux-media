Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:50072 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949Ab2CWJca convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 05:32:30 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	spear-devel <spear-devel@list.st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 23 Mar 2012 17:31:19 +0800
Subject: RE: [PATCH] usb: gadget/uvc: Remove non-required locking from
 'uvc_queue_next_buffer' routine
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA2E26B3C@EAPEX1MAIL1.st.com>
References: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
 <20120322144056.GG19835@kroah.com>
In-Reply-To: <20120322144056.GG19835@kroah.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, March 22, 2012 8:11 PM
> To: Bhupesh SHARMA
> Cc: linux-usb@vger.kernel.org; laurent.pinchart@ideasonboard.com;
> spear-devel; linux-media@vger.kernel.org
> Subject: Re: [PATCH] usb: gadget/uvc: Remove non-required locking from
> 'uvc_queue_next_buffer' routine
> 
> On Thu, Mar 22, 2012 at 10:20:37AM +0530, Bhupesh Sharma wrote:
> > This patch removes the non-required spinlock acquire/release calls on
> > 'queue_irqlock' from 'uvc_queue_next_buffer' routine.
> >
> > This routine is called from 'video->encode' function (which
> translates to either
> > 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in 'uvc_video.c'.
> > As, the 'video->encode' routines are called with 'queue_irqlock'
> already held,
> > so acquiring a 'queue_irqlock' again in 'uvc_queue_next_buffer'
> routine causes
> > a spin lock recursion.
> >
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/usb/gadget/uvc_queue.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> Please use scripts/get_maintainer.pl to determine who to send this to
> (hint, it's not me...)
> 

Can you please pick this USB webcam gadget/peripheral specific patch
in your tree?

Regards,
Bhupesh
