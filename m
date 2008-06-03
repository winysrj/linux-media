Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-37.mail.demon.net ([194.217.242.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1K3bj6-0003oP-Br
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 20:59:21 +0200
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-37.mail.demon.net with esmtp (Exim 4.68)
	id 1K3bj2-0005A5-P9
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 18:59:16 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1K3bix-0005eM-D8
	for linux-dvb@linuxtv.org; Tue, 03 Jun 2008 19:59:15 +0100
Date: Tue, 03 Jun 2008 19:56:02 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4FAF355C38%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <48457545.6060509@gmail.com>
References: <48457545.6060509@gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] [BUG] Firmware loading of FF cards is broken
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I demand that e9hack may or may not have written...

[snip]
> It seems, that get_unaligned_be32() is broken. The definition in compat.h
> is:
> #define get_unaligned_be32(a)                                   \
>          be32_to_cpu(get_unaligned((unsigned short *)(a)))

> 'unsigned short *' is wrong. It should be 'unsigned long *'.

That could be a 64-bit type. You want unsigned int or uint32_t.

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Buy local produce. Try to walk or cycle. TRANSPORT CAUSES GLOBAL WARMING.

Succumb to natural tendencies. Be hateful and boring.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
