Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50404 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2CHV15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 16:27:57 -0500
Received: by wejx9 with SMTP id x9so655935wej.19
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 13:27:55 -0800 (PST)
Message-ID: <4F592457.2010000@gmail.com>
Date: Thu, 08 Mar 2012 22:27:51 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: sungchun.kang@samsung.com
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, jonghun.han@samsung.com,
	sy0816.kang@samsung.com, khw0178.kim@samsung.com
Subject: Re: [PATCH] media: fimc-lite: Add new driver for camera interface
References: <005401cceba7$d4d75790$7e8606b0$%kang@samsung.com> <4F529864.2050409@gmail.com> <000201ccfc46$a8259f90$f870deb0$%kang@samsung.com>
In-Reply-To: <000201ccfc46$a8259f90$f870deb0$%kang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sungchun,

On 03/07/2012 10:42 AM, Sungchun Kang wrote:
>> On 03/04/2012 07:17 AM, Sylwester Nawrocki wrote:
>> On 02/15/2012 07:05 AM, Sungchun Kang wrote:
>>> This patch adds support fimc-lite device which is a new device for
>>> camera interface on EXYNOS5 SoCs.
>>
>> It's also available in the Exynos4 SoC and I was planning adding it at
>> the s5p-fimc driver eventually. It may take some time though since it
>> is not described in the datasheets I have.
>>
> You're right, Fimc-lite is used exynos4(4212 and 4412 except 4210) and exynos5.
> But we decided to use mc in exynos5 only.

I'd like to use the s5p-fimc with fimc-lite driver that we agree on for exynos4x12.

> And exynos4 has fimc-lite and fimc, on the other hand, exynos5 fimc-lite and
> g-scaler.
> Also, fimc-lite can memory operation like as fimc and SFR is quite different.

I guess you mean FIMC-LITE doesn't support data input from memory (mem-to-mem).
I also think FIMC-LITE device is different enough from FIMC to deserve its own
driver.

...
>>> +static int flite_s_power(struct v4l2_subdev *sd, int on) {
>>> +	struct flite_dev *flite = v4l2_get_subdevdata(sd);
>>> +	int ret = 0;
>>> +
>>> +	if (on) {
>>> +		pm_runtime_get_sync(&flite->pdev->dev);
>>> +		set_bit(FLITE_ST_POWER,&flite->state);
>>> +	} else {
>>> +		pm_runtime_put_sync(&flite->pdev->dev);
>>
>> The runtime PM calls shouldn't be used from within the system sleep
>> helpers AFAIK, so there may be issues when calling flite_s_power from
>> within any system suspen or resume callback. And no, I don't know how
>> to handle this properly yet.
>>
> You're right, the runtime PM calls use schedule function. So it shouldn't
> Use within atomic operation e.g) interrupt service routine.

The PM core calls directly the driver's pm_runtime_[suspend/resume] helpers
when pm_runtime_[suspend/resume]_sync() functions are used. So the PM workqueue
is not involved.

I previously didn't check the (system sleep) PM helpers implementation in this 
driver carefully enough, I thought you are resuming/suspending the whole video
pipeline from within system sleep helpers of this driver. But that's not the 
case. Probably because FIMC-LITE is not always the terminating entity for the
data pipeline.

I think we need a centrally coordinated suspending/resuming of devices that
are part of an active pipeline. The others, that are idle, can just use their
own platform device suspend/resume helpers.

> But why s_power is system sleep function?

I mean, flite_s_power() is called from within the system sleep helpers 
(flite_suspend/resume). This is not correct from PM core POV and may cause 
trouble.

Probably you haven't noticed that because all the devices belong to same power
domain and the power domain have been a parent device of each device in the
pipeline (Samsung-specific power domains implementation). Let's hope after 
migration to the generic power domains it doesn't break. To be sure the best
thing to do is just to re-factor the PM code to eliminate PM runtime API calls
in the system sleep helpers.

Btw, have you already tested this driver against system suspend/resume cycle
with active camera capture pipeline ? Is the pipeline properly restored
after systems has woken up, i.e. a user space application continues to work ?

>From the patches it doesn't quite look like it could work.

...
>>> +	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
>>> +	if (!sd)
>>> +	       goto err_irq;
>>> +
>>> +	v4l2_subdev_init(sd,&flite_subdev_ops);
>>> +	snprintf(sd->name, sizeof(sd->name), "flite-subdev.%d", flite-
>>> id);
>>> +
>>> +	flite->sd_flite = sd;
>>> +	v4l2_set_subdevdata(flite->sd_flite, flite);
>>> +
>>> +	mutex_init(&flite->lock);
>>> +	flite->mdev = flite_get_capture_md(MDEV_CAPTURE);
>>> +	if (IS_ERR_OR_NULL(flite->mdev))
>>> +		goto err_irq;
>>
>> How are you making sure the media device driver is already probed at
>> this point ?
> Media device is probed before this point using makefile.

OK, then it seems the loadable module build support was not on the list
of your requirements. ;)

