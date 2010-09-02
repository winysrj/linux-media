Return-path: <mchehab@localhost>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33036 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0IBVVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 17:21:03 -0400
Subject: Re: [PATCH 6/7] IR: extend ir_raw_event and do refactoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <20100902205607.GB3886@hardeman.nu>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
	 <1283158348-7429-7-git-send-email-maximlevitsky@gmail.com>
	 <20100902205607.GB3886@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 00:20:54 +0300
Message-ID: <1283462454.3306.15.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Thu, 2010-09-02 at 22:56 +0200, David Härdeman wrote: 
> On Mon, Aug 30, 2010 at 11:52:26AM +0300, Maxim Levitsky wrote:
> > Add new event types for timeout & carrier report
> > Move timeout handling from ir_raw_event_store_with_filter to
> > ir-lirc-codec, where it is really needed.
> 
> Yes, but it still might make more sense to keep the timeout handling in 
> ir_raw_event_store_with_filter so that all decoders get the same data 
> from rc-core?
I don't want any timeouts in rc-core. There is just an IR packet that
starts optionally with a reset and ends with a timeout bit.
I have also nothing against renaming reset/timeout to start/stop.

rc-core really shouldn't care about consistent pulse/space ordering.
Its lirc that needs it.

Also in the future I think I should make the
ir_raw_event_store_with_filter the default submit function for all
drivers, and then I could drop that silly '_with_filter" thing
(Couldn't think for a better name for this function...)

> 
> > Now lirc bridge ensures proper gap handling.
> > Extend lirc bridge for carrier & timeout reports
> > 
> > Note: all new ir_raw_event variables now should be initialized
> > like that:
> > struct ir_raw_event ev = ir_new_event;
> 
> Wouldn't DEFINE_RAW_EVENT(ev); be more in line with the kernel coding 
> style? (cf. DEFINE_MUTEX, DEFINE_SPINLOCK, etc).
Of course, nothing against that.


Best regards,
Maxim Levitsky

