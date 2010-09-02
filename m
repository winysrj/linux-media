Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:60610 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0IBWdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 18:33:01 -0400
Date: Fri, 3 Sep 2010 00:32:56 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 6/7] IR: extend ir_raw_event and do refactoring
Message-ID: <20100902223256.GA2492@hardeman.nu>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
 <1283158348-7429-7-git-send-email-maximlevitsky@gmail.com>
 <20100902205607.GB3886@hardeman.nu>
 <1283462454.3306.15.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283462454.3306.15.camel@maxim-laptop>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Sep 03, 2010 at 12:20:54AM +0300, Maxim Levitsky wrote:
> Also in the future I think I should make the
> ir_raw_event_store_with_filter the default submit function for all
> drivers, and then I could drop that silly '_with_filter" thing
> (Couldn't think for a better name for this function...)

I agree. Perhaps it would even be possible to merge 
ir_raw_event_store_with_filter and ir_raw_event_store. The automatic 
merger of consecutive pulse-pulse events or space-space events should 
help simplify some drivers...

> > Wouldn't DEFINE_RAW_EVENT(ev); be more in line with the kernel 
> > coding style? (cf. DEFINE_MUTEX, DEFINE_SPINLOCK, etc).
> Of course, nothing against that.

DEFINE_RC_RAW_EVENT() is probably better by the way...

-- 
David Härdeman
