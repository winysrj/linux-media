Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:8988 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2H3GgO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 02:36:14 -0400
Message-ID: <503F07ED.6080802@atmel.com>
Date: Thu, 30 Aug 2012 14:27:57 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, nicolas.ferre@atmel.com,
	mchehab@redhat.com, linux-arm-kernel@lists.infradead.org,
	nicolas.thery@st.com
Subject: Re: [PATCH] [media] atmel_isi: allocate memory to store the isi platform
 data.
References: <1346235093-28613-1-git-send-email-josh.wu@atmel.com> <503E323A.8060409@samsung.com> <alpine.DEB.2.00.1208291755220.3095@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1208291755220.3095@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all

Sorry, My mistake here. After checking the code, this ISI bug doesn't 
exist in current mainline code. So I will *cancel* this patch.

Since current mainline will copy this __initdata isi platform data to 
one static structure in function at91_add_device_isi(...). Then pass 
this static structure to the driver.

So the ISI driver has no bug that isi platform became invalid. I meet 
this is because I'm not call the at91_add_device_isi(...) since I try in 
the DT support board.

At last, even no above bug in the code, This isi_platform_data is still 
need to stored in ISI driver. Since if we support DT then we need this 
isi platform data and the function at91_add_device_isi(...) will not to 
be called (it is in device file).

So I think after soc-camera DT support is merged. Then I will send a DT 
support patch for ISI driver which will embed the isi_platform_data into 
atmel_isi.

Thank you all for the replies. That helps a lot even in this small 
patch.  :)

On 8/30/2012 12:02 AM, Guennadi Liakhovetski wrote:
> On Wed, 29 Aug 2012, Sylwester Nawrocki wrote:
>
>> Hi,
>>
>> On 08/29/2012 12:11 PM, Josh Wu wrote:
>>> This patch fix the bug: ISI driver's platform data became invalid
>>> when isi platform data's attribution is __initdata.
>>>
>>> If the isi platform data is passed as __initdata. Then we need store
>>> it in driver allocated memory. otherwise when we use it out of the
>>> probe() function, then the isi platform data is invalid.
>>>
>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>> ---
>>>   drivers/media/platform/soc_camera/atmel-isi.c |   12 +++++++++++-
>>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
>>> index ec3f6a0..dc0fdec 100644
>>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>>> @@ -926,6 +926,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
>>>   	clk_put(isi->mck);
>>>   	clk_unprepare(isi->pclk);
>>>   	clk_put(isi->pclk);
>>> +	kfree(isi->pdata);
>>>   	kfree(isi);
>>>   
>>>   	return 0;
>>> @@ -968,8 +969,15 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>>>   		goto err_alloc_isi;
>>>   	}
>>>   
>>> +	isi->pdata = kzalloc(sizeof(struct isi_platform_data), GFP_KERNEL);
>>> +	if (!isi->pdata) {
>>> +		ret = -ENOMEM;
>>> +		dev_err(&pdev->dev, "Can't allocate isi platform data!\n");
>>> +		goto err_alloc_isi_pdata;
>>> +	}
>>> +	memcpy(isi->pdata, pdata, sizeof(struct isi_platform_data));
>>> +
>> Why not just embed struct isi_platform_data in struct atmel_isi and drop this
>> another kzalloc() ?
>> Then you could simply do isi->pdata = *pdata.
>>
>> Also, is this going to work when this driver is build and as a module
>> and its loading is deferred past system booting ? At that time the driver's
>> platform data may be well discarded.
> Right, it will be gone, I think.
>
>> You may wan't to duplicate it on the
>> running boards in board code with kmemdup() or something.
> How about removing __initdata from board code?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Josh Wu
