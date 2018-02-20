Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57021 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbeBTJgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 04:36:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [PATCH 1/8] clk: Add clk_bulk_alloc functions
To: Robin Murphy <robin.murphy@arm.com>,
        Maciej Purski <m.purski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>,
        Michael Turquette <mturquette@baylibre.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
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
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <f13fb12b-54e6-104b-4ec0-192d1bb72cc8@samsung.com>
Date: Tue, 20 Feb 2018 10:36:03 +0100
In-reply-to: <b67b5043-f5e5-826a-f0b8-f7cf722c61e6@arm.com>
Content-transfer-encoding: 8bit
Content-language: en-US
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154456eucas1p15f4073beaf61312238f142f217a8bb3c@eucas1p1.samsung.com>
        <1519055046-2399-2-git-send-email-m.purski@samsung.com>
        <b67b5043-f5e5-826a-f0b8-f7cf722c61e6@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robin,

On 2018-02-19 17:29, Robin Murphy wrote:
> Hi Maciej,
>
> On 19/02/18 15:43, Maciej Purski wrote:
>> When a driver is going to use clk_bulk_get() function, it has to
>> initialize an array of clk_bulk_data, by filling its id fields.
>>
>> Add a new function to the core, which dynamically allocates
>> clk_bulk_data array and fills its id fields. Add clk_bulk_free()
>> function, which frees the array allocated by clk_bulk_alloc() function.
>> Add a managed version of clk_bulk_alloc().
>
> Seeing how every subsequent patch ends up with the roughly this same 
> stanza:
>
>     x = devm_clk_bulk_alloc(dev, num, names);
>     if (IS_ERR(x)
>         return PTR_ERR(x);
>     ret = devm_clk_bulk_get(dev, x, num);
>
> I wonder if it might be better to simply implement:
>
>     int devm_clk_bulk_alloc_get(dev, &x, num, names)
>
> that does the whole lot in one go, and let drivers that want to do 
> more fiddly things continue to open-code the allocation.
>
> But perhaps that's an abstraction too far... I'm not all that familiar 
> with the lie of the land here.

Hmmm. This patchset clearly shows, that it would be much simpler if we
get rid of clk_bulk_data structure at all and let clk_bulk_* functions
to operate on struct clk *array[]. Typically the list of clock names
is already in some kind of array (taken from driver data or statically
embedded into driver), so there is little benefit from duplicating it
in clk_bulk_data. Sadly, I missed clk_bulk_* api discussion and maybe
there are other benefits from this approach.

If not, I suggest simplifying clk_bulk_* api by dropping clk_bulk_data
structure and switching to clock ptr array:

int clk_bulk_get(struct device *dev, int num_clock, struct clk *clocks[],
                  const char *clk_names[]);
int clk_bulk_prepare(int num_clks, struct clk *clks[]);
int clk_bulk_enable(int num_clks, struct clk *clks[]);
...



>
>> Signed-off-by: Maciej Purski <m.purski@samsung.com>
>> ---
>>   drivers/clk/clk-bulk.c   | 16 ++++++++++++
>>   drivers/clk/clk-devres.c | 37 +++++++++++++++++++++++++---
>>   include/linux/clk.h      | 64 
>> ++++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 113 insertions(+), 4 deletions(-)
>>
>
> [...]
>> @@ -598,6 +645,23 @@ struct clk *clk_get_sys(const char *dev_id, 
>> const char *con_id);
>>     #else /* !CONFIG_HAVE_CLK */
>>   +static inline struct clk_bulk_data *clk_bulk_alloc(int num_clks,
>> +                           const char **clk_ids)
>> +{
>> +    return NULL;
>
> Either way, is it intentional not returning an ERR_PTR() value in this 
> case? Since NULL will pass an IS_ERR() check, it seems a bit fragile 
> for an allocation call to apparently succeed when the whole API is 
> configured out (and I believe introducing new uses of IS_ERR_OR_NULL() 
> is in general strongly discouraged.)
>
> Robin.
>
>> +}
>> +
>> +static inline struct clk_bulk_data *devm_clk_bulk_alloc(struct 
>> device *dev,
>> +                            int num_clks,
>> +                            const char **clk_ids)
>> +{
>> +    return NULL;
>> +}
>> +
>> +static inline void clk_bulk_free(struct clk_bulk_data *clks)
>> +{
>> +}
>> +
>>   static inline struct clk *clk_get(struct device *dev, const char *id)
>>   {
>>       return NULL;
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
