Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36191 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab1DMWAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 18:00:48 -0400
Date: Wed, 13 Apr 2011 23:00:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper
	broken on ARM
Message-ID: <20110413220008.GA23901@n2100.arm.linux.org.uk>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <201104131252.32011.jkrzyszt@tis.icnet.pl> <20110413183231.GA23631@n2100.arm.linux.org.uk> <201104132256.40325.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201104132256.40325.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Apr 13, 2011 at 10:56:39PM +0200, Janusz Krzysztofik wrote:
> Dnia środa 13 kwiecień 2011 o 20:32:31 Russell King - ARM Linux 
> napisał(a):
> > On Wed, Apr 13, 2011 at 12:52:31PM +0200, Janusz Krzysztofik wrote:
> > > Taking into account that I'm just trying to fix a regression, and
> > > not invent a new, long term solution: are you able to name an ARM
> > > based board which a) is already supported in 2.6.39, b) is (or can
> > > be) equipped with a device supported by a V4L driver which uses
> > > videobuf- dma-config susbsystem, c) has a bus structure with which
> > > virt_to_phys(bus_to_virt(dma_handle)) is not equal dma_handle?
> > 
> > I have no idea - and why should whether someone can name something
> > that may break be a justification to allow something which is
> > technically wrong?
> > 
> > Surely it should be the other way around - if its technically wrong
> > and _may_ break something then it shouldn't be allowed.
> 
> In theory - of course. In practice - couldn't we now, close to -rc3, 
> relax the rules a little bit and stop bothering with something that may 
> break in the future if it doesn't break on any board supported so far (I 
> hope)?

If we are worried about closeness to -final, then what should happen is
that the original commit is reverted; the "fix" for IOMMUs resulted in
a regression for existing users which isn't trivial to resolve without
risking possible breakage of other users.

Do we even know whether bus_to_virt(iommu_bus_address) works?  I suspect
it doesn't, so by doing so you're already re-breaking the IOMMU case.
