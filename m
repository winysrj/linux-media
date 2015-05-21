Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11063 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbbEUJjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:39:42 -0400
Message-id: <555DA7D7.1000308@samsung.com>
Date: Thu, 21 May 2015 11:39:35 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: [PATCH v8 5/8] exynos4-is: Add support for v4l2-flash subdevs
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-6-git-send-email-j.anaszewski@samsung.com>
 <20150521074648.GF8601@valkosipuli.retiisi.org.uk>
In-reply-to: <20150521074648.GF8601@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/21/2015 09:46 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, May 20, 2015 at 04:10:12PM +0200, Jacek Anaszewski wrote:
>> This patch adds support for external v4l2-flash devices.
>> The support includes parsing "samsung,flash-led" DT property
>> and asynchronous subdevice registration.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>   drivers/media/platform/exynos4-is/media-dev.c |   39 +++++++++++++++++++++++--
>>   drivers/media/platform/exynos4-is/media-dev.h |   13 ++++++++-
>>   2 files changed, 49 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
>> index f315ef9..80cecd8 100644
>> --- a/drivers/media/platform/exynos4-is/media-dev.c
>> +++ b/drivers/media/platform/exynos4-is/media-dev.c
>> @@ -451,6 +451,28 @@ rpm_put:
>>   	return ret;
>>   }
>>
>> +static void fimc_md_register_flash_entities(struct fimc_md *fmd)
>> +{
>> +	int i;
>> +
>> +	fmd->num_flashes = 0;
>> +
>> +	for (i = 0; i < fmd->num_sensors; i++) {
>> +		const struct device_node *np =
>> +					fmd->sensor[i].asd.match.of.node;
>> +		const int nf = fmd->num_flashes;
>> +
>> +		np = of_parse_phandle(np, "samsung,flash-led", 0);
>> +		if (!np)
>> +			continue;
>> +
>> +		fmd->flash[nf].asd.match_type = V4L2_ASYNC_MATCH_OF;
>> +		fmd->flash[nf].asd.match.of.node = np;
>> +		fmd->async_subdevs[fmd->num_sensors + nf] = &fmd->flash[nf].asd;
>> +		fmd->num_flashes++;
>> +	}
>> +}
>> +
>>   static int __of_get_csis_id(struct device_node *np)
>>   {
>>   	u32 reg = 0;
>> @@ -1275,6 +1297,15 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
>>   	struct fimc_sensor_info *si = NULL;
>>   	int i;
>>
>> +	/* Register flash subdev if detected any */
>> +	for (i = 0; i < ARRAY_SIZE(fmd->flash); i++) {
>> +		if (fmd->flash[i].asd.match.of.node == subdev->of_node) {
>
> Does the index of a particular sub-device index matter? Could you just use
> the next available one?

Having the positions of sensor sub-devices kept in synch with
the positions of associated flash sub-devices in the 'flash' array
allows to avoid the addition o a condition for checking if the element
of the flash array is available.

> There would be no need to for the check anything here, please see how the
> omap3isp driver does it --- it's in isp_subdev_notifier_bound()
> drivers/media/platform/omap3isp/isp.c .

This 'for' loop allows to detect that the sub-device being bound
is of flash type and basing on that we can exit the function
at this point. Otherwise some guards would have to be added in
the remaining part of the function.

>> +			fmd->flash[i].subdev = subdev;
>> +			fmd->num_flashes++;
>> +			return 0;
>> +		}
>> +	}
>> +
>>   	/* Find platform data for this sensor subdev */
>>   	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
>>   		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
>


-- 
Best Regards,
Jacek Anaszewski
