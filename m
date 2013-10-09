Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54747 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab3JINFa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Oct 2013 09:05:30 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-media@vger.kernel.org
References: <m3eh82a1yo.fsf@t19.piap.pl> <m361t9a31i.fsf@t19.piap.pl>
	<20131007142429.GG3098@linux-mips.org> <m3li24891u.fsf@t19.piap.pl>
	<20131008120727.GH1615@linux-mips.org> <m38uy37x5r.fsf@t19.piap.pl>
	<20131009081707.GL1615@linux-mips.org>
Date: Wed, 09 Oct 2013 15:05:28 +0200
In-Reply-To: <20131009081707.GL1615@linux-mips.org> (Ralf Baechle's message of
	"Wed, 9 Oct 2013 10:17:07 +0200")
MIME-Version: 1.0
Message-ID: <m3y562d27b.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ralf Baechle <ralf@linux-mips.org> writes:

> The kernel is supposed to perform the necessary cache flushing, so any
> remaining aliasing issue would be considered a bug.  But the code is
> performance sensitive, some of the problem cases are twisted and complex
> so bugs and unsolved corner cases show up every now and then.

Ok. This means I should also investigate the V4L2 and the hw driver
code, because the cache aliasing shouldn't be there in the first place.

> Does it work for you, even solve your problem?

Sure, with 16 KB page size everything works fine.

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
