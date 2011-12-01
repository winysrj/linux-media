Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57678 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616Ab1LARaj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 12:30:39 -0500
MIME-Version: 1.0
In-Reply-To: <201112011824.49591.laurent.pinchart@ideasonboard.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-6-git-send-email-saaguirre@ti.com> <201112011824.49591.laurent.pinchart@ideasonboard.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 1 Dec 2011 11:30:14 -0600
Message-ID: <CAKnK67TR5KJ8U4AeDuF7AzxDwOPF7X1ak7mn0tBhrROwu8H6_g@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] OMAP4: Add base addresses for ISS
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Thu, Dec 1, 2011 at 11:24 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Sergio,
>
> On Thursday 01 December 2011 01:14:54 Sergio Aguirre wrote:
>> NOTE: This isn't the whole list of features that the
>> ISS supports, but the only ones supported at the moment.
>>
>> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>> ---
>>  arch/arm/mach-omap2/devices.c              |   32
>> ++++++++++++++++++++++++++++ arch/arm/plat-omap/include/plat/omap44xx.h |
>>   9 +++++++
>>  2 files changed, 41 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
>> index c15cfad..b48aeea 100644
>> --- a/arch/arm/mach-omap2/devices.c
>> +++ b/arch/arm/mach-omap2/devices.c
>> @@ -32,6 +32,7 @@
>>  #include <plat/omap_hwmod.h>
>>  #include <plat/omap_device.h>
>>  #include <plat/omap4-keypad.h>
>> +#include <plat/omap4-iss.h>
>
> I try to keep headers sorted alphabetically when possible, but that might just
> be me.

No problem. I can change it.

>
>>
>>  #include "mux.h"
>>  #include "control.h"
>> @@ -217,6 +218,37 @@ int omap3_init_camera(struct isp_platform_data *pdata)
>>       return platform_device_register(&omap3isp_device);
>>  }
>>
>> +int omap4_init_camera(struct iss_platform_data *pdata, struct
>> omap_board_data *bdata)
>> +{
>> +     struct platform_device *pdev;
>> +     struct omap_hwmod *oh;
>> +     struct iss_platform_data *omap4iss_pdata;
>> +     char *oh_name = "iss";
>> +     char *name = "omap4iss";
>
> Would const char or static const char help the compiler putting the strings to
> a read-only section ?

Right. Will fix.

>
>> +     unsigned int id = -1;
>> +
>> +     oh = omap_hwmod_lookup(oh_name);
>> +     if (!oh) {
>> +             pr_err("Could not look up %s\n", oh_name);
>> +             return -ENODEV;
>> +     }
>> +
>> +     omap4iss_pdata = pdata;
>> +
>> +     pdev = omap_device_build(name, id, oh, omap4iss_pdata,
>> +                     sizeof(struct iss_platform_data), NULL, 0, 0);
>
> This is the only location where id is used, maybe you could pass -1 directly
> to the function ?

Ditto.

Thanks and regards,
Sergio

>
>> +
>> +     if (IS_ERR(pdev)) {
>> +             WARN(1, "Can't build omap_device for %s:%s.\n",
>> +                                             name, oh->name);
>> +             return PTR_ERR(pdev);
>> +     }
>> +
>> +     oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
>> +
>> +     return 0;
>> +}
>> +
>>  static inline void omap_init_camera(void)
>>  {
>>  #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
>> diff --git a/arch/arm/plat-omap/include/plat/omap44xx.h
>> b/arch/arm/plat-omap/include/plat/omap44xx.h index ea2b8a6..31432aa 100644
>> --- a/arch/arm/plat-omap/include/plat/omap44xx.h
>> +++ b/arch/arm/plat-omap/include/plat/omap44xx.h
>> @@ -49,6 +49,15 @@
>>  #define OMAP44XX_MAILBOX_BASE                (L4_44XX_BASE + 0xF4000)
>>  #define OMAP44XX_HSUSB_OTG_BASE              (L4_44XX_BASE + 0xAB000)
>>
>> +#define OMAP44XX_ISS_BASE                    0x52000000
>> +#define OMAP44XX_ISS_TOP_BASE                        (OMAP44XX_ISS_BASE + 0x0)
>> +#define OMAP44XX_ISS_CSI2_A_REGS1_BASE               (OMAP44XX_ISS_BASE + 0x1000)
>> +#define OMAP44XX_ISS_CAMERARX_CORE1_BASE     (OMAP44XX_ISS_BASE + 0x1170)
>> +
>> +#define OMAP44XX_ISS_TOP_END                 (OMAP44XX_ISS_TOP_BASE + 256 - 1)
>> +#define OMAP44XX_ISS_CSI2_A_REGS1_END                (OMAP44XX_ISS_CSI2_A_REGS1_BASE +
>> 368 - 1) +#define
>> OMAP44XX_ISS_CAMERARX_CORE1_END               (OMAP44XX_ISS_CAMERARX_CORE1_BASE + 32 -
>> 1) +
>>  #define OMAP4_MMU1_BASE                      0x55082000
>>  #define OMAP4_MMU2_BASE                      0x4A066000
>
> --
> Regards,
>
> Laurent Pinchart
