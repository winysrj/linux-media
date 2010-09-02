Return-path: <mchehab@localhost>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45711 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab0IBU4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 16:56:11 -0400
Date: Thu, 2 Sep 2010 22:56:07 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 6/7] IR: extend ir_raw_event and do refactoring
Message-ID: <20100902205607.GB3886@hardeman.nu>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
 <1283158348-7429-7-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283158348-7429-7-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Mon, Aug 30, 2010 at 11:52:26AM +0300, Maxim Levitsky wrote:
> Add new event types for timeout & carrier report
> Move timeout handling from ir_raw_event_store_with_filter to
> ir-lirc-codec, where it is really needed.

Yes, but it still might make more sense to keep the timeout handling in 
ir_raw_event_store_with_filter so that all decoders get the same data 
from rc-core?

> Now lirc bridge ensures proper gap handling.
> Extend lirc bridge for carrier & timeout reports
> 
> Note: all new ir_raw_event variables now should be initialized
> like that:
> struct ir_raw_event ev = ir_new_event;

Wouldn't DEFINE_RAW_EVENT(ev); be more in line with the kernel coding 
style? (cf. DEFINE_MUTEX, DEFINE_SPINLOCK, etc).

-- 
David Härdeman
