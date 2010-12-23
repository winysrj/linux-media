Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50703 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0LWNld (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 08:41:33 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kyungmin Park <kmpark@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Ankita Garg <ankita@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
	<AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
	<20101223100642.GD3636@n2100.arm.linux.org.uk>
Date: Thu, 23 Dec 2010 14:41:26 +0100
In-Reply-To: <20101223100642.GD3636@n2100.arm.linux.org.uk> (Russell King's
	message of "Thu, 23 Dec 2010 10:06:42 +0000")
Message-ID: <87k4j0ehdl.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> Has anyone addressed my issue with it that this is wide-open for
> abuse by allocating large chunks of memory, and then remapping
> them in some way with different attributes, thereby violating the
> ARM architecture specification?
>
> In other words, do we _actually_ have a use for this which doesn't
> involve doing something like allocating 32MB of memory from it,
> remapping it so that it's DMA coherent, and then performing DMA
> on the resulting buffer?

Huge pages.

Also, don't treat it as coherent memory and just flush/clear/invalidate
cache before and after each DMA transaction.  I never understood what's
wrong with that approach.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
