Return-path: <linux-media-owner@vger.kernel.org>
Received: from [192.199.1.245] ([192.199.1.245]:19296 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753498AbbEZNKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:10:34 -0400
Message-ID: <55643980.6090101@atmel.com>
Date: Tue, 26 May 2015 17:14:40 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] media: atmel-isi: add runtime pm support
References: <1432627211-4338-1-git-send-email-josh.wu@atmel.com> <1432627211-4338-2-git-send-email-josh.wu@atmel.com> <3343948.3GpRNgsx2G@avalon>
In-Reply-To: <3343948.3GpRNgsx2G@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 5/26/2015 4:16 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Tuesday 26 May 2015 16:00:09 Josh Wu wrote:
>> The runtime pm resume/suspend will enable/disable pclk (ISI peripheral
>> clock).
>> And we need to call runtime_pm_get_sync()/runtime_pm_put() when we need
>> access ISI registers. In atmel_isi_probe(), remove the isi disable code
>> as in the moment ISI peripheral clock is not enable yet.
>>
>> In the meantime, as clock_start()/clock_stop() is used to control the
>> mclk not ISI peripheral clock. So move this to start[stop]_streaming()
>> function.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>> Changes in v4:
>> - need to call pm_runtime_disable() in atmel_isi_remove().
>> - merged the patch which remove isi disable code in atmel_isi_probe() as
>>    isi peripherial clock is not enabled in this moment.
>> - refine the commit log
>>
>> Changes in v3: None
>> Changes in v2:
>> - merged v1 two patch into one.
>> - use runtime_pm_put() instead of runtime_pm_put_sync()
>> - enable peripheral clock before access ISI registers.
>>
>>   drivers/media/platform/soc_camera/atmel-isi.c | 54 ++++++++++++++++++++----
>>   1 file changed, 46 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index 2879026..194e875
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/kernel.h>
>>   #include <linux/module.h>
>>   #include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>>   #include <linux/slab.h>
>>
>>   #include <media/atmel-isi.h>
>> @@ -386,6 +387,8 @@ static int start_streaming(struct vb2_queue *vq,
>> unsigned int count) struct atmel_isi *isi = ici->priv;
>>   	int ret;
>>
>> +	pm_runtime_get_sync(ici->v4l2_dev.dev);
>> +
>>   	/* Reset ISI */
>>   	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
>>   	if (ret < 0) {
> You need to call pm_runtime_put() in the error path, otherwise an
> atmel_isi_wait_status() failure will keep the device enabled.

Nice catch. Thanks.

>
>> @@ -445,6 +448,8 @@ static void stop_streaming(struct vb2_queue *vq)
>>   	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
>>   	if (ret < 0)
>>   		dev_err(icd->parent, "Disable ISI timed out\n");
>> +
>> +	pm_runtime_put(ici->v4l2_dev.dev);
>>   }
>>
>>   static struct vb2_ops isi_video_qops = {
>> @@ -516,7 +521,13 @@ static int isi_camera_set_fmt(struct soc_camera_device
>> *icd, if (mf->code != xlate->code)
>>   		return -EINVAL;
>>
>> +	/* Enable PM and peripheral clock before operate isi registers */
>> +	pm_runtime_get_sync(ici->v4l2_dev.dev);
>> +
>>   	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
>> +
>> +	pm_runtime_put(ici->v4l2_dev.dev);
> I think it would simplify the code to move the configure_geometry() call to
> start_streaming() as you already call pm_runtime_get_sync() there. That can be
> done in a separate patch though.

I think it's a good idea. I would like to make this in a separate patch 
and not include in this series.

In summary, I'll resend this patch just with the fix you mentioned in 
above (fix the error path in start_streaming).
Is that okay for you?

Best Regards,
Josh Wu

>
>> +
>>   	if (ret < 0)
>>   		return ret;
>>
>> @@ -736,14 +747,9 @@ static int isi_camera_clock_start(struct
>> soc_camera_host *ici) struct atmel_isi *isi = ici->priv;
>>   	int ret;
>>
>> -	ret = clk_prepare_enable(isi->pclk);
>> -	if (ret)
>> -		return ret;
>> -
>>   	if (!IS_ERR(isi->mck)) {
>>   		ret = clk_prepare_enable(isi->mck);
>>   		if (ret) {
>> -			clk_disable_unprepare(isi->pclk);
>>   			return ret;
>>   		}
>>   	}
>> @@ -758,7 +764,6 @@ static void isi_camera_clock_stop(struct soc_camera_host
>> *ici)
>>
>>   	if (!IS_ERR(isi->mck))
>>   		clk_disable_unprepare(isi->mck);
>> -	clk_disable_unprepare(isi->pclk);
>>   }
>>
>>   static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
>> @@ -855,9 +860,14 @@ static int isi_camera_set_bus_param(struct
>> soc_camera_device *icd)
>>
>>   	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
>>
>> +	/* Enable PM and peripheral clock before operate isi registers */
>> +	pm_runtime_get_sync(ici->v4l2_dev.dev);
>> +
>>   	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>>   	isi_writel(isi, ISI_CFG1, cfg1);
>>
>> +	pm_runtime_put(ici->v4l2_dev.dev);
>> +
>>   	return 0;
>>   }
>>
>> @@ -889,6 +899,7 @@ static int atmel_isi_remove(struct platform_device
>> *pdev) sizeof(struct fbd) * MAX_BUFFER_NUM,
>>   			isi->p_fb_descriptors,
>>   			isi->fb_descriptors_phys);
>> +	pm_runtime_disable(&pdev->dev);
>>
>>   	return 0;
>>   }
>> @@ -1027,8 +1038,6 @@ static int atmel_isi_probe(struct platform_device
>> *pdev) if (isi->pdata.data_width_flags & ISI_DATAWIDTH_10)
>>   		isi->width_flags |= 1 << 9;
>>
>> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> -
>>   	irq = platform_get_irq(pdev, 0);
>>   	if (IS_ERR_VALUE(irq)) {
>>   		ret = irq;
>> @@ -1049,6 +1058,9 @@ static int atmel_isi_probe(struct platform_device
>> *pdev) soc_host->v4l2_dev.dev	= &pdev->dev;
>>   	soc_host->nr		= pdev->id;
>>
>> +	pm_suspend_ignore_children(&pdev->dev, true);
>> +	pm_runtime_enable(&pdev->dev);
>> +
>>   	if (isi->pdata.asd_sizes) {
>>   		soc_host->asd = isi->pdata.asd;
>>   		soc_host->asd_sizes = isi->pdata.asd_sizes;
>> @@ -1062,6 +1074,7 @@ static int atmel_isi_probe(struct platform_device
>> *pdev) return 0;
>>
>>   err_register_soc_camera_host:
>> +	pm_runtime_disable(&pdev->dev);
>>   err_req_irq:
>>   err_ioremap:
>>   	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
>> @@ -1074,6 +1087,30 @@ err_alloc_ctx:
>>   	return ret;
>>   }
>>
>> +static int atmel_isi_runtime_suspend(struct device *dev)
>> +{
>> +	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
>> +	struct atmel_isi *isi = container_of(soc_host,
>> +					struct atmel_isi, soc_host);
>> +
>> +	clk_disable_unprepare(isi->pclk);
>> +
>> +	return 0;
>> +}
>> +static int atmel_isi_runtime_resume(struct device *dev)
>> +{
>> +	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
>> +	struct atmel_isi *isi = container_of(soc_host,
>> +					struct atmel_isi, soc_host);
>> +
>> +	return clk_prepare_enable(isi->pclk);
>> +}
>> +
>> +static const struct dev_pm_ops atmel_isi_dev_pm_ops = {
>> +	SET_RUNTIME_PM_OPS(atmel_isi_runtime_suspend,
>> +				atmel_isi_runtime_resume, NULL)
>> +};
>> +
>>   static const struct of_device_id atmel_isi_of_match[] = {
>>   	{ .compatible = "atmel,at91sam9g45-isi" },
>>   	{ }
>> @@ -1085,6 +1122,7 @@ static struct platform_driver atmel_isi_driver = {
>>   	.driver		= {
>>   		.name = "atmel_isi",
>>   		.of_match_table = of_match_ptr(atmel_isi_of_match),
>> +		.pm	= &atmel_isi_dev_pm_ops,
>>   	},
>>   };

