Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KYU7M-0003Jr-1q
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 01:08:02 +0200
Date: Thu, 28 Aug 2008 01:07:26 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20080827212413.GI7830@moelleritberatung.de>
Message-ID: <20080827230726.271670@gmx.net>
MIME-Version: 1.0
References: <BAY137-W489CF3F8D962EC11AB96CD90610@phx.gbl>
	<20080827212413.GI7830@moelleritberatung.de>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Inclusion of STB0899 support in kernel
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

> Hi,
> 
> On Wed, Aug 27, 2008 at 10:19:06PM +0200, johan vdp wrote:
> > 
> > What happened to STB0899 support?
> > Building a kernel, patching it (with some luck), building applications
> with patches to match the driver, it is simply too much work.
> > (It might be fun once, but starts to be annoying when automatic package
> updates start to fail, the next day.)
> > Having support in the kernel, will lead to applications that
> 'automatically' start to support it.
> >  
> > Back in the days that 'multiproto' development was still alive and
> buzzing. The STB0899 cards looked like having the best support.
> > I have followed these lists for some time and opted to buy a STB0899
> based DVB-S2 tuner card because the outlook for support was good; THEN.
> > NOW it must have been two years, and it is still not merged into the
> kernel.
> 
> Same here. I am using multiproto for a long time now. Personally for me
> it works great, but it is really bad, that it is still not included in
> the kernel.
> 
> Manu Abrahams hg tree is "out of date" and it is impossible to compile
> it with a recent kernel without patching it.
> 
> Hopefully Igor M. Liplianin has created an hg tree, which merges all the
> different dvb-trees in one single tree
> (http://liplianindvb.sourceforge.net/hg/liplianindvb).
> This really helps in compiling multiproto, but this is not the solution.
> 
> What is required to get multiproto into the kernel?
> Where are the problems?
> 
> Regards, Artem

I absolutely agree. Please see the messages I sent on this recently
http://linuxtv.org/pipermail/linux-dvb/2008-August/028084.html

For the reasons mentioned above it is a terrible waste of effort to maintain
code outside the kernel. Because multiproto (or equivalent code) has not
been merged into the kernel (after 2 years and 4.5 months in development) there
is a *lot* of out-of-kernel code supporting DVB-S2 cards, which of course are
amongst the most popular, capable and important cards on the market. It is 
not OK to expect everyone (including end users) to clone hg trees and update
and patch them repeatedly. All driver code should be heading towards the kernel,
preferably sooner than later. Anything else is pointless.

I think Linux DVB is in a state of unacknowledged crisis.  

The code works, but the kernel merging of multiproto or another way of supporting
DVB-S2 cards seems to be completely paralysed.  What is required to get it done?
It must eventually be accomplished.

OT, even the simplest userspace code is sorely lacking. Simple yet important tools such
as szap, and scan don't even have version numbers. Distros don't agree on whether
the package is called dvb-apps or dvb-utils and have had to create their own code
versioning. How many szap patches are floating around?

Hans
-- 
Release early, release often. Really, you should.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
