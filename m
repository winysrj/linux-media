Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:38635 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab3AEQyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 11:54:20 -0500
Date: Sat, 5 Jan 2013 16:47:33 +0000
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] winbond-cir: increase IR receiver
 resolution
Message-ID: <20130105164733.GA8312@pequod.mess.org>
References: <1351113762-5530-1-git-send-email-sean@mess.org>
 <1351113762-5530-2-git-send-email-sean@mess.org>
 <20130103001657.GB13132@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130103001657.GB13132@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 03, 2013 at 01:16:57AM +0100, David Härdeman wrote:
> On Wed, Oct 24, 2012 at 10:22:41PM +0100, Sean Young wrote:
> >This is needed for carrier reporting.
> >
> >Signed-off-by: Sean Young <sean@mess.org>
> >---
> > drivers/media/rc/winbond-cir.c | 14 +++++++++-----
> > 1 file changed, 9 insertions(+), 5 deletions(-)
> 
> Using a resolution of 2us rather than 10us means that the resolution
> (and amount of work necessary for decoding a given signal) is about 25x
> higher than in the windows driver (which uses a 50us resolution IIRC)...
> 
> Most of it is mitigated by using RLE (which I don't think the windows
> driver uses....again...IIRC), but it still seems unnecessary for the
> general case.

You're right, the hardware will generate more data for 2us rather than 
10us. For one key press on a nec remote, I get 69 interrupts before 
this patch and 302 after. That's almost 5 times as much, but not a 
ridiculous amount of work.

> Wouldn't it be possible to only use the high-res mode when carrier
> reports are actually enabled?

That is possible, although is it really worth the effort? I'll have a
look at implementing it and see what the code will look like.


Sean
