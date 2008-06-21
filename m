Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KA6lq-00031J-5l
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 19:21:04 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out2.iol.cz (Postfix) with ESMTP id EF0D61BA25E
	for <linux-dvb@linuxtv.org>; Sat, 21 Jun 2008 19:20:26 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Sat, 21 Jun 2008 19:20:25 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200806211552.41278.ajurik@quick.cz>
	<200806211840.47025.dkuhlen@gmx.net>
In-Reply-To: <200806211840.47025.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806211920.25821.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels
	with TT S2-3200/linux
Reply-To: ajurik@quick.cz
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

On Saturday 21 of June 2008, Dominik Kuhlen wrote:
> Well, I tested:
> 19.2 12522 V 8PSK 22000 2/3
>   i get 100% (and immediate) lock in the range from: 12512 to 12532
Hi,
with this transponder I also don't have problem to get lock.
>
...
>
> The other 13.0 8PSK (11278V and 11449H) are tougher:  they take a few
> seconds to lock and sometimes they don't lock at all according to the NIT
> they use roll-off factor 0.2 (the other channels use 0.35) This is
> interesting: I'll check why this takes so much longer

Yes, these transponders are those I couldn't lock. Other transponders with the 
same problem are transponders from Thor5 (0.8W) - 11341MHz V, 11421MHz H, 
11434MHz V, 12015MHz H and 12128MHz H. 

Changig RollOff to any value didn't get me any result.

BR,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
