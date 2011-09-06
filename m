Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61611 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab1IFUm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 16:42:27 -0400
Received: by ewy4 with SMTP id 4so2920511ewy.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 13:42:26 -0700 (PDT)
Message-ID: <4E6685AE.1060102@gmail.com>
Date: Tue, 06 Sep 2011 22:42:22 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Subject: Re: [PATCH v4] s5p-fimc: Add runtime PM support in the mem-to-mem
 driver
References: <1314716439-23642-1-git-send-email-s.nawrocki@samsung.com> <20110905060645.GA955@valkosipuli.localdomain> <4E651C8F.5020807@gmail.com> <20110905212000.GA1393@valkosipuli.localdomain>
In-Reply-To: <20110905212000.GA1393@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2011 11:20 PM, Sakari Ailus wrote:
>>>> +static int fimc_suspend(struct device *dev)
>>>> +{
>>>> +	struct fimc_dev *fimc =	dev_get_drvdata(dev);
>>>> +
>>>> +	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
>>>> +
>>>> +	if (test_and_set_bit(ST_LPM,&fimc->state))
>>>> +		return 0;
>>>> +	if (fimc_capture_busy(fimc))
>>>> +		return fimc_capture_suspend(fimc);
>>>
>>> Now that fimc_capture_suspend()  returns -EBUSY always, is this intended
>>> behavious or do you plan to change this later on?
>>
>> No, it's by no means the intended behaviour. This patch is only a part of the
>> whole picture, but I thought it's independent from the MC related patches
>> which are on hold and could be merged independently. Moreover the FIMC driver
>> is broken without this patch on Exynos4, if the boot loader doesn't enable
>> the related power domain permanently. So I thought it should be merged
>> regardless of the fate of the capture PM support patch which depends on the
>> MC related patches.
> 
> Right, I agree the patch has enough merits for merging.
> 
>> Here is the capture PM patch for your critics;) http://tinyurl.com/4yj8z4t
> 
> I'll take a look at it once you post it on the list. ;)

It's been on the lists for some time already, this is the fourth version:
https://patchwork.kernel.org/patch/1119562/
However it doesn't include a small fix I have added after posting v4, 
which is available in the above git repository.

>>>
>>> Not that it'd be really easy to do this properly; the sensors, for example,
>>> probably need a clock from the ISP and I2C before they can continue. The
>>> OMAP 3 ISP driver does attempt to do this but doesn't handle these
>>> dependencies.
>>
>> I'm not handling the device PM dependencies explicitly in this driver either.
>>
>> But it's assured the I2C bus device is registered first, then the camera host
>> device, and finally the I2C client devices.
>> AFAIU the PM core should call PM suspend helpers on the subdev/host drivers
>> in order: I2C clients, the camera host and I2C bus. And for the resume helpers
>> the sequence should be reversed.
> 
> In my understanding it is not ensured that the I2C bus driver starts before
> the media device parent does (as it is controlling the sensors' power
> state). The same goes for suspend. Or am I missing something?

AFAIU PM core maintains private list of its active devices which it then walks
when preparing, suspending, resuming and 'completing' subsystems.
Please check pm_device_add() and dpm_start_suspend() for instance. It looks like
the list can only be reordered through returning -EAGAIN from subsystem prepare
helper or by calling implicitly pm_device_move().
I might be missing some important details though, it would be best to clarify
these things on linux-pm ML.

> 
>> The sensor drivers do not implement their standard PM helper callbacks,
>> their are just controlled directly through s_power op by the host driver.
>>
>>>
>>> I'm not suggesting this should be part of the patch, just thought of asking
>>> it. :)
>>
>> First of all I'm not entirely happy with this code. The are some issues in
>> the v4l2-mem2mem framework which I plan to address when time permits. I think
>> it wasn't designed in PM use cases in mind. Plus PM support in Exynos4 platform
>> (including drivers) is rather not yet stable in the mainline kernel. So I was
>> having hard time to make this PM code working in the mem-to-mem device.
>> But it's now done and only a per frame clock gating is still missing.
>> This is a quite complex topic, to get everything right, in line with all
>> frameworks involved.
>>
>>>
>>>> +	return fimc_m2m_suspend(fimc);
>>>
>>> Does pending mean there are further images to process in a queue, or just
>>> that driver is busy one?
>>
>> It means the driver got an ownership of a pair of buffers and is about to or
>> is already processing them. In any case fimc_m2m_suspend() will wait for
>> only those two buffers to be processed, without dequeuing them back to user
>> space. They will be returned back to user space when the driver's resume helper
>> is called.
> 
> I think this is a good approach. Processing the buffers takes a fraction of
> a second. If one would cancel this it would unnecessarily complicate the
> user space.

Yes, and applications should not really care much about device power state 
transitions.

> 
>>>
>>>> +#endif /* CONFIG_PM_SLEEP */
>>>> +
>> ...
>>>> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
>>>> index 4893b2d..938dadf 100644
>>>> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
>>>> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
>>>> @@ -30,7 +30,7 @@ void fimc_hw_reset(struct fimc_dev *dev)
>>>>    	cfg = readl(dev->regs + S5P_CIGCTRL);
>>>>    	cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
>>>>    	writel(cfg, dev->regs + S5P_CIGCTRL);
>>>> -	udelay(1000);
>>>> +	udelay(10);
>>>
>>> Good catch. Large delays such as this one should have either used msleep()
>>> or usleep_range(). If a smaller one does, all the better.
>>
>> Yeah, now this delay gets in the way every time the device is brought from
>> no power to fully operational state, e.g. the video node is opened.
>> Some of this code comes from original vendor BSP package as sometimes
>> it saves plenty of time on experimenting to bring everything up due to
>> not so good documentation.
> 
> I wonder if it would make sense to separate this into another patch as it is
> a significant change in terms of controlling the device and has nothing to
> do with power management. I have no strong opinion on this.
> 
> Either way,
> 
> Acked-by: Sakari Ailus<sakari.ailus@iki.fi>

Thanks a lot! Unfortunately I can't add this tag yet, as Mauro already pulled
the patch. 

> 
> Btw. is there public documentation on FIMC block or SoCs that have it
> integrated? I probably have seen links but I don't remember any right now.
> :)

You can find S5PV210 Soc User Manual at this site: http://www.aesop.or.kr
(requires free registration).
There is also a public UM there for Exynos4210 SoC, however FIMC documentation
is not included.

--
Regards,
Sylwester
