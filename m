Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44284 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbCXIwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 04:52:45 -0400
Message-id: <551125D9.5080702@samsung.com>
Date: Tue, 24 Mar 2015 09:52:41 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v1 06/11] exynos4-is: Add support for v4l2-flash subdevs
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-7-git-send-email-j.anaszewski@samsung.com>
 <20150322012105.GI16613@valkosipuli.retiisi.org.uk>
 <551031FC.5010903@samsung.com>
 <20150323223935.GR16613@valkosipuli.retiisi.org.uk>
In-reply-to: <20150323223935.GR16613@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 03/23/2015 11:39 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Mon, Mar 23, 2015 at 04:32:12PM +0100, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the review.
>>
>> On 03/22/2015 02:21 AM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Some comments below. Please also get an ack from Sylwester! :-)
>>
>> No doubt about that :)
>>
>>> On Fri, Mar 20, 2015 at 04:03:26PM +0100, Jacek Anaszewski wrote:
>>>> This patch adds support for external v4l2-flash devices.
>>>> The support includes parsing "flashes" DT property
>>>> and asynchronous subdevice registration.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> ---
>>>>   drivers/media/platform/exynos4-is/media-dev.c |   36 +++++++++++++++++++++++--
>>>>   drivers/media/platform/exynos4-is/media-dev.h |   13 ++++++++-
>>>>   2 files changed, 46 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
>>>> index f315ef9..8dd0e5d 100644
>>>> --- a/drivers/media/platform/exynos4-is/media-dev.c
>>>> +++ b/drivers/media/platform/exynos4-is/media-dev.c
>>>> @@ -451,6 +451,25 @@ rpm_put:
>>>>   	return ret;
>>>>   }
>>>>
>>>> +static void fimc_md_register_flash_entities(struct fimc_md *fmd)
>>>> +{
>>>> +	struct device_node *parent = fmd->pdev->dev.of_node;
>>>> +	struct device_node *np;
>>>> +	int i = 0;
>>>> +
>>>> +	do {
>>>> +		np = of_parse_phandle(parent, "flashes", i);
>>>> +		if (np) {
>>>
>>> if (!np)
>>> 	break;
>>>
>>> And you can remove checking np another time in the loop condition.
>>
>> Thanks, this will be cleaner indeed.
>>
>>>> +			fmd->flash[fmd->num_flashes].asd.match_type =
>>>> +							V4L2_ASYNC_MATCH_OF;
>>>> +			fmd->flash[fmd->num_flashes].asd.match.of.node = np;
>>>> +			fmd->num_flashes++;
>>>> +			fmd->async_subdevs[fmd->num_sensors + i] =
>>>> +						&fmd->flash[i].asd;
>>>
>>> Have all the sensors been already registered by this point?
>>
>> Function fimc_md_register_sensor_entities is called before
>> this one.
>
> Ok. Then it's fine. I just thing this would be much cleaner if there was no
> assumption that fmd->num_flashes is necessarily zero (and all sensors have
> been registered).

Do you think this should be approached differently? I don't catch your
point here, could you be more specific? :)

>>>> +		}
>>>> +	} while (np && (++i < FIMC_MAX_FLASHES));
>>>
>>> How about instead:
>>>
>>> fmd->num_flashes < FIMC_MAX_FLASHES
>>>
>>> And drop i. Also move incrementing num_flashes as last in the if.
>>
>> Dropping i will enforce referring to fmd->num_flashes 7 times
>> in this short fragment of code.
>> Maybe it would be better to use a pointer to it?
>> int *nf = &fmd=>num_flashes ?
>
> You could also do
>
> const int nf = fmd->num_flashes;

fmd->num_flashes is incremented in the loop, so the constant
will not work here. There is a tradeoff - counter variable
or many references to the fmd->num_flashes.

