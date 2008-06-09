Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hond.eatserver.nl ([195.20.9.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joep@groovytunes.nl>) id 1K5klp-0006w4-IA
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 19:03:04 +0200
Received: from test (82-171-18-31.ip.telfort.nl [82.171.18.31])
	(authenticated bits=0)
	by hond.eatserver.nl (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	m59H2uoh022614
	for <linux-dvb@linuxtv.org>; Mon, 9 Jun 2008 19:02:56 +0200
From: joep <joep@groovytunes.nl>
To: linux-dvb@linuxtv.org
Date: Mon, 9 Jun 2008 19:06:28 +0200
References: <1212585271.32385.41.camel@pascal>
	<1212590233.15236.11.camel@rommel.snap.tv>
	<200806041928.26807.joep@groovytunes.nl>
In-Reply-To: <200806041928.26807.joep@groovytunes.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806091906.28380.joep@groovytunes.nl>
Subject: Re: [linux-dvb] diseqc VP-1041 skystar hd2
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

Op Wednesday 04 June 2008 19:28:26 schreef joep:
> Hello all.
> I have a skystar hd2 card and installed the latest mantis driver.
> Now I am able to watch some dvb-s and dvb-s2 channels from astra 19,2.
> The LNB for this satalite is connected to the default switch port.
> When I try to tune to a channel on any other satalite that is on de diseqc
> switch I get no signal.
> I tried this with mythtv 0.21 and the mythtv patch from:
> http://svn.mythtv.org/trac/ticket/5403
>
> I have 2 questions.
> 1. Has anyone used the skystar hd2 or twinhand vp-1041 succesfull with a
> diseqc switch?
>
> 2. What should I do to figure out what the problem is exactly?
>
> Thanks
> Joep
>

Hmm nobody seems to use the same setup as I am using..
I have a more common question:
Is it possilbe to load the mantis module with some kind of debug parameter?
In my case I would like to know exactly what driver calls MythTV makes.

Thanks,
Joep

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
