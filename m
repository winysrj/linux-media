Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8677 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdITRBT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 13:01:19 -0400
Subject: Re: [PATCH] [media] staging: atomisp: use clock framework for camera
 clocks
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?Q?J=c3=a9r=c3=a9my_Lefaure?= <jeremy.lefaure@lse.epita.fr>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20170919204549.27468-1-pierre-louis.bossart@linux.intel.com>
 <1505898738.16112.3.camel@linux.intel.com>
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <a547a897-37e9-1509-889e-d83ff055b3e4@linux.intel.com>
Date: Wed, 20 Sep 2017 12:01:14 -0500
MIME-Version: 1.0
In-Reply-To: <1505898738.16112.3.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/20/2017 04:12 AM, Andy Shevchenko wrote:
> On Tue, 2017-09-19 at 15:45 -0500, Pierre-Louis Bossart wrote:
>> The Atom ISP driver initializes and configures PMC clocks which are
>> already handled by the clock framework.
>>
>> Remove all legacy vlv2_platform_clock stuff and move to the clk API to
>> avoid conflicts, e.g. with audio machine drivers enabling the MCLK for
>> external codecs
>>
> I think it might have a Fixes: tag as well (though I dunno which commit
> could be considered as anchor).
The initial integration of the atomisp driver already had this problem, 
i'll add a reference to
'a49d25364dfb9 ("staging/atomisp: Add support for the Intel IPU v2")'
>
> (I doubt Git is so clever to remove files based on information out of
> the diff, can you check it and if needed to resend without -D implied?)
Gee, I thought -C -M -D were the standard options to checkpatch, never 
realized it'd prevent patches from applying. Thanks for the tip.

