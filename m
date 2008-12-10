Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LAUY3-00087t-Dd
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 20:16:41 +0100
Received: by ug-out-1314.google.com with SMTP id x30so159076ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 10 Dec 2008 11:16:36 -0800 (PST)
Date: Wed, 10 Dec 2008 20:16:30 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Jordi Moles Blanco <jordi@cdmon.com>
In-Reply-To: <4940032D.90106@cdmon.com>
Message-ID: <alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>
References: <493FFD3A.80209@cdmon.com>
	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>
	<4940032D.90106@cdmon.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working through
 diseqc anymore
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

On Wed, 10 Dec 2008, Jordi Moles Blanco wrote:

> > > And it doesn't matter if i run "scan -s 1" or "scan -s 2" or "scan -s
> > > 3", it will always scan from "switch 1"
> > >     
> > 
> > Try with -s 0; I'm not sure if it is always the case,
> > but my unhacked `scan' uses 0-3 for DiSEqC positions
> > 1/4 to 4/4 -- I've hacked this to use the range of 1-4


> hi, thanks for anwsering.
> I've already tried that.
> remember, on switch 1 i've got astra 28.2E and on switch 2 i've got astra 19E

I realized soon after sending my reply, that I had probably
confused myself about which inputs you had where, and my
advice, while partly correct, wouldn't help...

Anyway -- the important thing to remember, is that if your
`scan' works as I expect and your kernel modules work properly
and you have a 2/1 DiSEqC switch, that scan -s option...
 0 -- will tune to position 1/2;
 1 -- will tune to position 2/2;
 2 -- will cycle back and tune position 1/2;
 3 -- will again tune position 2/2
 4 -- should spit a warning, I think (something does)

In other words -- if your system worked properly, `-s 1'
would give you 19E2 and `-s 2' would give you 28E; the
opposite of your switch labels.



> I don't why but it looks like it doesn't know how to switch to "switch 2"

If I understand from your original post (re-reading it;
as soon as people start posting distribution or system
details my eyes sort of glaze over, while other people
will get an `aha!' moment that shall remain elusive to
me)...

An older kernel version + modules worked;
an update of those modules broke DiSEqC;
your original kernel and modules didn't support your card.

What I would suggest -- keeping in mind that the dvb kernel
modules, which you should see with `lsmod', are where you
should find correct support, are probably in some package
unknown to me which you'd need to downgrade -- would be to
either revert, if possible, whatever contains those modules,
or jump ahead several kernel versions.

If you feel comfortable compiling and installing a newer
kernel (which is now around the 2.6.28 area), you could do
that.

Alternatively, and possibly better, would be to upgrade
only the linux-dvb kernel modules, building them against
your 2.6.24-era kernel source, which you may need to
download and install.

It's simple to download and build the latest linux-dvb
modules even against a 2.6.24 kernel, and that should
make things work -- if not, then something's been broken
for a while, and some expert should be able to help you.


barryb ouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
