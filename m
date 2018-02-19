Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33352 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752897AbeBSQ31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 11:29:27 -0500
Subject: Re: [PATCH 1/8] clk: Add clk_bulk_alloc functions
To: Maciej Purski <m.purski@samsung.com>, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>,
        Michael Turquette <mturquette@baylibre.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
 <CGME20180219154456eucas1p15f4073beaf61312238f142f217a8bb3c@eucas1p1.samsung.com>
 <1519055046-2399-2-git-send-email-m.purski@samsung.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <b67b5043-f5e5-826a-f0b8-f7cf722c61e6@arm.com>
Date: Mon, 19 Feb 2018 16:29:12 +0000
MIME-Version: 1.0
In-Reply-To: <1519055046-2399-2-git-send-email-m.purski@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maciej,

On 19/02/18 15:43, Maciej Purski wrote:
> When a driver is going to use clk_bulk_get() function, it has to
> initialize an array of clk_bulk_data, by filling its id fields.
> 
> Add a new function to the core, which dynamically allocates
> clk_bulk_data array and fills its id fields. Add clk_bulk_free()
> function, which frees the array allocated by clk_bulk_alloc() function.
> Add a managed version of clk_bulk_alloc().

Seeing how every subsequent patch ends up with the roughly this same stanza:

	x = devm_clk_bulk_alloc(dev, num, names);
	if (IS_ERR(x)
		return PTR_ERR(x);
	ret = devm_clk_bulk_get(dev, x, num);

I wonder if it might be better to simply implement:

	int devm_clk_bulk_alloc_get(dev, &x, num, names)

that does the whole lot in one go, and let drivers that want to do more 
fiddly things continue to open-code the allocation.

But perhaps that's an abstraction too far... I'm not all that familiar 
with the lie of the land here.

> Signed-off-by: Maciej Purski <m.purski@samsung.com>
> ---
>   drivers/clk/clk-bulk.c   | 16 ++++++++++++
>   drivers/clk/clk-devres.c | 37 +++++++++++++++++++++++++---
>   include/linux/clk.h      | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 113 insertions(+), 4 deletions(-)
> 

[...]
> @@ -598,6 +645,23 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id);
>   
>   #else /* !CONFIG_HAVE_CLK */
>   
> +static inline struct clk_bulk_data *clk_bulk_alloc(int num_clks,
> +						   const char **clk_ids)
> +{
> +	return NULL;

Either way, is it intentional not returning an ERR_PTR() value in this 
case? Since NULL will pass an IS_ERR() check, it seems a bit fragile for 
an allocation call to apparently succeed when the whole API is 
configured out (and I believe introducing new uses of IS_ERR_OR_NULL() 
is in general strongly discouraged.)

Robin.

> +}
> +
> +static inline struct clk_bulk_data *devm_clk_bulk_alloc(struct device *dev,
> +							int num_clks,
> +							const char **clk_ids)
> +{
> +	return NULL;
> +}
> +
> +static inline void clk_bulk_free(struct clk_bulk_data *clks)
> +{
> +}
> +
>   static inline struct clk *clk_get(struct device *dev, const char *id)
>   {
>   	return NULL;
> 
