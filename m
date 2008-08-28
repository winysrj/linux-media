Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n36.bullet.mail.ukl.yahoo.com ([87.248.110.169])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KYVIc-0000re-Bb
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 02:23:43 +0200
Date: Wed, 27 Aug 2008 20:23:03 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <BAY137-W489CF3F8D962EC11AB96CD90610@phx.gbl>
	<20080827212413.GI7830@moelleritberatung.de>
	<20080827230726.271670@gmx.net>
In-Reply-To: <20080827230726.271670@gmx.net> (from HWerner4@gmx.de on Wed
	Aug 27 19:07:26 2008)
Message-Id: <1219882983l.9440l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  Inclusion of STB0899 support in kernel
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 27.08.2008 19:07:26, Hans Werner a =E9crit=A0:
> > Hi,
> > =

> > On Wed, Aug 27, 2008 at 10:19:06PM +0200, johan vdp wrote:
> > > =

> > > What happened to STB0899 support?
> > > Building a kernel, patching it (with some luck), building
> applications
> > with patches to match the driver, it is simply too much work.
> > > (It might be fun once, but starts to be annoying when automatic
> package
> > updates start to fail, the next day.)
> > > Having support in the kernel, will lead to applications that
> > 'automatically' start to support it.
> > >  =

> > > Back in the days that 'multiproto' development was still alive =

> and
> > buzzing. The STB0899 cards looked like having the best support.
> > > I have followed these lists for some time and opted to buy a
> STB0899
> > based DVB-S2 tuner card because the outlook for support was good;
> THEN.
> > > NOW it must have been two years, and it is still not merged into
> the
> > kernel.
> > =

> > Same here. I am using multiproto for a long time now. Personally =

> for
> me
> > it works great, but it is really bad, that it is still not included
> in
> > the kernel.
> > =

> > Manu Abrahams hg tree is "out of date" and it is impossible to
> compile
> > it with a recent kernel without patching it.
> > =

> > Hopefully Igor M. Liplianin has created an hg tree, which merges =

> all
> the
> > different dvb-trees in one single tree
> > (http://liplianindvb.sourceforge.net/hg/liplianindvb).
> > This really helps in compiling multiproto, but this is not the
> solution.
> > =

> > What is required to get multiproto into the kernel?
> > Where are the problems?
> > =

> > Regards, Artem
> =

> I absolutely agree. Please see the messages I sent on this recently
> http://linuxtv.org/pipermail/linux-dvb/2008-August/028084.html
> =

> For the reasons mentioned above it is a terrible waste of effort to
> maintain
> code outside the kernel. Because multiproto (or equivalent code) has
> not
> been merged into the kernel (after 2 years and 4.5 months in
> development) there
> is a *lot* of out-of-kernel code supporting DVB-S2 cards, which of
> course are
> amongst the most popular, capable and important cards on the market.
> It is =

> not OK to expect everyone (including end users) to clone hg trees and
> update
> and patch them repeatedly. All driver code should be heading towards
> the kernel,
> preferably sooner than later. Anything else is pointless.
> =

> I think Linux DVB is in a state of unacknowledged crisis.  =

> =

> The code works, but the kernel merging of multiproto or another way =

> of
> supporting
> DVB-S2 cards seems to be completely paralysed.  What is required to
> get it done?
> It must eventually be accomplished.
> =

> OT, even the simplest userspace code is sorely lacking. Simple yet
> important tools such
> as szap, and scan don't even have version numbers. Distros don't =

> agree
> on whether
> the package is called dvb-apps or dvb-utils and have had to create
> their own code
> versioning. How many szap patches are floating around?

May I add that the support of certain cards (especially TT 3200) has =

some issues and that this state of affairs just makes it even harder to =

fix (see my numerous posts about it).
I would love to hear from the maintainers about what needs to be done =

(and please forget the history so that we can probably avoid another =

long and sterile flamewar), things must go forward from now.
Hope that someone who can do something about this can explain to us how =

we can help.
Bye
Manu




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
