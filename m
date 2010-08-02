Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52202 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0HBQ7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 12:59:22 -0400
Date: Mon, 2 Aug 2010 17:58:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: 'Kukjin Kim' <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 1/8] ARM: Samsung: Add register definitions for
	Samsung S5P SoC camera interface
Message-ID: <20100802165852.GA6671@n2100.arm.linux.org.uk>
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com> <1279902083-21250-2-git-send-email-s.nawrocki@samsung.com> <00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com> <003001cb322d$fc976b10$f5c64130$%osciak@samsung.com> <20100802105216.GD30670@n2100.arm.linux.org.uk> <003201cb323b$72f32df0$58d989d0$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003201cb323b$72f32df0$58d989d0$%osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 02, 2010 at 02:08:42PM +0200, Pawel Osciak wrote:
> >Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> >On Mon, Aug 02, 2010 at 12:32:20PM +0200, Pawel Osciak wrote:
> >> Well, some of them are indeed unused, but it's not an uncommon practice in
> >> kernel and might help future developers.
> >
> >On the other hand, arch/arm is getting soo big that we need to do
> >something about this - and one solution is to avoid unnecessary
> >definitions that we're not using.
> >
> >Another good idea is to put definitions along side the drivers which
> >they're relevant to - maybe in a local driver-name.h file which
> >driver-name.c includes, or maybe even within driver-name.c if they're
> >not excessive.  This has the advantage of distributing the "bloat" to
> >where its actually used, and means that the driver isn't dependent so
> >much on arch/arm or even the SoC itself.
> >
> >Take a look at arch/arm/mach-vexpress/include/mach/ct-ca9x4.h and
> >arch/arm/mach-vexpress/include/mach/motherboard.h - these are the only
> >two files which contain platform definitions which are actually used
> >for Versatile Express.  Compare that with
> >arch/arm/mach-realview/include/mach/platform.h which contains lots
> >more...
> 
> So basically, what you and Mauro are recommending is that we move the *.h
> file with register definitions to drivers/media?

What I'm suggesting is what's been pretty standard in Linux for a long
time.  Take a look at: drivers/net/3c503.[ch], or for a more recent
driver, drivers/net/e1000/*.[ch].  Or drivers/mmc/host/mmci.[ch]

Putting definitions which are only used by one driver in arch/arm/*/include
is silly.
