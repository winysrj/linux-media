Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:23384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbbKRQDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 11:03:15 -0500
Date: Wed, 18 Nov 2015 21:36:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine <dmaengine@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-spi <linux-spi@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Message-ID: <20151118160618.GV25173@localhost>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <6358656.jIv3GGCCXu@wuerfel>
 <CAHp75VeZFXp9i_zz7CBkVQVPGQxuzYk9AbWbbbn33r8YX3LCdw@mail.gmail.com>
 <8215351.e99Q2vhQ5T@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8215351.e99Q2vhQ5T@wuerfel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2015 at 04:51:54PM +0100, Arnd Bergmann wrote:
> On Wednesday 18 November 2015 17:43:04 Andy Shevchenko wrote:
> > >
> > > I assume that the sst-firmware.c case is a mistake, it should just use a
> > > plain DMA_SLAVE and not DMA_MEMCPY.
> > 
> > Other way around.
> > 
> 
> Ok, I see. In that case I guess it also shouldn't call
> dmaengine_slave_config(), right? I don't think that's valid
> on a MEMCPY channel.

Yes it is not valid. In this case the dma driver should invoke a generic memcpy
and not need slave parameters, knowing the hw and reason for this (firmware
download to DSP memory), this doesn't qualify for slave case.
In fact filter function doesn't need a channel, any channel in this
controller will be good

-- 
~Vinod
