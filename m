Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K7vv0-0005XH-6o
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 19:21:35 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Sun, 15 Jun 2008 19:20:30 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200805221013.10246.ajurik@quick.cz>
	<200806151147.19451.dkuhlen@gmx.net>
In-Reply-To: <200806151147.19451.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806151920.30719.ajurik@quick.cz>
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

On Sunday 15 of June 2008, Dominik Kuhlen wrote:
> Hi,
>
> On Thursday 22 May 2008, Ales Jurik wrote:
> > Hi,
> >
> > my friend told me that he is sometimes able to get lock by decreasing
> > (not increasing) the frequency. Yesterday I've tested it and it seems to
> > me he was right. So I'm able to get (not very stable, for few minutes)
> > lock as well as by increasing and by decreasing frequency of the same
> > channel (EurosportHD).
>
> The derotator code in the stb0899 seems to be setting the initial frequency
> to the lowest search range and never changes this (as it should increase
> steadily to find a lock)
>
> > It was also detected (not by me, I don't have riser card) that when the
> > card is connected not directly into PCI slot but with some riser card,
> > the needed difference for getting lock is higher (up to 10MHz). So also
> > some noise from PC is going into calculations.
> >
> > I don't think the problem is in computation of frequency but in for
> > example not stable signal amplitude at input of demodulator or in not
> > fluently changing the gain and bandwith of tuner within the band. As I
> > see in the code some parameters are changing in steps and maybe 3 steps
> > for whole band is not enough? Especially in real conditions (not in lab)?
>
> Could you please try the attached patch if this fixes the problem with
> nominal frequency/symbolrate settings?
>

Many thanks, but I don't see any improvement. Minimum time after I've lock is 
150s. 

The only improvement was done 2weeks ago when Manu Abraham fixed some headers 
with register addresses. From that time it is possible to get lock also at 
problematic channels but very unstable.

But I've found that all channels with lock problems are DVB-S2, 8PSK, FEC 3/4. 
So all channels broadcasted in QPSK is possible to tune without problems and 
also channels broadcasted in DVB-S2, 8PSK, FEC 2/3 are possible to tune to 
without problems. Channels in DVB-S2, 8PSK with different FEC (to 2/3 and 
3/4) I was not able to test.

Do you think that info could be useful?

BR,

Ales



> > But under Windows no problems were detected, so it seems that all that
> > problems are solveable by driver (software).
> >
> > BR,
> >
> > Ales
> >
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> Dominik



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
