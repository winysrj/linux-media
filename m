Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:52908 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964790AbeEYIfm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 04:35:42 -0400
Subject: Re: [PATCH v2 08/13] ASoC: pxa: remove the dmaengine compat need
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20180524070703.11901-1-robert.jarzmik@free.fr>
 <20180524070703.11901-9-robert.jarzmik@free.fr>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <5bc2aa06-7939-1ca4-6704-30f307edcda4@zonque.org>
Date: Fri, 25 May 2018 10:35:37 +0200
MIME-Version: 1.0
In-Reply-To: <20180524070703.11901-9-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, May 24, 2018 09:06 AM, Robert Jarzmik wrote:
> As the pxa architecture switched towards the dmaengine slave map, the
> old compatibility mechanism to acquire the dma requestor line number and
> priority are not needed anymore.
> 
> This patch simplifies the dma resource acquisition, using the more
> generic function dma_request_slave_channel().
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Reviewed-by: Daniel Mack <daniel@zonque.org>

> ---
>   sound/arm/pxa2xx-ac97.c     | 14 ++------------
>   sound/arm/pxa2xx-pcm-lib.c  |  6 +++---
>   sound/soc/pxa/pxa2xx-ac97.c | 32 +++++---------------------------
>   sound/soc/pxa/pxa2xx-i2s.c  |  6 ++----
>   4 files changed, 12 insertions(+), 46 deletions(-)
> 
> diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
> index 4bc244c40f80..236a63cdaf9f 100644
> --- a/sound/arm/pxa2xx-ac97.c
> +++ b/sound/arm/pxa2xx-ac97.c
> @@ -63,28 +63,18 @@ static struct snd_ac97_bus_ops pxa2xx_ac97_ops = {
>   	.reset	= pxa2xx_ac97_legacy_reset,
>   };
>   
> -static struct pxad_param pxa2xx_ac97_pcm_out_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 12,
> -};
> -
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_out = {
>   	.addr		= __PREG(PCDR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	.chan_name	= "pcm_pcm_stereo_out",
>   	.maxburst	= 32,
> -	.filter_data	= &pxa2xx_ac97_pcm_out_req,
> -};
> -
> -static struct pxad_param pxa2xx_ac97_pcm_in_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 11,
>   };
>   
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_in = {
>   	.addr		= __PREG(PCDR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	.chan_name	= "pcm_pcm_stereo_in",
>   	.maxburst	= 32,
> -	.filter_data	= &pxa2xx_ac97_pcm_in_req,
>   };
>   
>   static struct snd_pcm *pxa2xx_ac97_pcm;
> diff --git a/sound/arm/pxa2xx-pcm-lib.c b/sound/arm/pxa2xx-pcm-lib.c
> index e8da3b8ee721..dcbe7ecc1835 100644
> --- a/sound/arm/pxa2xx-pcm-lib.c
> +++ b/sound/arm/pxa2xx-pcm-lib.c
> @@ -125,9 +125,9 @@ int __pxa2xx_pcm_open(struct snd_pcm_substream *substream)
>   	if (ret < 0)
>   		return ret;
>   
> -	return snd_dmaengine_pcm_open_request_chan(substream,
> -					pxad_filter_fn,
> -					dma_params->filter_data);
> +	return snd_dmaengine_pcm_open(
> +		substream, dma_request_slave_channel(rtd->cpu_dai->dev,
> +						     dma_params->chan_name));
>   }
>   EXPORT_SYMBOL(__pxa2xx_pcm_open);
>   
> diff --git a/sound/soc/pxa/pxa2xx-ac97.c b/sound/soc/pxa/pxa2xx-ac97.c
> index 803818aabee9..1b41c0f2a8fb 100644
> --- a/sound/soc/pxa/pxa2xx-ac97.c
> +++ b/sound/soc/pxa/pxa2xx-ac97.c
> @@ -68,61 +68,39 @@ static struct snd_ac97_bus_ops pxa2xx_ac97_ops = {
>   	.reset	= pxa2xx_ac97_cold_reset,
>   };
>   
> -static struct pxad_param pxa2xx_ac97_pcm_stereo_in_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 11,
> -};
> -
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_stereo_in = {
>   	.addr		= __PREG(PCDR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	.chan_name	= "pcm_pcm_stereo_in",
>   	.maxburst	= 32,
> -	.filter_data	= &pxa2xx_ac97_pcm_stereo_in_req,
> -};
> -
> -static struct pxad_param pxa2xx_ac97_pcm_stereo_out_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 12,
>   };
>   
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_stereo_out = {
>   	.addr		= __PREG(PCDR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	.chan_name	= "pcm_pcm_stereo_out",
>   	.maxburst	= 32,
> -	.filter_data	= &pxa2xx_ac97_pcm_stereo_out_req,
>   };
>   
> -static struct pxad_param pxa2xx_ac97_pcm_aux_mono_out_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 10,
> -};
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_aux_mono_out = {
>   	.addr		= __PREG(MODR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_2_BYTES,
> +	.chan_name	= "pcm_aux_mono_out",
>   	.maxburst	= 16,
> -	.filter_data	= &pxa2xx_ac97_pcm_aux_mono_out_req,
>   };
>   
> -static struct pxad_param pxa2xx_ac97_pcm_aux_mono_in_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 9,
> -};
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_aux_mono_in = {
>   	.addr		= __PREG(MODR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_2_BYTES,
> +	.chan_name	= "pcm_aux_mono_in",
>   	.maxburst	= 16,
> -	.filter_data	= &pxa2xx_ac97_pcm_aux_mono_in_req,
>   };
>   
> -static struct pxad_param pxa2xx_ac97_pcm_aux_mic_mono_req = {
> -	.prio = PXAD_PRIO_LOWEST,
> -	.drcmr = 8,
> -};
>   static struct snd_dmaengine_dai_dma_data pxa2xx_ac97_pcm_mic_mono_in = {
>   	.addr		= __PREG(MCDR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_2_BYTES,
> +	.chan_name	= "pcm_aux_mic_mono",
>   	.maxburst	= 16,
> -	.filter_data	= &pxa2xx_ac97_pcm_aux_mic_mono_req,
>   };
>   
>   static int pxa2xx_ac97_hifi_startup(struct snd_pcm_substream *substream,
> diff --git a/sound/soc/pxa/pxa2xx-i2s.c b/sound/soc/pxa/pxa2xx-i2s.c
> index 3fb60baf6eab..e7184de0de04 100644
> --- a/sound/soc/pxa/pxa2xx-i2s.c
> +++ b/sound/soc/pxa/pxa2xx-i2s.c
> @@ -82,20 +82,18 @@ static struct pxa_i2s_port pxa_i2s;
>   static struct clk *clk_i2s;
>   static int clk_ena = 0;
>   
> -static unsigned long pxa2xx_i2s_pcm_stereo_out_req = 3;
>   static struct snd_dmaengine_dai_dma_data pxa2xx_i2s_pcm_stereo_out = {
>   	.addr		= __PREG(SADR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	.chan_name	= "tx",
>   	.maxburst	= 32,
> -	.filter_data	= &pxa2xx_i2s_pcm_stereo_out_req,
>   };
>   
> -static unsigned long pxa2xx_i2s_pcm_stereo_in_req = 2;
>   static struct snd_dmaengine_dai_dma_data pxa2xx_i2s_pcm_stereo_in = {
>   	.addr		= __PREG(SADR),
>   	.addr_width	= DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	.chan_name	= "rx",
>   	.maxburst	= 32,
> -	.filter_data	= &pxa2xx_i2s_pcm_stereo_in_req,
>   };
>   
>   static int pxa2xx_i2s_startup(struct snd_pcm_substream *substream,
> 
