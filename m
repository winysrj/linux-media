Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1Jz5vp-0005o5-OB
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 10:13:50 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out1.iol.cz (Postfix) with ESMTP id 0591310B8E9
	for <linux-dvb@linuxtv.org>; Thu, 22 May 2008 10:13:15 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 22 May 2008 10:13:10 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200805132326.45168.ajurik@quick.cz>
	<1210716109l.6217l.2l@manu-laptop>
In-Reply-To: <1210716109l.6217l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805221013.10246.ajurik@quick.cz>
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

Hi,

my friend told me that he is sometimes able to get lock by decreasing (not 
increasing) the frequency. Yesterday I've tested it and it seems to me he was 
right. So I'm able to get (not very stable, for few minutes) lock as well as 
by increasing and by decreasing frequency of the same channel (EurosportHD). 

It was also detected (not by me, I don't have riser card) that when the card 
is connected not directly into PCI slot but with some riser card, the needed 
difference for getting lock is higher (up to 10MHz). So also some noise from 
PC is going into calculations.

I don't think the problem is in computation of frequency but in for example 
not stable signal amplitude at input of demodulator or in not fluently 
changing the gain and bandwith of tuner within the band. As I see in the code 
some parameters are changing in steps and maybe 3 steps for whole band is not 
enough? Especially in real conditions (not in lab)? 

But under Windows no problems were detected, so it seems that all that 
problems are solveable by driver (software).

BR,

Ales



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