>
> Other than that - nice clean up!
>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
I'll add your Reviewed-by in the v2. Thanks for the review.
>
>
>> Tested-by: Carlo Caione <carlo@endlessm.com>
>> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.
>> com>
>> ---
>>   drivers/staging/media/atomisp/Kconfig              |   1 +
>>   drivers/staging/media/atomisp/platform/Makefile    |   1 -
>>   .../staging/media/atomisp/platform/clock/Makefile  |   6 -
>>   .../platform/clock/platform_vlv2_plat_clk.c        |  40 ----
>>   .../platform/clock/platform_vlv2_plat_clk.h        |  27 ---
>>   .../media/atomisp/platform/clock/vlv2_plat_clock.c | 247 ------------
>> ---------
>>   .../platform/intel-mid/atomisp_gmin_platform.c     |  63 +++++-
>>   7 files changed, 52 insertions(+), 333 deletions(-)
>>   delete mode 100644
>> drivers/staging/media/atomisp/platform/clock/Makefile
>>   delete mode 100644
>> drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c
>>   delete mode 100644
>> drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
>>   delete mode 100644
>> drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
>>
>> diff --git a/drivers/staging/media/atomisp/Kconfig
>> b/drivers/staging/media/atomisp/Kconfig
>> index 8eb13c3ba29c..7cdebea35ccf 100644
>> --- a/drivers/staging/media/atomisp/Kconfig
>> +++ b/drivers/staging/media/atomisp/Kconfig
>> @@ -1,6 +1,7 @@
>>   menuconfig INTEL_ATOMISP
>>           bool "Enable support to Intel MIPI camera drivers"
>>           depends on X86 && EFI && MEDIA_CONTROLLER && PCI && ACPI
>> +	select COMMON_CLK
>>           help
>>             Enable support for the Intel ISP2 camera interfaces and
>> MIPI
>>             sensor drivers.
>> diff --git a/drivers/staging/media/atomisp/platform/Makefile
>> b/drivers/staging/media/atomisp/platform/Makefile
>> index df157630bda9..0e3b7e1c81c6 100644
>> --- a/drivers/staging/media/atomisp/platform/Makefile
>> +++ b/drivers/staging/media/atomisp/platform/Makefile
>> @@ -2,5 +2,4 @@
>>   # Makefile for camera drivers.
>>   #
>>   
>> -obj-$(CONFIG_INTEL_ATOMISP) += clock/
>>   obj-$(CONFIG_INTEL_ATOMISP) += intel-mid/
>> diff --git a/drivers/staging/media/atomisp/platform/clock/Makefile
>> b/drivers/staging/media/atomisp/platform/clock/Makefile
>> deleted file mode 100644
>> index 82fbe8b6968a..000000000000
>> diff --git
>> a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.
>> c
>> b/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.
>> c
>> deleted file mode 100644
>> index 0aae9b0283bb..000000000000
>> diff --git
>> a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.
>> h
>> b/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.
>> h
>> deleted file mode 100644
>> index b730ab0e8223..000000000000
>> diff --git
>> a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
>> b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
>> deleted file mode 100644
>> index f96789a31819..000000000000
>> diff --git a/drivers/staging/media/atomisp/platform/intel-
>> mid/atomisp_gmin_platform.c
>> b/drivers/staging/media/atomisp/platform/intel-
>> mid/atomisp_gmin_platform.c
>> index edaae93af8f9..17b4cfae5abf 100644
>> --- a/drivers/staging/media/atomisp/platform/intel-
>> mid/atomisp_gmin_platform.c
>> +++ b/drivers/staging/media/atomisp/platform/intel-
>> mid/atomisp_gmin_platform.c
>> @@ -4,10 +4,10 @@
>>   #include <linux/efi.h>
>>   #include <linux/pci.h>
>>   #include <linux/acpi.h>
>> +#include <linux/clk.h>
>>   #include <linux/delay.h>
>>   #include <media/v4l2-subdev.h>
>>   #include <linux/mfd/intel_soc_pmic.h>
>> -#include "../../include/linux/vlv2_plat_clock.h"
>>   #include <linux/regulator/consumer.h>
>>   #include <linux/gpio/consumer.h>
>>   #include <linux/gpio.h>
>> @@ -17,11 +17,7 @@
>>   
>>   #define MAX_SUBDEVS 8
>>   
>> -/* Should be defined in vlv2_plat_clock API, isn't: */
>> -#define VLV2_CLK_PLL_19P2MHZ 1
>> -#define VLV2_CLK_XTAL_19P2MHZ 0
>> -#define VLV2_CLK_ON      1
>> -#define VLV2_CLK_OFF     2
>> +#define VLV2_CLK_PLL_19P2MHZ 1 /* XTAL on CHT */
>>   #define ELDO1_SEL_REG	0x19
>>   #define ELDO1_1P8V	0x16
>>   #define ELDO1_CTRL_SHIFT 0x00
>> @@ -33,6 +29,7 @@ struct gmin_subdev {
>>   	struct v4l2_subdev *subdev;
>>   	int clock_num;
>>   	int clock_src;
>> +	struct clk *pmc_clk;
>>   	struct gpio_desc *gpio0;
>>   	struct gpio_desc *gpio1;
>>   	struct regulator *v1p8_reg;
>> @@ -344,6 +341,9 @@ static int gmin_platform_deinit(void)
>>   	return 0;
>>   }
>>   
>> +#define GMIN_PMC_CLK_NAME 14 /* "pmc_plt_clk_[0..5]" */
>> +static char gmin_pmc_clk_name[GMIN_PMC_CLK_NAME];
>> +
>>   static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev
>> *subdev)
>>   {
>>   	int i, ret;
>> @@ -377,6 +377,37 @@ static struct gmin_subdev *gmin_subdev_add(struct
>> v4l2_subdev *subdev)
>>   	gmin_subdevs[i].gpio0 = gpiod_get_index(dev, NULL, 0,
>> GPIOD_OUT_LOW);
>>   	gmin_subdevs[i].gpio1 = gpiod_get_index(dev, NULL, 1,
>> GPIOD_OUT_LOW);
>>   
>> +	/* get PMC clock with clock framework */
>> +	snprintf(gmin_pmc_clk_name,
>> +		 sizeof(gmin_pmc_clk_name),
>> +		 "%s_%d", "pmc_plt_clk", gmin_subdevs[i].clock_num);
>> +
>> +	gmin_subdevs[i].pmc_clk = devm_clk_get(dev,
>> gmin_pmc_clk_name);
>> +	if (IS_ERR(gmin_subdevs[i].pmc_clk)) {
>> +		ret = PTR_ERR(gmin_subdevs[i].pmc_clk);
>> +
>> +		dev_err(dev,
>> +			"Failed to get clk from %s : %d\n",
>> +			gmin_pmc_clk_name,
>> +			ret);
>> +
>> +		return NULL;
>> +	}
>> +
>> +	/*
>> +	 * The firmware might enable the clock at
>> +	 * boot (this information may or may not
>> +	 * be reflected in the enable clock register).
>> +	 * To change the rate we must disable the clock
>> +	 * first to cover these cases. Due to common
>> +	 * clock framework restrictions that do not allow
>> +	 * to disable a clock that has not been enabled,
>> +	 * we need to enable the clock first.
>> +	 */
>> +	ret = clk_prepare_enable(gmin_subdevs[i].pmc_clk);
>> +	if (!ret)
>> +		clk_disable_unprepare(gmin_subdevs[i].pmc_clk);
>> +
>>   	if (!IS_ERR(gmin_subdevs[i].gpio0)) {
>>   		ret = gpiod_direction_output(gmin_subdevs[i].gpio0,
>> 0);
>>   		if (ret)
>> @@ -539,13 +570,21 @@ static int gmin_flisclk_ctrl(struct v4l2_subdev
>> *subdev, int on)
>>   {
>>   	int ret = 0;
>>   	struct gmin_subdev *gs = find_gmin_subdev(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +
>> +	if (on) {
>> +		ret = clk_set_rate(gs->pmc_clk, gs->clock_src);
>> +
>> +		if (ret)
>> +			dev_err(&client->dev, "unable to set PMC rate
>> %d\n",
>> +				gs->clock_src);
>>   
>> -	if (on)
>> -		ret = vlv2_plat_set_clock_freq(gs->clock_num, gs-
>>> clock_src);
>> -	if (ret)
>> -		return ret;
>> -	return vlv2_plat_configure_clock(gs->clock_num,
>> -					 on ? VLV2_CLK_ON :
>> VLV2_CLK_OFF);
>> +		ret = clk_prepare_enable(gs->pmc_clk);
>> +	} else {
>> +		clk_disable_unprepare(gs->pmc_clk);
>> +	}
>> +
>> +	return ret;
>>   }
>>   
>>   static int gmin_csi_cfg(struct v4l2_subdev *sd, int flag)
