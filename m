Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:49771 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab2LPWT4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:19:56 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 14:19:54 -0800
Subject: RE: [PATCH V3 12/15] [media] marvell-ccic: add soc_camera support
 in mmp driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE5@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-13-git-send-email-twang13@marvell.com>
 <20121216094613.79718cc8@hpe.lwn.net>
In-Reply-To: <20121216094613.79718cc8@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan



>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:46
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 12/15] [media] marvell-ccic: add soc_camera support in mmp
>driver
>
>On Sat, 15 Dec 2012 17:58:01 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> This patch adds the soc_camera support in the platform driver: mmp-driver.c.
>> Specified board driver also should be modified to support soc_camera by passing
>> some platform datas to platform driver.
>>
>> Currently the soc_camera mode in mmp driver only supports B_DMA_contig mode.
>
>You do intend to add the other modes (or SG, at least) in the future?
>
[Albert Wang] Yes, if need we can add the other modes in the future.

>> --- a/drivers/media/platform/marvell-ccic/Kconfig
>> +++ b/drivers/media/platform/marvell-ccic/Kconfig
>> @@ -1,23 +1,45 @@
>> +config VIDEO_MARVELL_CCIC
>> +       tristate
>> +config VIDEO_MRVL_SOC_CAMERA
>> +       bool
>
>If Linus sees this you'll get an unpleasant reminder that vowels are not
>actually in short supply; I'd suggest spelling out "MARVELL".
>
[Albert Wang] Sorry, we will change it.

>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 40c243e..cd850f4 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> @@ -28,6 +28,10 @@
>>  #include <linux/list.h>
>>  #include <linux/pm.h>
>>  #include <linux/clk.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>>
>>  #include "mcam-core.h"
>>
>> @@ -40,6 +44,8 @@ struct mmp_camera {
>>  	struct platform_device *pdev;
>>  	struct mcam_camera mcam;
>>  	struct list_head devlist;
>> +	/* will change here */
>> +	struct clk *clk[3];	/* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
>
>What does that comment mean?
>
[Albert Wang] It means there are 3 clk setting, gate_clk, rst_clk, dbg_clk.
Forgive me, the name of CCIC_DBG register is not good, but it's our actual register name. :(

>>  	int irq;
>>  };
>>
>> @@ -144,15 +150,17 @@ static void mmpcam_power_up(struct mcam_camera
>*mcam)
>>   * Provide power to the sensor.
>>   */
>>  	mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
>> -	pdata = cam->pdev->dev.platform_data;
>> -	gpio_set_value(pdata->sensor_power_gpio, 1);
>> -	mdelay(5);
>> +	if (mcam->chip_id == V4L2_IDENT_ARMADA610) {
>
>I'm seeing a lot of these tests being added to the code.  I can imagine
>more in the future as new chipsets are supported in the driver.  Maybe it's
>time to add a structure to hide chipset-specific low-level operations?  It
>would make the code a lot cleaner.
>
[Albert Wang] OK, we will do it.

>Actually, things like mmpcam_power_up() were meant to be exactly that.  Can
>we just define a different version of this function for different chipsets?
>
[Albert Wang] Sure.

>> +		pdata = cam->pdev->dev.platform_data;
>> +		gpio_set_value(pdata->sensor_power_gpio, 1);
>> +		mdelay(5);
>> +		/* reset is active low */
>> +		gpio_set_value(pdata->sensor_reset_gpio, 0);
>> +		mdelay(5);
>> +		gpio_set_value(pdata->sensor_reset_gpio, 1);
>> +		mdelay(5);
>> +	}
>>  	mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
>> -	gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
>> -	mdelay(5);
>> -	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
>> -	mdelay(5);
>> -
>>  	mcam_clk_set(mcam, 1);
>>  }
>>
>> @@ -165,13 +173,14 @@ static void mmpcam_power_down(struct mcam_camera
>*mcam)
>>   */
>>  	iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
>>  	iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
>> -/*
>> - * Shut down the sensor.
>> - */
>> -	pdata = cam->pdev->dev.platform_data;
>> -	gpio_set_value(pdata->sensor_power_gpio, 0);
>> -	gpio_set_value(pdata->sensor_reset_gpio, 0);
>> -
>> +	if (mcam->chip_id == V4L2_IDENT_ARMADA610) {
>
>Same comment applies here.
>
>> +		/*
>> +		 * Shut down the sensor.
>> +		 */
>> +		pdata = cam->pdev->dev.platform_data;
>> +		gpio_set_value(pdata->sensor_power_gpio, 0);
>> +		gpio_set_value(pdata->sensor_reset_gpio, 0);
>> +	}
>>  	mcam_clk_set(mcam, 0);
>
>jon


Thanks
Albert Wang
86-21-61092656
