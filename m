Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f193.google.com ([209.85.160.193]:34373 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbbKRPnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 10:43:05 -0500
MIME-Version: 1.0
In-Reply-To: <6358656.jIv3GGCCXu@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<6347063.Gd6coh6hX8@wuerfel>
	<564C8E1F.8010501@ti.com>
	<6358656.jIv3GGCCXu@wuerfel>
Date: Wed, 18 Nov 2015 17:43:04 +0200
Message-ID: <CAHp75VeZFXp9i_zz7CBkVQVPGQxuzYk9AbWbbbn33r8YX3LCdw@mail.gmail.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2015 at 5:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 18 November 2015 16:41:35 Peter Ujfalusi wrote:
>> On 11/18/2015 04:29 PM, Arnd Bergmann wrote:
>> > On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
>> >> 2. non slave channel requests, where only the functionality matters, like
>> >> memcpy, interleaved, memset, etc.
>> >> We could have a simple:
>> >> dma_request_channel(mask);
>> >>
>> >> But looking at the drivers using dmaengine legacy dma_request_channel() API:
>> >> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
>> >> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SLAVE|DMA_SG
>> >> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE|DMA_SG
>> >> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVATE
>> >> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
>> >>
>> >> as examples.
>> >> Not sure how valid are these...
>
> I just had a look myself. carma has been removed fortunately in linux-next,
> so we don't have to worry about that any more.
>
> I assume that the sst-firmware.c case is a mistake, it should just use a
> plain DMA_SLAVE and not DMA_MEMCPY.

Other way around.

-- 
With Best Regards,
Andy Shevchenko
