Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45487 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3JIGxe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Oct 2013 02:53:34 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-media@vger.kernel.org
References: <m3eh82a1yo.fsf@t19.piap.pl> <m361t9a31i.fsf@t19.piap.pl>
	<20131007142429.GG3098@linux-mips.org> <m3li24891u.fsf@t19.piap.pl>
	<20131008120727.GH1615@linux-mips.org>
Date: Wed, 09 Oct 2013 08:53:20 +0200
In-Reply-To: <20131008120727.GH1615@linux-mips.org> (Ralf Baechle's message of
	"Tue, 8 Oct 2013 14:07:27 +0200")
MIME-Version: 1.0
Message-ID: <m38uy37x5r.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ralf Baechle <ralf@linux-mips.org> writes:

> 16K is a silver bullet solution to all cache aliasing problems.  So if
> your issue persists with 16K page size, it's not a cache aliasing issue.
> Aside there are generally performance gains from the bigger page size.

I wonder why isn't the issue present in other cases. Perhaps remapping
of a userspace address and accessing it with kseg0 isn't a frequent
operation.

Shouldn't we change the default page size (on affected CPUs) to 16 KB
then? Alternatively, we could flush/invalidate the cache when needed -
is it a viable option?

Thanks.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
