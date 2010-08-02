Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59602 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0HBMJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 08:09:51 -0400
Date: Mon, 2 Aug 2010 13:09:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Pawel Osciak <p.osciak@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 1/8] ARM: Samsung: Add register definitions for
	Samsung S5P SoC camera interface
Message-ID: <20100802120914.GF30670@n2100.arm.linux.org.uk>
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com> <1279902083-21250-2-git-send-email-s.nawrocki@samsung.com> <00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com> <003001cb322d$fc976b10$f5c64130$%osciak@samsung.com> <20100802105216.GD30670@n2100.arm.linux.org.uk> <4C56B12A.3080808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C56B12A.3080808@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 02, 2010 at 08:51:06AM -0300, Mauro Carvalho Chehab wrote:
> Em 02-08-2010 07:52, Russell King - ARM Linux escreveu:
> > On Mon, Aug 02, 2010 at 12:32:20PM +0200, Pawel Osciak wrote:
> >> Well, some of them are indeed unused, but it's not an uncommon practice in
> >> kernel and might help future developers.
> > 
> > On the other hand, arch/arm is getting soo big that we need to do
> > something about this - and one solution is to avoid unnecessary
> > definitions that we're not using.
> > 
> > Another good idea is to put definitions along side the drivers which
> > they're relevant to - maybe in a local driver-name.h file which
> > driver-name.c includes, or maybe even within driver-name.c if they're
> > not excessive.  This has the advantage of distributing the "bloat" to
> > where its actually used, and means that the driver isn't dependent so
> > much on arch/arm or even the SoC itself.
> 
> Very much appreciated from my side. It is very hard to sync changes that
> happen via arm trees when merging from my tree. There were several cases
> in the past were I needed to coordinate with an ARM maintainer about when
> he would merge from his tree, as the patches I had on media tree were
> highly dependent on the patches at arch.

That's a separate problem - one which occurs when there's platform
code in arch/arm/ which shares a common data structure with driver
code under drivers/.

I don't think there's an easy resolution to that one, because if
you split the arch/arm/ change (which may depend on other arch/arm/
changes) from the drivers/ change, someone ends up losing no matter
where the header file with the common data structure is placed.

One answer to that is to kill the idea that every ARM architecture
needs to define their own watchdog platform data - and instead
replace it with a shared watchdog_platform_data structure, much like
the flash_platform_data structure in arch/arm/include/asm/mach/flash.h
(which'd would be nice to be under include/linux ...)
