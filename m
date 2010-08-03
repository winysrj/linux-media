Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:25694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab0HCAqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 20:46:49 -0400
Date: Tue, 03 Aug 2010 09:46:53 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH v3 1/8] ARM: Samsung: Add register definitions for	Samsung
 S5P SoC camera interface
In-reply-to: <20100802165852.GA6671@n2100.arm.linux.org.uk>
To: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	'Pawel Osciak' <p.osciak@samsung.com>
Cc: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <00e601cb32a5$61f4d8e0$25de8aa0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com>
 <1279902083-21250-2-git-send-email-s.nawrocki@samsung.com>
 <00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com>
 <003001cb322d$fc976b10$f5c64130$%osciak@samsung.com>
 <20100802105216.GD30670@n2100.arm.linux.org.uk>
 <003201cb323b$72f32df0$58d989d0$%osciak@samsung.com>
 <20100802165852.GA6671@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King wrote:
> 
> On Mon, Aug 02, 2010 at 02:08:42PM +0200, Pawel Osciak wrote:
> > >Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > >On Mon, Aug 02, 2010 at 12:32:20PM +0200, Pawel Osciak wrote:
> > >> Well, some of them are indeed unused, but it's not an uncommon
practice in
> > >> kernel and might help future developers.
> > >
> > >On the other hand, arch/arm is getting soo big that we need to do
> > >something about this - and one solution is to avoid unnecessary
> > >definitions that we're not using.
> > >
> > >Another good idea is to put definitions along side the drivers which
> > >they're relevant to - maybe in a local driver-name.h file which
> > >driver-name.c includes, or maybe even within driver-name.c if they're
> > >not excessive.  This has the advantage of distributing the "bloat" to
> > >where its actually used, and means that the driver isn't dependent so
> > >much on arch/arm or even the SoC itself.
> > >
> > >Take a look at arch/arm/mach-vexpress/include/mach/ct-ca9x4.h and
> > >arch/arm/mach-vexpress/include/mach/motherboard.h - these are the only
> > >two files which contain platform definitions which are actually used
> > >for Versatile Express.  Compare that with
> > >arch/arm/mach-realview/include/mach/platform.h which contains lots
> > >more...
> >
> > So basically, what you and Mauro are recommending is that we move the
*.h
> > file with register definitions to drivers/media?
> 
> What I'm suggesting is what's been pretty standard in Linux for a long
> time.  Take a look at: drivers/net/3c503.[ch], or for a more recent
> driver, drivers/net/e1000/*.[ch].  Or drivers/mmc/host/mmci.[ch]
> 
I agree with Russell's opinion.
I don't want to add unnecessary(or unavailable in arch/arm) definitions in
arch/arm/*/include

> Putting definitions which are only used by one driver in
arch/arm/*/include
> is silly.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

