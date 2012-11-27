Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59914 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753584Ab2K0MSJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 07:18:09 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 04:18:11 -0800
Subject: RE: [PATCH 08/15] [media] marvell-ccic: switch to resource managed
 allocation and request
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C8EF@SC-VEXCH1.marvell.com>
References: <1353677637-24215-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271258210.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271258210.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 27 November, 2012 20:00
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 08/15] [media] marvell-ccic: switch to resource managed allocation
>and request
>
>On Fri, 23 Nov 2012, twang13@marvell.com wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch switchs to resource managed allocation and request in mmp-driver.
>> It can remove free resource operations.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>
>Nice! You can also use devm_gpio_request() :-)
>
Fine, it looks we forgot it.
We will change it.

>Thanks
>Guennadi
>

Thanks
Albert Wang
86-21-61092656
>> ---
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |   35 +++++++---------------
>>  1 file changed, 10 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 20046d0..c3031e7 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> @@ -315,7 +315,7 @@ static int mmpcam_probe(struct platform_device
>> *pdev)
>>
>>  	pdata = pdev->dev.platform_data;
>>
>> -	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
>> +	cam = devm_kzalloc(&pdev->dev, sizeof(*cam), GFP_KERNEL);
>>  	if (cam == NULL)
>>  		return -ENOMEM;
>>  	cam->pdev = pdev;
>> @@ -342,14 +342,12 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>  	if (res == NULL) {
>>  		dev_err(&pdev->dev, "no iomem resource!\n");
>> -		ret = -ENODEV;
>> -		goto out_free;
>> +		return -ENODEV;
>>  	}
>> -	mcam->regs = ioremap(res->start, resource_size(res));
>> +	mcam->regs = devm_request_and_ioremap(&pdev->dev, res);
>>  	if (mcam->regs == NULL) {
>>  		dev_err(&pdev->dev, "MMIO ioremap fail\n");
>> -		ret = -ENODEV;
>> -		goto out_free;
>> +		return -ENODEV;
>>  	}
>>  	/*
>>  	 * Power/clock memory is elsewhere; get it too.  Perhaps this @@
>> -358,14 +356,12 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>  	if (res == NULL) {
>>  		dev_err(&pdev->dev, "no power resource!\n");
>> -		ret = -ENODEV;
>> -		goto out_unmap1;
>> +		return -ENODEV;
>>  	}
>> -	cam->power_regs = ioremap(res->start, resource_size(res));
>> +	cam->power_regs = devm_request_and_ioremap(&pdev->dev, res);
>>  	if (cam->power_regs == NULL) {
>>  		dev_err(&pdev->dev, "power MMIO ioremap fail\n");
>> -		ret = -ENODEV;
>> -		goto out_unmap1;
>> +		return -ENODEV;
>>  	}
>>
>>  	mcam_init_clk(mcam, pdata, 1);
>> @@ -375,9 +371,8 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	 */
>>  	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
>>  	if (mcam->i2c_adapter == NULL) {
>> -		ret = -ENODEV;
>>  		dev_err(&pdev->dev, "No i2c adapter\n");
>> -		goto out_unmap2;
>> +		return -ENODEV;
>>  	}
>>  	/*
>>  	 * Sensor GPIO pins.
>> @@ -386,7 +381,7 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  	if (ret) {
>>  		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
>>  				pdata->sensor_power_gpio);
>> -		goto out_unmap2;
>> +		return ret;
>>  	}
>>  	gpio_direction_output(pdata->sensor_power_gpio, 0);
>>  	ret = gpio_request(pdata->sensor_reset_gpio, "cam-reset"); @@ -414,7
>> +409,7 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  		goto out_unregister;
>>  	}
>>  	cam->irq = res->start;
>> -	ret = request_irq(cam->irq, mmpcam_irq, IRQF_SHARED,
>> +	ret = devm_request_irq(&pdev->dev, cam->irq, mmpcam_irq,
>> +IRQF_SHARED,
>>  			"mmp-camera", mcam);
>>  	if (ret == 0) {
>>  		mmpcam_add_device(cam);
>> @@ -428,13 +423,7 @@ out_gpio2:
>>  	gpio_free(pdata->sensor_reset_gpio);
>>  out_gpio:
>>  	gpio_free(pdata->sensor_power_gpio);
>> -out_unmap2:
>>  	mcam_init_clk(mcam, pdata, 0);
>> -	iounmap(cam->power_regs);
>> -out_unmap1:
>> -	iounmap(mcam->regs);
>> -out_free:
>> -	kfree(cam);
>>  	return ret;
>>  }
>>
>> @@ -445,16 +434,12 @@ static int mmpcam_remove(struct mmp_camera *cam)
>>  	struct mmp_camera_platform_data *pdata;
>>
>>  	mmpcam_remove_device(cam);
>> -	free_irq(cam->irq, mcam);
>>  	mccic_shutdown(mcam);
>>  	mmpcam_power_down(mcam);
>>  	pdata = cam->pdev->dev.platform_data;
>>  	gpio_free(pdata->sensor_reset_gpio);
>>  	gpio_free(pdata->sensor_power_gpio);
>> -	iounmap(cam->power_regs);
>> -	iounmap(mcam->regs);
>>  	mcam_init_clk(mcam, pdata, 0);
>> -	kfree(cam);
>>  	return 0;
>>  }
>>
>> --
>> 1.7.9.5
>>
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
