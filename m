Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:51578 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3HFErK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 00:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <51FD7982.5080101@gmail.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
	<1375455762-22071-5-git-send-email-arun.kk@samsung.com>
	<51FD7982.5080101@gmail.com>
Date: Tue, 6 Aug 2013 10:17:09 +0530
Message-ID: <CALt3h7-N+79tfNb0o8bcEZRuNDLS9-wbynHFo+aErr0k_Lb6Vg@mail.gmail.com>
Subject: Re: [RFC v3 04/13] [media] exynos5-fimc-is: Add common driver header files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Aug 4, 2013 at 3:13 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>>
>> This patch adds all the common header files used by the fimc-is
>> driver. It includes the commands for interfacing with the firmware
>> and error codes from IS firmware, metadata and command parameter
>> definitions.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
>> ---
>>   drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 +++
>>   drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++++
>>   .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++++++
>>   drivers/media/platform/exynos5-is/fimc-is-param.h  | 1212
>> ++++++++++++++++++++
>>   4 files changed, 2423 insertions(+)
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
>>

[snip]

>> +
>> +struct camera2_tonemap_dm {
>> +       enum tonemap_mode               mode;
>> +       /* assuming maxCurvePoints = 64 */
>> +       float                           curve_red[64];
>> +       float                           curve_green[64];
>> +       float                           curve_blue[64];
>
>
> So all those floating point numbers are now not really used in
> the driver but we need them for proper data structures/offsets
> declarations of the firmware interface ?
>

Yes. Same floats are used in firmware internal data structures
also and the driver should assign these values when these parameters
are to be changed.

>> +};
>> +

[snip]

>> +/* --------------------------  Effect
>> ----------------------------------- */
>> +enum isp_imageeffect_command {
>> +       ISP_IMAGE_EFFECT_DISABLE                = 0,
>> +       ISP_IMAGE_EFFECT_MONOCHROME             = 1,
>> +       ISP_IMAGE_EFFECT_NEGATIVE_MONO          = 2,
>> +       ISP_IMAGE_EFFECT_NEGATIVE_COLOR         = 3,
>> +       ISP_IMAGE_EFFECT_SEPIA                  = 4,
>> +       ISP_IMAGE_EFFECT_AQUA                   = 5,
>> +       ISP_IMAGE_EFFECT_EMBOSS                 = 6,
>> +       ISP_IMAGE_EFFECT_EMBOSS_MONO            = 7,
>> +       ISP_IMAGE_EFFECT_SKETCH                 = 8,
>> +       ISP_IMAGE_EFFECT_RED_YELLOW_POINT       = 9,
>> +       ISP_IMAGE_EFFECT_GREEN_POINT            = 10,
>> +       ISP_IMAGE_EFFECT_BLUE_POINT             = 11,
>> +       ISP_IMAGE_EFFECT_MAGENTA_POINT          = 12,
>> +       ISP_IMAGE_EFFECT_WARM_VINTAGE           = 13,
>> +       ISP_IMAGE_EFFECT_COLD_VINTAGE           = 14,
>> +       ISP_IMAGE_EFFECT_POSTERIZE              = 15,
>> +       ISP_IMAGE_EFFECT_SOLARIZE               = 16,
>> +       ISP_IMAGE_EFFECT_WASHED                 = 17,
>> +       ISP_IMAGE_EFFECT_CCM                    = 18,
>> +};
>
>
> Hmm, I guess we will need a private v4l2 control for those.
>

Yes. I am planning to add the controls after the basic support
gets merged.

Regards
Arun
