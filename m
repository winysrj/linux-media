Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:4456 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdI1GLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 02:11:49 -0400
Subject: Re: [PATCH v2 1/5] media: atmel_isc: Add spin lock for clock enable
 ops
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170918063925.6372-1-wenyou.yang@microchip.com>
 <20170918063925.6372-2-wenyou.yang@microchip.com>
 <20170927071626.mok5h3ckisyipy53@valkosipuli.retiisi.org.uk>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <ab5896f3-8631-4ce4-b996-5b679f66909b@Microchip.com>
Date: Thu, 28 Sep 2017 14:11:41 +0800
MIME-Version: 1.0
In-Reply-To: <20170927071626.mok5h3ckisyipy53@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2017/9/27 15:16, Sakari Ailus wrote:
> Hi Wenyou,
>
> On subject:
>
> s/_/-/
>
> On Mon, Sep 18, 2017 at 02:39:21PM +0800, Wenyou Yang wrote:
>> Add the spin lock for the clock enable and disable operations.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
>> ---
>>
>> Changes in v2: None
>>
>>   drivers/media/platform/atmel/atmel-isc.c | 14 +++++++++++++-
>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>> index 2f8e345d297e..78114193af4c 100644
>> --- a/drivers/media/platform/atmel/atmel-isc.c
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>> @@ -65,6 +65,7 @@ struct isc_clk {
>>   	struct clk_hw   hw;
>>   	struct clk      *clk;
>>   	struct regmap   *regmap;
>> +	spinlock_t	*lock;
> Can this work? I don't see lock being assigned anywhere. Did you mean
>
> 	spinlock_t	lock;
>
> ?
Ooh. I made a mistake.

Thank you very much.
>
>>   	u8		id;
>>   	u8		parent_id;
>>   	u32		div;
>> @@ -312,26 +313,37 @@ static int isc_clk_enable(struct clk_hw *hw)
>>   	struct isc_clk *isc_clk = to_isc_clk(hw);
>>   	u32 id = isc_clk->id;
>>   	struct regmap *regmap = isc_clk->regmap;
>> +	unsigned long flags;
>> +	unsigned int status;
>>   
>>   	dev_dbg(isc_clk->dev, "ISC CLK: %s, div = %d, parent id = %d\n",
>>   		__func__, isc_clk->div, isc_clk->parent_id);
>>   
>> +	spin_lock_irqsave(isc_clk->lock, flags);
>>   	regmap_update_bits(regmap, ISC_CLKCFG,
>>   			   ISC_CLKCFG_DIV_MASK(id) | ISC_CLKCFG_SEL_MASK(id),
>>   			   (isc_clk->div << ISC_CLKCFG_DIV_SHIFT(id)) |
>>   			   (isc_clk->parent_id << ISC_CLKCFG_SEL_SHIFT(id)));
>>   
>>   	regmap_write(regmap, ISC_CLKEN, ISC_CLK(id));
>> +	spin_unlock_irqrestore(isc_clk->lock, flags);
>>   
>> -	return 0;
>> +	regmap_read(regmap, ISC_CLKSR, &status);
>> +	if (status & ISC_CLK(id))
>> +		return 0;
>> +	else
>> +		return -EINVAL;
>>   }
>>   
>>   static void isc_clk_disable(struct clk_hw *hw)
>>   {
>>   	struct isc_clk *isc_clk = to_isc_clk(hw);
>>   	u32 id = isc_clk->id;
>> +	unsigned long flags;
>>   
>> +	spin_lock_irqsave(isc_clk->lock, flags);
>>   	regmap_write(isc_clk->regmap, ISC_CLKDIS, ISC_CLK(id));
>> +	spin_unlock_irqrestore(isc_clk->lock, flags);
>>   }
>>   
>>   static int isc_clk_is_enabled(struct clk_hw *hw)
Best Regards,
Wenyou Yang
