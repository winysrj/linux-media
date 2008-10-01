Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Kkphl-0002Yk-Vn
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 02:36:39 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4FEC93ECE8%linux@youmustbejoking.demon.co.uk>
References: <c362cb880809301158t27afbe1fqd9c5d391e46ffdbe@mail.gmail.com>
	<alpine.DEB.2.00.0809302137380.4242@ybpnyubfg.ybpnyqbznva>
	<4FEC93ECE8%linux@youmustbejoking.demon.co.uk>
Date: Wed, 01 Oct 2008 02:31:18 +0200
Message-Id: <1222821078.5209.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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


Am Dienstag, den 30.09.2008, 23:57 +0100 schrieb Darren Salt:
> I demand that BOUWSMA Barry may or may not have written...
> 
> > On Tue, 30 Sep 2008, Lee Jones wrote:
> [snip]
> >> $ tzap -r "BBC FOUR"
> >> tuning to 562000000 Hz
> >> video pid 0x0000, audio pid 0x0000
> >              ^^^^              ^^^^
> > This is wrong -- at least after 19h your-time -- but in case you did the
> > scan before 19h your-time, you may have gotten correct PIDs for
> > CBBC+CBeebies -- but not for BBC3+4, as the correct PIDs are only broadcast
> > during the time those programs are actually on-air, and `tzap' is not smart
> > enough to take the Service ID and derive the up-to-date PIDs from that...
> 
> OTOH, each pair (BBC3 and CBBC, BBC4 and CBeebies) use the same PIDs, so a
> little careful copying will fix things.
> 
> [snip]

If also FEC has changed, we often saw that already, it must be corrected
or all except frequency and bandwidth should be set to AUTO in the
initial scanfile for the tda10046.

Also above we see a tuning attempt to 562000000 Hz and previously we saw
already a positive offset added 562166670:INVERSION_AUTO:BANDWIDTH_8_MHZ

IIRC, in the UK, the queen might save you from trolls, spam and vikings,
usually a negative offset like this is reported more regularly?

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
