Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48862 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757602Ab3CFOQl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 09:16:41 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 06:10:35 -0800
Subject: RE: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree
 support for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA88@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-3-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051047120.25837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303051047120.25837@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 05 March, 2013 17:51
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree support for
>marvell-ccic driver
>
>Hi Albert
>
>On Thu, 7 Feb 2013, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the clock tree support for marvell-ccic.
>>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Acked-by: Jonathan Corbet <corbet@lwn.net>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.h  |    4 ++
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |   47 ++++++++++++++++++++++
>>  2 files changed, 51 insertions(+)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index f73a801..2b2dc06 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -82,6 +82,8 @@ struct mcam_frame_state {
>>  	unsigned int delivered;
>>  };
>>
>> +#define NR_MCAM_CLK 3
>> +
>>  /*
>>   * A description of one of our devices.
>>   * Locking: controlled by s_mutex.  Certain fields, however, require
>> @@ -109,6 +111,8 @@ struct mcam_camera {
>>  	int lane;			/* lane number */
>>
>>  	struct clk *pll1;
>> +	/* clock tree support */
>> +	struct clk *clk[NR_MCAM_CLK];
>>
>>  	/*
>>  	 * Callbacks from the core to the platform code.
>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 7ab01e9..2fe0324 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> @@ -35,6 +35,8 @@ MODULE_ALIAS("platform:mmp-camera");
>>  MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
>>  MODULE_LICENSE("GPL");
>>
>> +static char *mcam_clks[] = {"CCICAXICLK", "CCICFUNCLK", "CCICPHYCLK"};
>> +
>
>It's good, you are using fixed clock names now!
>
>>  struct mmp_camera {
>>  	void *power_regs;
>>  	struct platform_device *pdev;
>> @@ -104,6 +106,26 @@ static struct mmp_camera *mmpcam_find_device(struct
>platform_device *pdev)
>>  #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
>>  #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
>>
>> +static void mcam_clk_enable(struct mcam_camera *mcam)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < NR_MCAM_CLK; i++) {
>> +		if (mcam->clk[i])
>> +			clk_enable(mcam->clk[i]);
>
>I think it's generally considered a better option to use
>clk_prepare_enable() and clk_disable_unprepare() instead of just
>clk_enable() and clk_disable().
>
Sounds great, we will think about it.

>> +	}
>> +}
>> +
>> +static void mcam_clk_disable(struct mcam_camera *mcam)
>> +{
>> +	int i;
>> +
>> +	for (i = NR_MCAM_CLK - 1; i >= 0; i--) {
>> +		if (mcam->clk[i])
>> +			clk_disable(mcam->clk[i]);
>> +	}
>> +}
>> +
>>  /*
>>   * Power control.
>>   */
>> @@ -134,6 +156,8 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
>>  	mdelay(5);
>>  	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
>>  	mdelay(5);
>> +
>> +	mcam_clk_enable(mcam);
>>  }
>>
>>  static void mmpcam_power_down(struct mcam_camera *mcam)
>> @@ -151,6 +175,8 @@ static void mmpcam_power_down(struct mcam_camera
>*mcam)
>>  	pdata = cam->pdev->dev.platform_data;
>>  	gpio_set_value(pdata->sensor_power_gpio, 0);
>>  	gpio_set_value(pdata->sensor_reset_gpio, 0);
>> +
>> +	mcam_clk_disable(mcam);
>>  }
>>
>>  /*
>> @@ -263,6 +289,23 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
>>  	return IRQ_RETVAL(handled);
>>  }
>>
>> +static int mcam_init_clk(struct mcam_camera *mcam,
>> +			struct mmp_camera_platform_data *pdata)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < NR_MCAM_CLK; i++) {
>> +		if (mcam_clks[i] != NULL) {
>> +			mcam->clk[i] = devm_clk_get(mcam->dev, mcam_clks[i]);
>> +			if (IS_ERR(mcam->clk[i])) {
>> +				dev_err(mcam->dev, "Could not get clk: %s\n",
>> +						mcam_clks[i]);
>> +				return PTR_ERR(mcam->clk[i]);
>> +			}
>> +		}
>> +	}
>> +	return 0;
>> +}
>>
>>  static int mmpcam_probe(struct platform_device *pdev)
>>  {
>> @@ -331,6 +374,10 @@ static int mmpcam_probe(struct platform_device *pdev)
>>  		ret = -ENODEV;
>>  		goto out_unmap1;
>>  	}
>> +
>> +	ret = mcam_init_clk(mcam, pdata);
>> +	if (ret)
>> +		goto out_unmap2;
>
>Now, I'm confused again: doesn't this mean, that all existing users of
>this driver will fail?
>
Sorry, I don't understand what's your concern?

>>  	/*
>>  	 * Find the i2c adapter.  This assumes, of course, that the
>>  	 * i2c bus is already up and functioning.
>> --
>> 1.7.9.5
>>
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
