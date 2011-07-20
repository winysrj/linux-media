Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1GTN2W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 09:28:22 -0400
Date: Wed, 20 Jul 2011 09:18:30 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Chris W <lkml@psychogeeks.com>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH] [media] imon: don't parse scancodes until intf configured
Message-ID: <20110720131830.GC9799@redhat.com>
References: <D7E52A85-331A-4650-94F0-C1477F457457@redhat.com>
 <1311091967-2791-1-git-send-email-jarod@redhat.com>
 <4E25FFB7.70205@psychogeeks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E25FFB7.70205@psychogeeks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 20, 2011 at 08:05:43AM +1000, Chris W wrote:
> On 20/07/11 02:12, Jarod Wilson wrote:
> > The imon devices have either 1 or 2 usb interfaces on them, each wired
> > up to its own urb callback. The interface 0 urb callback is wired up
> > before the imon context's rc_dev pointer is filled in, which is
> > necessary for imon 0xffdc device auto-detection to work properly, but
> > we need to make sure we don't actually run the callback routines until
> > we've entirely filled in the necessary bits for each given interface,
> > lest we wind up oopsing. Technically, any imon device could have hit
> > this, but the issue is exacerbated on the 0xffdc devices, which send a
> > constant stream of interrupts, even when they have no valid key data.
> 
> 
> 
> OK.  The patch applies and everything continues to work.   There is no
> obvious difference in the dmesg output on module load, with my device
> remaining unidentified.  I don't know if that is indicative of anything.

Did you apply this patch on top of the earlier patch, or instead of it?

> input: iMON Panel, Knob and Mouse(15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input9
> imon 4-2:1.0: Unknown 0xffdc device, defaulting to VFD and iMON IR (id 0x00)

The 'id 0x00' part should read 'id 0x24', as the ongoing spew below has in
index 6, which makes me think you still have the earlier patch applied.
You actually want only the newer patch applied. If you only have the newer
one applied, then I'll have to take another look to see what's up.

> intf0 decoded packet: 00 00 00 00 00 00 24 01
> intf0 decoded packet: 00 00 00 00 00 00 24 01
> intf0 decoded packet: 00 00 00 00 00 00 24 01

One other amusing tidbit: you get continuous spew like the above, because
to date, I thought all the ffdc devices had "nothing to report" spew that
started with 0xffffff, which we filter out. Sigh. I hate imon hardware...

-- 
Jarod Wilson
jarod@redhat.com

