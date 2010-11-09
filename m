Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab0KIKfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 05:35:08 -0500
Message-ID: <4CD923C3.5040000@infradead.org>
Date: Tue, 09 Nov 2010 08:34:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@wilsonet.com
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <66b8b2f940b40cc67fa95c3ae064ef91@hardeman.nu>
In-Reply-To: <66b8b2f940b40cc67fa95c3ae064ef91@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

Em 09-11-2010 08:27, David Härdeman escreveu:
> On Tue, 02 Nov 2010 21:17:38 +0100, David Härdeman <david@hardeman.nu>
> wrote:
>> This is my current patch queue, the main change is to make struct rc_dev
>> the primary interface for rc drivers and to abstract away the fact that
>> there's an input device lurking in there somewhere.
> 
> Mauro,
> 
> you have neither commented on the patches nor committed them. At the same
> time you've created a "for_v2.6.38" branch where you've already committed
> other IR related patches. Could you please provide some feedback on what
> the plan is?

I've returned from LPC at Sunday. In the last two weeks, I received
about 140+ patches at patchwork, plus 8 pull requests, plus tons of emails that
I received at the last week. So, I have lots of backlog to handle.

My intention is to handle the pending stuff during this week.

Cheers,
Mauro


