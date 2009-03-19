Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZCSOja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 10:39:30 -0400
Date: Thu, 19 Mar 2009 11:39:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci, and
  others drivers
Message-ID: <20090319113903.7663ae71@pedra.chehab.org>
In-Reply-To: <208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
References: <1237467800.19717.37.camel@tux.localhost>
	<20090319110303.7a53f9bb@pedra.chehab.org>
	<208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009 17:18:47 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> On Thu, Mar 19, 2009 at 5:03 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Thu, 19 Mar 2009 16:03:20 +0300
> > Alexey Klimov <klimov.linux@gmail.com> wrote:
> >
> >> Hello, all
> >> What do you think about such patch that makes selecting of radio drivers
> >> in menuconfig more comfortable ?
> >
> > Frankly, I don't see any gain: If the user doesn't have ISA (or doesn't want to
> > have), it should have already unselected the ISA sub-menu. The remaining PCI
> > and USB drivers are few. So, creating menus for them seem overkill.
> >
> > We could eventually reorganize the item order, and adding a few comments to
> > indicate the drivers that are ISA, PCI, PCIe and USB (something similar to what
> > was done at DVB frontend part of the menu), but still, I can't see much value.
> 
> Okay, well, sorry for bothering.
> Only one point here - if user want to unselect radio drivers in
> menuconfig, for example - pci and isa in some bad config file he
> should pick a lot of times, and with this patch only 2 times.
> But, okay.
> 

Once, someone suggested me to create some sort of "default" option for media
drivers, in a way that people can just click on a few places, if he wants
to do things like "select all that compiles and their dependencies" or "don't
select nothing" except for those.

Those kind of things could be interesting, but they may create even more mess
over what we currently have on our complex Kbuilding system.

For the out-of-system building, one alternative would be to create some make
syntax for building just some drivers, like:

	make driver=cx88,ivtv

or, even better:

	make cx88 ivtv

Such command could generate a .config file that has just the driver plus their
dependencies and selects.

Cheers,
Mauro