>
> in the beginning of the loop.
>
> Up to you. Either is IMO better than an unrelated counter variable i. :-)
>
>>>> +}
>>>> +
>>>>   static int __of_get_csis_id(struct device_node *np)
>>>>   {
>>>>   	u32 reg = 0;
>>>> @@ -1275,6 +1294,15 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
>>>>   	struct fimc_sensor_info *si = NULL;
>>>>   	int i;
>>>>
>>>> +	/* Register flash subdev if detected any */
>>>> +	for (i = 0; i < ARRAY_SIZE(fmd->flash); i++) {
>>>> +		if (fmd->flash[i].asd.match.of.node == subdev->dev->of_node) {
>>>> +			fmd->flash[i].subdev = subdev;
>>>> +			fmd->num_flashes++;
>>>> +			return 0;
>>>> +		}
>>>> +	}
>>>> +
>>>>   	/* Find platform data for this sensor subdev */
>>>>   	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
>>>>   		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
>>>> @@ -1385,6 +1413,8 @@ static int fimc_md_probe(struct platform_device *pdev)
>>>>   		goto err_m_ent;
>>>>   	}
>>>>
>>>> +	fimc_md_register_flash_entities(fmd);
>>>> +
>>>>   	mutex_unlock(&fmd->media_dev.graph_mutex);
>>>>
>>>>   	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
>>>> @@ -1401,12 +1431,14 @@ static int fimc_md_probe(struct platform_device *pdev)
>>>>   		goto err_attr;
>>>>   	}
>>>>
>>>> -	if (fmd->num_sensors > 0) {
>>>> +	if (fmd->num_sensors > 0 || fmd->num_flashes > 0) {
>>>>   		fmd->subdev_notifier.subdevs = fmd->async_subdevs;
>>>> -		fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
>>>> +		fmd->subdev_notifier.num_subdevs = fmd->num_sensors +
>>>> +							fmd->num_flashes;
>>>>   		fmd->subdev_notifier.bound = subdev_notifier_bound;
>>>>   		fmd->subdev_notifier.complete = subdev_notifier_complete;
>>>>   		fmd->num_sensors = 0;
>>>> +		fmd->num_flashes = 0;
>>>>
>>>>   		ret = v4l2_async_notifier_register(&fmd->v4l2_dev,
>>>>   						&fmd->subdev_notifier);
>>>> diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
>>>> index 0321454..feff9c8 100644
>>>> --- a/drivers/media/platform/exynos4-is/media-dev.h
>>>> +++ b/drivers/media/platform/exynos4-is/media-dev.h
>>>> @@ -34,6 +34,8 @@
>>>>
>>>>   #define FIMC_MAX_SENSORS	4
>>>>   #define FIMC_MAX_CAMCLKS	2
>>>> +#define FIMC_MAX_FLASHES	2
>>>> +#define FIMC_MAX_ASYNC_SUBDEVS (FIMC_MAX_SENSORS + FIMC_MAX_FLASHES)
>>>>   #define DEFAULT_SENSOR_CLK_FREQ	24000000U
>>>>
>>>>   /* LCD/ISP Writeback clocks (PIXELASYNCMx) */
>>>> @@ -93,6 +95,11 @@ struct fimc_sensor_info {
>>>>   	struct fimc_dev *host;
>>>>   };
>>>>
>>>> +struct fimc_flash_info {
>>>> +	struct v4l2_subdev *subdev;
>>>> +	struct v4l2_async_subdev asd;
>>>> +};
>>>> +
>>>>   struct cam_clk {
>>>>   	struct clk_hw hw;
>>>>   	struct fimc_md *fmd;
>>>> @@ -104,6 +111,8 @@ struct cam_clk {
>>>>    * @csis: MIPI CSIS subdevs data
>>>>    * @sensor: array of registered sensor subdevs
>>>>    * @num_sensors: actual number of registered sensors
>>>> + * @flash: array of registered flash subdevs
>>>> + * @num_flashes: actual number of registered flashes
>>>>    * @camclk: external sensor clock information
>>>>    * @fimc: array of registered fimc devices
>>>>    * @fimc_is: fimc-is data structure
>>>> @@ -123,6 +132,8 @@ struct fimc_md {
>>>>   	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
>>>>   	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
>>>>   	int num_sensors;
>>>> +	struct fimc_flash_info flash[FIMC_MAX_FLASHES];
>>>> +	int num_flashes;
>>>>   	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
>>>>   	struct clk *wbclk[FIMC_MAX_WBCLKS];
>>>>   	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
>>>> @@ -149,7 +160,7 @@ struct fimc_md {
>>>>   	} clk_provider;
>>>>
>>>>   	struct v4l2_async_notifier subdev_notifier;
>>>> -	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
>>>> +	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_ASYNC_SUBDEVS];
>>>>
>>>>   	bool user_subdev_api;
>>>>   	spinlock_t slock;
>>>
>>
>>
>


-- 
Best Regards,
Jacek Anaszewski
