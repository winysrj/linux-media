Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1Ki83q-0001ec-T6
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 15:36:15 +0200
Received: from shalafi.ath.cx (shalafi-old.xs4all.nl [82.95.219.165])
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id m8NDa9Lx061555
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 15:36:09 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Received: from shalafi.ath.cx (localhost [127.0.0.1])
	by shalafi.ath.cx (8.14.2/8.14.2/Debian-2build1) with ESMTP id
	m8NDa9GM000610
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 15:36:09 +0200
From: =?us-ascii?Q?Niels_Wagenaar?= <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
Date: Tue, 23 Sep 2008 15:36:09 +0200
Mime-Version: 1.0
Message-Id: <vmime.48d8f0c9.2764.5f503f2dd63a35b@shalafi.ath.cx>
Subject: Re: [linux-dvb] Satelco EasyWatch reception woes in the 11700-11800
 MHz range
Reply-To: n.wagenaar@xs4all.nl
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

-----Original message-----
From: David Santinoli <marauder@tiscali.it>
Sent: Tue 23-09-2008 15:16
To: linux-dvb@linuxtv.org; 
Subject: [linux-dvb] Satelco EasyWatch reception woes in the 11700-11800 MHz range

> 
> Hi,
>   I'm experiencing reception problems (blocky video and scratchy audio)
> with my Satelco EasyWatch PCI card (PCI ID 1131:7146) when tuning to
> certain frequencies, roughly in the 11700-11800 MHz range.  Channels
> outside this interval are tuned OK.
> It does not look like an antenna-related issue, since feeding the same
> input to a different card (Twinhan VP1032) or a set-top box gives good
> results with all channels.
> 

Satelco is a rebrand of the KNC1 product line (or the other way around). And I encountered similar problems with the KNC1 TV-Station DVB-S card as well. But in my case, I had only problems with the transponders on Astra 28.2e which had the BBC and ITV channels on them. Other sats (or at least, the ones I could receive and watch) didn't had the problems.

> Anyone with similar experiences (with this or other cards)?
> 

First I thought it was an dish-alligment problem. But after switching to a TT-1500S the problem was resolved. I then thought allready it was a driver problem. Because the TT-1500S resolved it, I never thought about it again till your message.

> Thanks,
>  David

Regards,

Niels Wagenaar

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
