Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:1943 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1LGGKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 01:10:12 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Date: Wed, 7 Dec 2011 14:09:56 +0800
Message-ID: <4C79549CB6F772498162A641D92D5328039E98C1@penmb01.corp.atmel.com>
In-Reply-To: <Pine.LNX.4.64.1112061045150.10715@axis700.grange>
References: <1322647604-30662-1-git-send-email-josh.wu@atmel.com> <1322647604-30662-2-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1112061045150.10715@axis700.grange>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	<linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thank you for explain the label name rules. I've sent the v2 version
patch out. In v2 version I modified the code and make the label name
consistent.

On 12/06/2011 5:49PM, Guennadi Liakhovetski wrote:

> Hi Josh

> Thanks for the patch, but I'll ask you to fix the same thing in it,
that 
> I've fixed for you in the first patch in this series:

> On Wed, 30 Nov 2011, Josh Wu wrote:

>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>  drivers/media/video/atmel-isi.c |   17 ++++++++++++++++-
>>  1 files changed, 16 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/media/video/atmel-isi.c
b/drivers/media/video/atmel-isi.c
>> index ea4eef4..5da4381 100644
>> --- a/drivers/media/video/atmel-isi.c
>> +++ b/drivers/media/video/atmel-isi.c

> [snip]

>> @@ -978,10 +986,14 @@ static int __devinit atmel_isi_probe(struct
platform_device *pdev)
>>  		goto err_clk_get;
>>  	}
>>  
>> +	ret = clk_prepare(isi->mck);
>> +	if (ret)
>> +		goto err_set_mck_rate;
>> +
>>  	/* Set ISI_MCK's frequency, it should be faster than pixel clock
*/
>>  	ret = clk_set_rate(isi->mck, pdata->mck_hz);
>>  	if (ret < 0)
>> -		goto err_set_mck_rate;
>> +		goto err_unprepare_mck;
>>  
>>  	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
>>  				sizeof(struct fbd) * MAX_BUFFER_NUM,
>> @@ -1058,11 +1070,14 @@ err_alloc_ctx:
>>  			isi->p_fb_descriptors,
>>  			isi->fb_descriptors_phys);
>>  err_alloc_descriptors:
>> +err_unprepare_mck:
>> +	clk_unprepare(isi->mck);
>>  err_set_mck_rate:
>>  	clk_put(isi->mck);
>>  err_clk_get:
>>  	kfree(isi);
>>  err_alloc_isi:
>> +	clk_unprepare(pclk);
>>  	clk_put(pclk);
>>  
>>  	return ret;

> Please, use error label names consistently. As you can see, currently
the 
> driver uses the convention

>	ret = do_something();
>	if (ret < 0)
>		goto err_do_something;

> i.e., the label is called after the operation, that has failed, not
after 
> the clean up step, that the control now has to jump to. Please, update

> your patch to also use this convention.

Understand it now. Thank you.

> Thanks
> Guennadi

Best Regards,
Josh Wu
