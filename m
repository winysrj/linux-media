Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45944 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbKTMwY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 07:52:24 -0500
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
To: Arnd Bergmann <arnd@arndb.de>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <4533695.7ZVFN1S94o@wuerfel> <564EF502.6040708@ti.com>
 <6118451.vaLZWOZEF5@wuerfel>
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
Message-ID: <564F1773.9030006@ti.com>
Date: Fri, 20 Nov 2015 14:52:03 +0200
MIME-Version: 1.0
In-Reply-To: <6118451.vaLZWOZEF5@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2015 12:58 PM, Arnd Bergmann wrote:
>>> That way the vast majority of drivers can use one of the two nice interfaces
>>> and the rest can be converted to use __dma_request_chan().
>>>
>>> On a related topic, we had in the past considered providing a way for
>>> platform code to register a lookup table of some sort, to associate
>>> a device/name pair with a configuration. That would let us use the
>>> simplified dma_request_slavechan(dev, name) pair everywhere. We could
>>> use the same method that we have for clk_register_clkdevs() or
>>> pinctrl_register_map().
>>>
>>> Something like either
>>>
>>> static struct dma_chan_map myplatform_dma_map[] = {
>>> 	{ .devname = "omap-aes0", .slave = "tx", .filter = omap_dma_filter_fn, .arg = (void *)65, },
>>> 	{ .devname = "omap-aes0", .slave = "rx", .filter = omap_dma_filter_fn, .arg = (void *)66, },
>>> };
>>>
>>> or
>>>
>>> static struct dma_chan_map myplatform_dma_map[] = {
>>> 	{ .devname = "omap-aes0", .slave = "tx", .master = "omap-dma-engine0", .req = 65, },
>>> 	{ .devname = "omap-aes0", .slave = "rx", .master = "omap-dma-engine0", .req = 66, },
>>
>> sa11x0-dma expects the fn_param as string :o
> 
> Some of them do, but the new API requires changes in both the DMA master and
> slave drivers, so that could be changed if we wanted to, or we just allow 
> both methods indefinitely and let sa11x0-dma pass the filterfn+data rather than
> a number.

Hrm, I would say that we need to push everyone to use the new API. sa11x0
should not be a big deal to fix IMHO and other users should be reasonably
simple to convert.

>>> };
>>
>> Basically we are deprecating the use of IORESOURCE_DMA?
> 
> I thought we already had ;-)

For DT boot, yes. Not for the legacy boot.

>> For legacy the filter function is pretty much needed to handle the differences
>> between the platforms as not all of them does the filtering in a same way. So
>> the first type of map would be feasible IMHO.
> 
> It certainly makes the transition to a map table much easier.

And the aim anyway is to convert everything to DT, right?

>>> we could even allow a combination of the two, so the simple case just specifies
>>> master and req number, which requires changes to the dmaengine driver, but we could
>>> also do a mass-conversion to the .filter/.arg variant.
>>
>> This will get rid of the need for the fn and fn_param parameters when
>> requesting dma channel, but it will not get rid of the exported function from
>> the dma engine drivers since in arch code we need to have visibility to the
>> filter_fn.
> 
> Correct. A lot of dmaengine drivers already need to be built-in so the platform
> code can put a pointer to the filter function, so it would not be worse for them.
> 
> Another idea would be to remove the filter function from struct dma_chan_map
> and pass the map through platform data to the dmaengine driver, which then
> registers it to the core along with the mask. Something like:
> 
> /* platform code */
> static struct dma_chan_map oma_dma_map[] = {
>  	{ .devname = "omap-aes0", .slave = "tx", .arg = (void *)65, },
>  	{ .devname = "omap-aes0", .slave = "rx", .arg = (void *)66, },
> 	...
> 	{},
> };
> 
> static struct omap_system_dma_plat_info dma_plat_info __initdata = {
> 	.dma_map = &oma_dma_map,
> 	...
> };      
> 
> machine_init(void)
> {
> 	...
> 	platform_device_register_data(NULL, "omap-dma-engine", 0, &dma_plat_info, sizeof(dma_plat_info);
> 	...
> }
> 
> /* dmaengine driver */
> 
> static int omap_dma_probe(struct platform_device *pdev)
> {
> 	struct omap_system_dma_plat_info *pdata = dev_get_platdata(&pdev->dev);
> 	...
> 
> 	dmam_register_platform_map(&pdev->dev, omap_dma_filter_fn, pdata->dma_map);
> }
> 
> /* dmaengine core */
> 
> struct dma_map_list {
> 	struct list_head node;
> 	struct device *master;
> 	dma_filter_fn filter;
> 	struct dma_chan_map *map;
> };
> 
> static LIST_HEAD(dma_map_list);
> static DEFINE_MUTEX(dma_map_mutex);
> 
> int dmam_register_platform_map(struct device *dev, dma_filter_fn filter, struct dma_chan_map *map)
> {
> 	struct dma_map_list *list = kmalloc(sizeof(*list), GFP_KERNEL);
> 
> 	if (!list)
> 		return -ENOMEM;
> 
> 	list->dev = dev;
> 	list->filter = filter;
> 	list->map = map;
> 
> 	mutex_lock(&dma_map_mutex);
> 	list_add(&dma_map_list, &list->node);
> 	mutex_unlock(&dma_map_mutex);
> }
> 
> Now we can completely remove the dependency on the filter function definition
> from platform code and slave drivers.

Sounds feasible for OMAP and daVinci and for others as well. I think ;)
I would go with this if someone asks my opinion :D

The core change to add the new API + the dma_map support should be pretty
straight forward. It can live alongside with the old API and we can phase out
the users of the old one.
The legacy support would need more time since we need to modify the arch codes
and the corresponding DMA drivers to get the map registered, but after that
the remaining drivers can be converted to use the new API.

-- 
Péter
