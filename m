Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZHUFJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 01:09:38 -0400
Date: Fri, 21 Aug 2009 02:09:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: h.ungar@deuromedia.com
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manfred Petz <m.petz@deuromedia.com>,
	Gerhard Achs <g.achs@deuromedia.com>
Subject: Re: V4L-DVB issue in systems with >4Gb RAM?
Message-ID: <20090821020929.0e6b8853@pedra.chehab.org>
In-Reply-To: <829197380908201529u4a41c87akf685bc599e481c41@mail.gmail.com>
References: <4A8C076C.8040109@deuromedia.com>
	<37219a840908201516p23f5164fs98ad7f8267362d85@mail.gmail.com>
	<829197380908201529u4a41c87akf685bc599e481c41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helmut,

Em Thu, 20 Aug 2009 18:29:15 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Thu, Aug 20, 2009 at 6:16 PM, Michael Krufky<mkrufky@kernellabs.com> wrote:
> > I have a server with three cx23885-based PCI-E boards, one of them
> > single tuner, the other two with dual tuners.  This server has 8G RAM.
> >  The single tuner is a Hauppauge board and the dual tuners are DViCO
> > boards.  (I chose this setup for maximum tuner capacity and brand
> > diversity for the sake of testing -- I plan to replace the DViCO
> > boards with two HVR2250's)
> >
> > So, in summary, my 8G system has five digital tuners and I am not
> > experiencing the problems that you report.  I doubt the issue is
> > within the v4l-dvb subsystem.
> >
> > Good luck,
> >
> > Mike Krufky
> 
> Someone on v4l yesterday similarly reported a case where the driver
> only started to work when switched from the PAE kernel to the non-PAE.
>  Perhaps the two issues are related.

PAE kernel only affects i386 kernels. AFAIK, non-PAE kernels support only 3 Gb
of memory for normal usage, plus 1 Gb for some types of in-kernel memory usage.
As you mentioned that you're using kernel 2.6.18-128.4.1.el5 on x86_64, this
shouldn't be the problem.

I suspect that your issue is related with backporting v4l/dvb to RHEL5 kernel.
The way backport is handled at the subsystem, there are no warranties that you
won't experience any troubles, since there aren't any regression tests and the
priority is to support the latest development kernel. The only test done is
compilation test (and, eventually, a quick test with one of the supported
boards).

The task of carefully handle driver backports is an important contribution made
by the distros at the Linux ecosystem. It isn't (and never was) the intention
of the backport patches at v4l-dvb to replace the distros paper.

In a matter of fact, some of recent kernel internal API changes on some kernel
subsystems affected a lot v4l/dvb drivers, being very hard and complex to fully
support all kernel versions. Also, a few applied changes assumes that certain
bug fixes where applied on some other areas of the kernel in order to work
properly. Yet, even without those patches, for an eventual user, in general,
the driver works good enough for them. 

However, I suspect that, if you're running a RHEL5 kernel, on a machine with
8GB of RAM and 3 PCIe cx23885 cards, probably streaming regularly, your change
of hitting one of those bugs is high.

So, If you have RHEL5 support, I suggest that you should address those issues
via their support channels for they to investigate further and apply the
relevant patches that are affecting your environment

Cheers,
Mauro