>>> +	flite_dbg("mdev = 0x%08x", (u32)flite->mdev);
>>> +
>>> +	ret = flite_register_video_device(flite);
>>> +	if (ret)
>>> +		goto err_irq;
>>
>> Not all resources are initialized at this point so it's to early to
>> register the video node. You need to move that after the allocator
>> initialization. The driver would crash the system if the video node is
>> opened right after it is registered, and it is not unusual at all.
>>
> I see. I will fixed it.
>>> +	/* Get mipi-csis subdev ptr using mdev */
>>> +	flite->sd_csis = flite->mdev->csis_sd[flite->id];
>>> +
>>> +	for (i = 0; i<   flite->pdata->num_clients; i++) {
>>> +		isp_info = flite->pdata->isp_info[i];
>>> +		ret = flite_config_camclk(flite, isp_info, i);
>>> +		if (ret) {
>>> +			flite_err("failed setup cam clk");
>>> +			goto err_vfd_alloc;
>>> +		}
>>> +	}
>>> +
>>> +	ret = flite_register_sensor_entities(flite);
>>> +	if (ret) {
>>> +		flite_err("failed register sensor entities");
>>> +		goto err_clk;
>>> +	}
>>
>> ARGH. Please consider moving that to the media device driver probe().
>>
> I don't think I can about this. As you know, separate devices use same media device.

I suggest using a dedicated media drivers, for camera, hdmi, etc., rather than
a simple universal driver. Each of the media devices is different after all.

...
>>> diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
>>> b/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
>> ...
>>> +/* Camera General Purpose */
>>> +#define FLITE_REG_CIGENERAL				0xFC
>>
>> In the kernel using lower case for hex numbers is preferred.
> Really?? S5p-fimc too..

It's just a suggestion. If you don't want to change it, I'll rework it myself,
when adding to the s5p-fimc driver.. :)

# git grep  "0x[0-9A-F][A-F]\|0x[A-F][0-9A-F]" drivers/media/video/s5p-fimc | wc -l
2

# git grep  "0x[0-9a-f][a-f]\|0x[a-f][0-9a-f]" drivers/media/video/s5p-fimc | wc -l
42
...
>>> +};
>>> +
>>> +/**
>>> + * struct exynos_platform_flite - camera host interface platform
>> data
>>> + *
>>> + * @cam: properties of camera sensor required for host interface
>>> +setup  */ struct exynos_platform_flite {
>>> +	struct s3c_platform_camera *cam[MAX_CAMIF_CLIENTS];
>>> +	struct exynos_isp_info *isp_info[MAX_CAMIF_CLIENTS];
>>> +	u32 active_cam_index;
>>> +	u32 num_clients;
>>> +};
>>
>> I don't think it is a good idea to associate the sensors with FIMC-
>> LITE devices. This creates a bigger mess to deal with when you try to
>> add DT support. It prevents you from re-attaching a sensor to
>> different FIMC-LITE instance at runtime, doesn't it ?
>>
>> Maybe you did that in order to support VIDIOC_S_INPUT, but that looks
>> wrong to me. Instead the sensors should be attached to a top level
>> camera media device.
>>
> We have legacy fimc and v4l2 fimc driver. S3c_platform_camera structure is for legacy.
> fimc-lite should support legacy, v4l2, exynos4 and exynos5.
> But I will consider another method.

I don't think it is a good idea to include any stubs for proprietary code
in the mainline kernel..

--
Regards,
Sylwester

