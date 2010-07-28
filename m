Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0G1RyV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:54:21 -0400
Date: Wed, 28 Jul 2010 13:43:38 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/9] IR: replace spinlock with mutex.
Message-ID: <20100728174338.GD26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
 <1280330051-27732-4-git-send-email-maximlevitsky@gmail.com>
 <4C5054B6.5050207@redhat.com>
 <1280334778.28785.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280334778.28785.6.camel@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 07:32:58PM +0300, Maxim Levitsky wrote:
> On Wed, 2010-07-28 at 13:03 -0300, Mauro Carvalho Chehab wrote:
> > Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> > > Some handlers (lirc for example) allocates memory on initialization,
> > > doing so in atomic context is cumbersome.
> > > Fixes warning about sleeping function in atomic context.
> > 
> > You should not replace it by a mutex, as the decoding code may happen during
> > IRQ time on several drivers.
> I though decoding code is run by a work queue?

Yeah, it is. (INIT_WORK(&ir->raw->rx_work, ir_raw_event_work); in
ir_raw_event_register).

> I don't see any atomic codepath here...

I think the ir_raw_event_store variants are the only things that are run
from an interrupt context, and none of them touch ir_raw_handler_lock.
That lock is advertised as being for the protection of ir_raw_handler_list
and ir_raw_client_list, which are primarily manipulated by
register/unregister functions, and we just lock them when doing actual IR
decode work (via said work queue) so we don't feed raw IR somewhere that
we shouldn't. I think Maxim is correct here, we should be okay with
changing this to a mutex, unless I'm missing something else.

-- 
Jarod Wilson
jarod@redhat.com

