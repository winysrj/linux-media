Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-31.mail.demon.net ([194.217.242.89])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1KkoPM-00084P-E0
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 01:13:33 +0200
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-31.mail.demon.net with esmtp (Exim 4.67)
	id 1KkoPI-0001Xj-57
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 23:13:28 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1KkoPD-0007k0-LF
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 00:13:27 +0100
Date: Tue, 30 Sep 2008 23:57:18 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4FEC93ECE8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <alpine.DEB.2.00.0809302137380.4242@ybpnyubfg.ybpnyqbznva>
References: <c362cb880809301158t27afbe1fqd9c5d391e46ffdbe@mail.gmail.com>
	<alpine.DEB.2.00.0809302137380.4242@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Trouble with tuning on Lifeview FlyDVB-T
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

I demand that BOUWSMA Barry may or may not have written...

> On Tue, 30 Sep 2008, Lee Jones wrote:
[snip]
>> $ tzap -r "BBC FOUR"
>> tuning to 562000000 Hz
>> video pid 0x0000, audio pid 0x0000
>              ^^^^              ^^^^
> This is wrong -- at least after 19h your-time -- but in case you did the
> scan before 19h your-time, you may have gotten correct PIDs for
> CBBC+CBeebies -- but not for BBC3+4, as the correct PIDs are only broadcast
> during the time those programs are actually on-air, and `tzap' is not smart
> enough to take the Service ID and derive the up-to-date PIDs from that...

OTOH, each pair (BBC3 and CBBC, BBC4 and CBeebies) use the same PIDs, so a
little careful copying will fix things.

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Buy local produce. Try to walk or cycle. TRANSPORT CAUSES GLOBAL WARMING.

The Green Midget Cafe, Bromley. Home to Spam and occasional Viking hordes.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
