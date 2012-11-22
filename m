Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:32878 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2KVWwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 17:52:24 -0500
Message-ID: <50AEACA5.1010805@gmail.com>
Date: Thu, 22 Nov 2012 23:52:21 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: V4L2: add temporary clock helpers
References: <Pine.LNX.4.64.1210301458250.29432@axis700.grange> <12527629.75AJWSknHq@avalon> <20121112233750.GQ25623@valkosipuli.retiisi.org.uk> <1455556.zPv2GVB7PN@avalon>
In-Reply-To: <1455556.zPv2GVB7PN@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On 11/14/2012 02:06 PM, Laurent Pinchart wrote:
...
>>>>>>> +
>>>>>>> +static DEFINE_MUTEX(clk_lock);
>>>>>>> +static LIST_HEAD(v4l2_clk);
>>>>>>
>>>>>> As Sylwester mentioned, what about s/v4l2_clk/v4l2_clks/ ?
>>>>>
>>>>> Don't you think naming of a static variable isn't important enough?
>>>>> ;-) I think code authors should have enough freedom to at least pick
>>>>> up single vs. plural form:-) "clks" is too many consonants for my
>>>>> taste, if it were anything important I'd rather agree to "clk_head" or
>>>>> "clk_list" or something similar.
>>>>
>>>> clk_list makes sense IMO since the clk_ prefis is the same.

FWIW, clk_list looks fine for me as well.

>>>>>>> +void v4l2_clk_put(struct v4l2_clk *clk)
>>>>>>> +{
>>>>>>> +	if (!IS_ERR(clk))
>>>>>>> +		module_put(clk->ops->owner);
>>>>>>> +}
>>>>>>> +EXPORT_SYMBOL(v4l2_clk_put);
>>>>>>> +
>>>>>>> +int v4l2_clk_enable(struct v4l2_clk *clk)
>>>>>>> +{
>>>>>>> +	if (atomic_inc_return(&clk->enable) == 1&&  clk->ops->enable) {
>>>>>>> +		int ret = clk->ops->enable(clk);
>>>>>>> +		if (ret<  0)
>>>>>>> +			atomic_dec(&clk->enable);
>>>>>>> +		return ret;
>>>>>>> +	}
>>>>>>
>>>>>> I think you need a spinlock here instead of atomic operations. You
>>>>>> could get preempted after atomic_inc_return() and before
>>>>>> clk->ops->enable() by another process that would call
>>>>>> v4l2_clk_enable(). The function would return with enabling the
>>>>>> clock.
>>>>>
>>>>> Sorry, what's the problem then? "Our" instance will succeed and call
>>>>> ->enable() and the preempting instance will see the enable count>  1
>>>>> and just return.
>>>>
>>>> The clock is guaranteed to be enabled only after the call has returned.
>>>> The second caller of v4lw_clk_enable() thus may proceed without the
>>>> clock being enabled.
>>>>
>>>> In principle enable() might also want to sleep, so how about using a
>>>> mutex for the purpose instead of a spinlock?
>>>
>>> If enable() needs to sleep we should split the enable call into prepare
>>> and enable, like the common clock framework did.
>>
>> I'm pretty sure we won't need to toggle this from interrupt context which is
>> what the clock framework does, AFAIU. Accessing i2c subdevs mandates
>> sleeping already.
>>
>> We might not need to have a mutex either if no driver needs to sleep for
>> this, still I guess this is more likely. I'm ok with both; just thought to
>> mention this.
>
> Right, I'm fine with a mutex for now, we'll split enable into enable and
> prepare later if needed.

How about just dropping reference counting from this code entirely ?
What would be use cases for multiple users of a single clock ? E.g. multiple
sensors case where each one uses same clock provided by a host interface ?
If we allow the sensor subdev drivers to be setting the clock frequency and
each sensor uses different frequency, then I can't see how this can work
reliably. I mean it's the clock's provider that should coordinate and
reference count the clock users. If a clock is enabled for one sensor and
some other sensor is attempting to set different frequency then the 
set_rate
callback should return an error. The clock provider will need use 
internally
a lock for the clock anyway, and to track the clock reference count too.
So I'm inclined to leave all this refcounting bits out to individual clock
providers.

--
Thanks,
Sylwester
