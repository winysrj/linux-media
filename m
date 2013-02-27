Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:62873 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3B0PWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 10:22:44 -0500
Message-ID: <512E24BC.3070806@gmail.com>
Date: Wed, 27 Feb 2013 23:22:36 +0800
From: Lonsn <lonsn2005@gmail.com>
MIME-Version: 1.0
To: Inderpal Singh <inderpal.singh@linaro.org>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Boojin Kim <boojin.kim@samsung.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
References: <51275DF7.4010600@gmail.com> <512D2780.3020103@gmail.com> <CAG17yqQ3d+3Uwpfo+_r0Jwm4TQXcSY-bcW4qRcygzjq=9qXvvA@mail.gmail.com>
In-Reply-To: <CAG17yqQ3d+3Uwpfo+_r0Jwm4TQXcSY-bcW4qRcygzjq=9qXvvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013/2/27 18:51, Inderpal Singh 写道:
> On 27 February 2013 02:52, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>> On 02/22/2013 01:00 PM, Lonsn wrote:
>>>
>>> Hi,
>>> I have tested the kernel 3.8 with a SMDKV210 like board. But I failed
>>> with dma-pl330 and HDMI driver.
>>> For dma-pl330, kernel print:
>>> dma-pl330 dma-pl330.0: PERIPH_ID 0x0, PCELL_ID 0x0 !
>>> dma-pl330: probe of dma-pl330.0 failed with error -22
>>> dma-pl330 dma-pl330.1: PERIPH_ID 0x0, PCELL_ID 0x0 !
>>> dma-pl330: probe of dma-pl330.1 failed with error -22
>>
>>
>> Maybe there is some issue with the PL330 DMA controller clocks and the
>> read values are all 0 because the clocks are disabled ?
>>
>> It seems arch/arm/mach-s5pv210/clock.c might be missing "apb_pclk" clock
>> supply names, which I suspect may be required after commits:
>>
>> commit 7c71b8eb268ee38235f7e924d943ea9d90e59469
>> Author: Inderpal Singh <inderpal.singh@linaro.org>
>> Date:   Fri Sep 7 12:14:48 2012 +0530
>>
>>      DMA: PL330: Remove redundant runtime_suspend/resume functions
>>
>>      The driver's  runtime_suspend/resume functions just disable/enable
>>      the clock which is already being managed at AMBA bus level
>>      runtime_suspend/resume functions.
>>
>>      Hence, remove the driver's runtime_suspend/resume functions.
>>
>>      Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>>      Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
>>      Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
>>
>> commit faf6fbc6f2ca3b34bf464a8bb079a998e571957c
>> Author: Inderpal Singh <inderpal.singh@linaro.org>
>> Date:   Fri Sep 7 12:14:47 2012 +0530
>>
>>      DMA: PL330: Remove controller clock enable/disable
>>
>>      The controller clock is being enabled/disabled in AMBA bus
>>      infrastructre in probe/remove functions. Hence, its not required
>>      at driver level probe/remove.
>>
>>      Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>>      Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
>>      Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
>>
>> I have added people who made related changes at Cc, hopefully they
>> can provide some help in debugging this.
>>
>
> The mentioned patches just removed the redundant clock enable/disable
> from the driver as clock is already being managed at amba bus level in
> the same code path. As per my understanding the issue should come even
> without these patches.
>
> @Lonsn: Can you please test without these patches?

