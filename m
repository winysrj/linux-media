Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:35214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab0L2MiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 07:38:07 -0500
Message-ID: <4D1B2BA6.9030002@infradead.org>
Date: Wed, 29 Dec 2010 10:37:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] DVB: TechnoTrend CT-3650 IR support
References: <4D170785.1070306@canonical.com> <4D1729DB.80406@infradead.org> <4D17999E.4000500@canonical.com> <4D18623C.8080006@infradead.org> <4D18B6AC.2040506@canonical.com> <4D18C413.3020300@infradead.org> <4D18E2D2.8020400@canonical.com> <4D1904EB.4020007@infradead.org> <4D1B23C6.2080302@canonical.com>
In-Reply-To: <4D1B23C6.2080302@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 29-12-2010 10:04, David Henningsson escreveu:
> 
> Ok, here comes the patch. It seems to be working sufficiently well after
> I discovered I needed a poll interval less than IR_KEYPRESS_TIMEOUT. As a
> side note, grepping for rc_interval seems to reveal a few intervals >= 250, 
> could we have suboptimal results from these as well?

There are some drivers that we actually fixed IR repeat by increasing it
to 500 ms ;)

Those timeouts are somewhat hardware-related, as it depends on what the hardware
(or how the raw IR decoder logic at RC core) decodes the IR code.

Cheers,
Mauro
