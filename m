Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33127 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752484AbeACPrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 10:47:03 -0500
Message-ID: <1514994414.5019.9.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] media: coda: Add i.MX51 (CodaHx4) support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Date: Wed, 03 Jan 2018 16:46:54 +0100
In-Reply-To: <201712210511.bpsOELIY%fengguang.wu@intel.com>
References: <20171218101629.31395-2-p.zabel@pengutronix.de>
         <201712210511.bpsOELIY%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-21 at 05:52 +0800, kbuild test robot wrote:
> Hi Philipp,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on linuxtv-media/master]
> [also build test WARNING on v4.15-rc4 next-20171220]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Philipp-Zabel/media-dt-bindings-coda-Add-compatible-for-CodaHx4-on-i-MX51/20171221-050217
> base:   git://linuxtv.org/media_tree.git master
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> Note: it may well be a FALSE warning.

I think it is.

>  FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/media/platform/coda/coda-bit.c: In function 'coda_setup_iram':
> > > drivers/media/platform/coda/coda-bit.c:648:28: warning: 'me_bits' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
>        iram_info->axi_sram_use |= me_bits;
>                                ^~
> 
> vim +/me_bits +648 drivers/media/platform/coda/coda-bit.c
> 
>    588	
>    589	static void coda_setup_iram(struct coda_ctx *ctx)
>    590	{
>    591		struct coda_iram_info *iram_info = &ctx->iram_info;
>    592		struct coda_dev *dev = ctx->dev;
>    593		int w64, w128;
>    594		int mb_width;
>    595		int dbk_bits;
>    596		int bit_bits;
>    597		int ip_bits;
>    598		int me_bits;
>    599	
>    600		memset(iram_info, 0, sizeof(*iram_info));
>    601		iram_info->next_paddr = dev->iram.paddr;
>    602		iram_info->remaining = dev->iram.size;
>    603	
>    604		if (!dev->iram.vaddr)
>    605			return;
>    606	
>    607		switch (dev->devtype->product) {
>    608		case CODA_HX4:
>    609			dbk_bits = CODA7_USE_HOST_DBK_ENABLE;
>    610			bit_bits = CODA7_USE_HOST_BIT_ENABLE;
>    611			ip_bits = CODA7_USE_HOST_IP_ENABLE;
>    612			me_bits = CODA7_USE_HOST_ME_ENABLE;
>    613			break;
>    614		case CODA_7541:
>    615			dbk_bits = CODA7_USE_HOST_DBK_ENABLE | CODA7_USE_DBK_ENABLE;
>    616			bit_bits = CODA7_USE_HOST_BIT_ENABLE | CODA7_USE_BIT_ENABLE;
>    617			ip_bits = CODA7_USE_HOST_IP_ENABLE | CODA7_USE_IP_ENABLE;
>    618			me_bits = CODA7_USE_HOST_ME_ENABLE | CODA7_USE_ME_ENABLE;
>    619			break;
>    620		case CODA_960:
>    621			dbk_bits = CODA9_USE_HOST_DBK_ENABLE | CODA9_USE_DBK_ENABLE;
>    622			bit_bits = CODA9_USE_HOST_BIT_ENABLE | CODA7_USE_BIT_ENABLE;
>    623			ip_bits = CODA9_USE_HOST_IP_ENABLE | CODA7_USE_IP_ENABLE;

This is the only path that continues with me_bits uninitialized.
In this case ...

>    624			break;
>    625		default: /* CODA_DX6 */
>    626			return;
>    627		}
>    628	
>    629		if (ctx->inst_type == CODA_INST_ENCODER) {
>    630			struct coda_q_data *q_data_src;
>    631	
>    632			q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
>    633			mb_width = DIV_ROUND_UP(q_data_src->width, 16);
>    634			w128 = mb_width * 128;
>    635			w64 = mb_width * 64;
>    636	
>    637			/* Prioritize in case IRAM is too small for everything */
>    638			if (dev->devtype->product == CODA_HX4 ||
>    639			    dev->devtype->product == CODA_7541) {
>    640				iram_info->search_ram_size = round_up(mb_width * 16 *
>    641								      36 + 2048, 1024);
>    642				iram_info->search_ram_paddr = coda_iram_alloc(iram_info,
>    643							iram_info->search_ram_size);
>    644				if (!iram_info->search_ram_paddr) {
>    645					pr_err("IRAM is smaller than the search ram size\n");
>    646					goto out;
>    647				}
>  > 648				iram_info->axi_sram_use |= me_bits;

... dev->devtype->product == CODA_960, and this use of me_bits is never
reached.

regards
Philipp
