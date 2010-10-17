Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56485 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab0JQBHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 21:07:47 -0400
Subject: Re: [PATCH 0/3] Remaining patches in my queue for IR
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <1287275805.11162.5.camel@morgan.silverblock.net>
References: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
	 <1287275805.11162.5.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 03:07:18 +0200
Message-ID: <1287277638.23804.3.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2010-10-16 at 20:36 -0400, Andy Walls wrote:
> On Sun, 2010-10-17 at 00:56 +0200, Maxim Levitsky wrote:
> > Hi,
> > 
> > This series is rebased on top of media_tree/staging/v2.6.37 only.
> > Really this time, sorry for cheating, last time :-)
> > 
> > The first patch like we agreed extends the raw packets.
> > It touches all drivers (except imon as it isn't a raw IR driver).
> 
> Will IR for the CX23885 and CX23888 still work given the changes?
> 
> Here's the relevant files that use struct ir_raw_event:
> 
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-input.c;h=bb61870b8d6ed39d25c11aa676b55bd0a94dc235;hb=staging/v2.6.37
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx25840/cx25840-ir.c;h=c2b4c14dc9ab533ff524b3e301235d6bdc92e2b9;hb=staging/v2.6.37
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23888-ir.c;h=2502a0a6709783b8c01d5de639d759d097f0f1cd;hb=staging/v2.6.37
> 
> If needed, cx23885-input.c is where a fix can be made to ensure
> structure fields are properly zeroed until I have time to fix he lower
> level stuff.
> 
> Regards,
> Andy
Wasn't aware of this as I only looked at IR directory. Will grep the
sources for more drivers. 
Anyway the changes I propose are
straightforward, I shouldn't break the driver with it.
But of course if driver isn't updated it probably won't work.

Best regards,
	Maxim Levitsky


