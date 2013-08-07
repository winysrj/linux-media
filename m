Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43912 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3HGPDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 11:03:21 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR6009HQ1THTPB0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Aug 2013 16:03:19 +0100 (BST)
Message-id: <520261B6.1080407@samsung.com>
Date: Wed, 07 Aug 2013 17:03:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] mt9v032: Use the common clock framework
References: <1373021725-14006-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1438897.qqa6gsnOmc@avalon> <51F27B56.9050504@gmail.com>
 <1684528.NgmHp9Ak4m@avalon>
In-reply-to: <1684528.NgmHp9Ak4m@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/26/2013 05:55 PM, Laurent Pinchart wrote:
> On Friday 26 July 2013 15:36:22 Sylwester Nawrocki wrote:
>> On 07/26/2013 03:15 PM, Laurent Pinchart wrote:
>>> On Friday 26 July 2013 15:11:08 Sylwester Nawrocki wrote:
>>>> On 07/05/2013 12:55 PM, Laurent Pinchart wrote:
>>>>> Configure the device external clock using the common clock framework
>>>>> instead of a board code callback function.
>>>>>
>>>>> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>>>> ---
>>>>>
>>>>>    drivers/media/i2c/mt9v032.c | 16 ++++++++++------
>>>>>    include/media/mt9v032.h     |  4 ----
>>>>>    2 files changed, 10 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
>>>>> index 60c6f67..7b30640 100644
>>>>> --- a/drivers/media/i2c/mt9v032.c
>>>>> +++ b/drivers/media/i2c/mt9v032.c
>>>>> @@ -12,6 +12,7 @@
>>>>>     * published by the Free Software Foundation.
>>>>>     */
>>>>>
>>>>> +#include<linux/clk.h>
>>>>>    #include<linux/delay.h>
>>>>>    #include<linux/i2c.h>
>>>>>    #include<linux/log2.h>
>>>>> @@ -135,6 +136,8 @@ struct mt9v032 {
>>>>>    	struct mutex power_lock;
>>>>>    	int power_count;
>>>>>
>>>>> +	struct clk *clk;
>>>>> +
>>>>>    	struct mt9v032_platform_data *pdata;
>>>>>    	
>>>>>    	u32 sysclk;
>>>>> @@ -219,10 +222,8 @@ static int mt9v032_power_on(struct mt9v032
>>>>> *mt9v032)
>>>>>    	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
>>>>>    	int ret;
>>>>>
>>>>> -	if (mt9v032->pdata->set_clock) {
>>>>> -		mt9v032->pdata->set_clock(&mt9v032->subdev, mt9v032->sysclk);
>>>>> -		udelay(1);
>>>>> -	}
>>>>> +	clk_prepare_enable(mt9v032->clk);
>>>>> +	udelay(1);
>>>>>
>>>>>    	/* Reset the chip and stop data read out */
>>>>>    	ret = mt9v032_write(client, MT9V032_RESET, 1);
>>>>> @@ -238,8 +239,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>>>>>
>>>>>    static void mt9v032_power_off(struct mt9v032 *mt9v032)
>>>>>    {
>>>>> -	if (mt9v032->pdata->set_clock)
>>>>> -		mt9v032->pdata->set_clock(&mt9v032->subdev, 0);
>>>>> +	clk_disable_unprepare(mt9v032->clk);
>>>>>    }
>>>>>    
>>>>>    static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
>>>>> @@ -748,6 +748,10 @@ static int mt9v032_probe(struct i2c_client *client,
>>>>>    	if (!mt9v032)
>>>>>    		return -ENOMEM;
>>>>>
>>>>> +	mt9v032->clk = devm_clk_get(&client->dev, NULL);
>>>>> +	if (IS_ERR(mt9v032->clk))
>>>>> +		return PTR_ERR(mt9v032->clk);
>>>>> +
>>>>>    	mutex_init(&mt9v032->power_lock);
>>>>>    	mt9v032->pdata = pdata;
>>>>>
>>>>> diff --git a/include/media/mt9v032.h b/include/media/mt9v032.h
>>>>> index 78fd39e..12175a6 100644
>>>>> --- a/include/media/mt9v032.h
>>>>> +++ b/include/media/mt9v032.h
>>>>> @@ -1,13 +1,9 @@
>>>>>    #ifndef _MEDIA_MT9V032_H
>>>>>    #define _MEDIA_MT9V032_H
>>>>>
>>>>> -struct v4l2_subdev;
>>>>> -
>>>>>    struct mt9v032_platform_data {
>>>>>    	unsigned int clk_pol:1;
>>>>> -	void (*set_clock)(struct v4l2_subdev *subdev, unsigned int rate);
>>>>> -
>>>>>    	const s64 *link_freqs;
>>>>>    	s64 link_def_freq;
>>>>>    };
>>>>
>>>> Is there clk_put() somewhere in this patch ? I would expect it somewhere
>>>> around driver remove() callback, but can't see it. :-/
>>>
>>> There's *devm_*clk_get() instead :-)
>>
>> Ah, I knew I must have been forgetting or overlooking something! ;)
>>
>> Do you rely on the fact that __clk_get()/__clk_put() doesn't get reference
>> on the clock supplier module (to avoid locking modules in memory) ? I was
>> planning on adding module_get()/module_put() inside __clk_get()/__clk_out()
>> for the common clock API implementation.
> 
> I'm currently relying on that, but I'm aware it's not a good idea. We need to 
> find a solution to fix the problem in the context of the v4l2-async framework.

There are few possible options I can see could be a resolution for that:

1. making the common clock API not getting reference on the clock supplier
   module; then dynamic clock deregistration needs to be handled, which has 
   its own share of problems;

2. using sysfs unbind attribute of the subdev and/or the host drivers to 
   release the circular references or create some additional sysfs entry
   for this - however requiring additional actions from user space to do
   something that worked before without them can be simply considered as 
   an regression;  

3. not keeping reference to a clock all times only when it is actively
   used, e.g. in subdev's s_power handler; this is in practice what 
   v4l2-clk does, just would be coded using standard clk API calls;

Any of these options isn't ideal but 3) seems to me most reasonable of 
them. I thought it would be better than using the v4l2-clk API, which is
supposed to be a temporary measure only, for platforms that already have 
the common clock API support.

I was wondering whether you don't need to also set the clock's frequency
in this patch. I guess the sensor driver should at least call 
clk_get_rate() to see if current frequency is suitable for the device ?


Regards,
Sylwester
