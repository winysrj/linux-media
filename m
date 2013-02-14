Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:48656 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3BNLYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 06:24:09 -0500
Received: by mail-la0-f52.google.com with SMTP id fs12so2142490lab.39
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 03:24:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511C4529.8030800@samsung.com>
References: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
 <1360749667-12028-4-git-send-email-vikas.sajjan@linaro.org> <511C4529.8030800@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Thu, 14 Feb 2013 16:53:47 +0530
Message-ID: <CAD025yS6v0vetCiXCukFRZ5Wc6GTzijFHwwKSak0-PaZr6WktQ@mail.gmail.com>
Subject: Re: [RFC v2 3/3] video: exynos: Making s6e8ax0 panel driver compliant
 with CDF
To: Donghwa Lee <dh09.lee@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	joshi@samsung.com, aditya.ps@samsung.com, tom.gall@linaro.org,
	patches@linaro.org, linux-samsung-soc@vger.kernel.org,
	ragesh.r@linaro.org, jesse.barker@linaro.org, robdclark@gmail.com,
	sumit.semwal@linaro.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr. Lee,

thanks for the review.

On 14 February 2013 07:30, Donghwa Lee <dh09.lee@samsung.com> wrote:
> On Wed, Feb 13, 2013 at 19:01, Vikas Sajjan wrote:
>>
>> Made necessary changes in s6e8ax0 panel driver as per the  CDF-T.
>> It also removes the dependency on backlight and lcd framework
>>
>> Signed-off-by: Vikas Sajjan<vikas.sajjan@linaro.org>
>> ---
>>   drivers/video/exynos/s6e8ax0.c |  848
>> +++++++++++++++++++++-------------------
>>   1 file changed, 444 insertions(+), 404 deletions(-)
>>
>> diff --git a/drivers/video/exynos/s6e8ax0.c
>> b/drivers/video/exynos/s6e8ax0.c
>> index 7f7b25f..5a17e3c 100644
>> --- a/drivers/video/exynos/s6e8ax0.c
>> +++ b/drivers/video/exynos/s6e8ax0.c
>> @@ -25,6 +25,7 @@
>>   #include <linux/backlight.h>
>>   #include <linux/regulator/consumer.h>
>>   +#include <video/display.h>
>>   #include <video/mipi_display.h>
>>   #include <video/exynos_mipi_dsim.h>
>>   @@ -38,8 +39,7 @@
>>   #define POWER_IS_OFF(pwr)     ((pwr) == FB_BLANK_POWERDOWN)
>>   #define POWER_IS_NRM(pwr)     ((pwr) == FB_BLANK_NORMAL)
>>   -#define lcd_to_master(a)     (a->dsim_dev->master)
>> -#define lcd_to_master_ops(a)   ((lcd_to_master(a))->master_ops)
>> +#define to_panel(p) container_of(p, struct s6e8ax0, entity)
>>     enum {
>>         DSIM_NONE_STATE = 0,
>> @@ -47,20 +47,34 @@ enum {
>>         DSIM_FRAME_DONE = 2,
>>   };
>>   +/* This structure defines all the properties of a backlight */
>> +struct backlight_prop {
>> +       /* Current User requested brightness (0 - max_brightness) */
>> +       int brightness;
>> +       /* Maximal value for brightness (read-only) */
>> +       int max_brightness;
>> +};
>> +
>> +struct panel_platform_data {
>> +       unsigned int    reset_delay;
>> +       unsigned int    power_on_delay;
>> +       unsigned int    power_off_delay;
>> +       const char      *video_source_name;
>> +};
>> +
>>   struct s6e8ax0 {
>> -       struct device   *dev;
>> -       unsigned int                    power;
>> -       unsigned int                    id;
>> -       unsigned int                    gamma;
>> -       unsigned int                    acl_enable;
>> -       unsigned int                    cur_acl;
>> -
>> -       struct lcd_device       *ld;
>> -       struct backlight_device *bd;
>> -
>> -       struct mipi_dsim_lcd_device     *dsim_dev;
>> -       struct lcd_platform_data        *ddi_pd;
>> +       struct platform_device  *pdev;
>> +       struct video_source     *src;
>> +       struct display_entity   entity;
>> +       unsigned int            power;
>> +       unsigned int            id;
>> +       unsigned int            gamma;
>> +       unsigned int            acl_enable;
>> +       unsigned int            cur_acl;
>> +       bool                    panel_reverse;
>> +       struct lcd_platform_data        *plat_data;
>>         struct mutex                    lock;
>> +       struct backlight_prop           bl_prop;
>>         bool  enabled;
>>   };
>>
>
> Could this panel driver use only CDF?
> Does not consider the compatibility with backlight and lcd framework?
>
as of now CDF does not support backlight and lcd framework functionalities.
Once CDF has the support, we modify the driver to support both CDF and
non CDF way, there by maintaining the backward compatibility with
backlight and lcd framework.

>> -static const unsigned char s6e8ax0_22_gamma_30[] = {
>> +static unsigned char s6e8ax0_22_gamma_30[] = {
>>         0xfa, 0x01, 0x60, 0x10, 0x60, 0xf5, 0x00, 0xff, 0xad, 0xaf,
>>         0xbA, 0xc3, 0xd8, 0xc5, 0x9f, 0xc6, 0x9e, 0xc1, 0xdc, 0xc0,
>>         0x00, 0x61, 0x00, 0x5a, 0x00, 0x74,
>>   };
>
> In all case, you had changed data type to 'static unsigned char'.
> Is it need to change all case? Otherwise, for the unity of the code?

in the CDF-T proposed by Mr. Tomi Valkeinen, the prototype for
"dcs_write" looks as below

int (*dcs_write)(struct video_source *src, int channel, u8 *data, size_t len);

It does not have "const" for the 3rd parameter (u8 *data ), and in our
driver we have all the arrays as "const".
Just to silence the compiler warnings, i had removed the "const" keyword.
>
>
> Thank you,
> Donghwa Lee
>
>



-- 
Thanks and Regards
 Vikas Sajjan
