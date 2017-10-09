Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:30234 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdJIFtv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 01:49:51 -0400
Subject: Re: [PATCH v3 3/5] media: atmel-isc: Enable the clocks during probe
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Corbet <corbet@lwn.net>,
        <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170928081828.20335-1-wenyou.yang@microchip.com>
 <20170928081828.20335-4-wenyou.yang@microchip.com>
 <20170928212543.sltvd4rgswfowtcd@valkosipuli.retiisi.org.uk>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <7d5bd4ff-f18e-5f0d-9ce1-3f5169be4c14@Microchip.com>
Date: Mon, 9 Oct 2017 13:49:44 +0800
MIME-Version: 1.0
In-Reply-To: <20170928212543.sltvd4rgswfowtcd@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Sorry for late answer, because I was in vacation last week.

On 2017/9/29 5:25, Sakari Ailus wrote:
> Hi Wenyou,
>
> On Thu, Sep 28, 2017 at 04:18:26PM +0800, Wenyou Yang wrote:
>> To meet the relationship, enable the HCLOCK and ispck during the
>> device probe, "isc_pck frequency is less than or equal to isc_ispck,
>> and isc_ispck is greater than or equal to HCLOCK."
>> Meanwhile, call the pm_runtime_enable() in the right place.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
>> ---
>>
>> Changes in v3: None
>> Changes in v2: None
>>
>>   drivers/media/platform/atmel/atmel-isc.c | 31 +++++++++++++++++++++++++------
>>   1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>> index 0b15dc1a3a0b..f092c95587c1 100644
>> --- a/drivers/media/platform/atmel/atmel-isc.c
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>> @@ -1594,6 +1594,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>>   	struct isc_subdev_entity *sd_entity;
>>   	struct video_device *vdev = &isc->video_dev;
>>   	struct vb2_queue *q = &isc->vb2_vidq;
>> +	struct device *dev = isc->dev;
>>   	int ret;
>>   
>>   	ret = v4l2_device_register_subdev_nodes(&isc->v4l2_dev);
>> @@ -1677,6 +1678,10 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>>   		return ret;
>>   	}
>>   
>> +	pm_runtime_set_active(dev);
>> +	pm_runtime_enable(dev);
>> +	pm_request_idle(dev);
> Remember that the driver's async complete function could never get called.
>
> What would be the reason to move it here?
The ISC provides the clock for the sensor, namely, it is the clock 
provider for the external sensor.
So it keeps active to make the sensor probe successfully.
Otherwise, the sensor, such as 0v7670 fails to probe due to the failure 
to clk_enable().
>
>> +
>>   	return 0;
>>   }
>>   
>> @@ -1856,25 +1861,37 @@ static int atmel_isc_probe(struct platform_device *pdev)
>>   		return ret;
>>   	}
>>   
>> +	ret = clk_prepare_enable(isc->hclock);
>> +	if (ret) {
>> +		dev_err(dev, "failed to enable hclock: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>>   	ret = isc_clk_init(isc);
>>   	if (ret) {
>>   		dev_err(dev, "failed to init isc clock: %d\n", ret);
>> -		goto clean_isc_clk;
>> +		goto unprepare_hclk;
>>   	}
>>   
>>   	isc->ispck = isc->isc_clks[ISC_ISPCK].clk;
>>   
>> +	ret = clk_prepare_enable(isc->ispck);
>> +	if (ret) {
>> +		dev_err(dev, "failed to enable ispck: %d\n", ret);
>> +		goto unprepare_hclk;
>> +	}
>> +
>>   	/* ispck should be greater or equal to hclock */
>>   	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
>>   	if (ret) {
>>   		dev_err(dev, "failed to set ispck rate: %d\n", ret);
>> -		goto clean_isc_clk;
>> +		goto unprepare_clk;
>>   	}
>>   
>>   	ret = v4l2_device_register(dev, &isc->v4l2_dev);
>>   	if (ret) {
>>   		dev_err(dev, "unable to register v4l2 device.\n");
>> -		goto clean_isc_clk;
>> +		goto unprepare_clk;
>>   	}
>>   
>>   	ret = isc_parse_dt(dev, isc);
>> @@ -1907,8 +1924,6 @@ static int atmel_isc_probe(struct platform_device *pdev)
>>   			break;
>>   	}
>>   
>> -	pm_runtime_enable(dev);
>> -
>>   	return 0;
>>   
>>   cleanup_subdev:
>> @@ -1917,7 +1932,11 @@ static int atmel_isc_probe(struct platform_device *pdev)
>>   unregister_v4l2_device:
>>   	v4l2_device_unregister(&isc->v4l2_dev);
>>   
>> -clean_isc_clk:
>> +unprepare_clk:
>> +	clk_disable_unprepare(isc->ispck);
>> +unprepare_hclk:
>> +	clk_disable_unprepare(isc->hclock);
> I think you're missing clk_disable_unprepare() in the driver's remove
> callback.
Will add in next version.
>
>> +
>>   	isc_clk_cleanup(isc);
>>   
>>   	return ret;

Best Regards,
Wenyou Yang
