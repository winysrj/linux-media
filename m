Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54995 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2GaNFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 09:05:23 -0400
Date: Tue, 31 Jul 2012 15:05:17 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: "[PULL] video_visstrim for 3.6"
Message-ID: <20120731130517.GS24458@pengutronix.de>
References: <1343295404-8931-1-git-send-email-javier.martin@vista-silicon.com>
 <50170DE0.2030007@redhat.com>
 <CACKLOr2+y5emMuvKR0nLdQR=GtUOZ6Ms7j65bO5iXB8jJw0L4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr2+y5emMuvKR0nLdQR=GtUOZ6Ms7j65bO5iXB8jJw0L4Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2012 at 08:13:59AM +0200, javier Martin wrote:
> On 31 July 2012 00:42, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > Em 26-07-2012 06:36, Javier Martin escreveu:
> >> Hi Mauro,
> >> this pull request is composed of two series that provide support for two mem2mem devices:
> >> - 'm2m-deinterlace' video deinterlacer
> >> - 'coda video codec'
> >> I've included platform support for them too.
> >>
> >>
> >> The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:
> >>
> >>    Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
> >>
> >> are available in the git repository at:
> >>
> >>    https://github.com/jmartinc/video_visstrim.git for_3.6
> >>
> >> for you to fetch changes up to 9bb10266da63ae7f8f198573e099580e9f98f4e8:
> >>
> >>    i.MX27: Visstrim_M10: Add support for deinterlacing driver. (2012-07-26 10:57:30 +0200)
> >>
> >> ----------------------------------------------------------------
> >> Javier Martin (5):
> >>        i.MX: coda: Add platform support for coda in i.MX27.
> >>        media: coda: Add driver for Coda video codec.
> >>        Visstrim M10: Add support for Coda.
> >>        media: Add mem2mem deinterlacing driver.
> >>        i.MX27: Visstrim_M10: Add support for deinterlacing driver.
> >>
> >>   arch/arm/mach-imx/clk-imx27.c                   |    4 +-
> >>   arch/arm/mach-imx/devices-imx27.h               |    4 +
> >>   arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |   49 +-
> >>   arch/arm/plat-mxc/devices/Kconfig               |    6 +-
> >>   arch/arm/plat-mxc/devices/Makefile              |    1 +
> >>   arch/arm/plat-mxc/devices/platform-imx27-coda.c |   37 +
> >>   arch/arm/plat-mxc/include/mach/devices-common.h |    8 +
> >
> > I need ARM maintainer's ack for the patches that touch the above files.

Generally:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

I think that these are quite late for this merge window though. The pull
request should have been out before the 3.5 Release.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
