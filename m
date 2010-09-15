Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0IOOlW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 10:41:22 -0400
Date: Wed, 15 Sep 2010 10:41:15 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Brian Rogers <brian@xyzw.org>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	jarod@wilsonet.com, linux-media@vger.kernel.org,
	mchehab@redhat.com, linux-input@vger.kernel.org
Subject: Re: [PATCH] ir-core: Fix null dereferences in the protocols sysfs
 interface
Message-ID: <20100915144115.GD13030@redhat.com>
References: <20100613202718.6044.29599.stgit@localhost.localdomain>
 <20100613202930.6044.97940.stgit@localhost.localdomain>
 <4C8797D3.1060606@xyzw.org>
 <20100908141613.GB22323@redhat.com>
 <4C90C2A6.1010408@xyzw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C90C2A6.1010408@xyzw.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Sep 15, 2010 at 05:57:10AM -0700, Brian Rogers wrote:
>  On 09/08/2010 07:16 AM, Jarod Wilson wrote:
> >On Wed, Sep 08, 2010 at 07:04:03AM -0700, Brian Rogers wrote:
> >>ir_dev->raw is also null. If I check these pointers before using
> >>them, and bail out if both are null, then I get a working lircd, but
> >>of course the file /sys/devices/virtual/rc/rc0/protocols no longer
> >>does anything. On 2.6.35.4, the system never creates the
> >>/sys/class/rc/rc0/current_protocol file. Is it the case that the
> >>'protocols' file should never appear, because my card can't support
> >>this feature?
> >Hm... So protocols is indeed intended for hardware that handles raw IR, as
> >its a list of raw IR decoders available/enabled/disabled for the receiver.
> >But some devices that do onboard decoding and deal with scancodes still
> >need to support changing protocols, as they can be told "decode rc5" or
> >"decode nec", etc... My memory is currently foggy on how it was exactly
> >that it was supposed to be donee though. :) (Yet another reason I really
> >need to poke at the imon driver code again).
> 
> How about the attached patch? Does this look like a reasonable
> solution for 2.6.36?
> 
> Brian
> 

> From 7937051c5e2c8b5b0410172d48e62d54bd1906ee Mon Sep 17 00:00:00 2001
> From: Brian Rogers <brian@xyzw.org>
> Date: Wed, 8 Sep 2010 05:33:34 -0700
> Subject: [PATCH] ir-core: Fix null dereferences in the protocols sysfs interface
> 
> For some cards, ir_dev->props and ir_dev->raw are both NULL. These cards are
> using built-in IR decoding instead of raw, and can't easily be made to switch
> protocols.
> 
> So upon reading /sys/class/rc/rc?/protocols on such a card, return 'builtin' as
> the supported and enabled protocol. Return -EINVAL on any attempts to change
> the protocol. And most important of all, don't crash.
> 
> Signed-off-by: Brian Rogers <brian@xyzw.org>
> ---
>  drivers/media/IR/ir-sysfs.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)

Yeah, this looks pretty sane for 2.6.36, would just be a short-lived panic
preventer until David's interface changes get merged after 2.6.37-rc1.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

