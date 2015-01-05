Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51053 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbAEKB5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 05:01:57 -0500
Message-ID: <54AA60CF.4000602@atmel.com>
Date: Mon, 5 Jan 2015 18:00:47 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] V4L2: add CCF support to the v4l2_clk API
References: <Pine.LNX.4.64.1501021244580.30761@axis700.grange> <Pine.LNX.4.64.1501021247590.30761@axis700.grange> <2303897.CzDnkeNcGb@avalon> <Pine.LNX.4.64.1501022107370.3028@axis700.grange> <54AA5526.7080903@atmel.com> <Pine.LNX.4.64.1501051033280.22059@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1501051033280.22059@axis700.grange>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/5/2015 5:36 PM, Guennadi Liakhovetski wrote:
> On Mon, 5 Jan 2015, Josh Wu wrote:
>
>> Hi, Guennadi
>>
>> On 1/3/2015 4:18 AM, Guennadi Liakhovetski wrote:
>>>   From aeaee56e04d023f3a019d2595ef5128015acdb06 Mon Sep 17 00:00:00 2001
>>> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> Date: Fri, 2 Jan 2015 12:26:41 +0100
>>> Subject: [PATCH 2/2] V4L2: add CCF support to the v4l2_clk API
>>>
>>> V4L2 clocks, e.g. used by camera sensors for their master clock, do not
>>> have to be supplied by a different V4L2 driver, they can also be
>>> supplied by an independent source. In this case the standart kernel
>>> clock API should be used to handle such clocks. This patch adds support
>>> for such cases.
>>>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> ---
>>>
>>> Hi Laurent,
>>> Thanks for the comment. The idea of allocating a new object for each "get"
>>> operation seems a bit weird to me, and completely trusting the user is a
>>> bit scary... :) But yes, it can work this way too, I think, and the user
>>> can screw either way too, anyway. So, here comes a v2. Something like
>>> this?
>>>
>>> v2: don't add CCF-related clocks on the global list, just allocate a new
>>> instance on each v4l2_clk_get()
>>>
>>>    drivers/media/v4l2-core/v4l2-clk.c | 45
>>> +++++++++++++++++++++++++++++++++++---
>>>    include/media/v4l2-clk.h           |  2 ++
>>>    2 files changed, 44 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
>>> b/drivers/media/v4l2-core/v4l2-clk.c
>>> index c210906..f5d1688 100644
>>> --- a/drivers/media/v4l2-core/v4l2-clk.c
>>> +++ b/drivers/media/v4l2-core/v4l2-clk.c
>>> @@ -9,6 +9,7 @@
>>>     */
>>>      #include <linux/atomic.h>
>>> +#include <linux/clk.h>
>>>    #include <linux/device.h>
>>>    #include <linux/errno.h>
>>>    #include <linux/list.h>
>>> @@ -42,6 +43,18 @@ static struct v4l2_clk *v4l2_clk_find(const char *dev_id,
>>> const char *id)
>>>    struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
>>>    {
>>>    	struct v4l2_clk *clk;
>>> +	struct clk *ccf_clk = clk_get(dev, id);
>> We need to check whether the 'id' is NULL, otherwise there is no error
>> reported if we use IS_ERR(ccf_clk).
> ? Sorry, don't understand. AFAIK, id = NULL is absolutely valid, no need
> to check for it explicitly. However, it just occurs to me, that we
> probably need to change the below test
>
>> Best Regards,
>> Josh Wu
>>
>>> +
>>> +	if (!IS_ERR(ccf_clk)) {
> to
>
>>> +	if (!IS_ERR_OR_NULL(ccf_clk)) {
> to cover the case when CCF isn't built at all and a stub is used. In that
> case it's probably better to fall back to the V4L2 clock emulation.
yes, this's what I mean. but I don't know the function 
IS_ERR_OR_NULL().  ;-)

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
>>> +		clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
>>> +		if (!clk) {
>>> +			clk_put(ccf_clk);
>>> +			return ERR_PTR(-ENOMEM);
>>> +		}
>>> +		clk->clk = ccf_clk;
>>> +
>>> +		return clk;
>>> +	}
>>>      	mutex_lock(&clk_lock);
>>>    	clk = v4l2_clk_find(dev_name(dev), id);
>>> @@ -61,6 +74,12 @@ void v4l2_clk_put(struct v4l2_clk *clk)
>>>    	if (IS_ERR(clk))
>>>    		return;
>>>    +	if (clk->clk) {
>>> +		clk_put(clk->clk);
>>> +		kfree(clk);
>>> +		return;
>>> +	}
>>> +
>>>    	mutex_lock(&clk_lock);
>>>      	list_for_each_entry(tmp, &clk_list, list)
>>> @@ -98,8 +117,12 @@ static void v4l2_clk_unlock_driver(struct v4l2_clk *clk)
>>>      int v4l2_clk_enable(struct v4l2_clk *clk)
>>>    {
>>> -	int ret = v4l2_clk_lock_driver(clk);
>>> +	int ret;
>>>    +	if (clk->clk)
>>> +		return clk_enable(clk->clk);
>>> +
>>> +	ret = v4l2_clk_lock_driver(clk);
>>>    	if (ret < 0)
>>>    		return ret;
>>>    @@ -125,6 +148,9 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
>>>    {
>>>    	int enable;
>>>    +	if (clk->clk)
>>> +		return clk_disable(clk->clk);
>>> +
>>>    	mutex_lock(&clk->lock);
>>>      	enable = --clk->enable;
>>> @@ -142,8 +168,12 @@ EXPORT_SYMBOL(v4l2_clk_disable);
>>>      unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
>>>    {
>>> -	int ret = v4l2_clk_lock_driver(clk);
>>> +	int ret;
>>> +
>>> +	if (clk->clk)
>>> +		return clk_get_rate(clk->clk);
>>>    +	ret = v4l2_clk_lock_driver(clk);
>>>    	if (ret < 0)
>>>    		return ret;
>>>    @@ -162,7 +192,16 @@ EXPORT_SYMBOL(v4l2_clk_get_rate);
>>>      int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
>>>    {
>>> -	int ret = v4l2_clk_lock_driver(clk);
>>> +	int ret;
>>> +
>>> +	if (clk->clk) {
>>> +		long r = clk_round_rate(clk->clk, rate);
>>> +		if (r < 0)
>>> +			return r;
>>> +		return clk_set_rate(clk->clk, r);
>>> +	}
>>> +
>>> +	ret = v4l2_clk_lock_driver(clk);
>>>      	if (ret < 0)
>>>    		return ret;
>>> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
>>> index 8f06967..4402b2d 100644
>>> --- a/include/media/v4l2-clk.h
>>> +++ b/include/media/v4l2-clk.h
>>> @@ -22,6 +22,7 @@
>>>    struct module;
>>>    struct device;
>>>    +struct clk;
>>>    struct v4l2_clk {
>>>    	struct list_head list;
>>>    	const struct v4l2_clk_ops *ops;
>>> @@ -30,6 +31,7 @@ struct v4l2_clk {
>>>    	int enable;
>>>    	struct mutex lock; /* Protect the enable count */
>>>    	atomic_t use_count;
>>> +	struct clk *clk;
>>>    	void *priv;
>>>    };
>>>    

