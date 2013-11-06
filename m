Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:45501 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3KFLvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 06:51:21 -0500
MIME-Version: 1.0
In-Reply-To: <527A269B.5040007@samsung.com>
References: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
	<1383631964-26514-4-git-send-email-arun.kk@samsung.com>
	<20131105125108.GF23061@valkosipuli.retiisi.org.uk>
	<CALt3h7_BCj7yJi6sy=KVOHoET4aWm_a-N=u63R8-bZ-uQ=AGag@mail.gmail.com>
	<527A269B.5040007@samsung.com>
Date: Wed, 6 Nov 2013 17:21:19 +0530
Message-ID: <CALt3h78Lwa5+s6oAykZ5xhMvJdVT-D3Sihe2PZ2S_Zs68X2yuw@mail.gmail.com>
Subject: Re: [PATCH v11 03/12] [media] exynos5-fimc-is: Add common driver
 header files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	"kilyeon.im@samsung.com" <kilyeon.im@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Nov 6, 2013 at 4:53 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi,
>
> On 05/11/13 14:16, Arun Kumar K wrote:
>>>> +struct is_common_reg {
>>>> +     u32 hicmd;
>>>> +     u32 hic_sensorid;
>>>> +     u32 hic_param[4];
>>>> +
>>>> +     u32 reserved1[3];
> [...]
>>>> +     u32 meta_iflag;
>>>> +     u32 meta_sensor_id;
>>>> +     u32 meta_param1;
>>>> +
>>>> +     u32 reserved9[1];
>>>> +
>>>> +     u32 fcount;
>>>
>>> If these structs define an interface that's not used by the driver only it
>>> might be a good idea to use __packed to ensure no padding is added.
>>>
>>
>> The same structure is used as is in the firmware code and so it is retained
>> in the driver.
>
> I agree it makes sense to use __packed attribute to ensure no padding is
> added by the compiler. The firmware source and the driver will likely be
> compiled with different toolchains, and in both cases we should ensure
> no padding is added.
>

Yes the toolchains are different and ideally the firmware also should
use a __packed
attribute which possibly is not happening.

>>>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-metadata.h b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>>>> new file mode 100644
>>>> index 0000000..02367c4
>>>> --- /dev/null
>>>> +++ b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>>>> @@ -0,0 +1,767 @@
> [..]
>>>> +enum metadata_mode {
>>>> +     METADATA_MODE_NONE,
>>>> +     METADATA_MODE_FULL
>>>> +};
>>>> +
>>>> +struct camera2_request_ctl {
>>>> +     uint32_t                id;
>>>> +     enum metadata_mode      metadatamode;
>>>> +     uint8_t                 outputstreams[16];
>>>> +     uint32_t                framecount;
>>>> +};
>>>> +
>>>> +struct camera2_request_dm {
>>>> +     uint32_t                id;
>>>> +     enum metadata_mode      metadatamode;
>>>> +     uint32_t                framecount;
>>>> +};
> [...]
>>>> +struct camera2_lens_ctl {
>>>> +     uint32_t                                focus_distance;
>>>> +     float                                   aperture;
>>>
>>> Floating point numbers? Really? :-)
>>>
>>
>> Yes as mentioned, the same structure is used by the firmware and
>> so it is used as is in the kernel.
>
> These floating numbers are pretty painful, but I don't think they can
> be avoided unless the firmware is changed. I hope there is no need to
> touch those in the kernel.
>
> There are already precedents of using floating point numbers in driver's
> public interface, e.g. some gpu/drm drivers.
>

Ok

> I noticed there is another issue in this firmware/kernel interface, i.e.
> some data structures contain enums in them, e.g.
>
> struct camera2_lens_ctl {
>         uint32_t                                focus_distance;
>         float                                   aperture;
>         float                                   focal_length;
>         float                                   filter_density;
>         enum optical_stabilization_mode         optical_stabilization_mode;
> };
>
> It looks like a mistake in the interface design, as size of an enum is
> implementation specific.
>
> I guess size of those enum types is supposed to be 4 bytes ? Presumably
> you should, e.g. use fixed data type like uin32_t or __u32 instead of those
> enums. It looks pretty fragile as it is now.
>

Yes its better to use 4byte data structures. Will change that.

> In addition all those data structures should be declared with __packed
> attribute, to ensure a specific data structure layout and to avoid
> an unexpected padding.
>

Ok.

>>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-param.h b/drivers/media/platform/exynos5-is/fimc-is-param.h
>>> new file mode 100644
>>> index 0000000..015cc13
>>> --- /dev/null
>>> +++ b/drivers/media/platform/exynos5-is/fimc-is-param.h
>> ...
>>> +struct param_control {
>>> +    u32 cmd;
>>
>> You use uint32_t in some other headers. It's not wrong to use both C99 and
>> Linux types but I'd try to stick to either one.
>
> I tend to agree with that, it's probably better to use one convention, u32
> for kernel internal structures and __u32 for any public interfaces. I don't
> think it is e requirement but would be nice to keep it more consistent.
>

Ok

> Even if we wanted to keep the firmware defined data structures in sync with
> the Linux driver, there are already some Linux types used within the firmware
> interface. if I understood things correctly.
>
>>> +    u32 bypass;
>>> +    u32 buffer_address;
>>> +    u32 buffer_number;
>>> +    /* 0: continuous, 1: single */
>>> +    u32 run_mode;
>>> +    u32 reserved[PARAMETER_MAX_MEMBER - 6];
>>> +    u32 err;
>>> +};
>
> Can you please address those issues in follow up patches ?
> I will be sending these patches for inclusion in the media tree,
> I would prefer to avoid keeping it on the ML for more than those
> 7 months already passed.
>

Ok will address these comments in follow up patches.

Thanks & Regards
Arun
