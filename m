Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51103 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbbKROlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 09:41:53 -0500
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
To: Arnd Bergmann <arnd@arndb.de>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <20150624162401.GP19530@localhost> <564C8966.9080406@ti.com>
 <6347063.Gd6coh6hX8@wuerfel>
CC: Vinod Koul <vinod.koul@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	<dmaengine@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>,
	linux-spi <linux-spi@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <564C8E1F.8010501@ti.com>
Date: Wed, 18 Nov 2015 16:41:35 +0200
MIME-Version: 1.0
In-Reply-To: <6347063.Gd6coh6hX8@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/18/2015 04:29 PM, Arnd Bergmann wrote:
> On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
>> 2. non slave channel requests, where only the functionality matters, like
>> memcpy, interleaved, memset, etc.
>> We could have a simple:
>> dma_request_channel(mask);
>>
>> But looking at the drivers using dmaengine legacy dma_request_channel() API:
>> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
>> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SLAVE|DMA_SG
>> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE|DMA_SG
>> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVATE
>> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
>>
>> as examples.
>> Not sure how valid are these...
> 
> It's usually not much harder to separate out the legacy case from
> the normal dma_request_slave_channel_reason(), so those drivers don't
> really need to use the unified compat API.

The current dma_request_slave_channel()/_reason() is not the 'legacy' API.
Currently there is no way to get the reason why the dma channel request fails
when using the _compat() version of the API, which is used by drivers which
can be used in DT or in legacy mode as well. Sure, they all could have local
if(){}else{} for handling this, but it is not a nice thing.

As it was discussed instead of adding the _reason() version for the _compat
call, we should simplify the dmaengine API for getting the channel and at the
same time we will have ERR_PTR returned instead of NULL.

-- 
Péter
