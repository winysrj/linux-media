Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:26394 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2AKDzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 22:55:09 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH RESEND v3 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Date: Wed, 11 Jan 2012 11:54:43 +0800
Message-ID: <4C79549CB6F772498162A641D92D53280402939E@penmb01.corp.atmel.com>
In-Reply-To: <Pine.LNX.4.64.1201101224330.530@axis700.grange>
References: <1326193999-7609-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1201101224330.530@axis700.grange>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>, <mchehab@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	<linux@arm.linux.org.uk>, <arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thank you. I will send v4 version to apply your suggestion.

On Tuesday, January 10, 2012 7:29 PM, Guennadi Liakhovetski wrote:

> Hi Josh

> Right, sorry, I missed this one, I somehow developed an idea, that it
has 
> been merged into the original patch, adding ISI_MCK handling. Now, I
also 
> notice one detail, that we could improve:

> On Tue, 10 Jan 2012, Josh Wu wrote:

>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> Hi, Mauro
>> 
>> The first patch of this serie, [PATCH 1/2 v3] V4L: atmel-isi: add
code to enable/disable ISI_MCK clock, is already queued in media tree. 
>> But this patch (the second one of this serie) is not acked yet. Would
it be ok to for you to ack this patch?
>> 
>> Best Regards,
>> Josh Wu
>> 
>> v2: made the label name to be consistent.
>> 
>>  drivers/media/video/atmel-isi.c |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/media/video/atmel-isi.c
b/drivers/media/video/atmel-isi.c
>> index ea4eef4..91ebcfb 100644
>> --- a/drivers/media/video/atmel-isi.c
>> +++ b/drivers/media/video/atmel-isi.c
>> @@ -922,7 +922,9 @@ static int __devexit atmel_isi_remove(struct
platform_device *pdev)
>>  			isi->fb_descriptors_phys);
>>  
>>  	iounmap(isi->regs);
>> +	clk_unprepare(isi->mck);
>>  	clk_put(isi->mck);
>> +	clk_unprepare(isi->pclk);
>>  	clk_put(isi->pclk);
>>  	kfree(isi);
>>  
>> @@ -955,6 +957,12 @@ static int __devinit atmel_isi_probe(struct
platform_device *pdev)
>>  	if (IS_ERR(pclk))
>>  		return PTR_ERR(pclk);
>>  
>> +	ret = clk_prepare(pclk);
>> +	if (ret) {
>> +		clk_put(pclk);
>> +		return ret;

> Don't think it's a good idea here. You already have clk_put(pclk) on
the 
> error handling path below. So, just put a "goto err_clk_prepare_pclk"
here 
> and the respective error below.

Right. I'll fix it in v4.

> Thanks
> Guennadi

>> +	}
>> +
>>  	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
>>  	if (!isi) {
>>  		ret = -ENOMEM;
>> @@ -978,6 +986,10 @@ static int __devinit atmel_isi_probe(struct
platform_device *pdev)
>>  		goto err_clk_get;
>>  	}
>>  
>> +	ret = clk_prepare(isi->mck);
>> +	if (ret)
>> +		goto err_clk_prepare_mck;
>> +
>>  	/* Set ISI_MCK's frequency, it should be faster than pixel clock
*/
>>  	ret = clk_set_rate(isi->mck, pdata->mck_hz);
>>  	if (ret < 0)
>> @@ -1059,10 +1071,13 @@ err_alloc_ctx:
>>  			isi->fb_descriptors_phys);
>>  err_alloc_descriptors:
>>  err_set_mck_rate:
>> +	clk_unprepare(isi->mck);
>> +err_clk_prepare_mck:
>>  	clk_put(isi->mck);
>>  err_clk_get:
>>  	kfree(isi);
>>  err_alloc_isi:
>> +	clk_unprepare(pclk);
>>  	clk_put(pclk);
>>  
>>  	return ret;
>> -- 
>> 1.6.3.3
>> 

> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

Best Regards,
Josh Wu
