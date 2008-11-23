Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-3.orange.nl ([193.252.22.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1L4B0U-00064V-Tl
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 10:11:55 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6207.online.nl (SMTP Server) with ESMTP id 381581C00086
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 10:11:21 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6207.online.nl (SMTP Server) with ESMTP id 076CC1C00085
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 10:11:16 +0100 (CET)
Message-ID: <49291E33.1050204@verbraak.org>
Date: Sun, 23 Nov 2008 10:11:15 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4928288B.1050306@cadsoft.de>
In-Reply-To: <4928288B.1050306@cadsoft.de>
Subject: Re: [linux-dvb] How to determine DVB-S2 capability in S2API?
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

Klaus Schmidinger schreef:
> I'm currently adopting the patch that makes VDR use S2API,
> but I can't figure out how an application is supposed to find out
> whether a DVB device is DVB-S or DVB-S2.
>
> Clearly I must be missing something, since S2API is said to be
> "technically superior" than the "multiproto" API (where, BTW,
> this was no problem at all ;-).
>
> Klaus
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Klaus,

I have the same problem with diseqc version. There is no request we can 
do to determine which version is supported by te device. This was 
allready missing in V3 of the API.

Michel.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
