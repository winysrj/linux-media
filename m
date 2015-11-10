Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38297 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbKJGtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 01:49:17 -0500
Subject: Re: [PATCH 04/19] v4l: omap3isp: fix handling platform_get_irq result
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1443103227-25612-1-git-send-email-a.hajda@samsung.com>
 <1443103227-25612-5-git-send-email-a.hajda@samsung.com>
 <5373820.hJbPzosF9i@avalon>
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <56419356.5010603@samsung.com>
Date: Tue, 10 Nov 2015 07:48:54 +0100
MIME-version: 1.0
In-reply-to: <5373820.hJbPzosF9i@avalon>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/2015 09:16 PM, Laurent Pinchart wrote:
> Hi Andrzej,
>
> Thank you for the patch.
>
> On Thursday 24 September 2015 16:00:12 Andrzej Hajda wrote:
>> The function can return negative value.
>>
>> The problem has been detected using proposed semantic patch
>> scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].
>>
>> [1]: http://permalink.gmane.org/gmane.linux.kernel/2046107
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>> Hi,
>>
>> To avoid problems with too many mail recipients I have sent whole
>> patchset only to LKML. Anyway patches have no dependencies.
>>
>> Regards
>> Andrzej
>> ---
>>  drivers/media/platform/omap3isp/isp.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isp.c
>> b/drivers/media/platform/omap3isp/isp.c index 56e683b..df9d2c2 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -2442,12 +2442,13 @@ static int isp_probe(struct platform_device *pdev)
>>  	}
>>
>>  	/* Interrupt */
>> -	isp->irq_num = platform_get_irq(pdev, 0);
>> -	if (isp->irq_num <= 0) {
>> +	ret = platform_get_irq(pdev, 0);
>> +	if (ret <= 0) {
> Looking at platform_get_irq() all error values are negative. You could just 
> test for ret < 0 here, and remove the ret = -ENODEV assignment below to keep 
> the error code returned by platform_get_irq().
>
> If you're fine with that modification there's no need to resubmit, just let me 
> know and I'll fix it when applying it to my tree.

I left it as before, as it was not related to the patch. Additionally I have
lurked little bit inside platform_get_irq and it looks little bit scary to me:
platform_get_irq returns value of of_irq_get if ret >= 0,
of_irq_get calls of_irq_parse_one which can return 0,
in such case irq_create_of_mapping value is returned which is unsigned int
and evaluates to 0 in case of failures.
I am not sure if above scenario can ever occur, but the code looks so messy to me,
that I gave up :)

Anyway if you are sure about your change I am OK with it also :)

Regards
Andrzej

>
>>  		dev_err(isp->dev, "No IRQ resource\n");
>>  		ret = -ENODEV;
>>  		goto error_iommu;
>>  	}
>> +	isp->irq_num = ret;
>>
>>  	if (devm_request_irq(isp->dev, isp->irq_num, isp_isr, IRQF_SHARED,
>>  			     "OMAP3 ISP", isp)) {