Inder, I have made the DMA clock change according to Sylwester's 
suggetstions and it works!
Now kernel prints:
------------------------------------>
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
s3c-fb s5pv210-fb: window 0: fb
dma-pl330 dma-pl330.0: Loaded driver for PL330 DMAC-267056
dma-pl330 dma-pl330.0:  DBUFF-8x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
dma-pl330 dma-pl330.1: Loaded driver for PL330 DMAC-267056
dma-pl330 dma-pl330.1:  DBUFF-8x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
s5pv210-uart.0: ttySAC0 at MMIO 0xe2900000 (irq = 74) is a S3C6400/10
------------------------------------------>
>
> Thanks,
> Inder
>
>> Please try the following change:
>>
>> 8<--------------------
>> diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
>> index fcdf52d..87c7d3f 100644
>> --- a/arch/arm/mach-s5pv210/clock.c
>> +++ b/arch/arm/mach-s5pv210/clock.c
>> @@ -214,11 +214,6 @@ static struct clk clk_pcmcdclk2 = {
>>          .name           = "pcmcdclk",
>>   };
>>
>> -static struct clk dummy_apb_pclk = {
>> -       .name           = "apb_pclk",
>> -       .id             = -1,
>> -};
>> -
>>   static struct clk *clkset_vpllsrc_list[] = {
>>          [0] = &clk_fin_vpll,
>>          [1] = &clk_sclk_hdmi27m,
>> @@ -1333,6 +1328,8 @@ static struct clk_lookup s5pv210_clk_lookup[] = {
>>          CLKDEV_INIT(NULL, "spi_busclk0", &clk_p),
>>          CLKDEV_INIT("s5pv210-spi.0", "spi_busclk1", &clk_sclk_spi0.clk),
>>          CLKDEV_INIT("s5pv210-spi.1", "spi_busclk1", &clk_sclk_spi1.clk),
>> +       CLKDEV_INIT("dma-pl330.0", "apb_pclk", &init_clocks_off[0]),
>> +       CLKDEV_INIT("dma-pl330.1", "apb_pclk", &init_clocks_off[1]),
>>   };
>>
>>   void __init s5pv210_register_clocks(void)
>> @@ -1361,6 +1358,5 @@ void __init s5pv210_register_clocks(void)
>>          for (ptr = 0; ptr < ARRAY_SIZE(clk_cdev); ptr++)
>>                  s3c_disable_clocks(clk_cdev[ptr], 1);
>>
>> -       s3c24xx_register_clock(&dummy_apb_pclk);
>>          s3c_pwmclk_init();
>>   }
>> 8<--------------------
>>
>> If it works then we could make some cleaner patch.
>>
>>
>>> For HDMI driver,
>>> I have added the following HDMI related code to
>>> arch/arm/mach-s5pv210/mach-smdkv210.c:
>>> /* I2C module and id for HDMIPHY */
>>> static struct i2c_board_info hdmiphy_info = {
>>> I2C_BOARD_INFO("hdmiphy-s5pv210", 0x38),
>>> };
>>>
>>> i2c_register_board_info(2, smdkv210_i2c_devs2,
>>> ARRAY_SIZE(smdkv210_i2c_devs2));
>>>
>>> s5p_i2c_hdmiphy_set_platdata(NULL);
>>> s5p_hdmi_set_platdata(&hdmiphy_info, NULL, 0);
>>>
>>> s3c_ide_set_platdata(&smdkv210_ide_pdata);
>>>
>>> then kernel print:
>>> s5p-hdmi s5pv210-hdmi: hdmiphy adapter request failed
>>> s5p-hdmi s5pv210-hdmi: probe failed
>>> Samsung TV Mixer driver, (c) 2010-2011 Samsung Electronics Co., Ltd.
>>>
>>> s5p-mixer s5p-mixer: probe start
>>> s5p-mixer s5p-mixer: resources acquired
>>> s5p-mixer s5p-mixer: module s5p-hdmi provides no subdev!
>>> s5p-mixer s5p-mixer: module s5p-sdo provides no subdev!
>>> s5p-mixer s5p-mixer: failed to register any output
>>> s5p-mixer s5p-mixer: probe failed
>>>
>>> Can anybody help me on how to config the HDMI output function in linux
>>> kernel 3.8? I mainly want to do video hardware decode using s5pv210 MFC
>>> and then display with HDMI.
>>
>>
>> For video playback (video post-processing) you might also need at least one
>> FIMC device. Please refer to arch/arm/mach-goni.c for an example on how to
>> add related devices to your board. You don't need the camera stuff, just
>> add:
>>
>>          &s5p_device_mfc,
>>          &s5p_device_mfc_l,
>>          &s5p_device_mfc_r,
>>
>>          &s5p_device_fimc0,
>>          &s5p_device_fimc1,
>>          &s5p_device_fimc2,
>>          &s5p_device_fimc_md,
>>
>> to smdkv210_devices[] and related Kconfig entries to make it compile.
>> You'll need a function similar to goni_reserve() in your board file
>> to reserve memory for the video codec.
>>
>> Hope that helps.
Yes, I have added fimc0,fimc1,fimc2,fimc_md and reserve MFC memory. But 
currently HDMI output doesn't work correctly yet, I would try to see the 
HDMI output first and then video decoder.
Regards,


