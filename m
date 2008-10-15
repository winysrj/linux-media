Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-32.mail.demon.net ([194.217.242.90])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1Kq5yO-0004XS-D5
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 14:59:35 +0200
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-32.mail.demon.net with esmtp (Exim 4.67)
	id 1Kq5yJ-0007aP-7k
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 12:59:27 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1Kq5y7-0005OE-Uw
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 13:59:22 +0100
Date: Wed, 15 Oct 2008 13:54:20 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4FF41642E0%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1224067873.5059.15.camel@morgan.walls.org>
References: <001501c92e56$a4903870$edb0a950$@net>
	<1224029752.3248.34.camel@palomino.walls.org>
	<003101c92e68$fe5e5000$fb1af000$@net>
	<1224067873.5059.15.camel@morgan.walls.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Duel Hauppauge HVR-1600
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

I demand that Andy Walls may or may not have written...

> On Tue, 2008-10-14 at 20:54 -0500, Tom Moore wrote:
>> Thanks Andy for the reply.
>> I did what you said and now I'm getting an memory error message when
>> booting
>> The message reads:
>> Initrd extends beyond end of memory (0x37fef23a > 0x30000000)

> Well, that's a new one on me.

>> I tried lowering the amount but anything over 128M and I get the error
>> message.

[snip]
> The driver did make some suggestions in its original error message:
>>> cx18-1: ioremap failed, perhaps increasing __VMALLOC_RESERVE in page.h
>>> cx18-1: or disabling CONFIG_HIGHMEM4G into the kernel would help
>>> cx18-1: Error -12 on initialization

> both of which you could try.  They involve building a custom kernel.

> There may be other ways, but I'm no expert in Linux memory management.
> I suspect someone over on the LKML is.

I'd go straight for an amd64 kernel, so long as the hardware supports it.
That way, the 1GB/4GB/64GB stuff becomes irrelevant.

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
|   <URL:http://www.youmustbejoking.demon.co.uk/> (PGP 2.6, GPG keys)

Sooner or later, the worst possible set of circumstances is bound to occur.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
