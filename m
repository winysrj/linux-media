Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3520 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752766AbdC0WwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 18:52:06 -0400
Subject: Re: [PATCH v6 1/3] drm_fourcc: Add new P010, P016 video format
To: Ayaka <ayaka@soulik.info>,
        Ander Conselvan De Oliveira <conselvan2@gmail.com>
References: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
 <1488708033-5691-2-git-send-email-ayaka@soulik.info>
 <20170306130609.GT31595@intel.com>
 <AEC0BE28-4C63-430B-9972-BDF0A323D742@soulik.info>
 <20170306183434.GV31595@intel.com>
 <A7CC5F68-361D-4682-8811-C835613B2059@soulik.info>
 <1489499621.2338.6.camel@gmail.com>
 <AA8A1608-4875-481D-8313-D06C944F9922@soulik.info>
Cc: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
From: Clint Taylor <clinton.a.taylor@intel.com>
Message-ID: <08d62dbf-7520-1e9e-fc48-fe983e6c7737@intel.com>
Date: Mon, 27 Mar 2017 15:49:38 -0700
MIME-Version: 1.0
In-Reply-To: <AA8A1608-4875-481D-8313-D06C944F9922@soulik.info>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2017 09:05 PM, Ayaka wrote:
>
>
> 從我的 iPad 傳送
>
>> Ander Conselvan De Oliveira <conselvan2@gmail.com> 於 2017年3月14日 下午9:53 寫道：
>>
>>> On Tue, 2017-03-07 at 04:27 +0800, Ayaka wrote:
>>>
>>> 從我的 iPad 傳送
>>>
>>>>> Ville Syrjälä <ville.syrjala@linux.intel.com> 於 2017年3月7日 上午2:34 寫道：
>>>>>
>>>>> On Tue, Mar 07, 2017 at 01:58:23AM +0800, Ayaka wrote:
>>>>>
>>>>>
>>>>> 從我的 iPad 傳送
>>>>>
>>>>>>> Ville Syrjälä <ville.syrjala@linux.intel.com> 於 2017年3月6日 下午9:06 寫道：
>>>>>>>
>>>>>>> On Sun, Mar 05, 2017 at 06:00:31PM +0800, Randy Li wrote:
>>>>>>> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
>>>>>>> per channel video format.
>>>>>>>
>>>>>>> P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits
>>>>>>> per channel video format.
>>>>>>>
>>>>>>> V3: Added P012 and fixed cpp for P010
>>>>>>> V4: format definition refined per review
>>>>>>> V5: Format comment block for each new pixel format
>>>>>>> V6: reversed Cb/Cr order in comments
>>>>>>> v7: reversed Cb/Cr order in comments of header files, remove
>>>>>>> the wrong part of commit message.
>>>>>>
>>>>>> What? Why? You just undid what Clint did in v6.
>>>>>
>>>>> He missed a file also keeping the wrong description of rockchip.
>>>>
>>>> I don't follow. Who missed what exactly?
>>>
>>> What he sent is v5, I increase the order number twice in the message, it confuse me as well.
>>> I think Clint forgot the include/uapi/drm/drm_fourcc.h .
>>
>> Clint did send a v6, and that updates "include/uapi/drm/drm_fourcc.h":
>>
>> https://patchwork.freedesktop.org/patch/141342/
> Oh, yes but he still used Cr:Cb, but I think it should be Cb:Cr
> since I think the V is after the U.

 From the MSDN fourcc website:
"If the combined U-V array is addressed as an array of DWORDs, the least 
significant word (LSW) contains the U value and the most significant 
word (MSW) contains the V value. The stride of the combined U-V plane is 
equal to the stride of the Y plane. The U-V plane has half as many lines 
as the Y plane."

The LSW contains U and the MSW contains V, hence the Cr:Cb in the 
comments of the V6 patch.

-Clint

>>
>>
>> Ander
>>
>>>>
>>>>
>>>>>>
>>>>>>>
>>>>>>> Cc: Daniel Stone <daniel@fooishbar.org>
>>>>>>> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
>>>>>>>
>>>>>>> Signed-off-by: Randy Li <ayaka@soulik.info>
>>>>>>> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
>>>>>>> ---
>>>>>>> drivers/gpu/drm/drm_fourcc.c  |  3 +++
>>>>>>> include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
>>>>>>> 2 files changed, 24 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
>>>>>>> index 90d2cc8..3e0fd58 100644
>>>>>>> --- a/drivers/gpu/drm/drm_fourcc.c
>>>>>>> +++ b/drivers/gpu/drm/drm_fourcc.c
>>>>>>> @@ -165,6 +165,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
>>>>>>>      { .format = DRM_FORMAT_UYVY,        .depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>>>>>>      { .format = DRM_FORMAT_VYUY,        .depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>>>>>>      { .format = DRM_FORMAT_AYUV,        .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>>>>>>> +        { .format = DRM_FORMAT_P010,        .depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
>>>>>>> +        { .format = DRM_FORMAT_P012,        .depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
>>>>>>> +        { .format = DRM_FORMAT_P016,        .depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
>>>>>>>  };
>>>>>>>
>>>>>>>  unsigned int i;
>>>>>>> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
>>>>>>> index ef20abb..306f979 100644
>>>>>>> --- a/include/uapi/drm/drm_fourcc.h
>>>>>>> +++ b/include/uapi/drm/drm_fourcc.h
>>>>>>> @@ -128,6 +128,27 @@ extern "C" {
>>>>>>> #define DRM_FORMAT_NV42        fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
>>>>>>>
>>>>>>> /*
>>>>>>> + * 2 plane YCbCr MSB aligned
>>>>>>> + * index 0 = Y plane, [15:0] Y:x [10:6] little endian
>>>>>>> + * index 1 = Cb:Cr plane, [31:0] Cb:x:Cr:x [10:6:10:6] little endian
>>>>>>> + */
>>>>>>> +#define DRM_FORMAT_P010        fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cb:Cr plane 10 bits per channel */
>>>>>>> +
>>>>>>> +/*
>>>>>>> + * 2 plane YCbCr MSB aligned
>>>>>>> + * index 0 = Y plane, [15:0] Y:x [12:4] little endian
>>>>>>> + * index 1 = Cb:Cr plane, [31:0] Cb:x:Cr:x [12:4:12:4] little endian
>>>>>>> + */
>>>>>>> +#define DRM_FORMAT_P012        fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cb:Cr plane 12 bits per channel */
>>>>>>> +
>>>>>>> +/*
>>>>>>> + * 2 plane YCbCr MSB aligned
>>>>>>> + * index 0 = Y plane, [15:0] Y little endian
>>>>>>> + * index 1 = Cb:Cr plane, [31:0] Cb:Cr [16:16] little endian
>>>>>>> + */
>>>>>>> +#define DRM_FORMAT_P016        fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cb:Cr plane 16 bits per channel */
>>>>>>> +
>>>>>>> +/*
>>>>>>> * 3 plane YCbCr
>>>>>>> * index 0: Y plane, [7:0] Y
>>>>>>> * index 1: Cb plane, [7:0] Cb
>>>>>>> --
>>>>>>> 2.7.4
>>>>>>
>>>>>> --
>>>>>> Ville Syrjälä
>>>>>> Intel OTC
>>>>
>>>> --
>>>> Ville Syrjälä
>>>> Intel OTC
>>>
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
