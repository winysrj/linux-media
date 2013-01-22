Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54962 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3AVXym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 18:54:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>,
	Mike Turquette <mturquette@linaro.org>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
Date: Wed, 23 Jan 2013 00:56:26 +0100
Message-ID: <5665847.MPnegB7rS6@avalon>
In-Reply-To: <alpine.DEB.2.00.1301220256040.25789@utopia.booyaka.com>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com> <4222427.SJZRgZMHGN@avalon> <alpine.DEB.2.00.1301220256040.25789@utopia.booyaka.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Tuesday 22 January 2013 02:57:22 Paul Walmsley wrote:
> On Mon, 21 Jan 2013, Laurent Pinchart wrote:
> > OK. The omap3isp patch can go through Paul's tree as well, it won't
> > conflict with other changes to the driver in this merge window.
> > 
> > Paul, can you take both patches together ? If so I'll send you a pull
> > request.
>
> Yes I'll take them, as long as they won't cause conflicts outside of
> arch/arm/mach-omap2. Otherwise the OMAP3 ISP patch should wait until the
> early v3.9-rc integration fixes timeframe.

There's currently no conflict with the other OMAP3 ISP patches that I intend 
to push to v3.9.

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/clock

for you to fetch changes up to 6d1aa02f10497b138e01ebe6eafabd6071729334:

  omap3isp: Set cam_mclk rate directly (2013-01-23 00:44:04 +0100)

----------------------------------------------------------------
Laurent Pinchart (2):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5
      omap3isp: Set cam_mclk rate directly

 arch/arm/mach-omap2/cclock3xxx_data.c | 10 +++++++++-
 drivers/media/platform/omap3isp/isp.c | 18 ++----------------
 drivers/media/platform/omap3isp/isp.h |  8 +++-----
 3 files changed, 14 insertions(+), 22 deletions(-)

-- 
Regards,

Laurent Pinchart

