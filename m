Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40548 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbbKSKek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 05:34:40 -0500
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
To: Arnd Bergmann <arnd@arndb.de>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <6347063.Gd6coh6hX8@wuerfel> <564C8E1F.8010501@ti.com>
 <6358656.jIv3GGCCXu@wuerfel>
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
Message-ID: <564DA5AE.3060608@ti.com>
Date: Thu, 19 Nov 2015 12:34:22 +0200
MIME-Version: 1.0
In-Reply-To: <6358656.jIv3GGCCXu@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/18/2015 05:07 PM, Arnd Bergmann wrote:
> On Wednesday 18 November 2015 16:41:35 Peter Ujfalusi wrote:
>> On 11/18/2015 04:29 PM, Arnd Bergmann wrote:
>>> On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
>>>> 2. non slave channel requests, where only the functionality matters, like
>>>> memcpy, interleaved, memset, etc.
>>>> We could have a simple:
>>>> dma_request_channel(mask);
>>>>
>>>> But looking at the drivers using dmaengine legacy dma_request_channel() API:
>>>> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
>>>> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SLAVE|DMA_SG
>>>> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE|DMA_SG
>>>> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVATE
>>>> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
>>>>
>>>> as examples.
>>>> Not sure how valid are these...
> 
> I just had a look myself. carma has been removed fortunately in linux-next,
> so we don't have to worry about that any more.
> 
> I assume that the sst-firmware.c case is a mistake, it should just use a
> plain DMA_SLAVE and not DMA_MEMCPY.
> 
> Aside from these, everyone else uses either DMA_CYCLIC in addition to
> DMA_SLAVE, which seems valid, or they use DMA_PRIVATE, which I think is
> redundant in slave drivers and can be removed.

Yep, CYCLIC. How could I forgot that ;)

>>> It's usually not much harder to separate out the legacy case from
>>> the normal dma_request_slave_channel_reason(), so those drivers don't
>>> really need to use the unified compat API.
>>
>> The current dma_request_slave_channel()/_reason() is not the 'legacy' API.
>> Currently there is no way to get the reason why the dma channel request fails
>> when using the _compat() version of the API, which is used by drivers which
>> can be used in DT or in legacy mode as well. Sure, they all could have local
>> if(){}else{} for handling this, but it is not a nice thing.
>>
>> As it was discussed instead of adding the _reason() version for the _compat
>> call, we should simplify the dmaengine API for getting the channel and at the
>> same time we will have ERR_PTR returned instead of NULL.
> 
> What I meant was that we don't need to handle them with the unified
> simple interface. The users of DMA_CYCLIC can just keep using
> an internal helper that only deals with the legacy case, or use
> dma_request_slave() or whatever is the new API for the DT case.

I think we can go with a single API, but I don't really like that:
dma_request_channel(dev, name, *mask, fn, fn_param);

This would cover all current uses being legacy, DT/ACPI, compat, etc:
dma_request_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy slave */
dma_request_channel(NULL, NULL, &mask, NULL, NULL); /* memcpy. etc */
dma_request_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, current slave */
dma_request_channel(dev, name, &mask, fn, fn_param); /* current compat */

Note, that we need "const dma_cap_mask_t *mask" to be able to make the mask
optional.

If we have two main APIs, one to request slave channels and one to get any
channel with given capability
dma_request_slave_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy slave */
dma_request_slave_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, current
							   slave */
dma_request_slave_channel(dev, name, &mask, fn, fn_param); /* current compat*/

This way we can omit the mask also in cases when the client only want to get
DMA_SLAVE, we can just build up the mask within the function. If the mask is
provided we would copy the bits from the provided mask, so for example if you
want to have DMA_SLAVE+DMA_CYCLIC, the driver only needs to pass DMA_CYCLIC,
the DMA_SLAVE is going to be set anyways.

dma_request_channel(mask); /* memcpy. etc, non slave mostly */

Not sure how to name this as reusing existing (good, descriptive) function
names would mean changes all over the kernel to start off this.

Not used and
request_dma_channel(); /* as _irq/_mem_region/_resource, etc */
request_dma();
dma_channel_request();

All in all, not sure which way would be better...

-- 
Péter
