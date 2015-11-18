Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:50656 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbbKRPwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 10:52:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Vinod Koul <vinod.koul@intel.com>,
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
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 16:51:54 +0100
Message-ID: <8215351.e99Q2vhQ5T@wuerfel>
In-Reply-To: <CAHp75VeZFXp9i_zz7CBkVQVPGQxuzYk9AbWbbbn33r8YX3LCdw@mail.gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <6358656.jIv3GGCCXu@wuerfel> <CAHp75VeZFXp9i_zz7CBkVQVPGQxuzYk9AbWbbbn33r8YX3LCdw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2015 17:43:04 Andy Shevchenko wrote:
> >
> > I assume that the sst-firmware.c case is a mistake, it should just use a
> > plain DMA_SLAVE and not DMA_MEMCPY.
> 
> Other way around.
> 

Ok, I see. In that case I guess it also shouldn't call
dmaengine_slave_config(), right? I don't think that's valid
on a MEMCPY channel.

	Arnd
