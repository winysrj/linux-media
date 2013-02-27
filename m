Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32941 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943Ab3B0PsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 10:48:22 -0500
Message-ID: <512E2ABF.1080206@gmail.com>
Date: Wed, 27 Feb 2013 23:48:15 +0800
From: Lonsn <lonsn2005@gmail.com>
MIME-Version: 1.0
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
References: <51275DF7.4010600@gmail.com> <512CB1BE.1070401@gmail.com> <512D160D.1050706@gmail.com> <512D1BFB.4000700@gmail.com> <512E22AA.8020006@gmail.com>
In-Reply-To: <512E22AA.8020006@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013/2/27 23:13, Lonsn 写道:
>> On 02/26/2013 09:07 PM, Sylwester Nawrocki wrote:
>>> Hi Lonsn,
>>>
>>> On 02/26/2013 01:59 PM, Lonsn wrote:
>>>> Now I checked HDMI failed at:
>>>> drivers/media/platform/s5p-tv/hdmi_drv.c: 912 line
>>>> adapter = i2c_get_adapter(pdata->hdmiphy_bus);
>>>> if (adapter == NULL) {
>>>> dev_err(dev, "hdmiphy adapter request failed\n");
>>>> ret = -ENXIO;
>>>> goto fail_vdev;
>>>> }
>>>> Since pdata->hdmiphy_bus is 3, why i2c_get_adapter failed?
>>>
>>> Do you have I2C3 bus controller device added to the list of devices
>>> registered in the init_machine() callback, i.e. &s3c_device_i2c3
>>> entry in smdkv210_devices[] array ?
>>>
>>> You can refer to arch/arm/mach-exynos/mach-universal_c210.c board file
>>> for how a complete setup for the HDMI driver should look like. It's
>>> for Exynos4210 SoCs but it should not be much different from what you
>>> need for S5PV210.
>>
>> To build the kernel with s3c_device_i2c3 S3C_DEV_I2C3 and
>> S5PV210_SETUP_I2C3
>> need to be selected in Kconfig, e.g.
>>
>> diff --git a/arch/arm/mach-s5pv210/Kconfig
>> b/arch/arm/mach-s5pv210/Kconfig
>> index 92ad72f..51ce100 100644
>> --- a/arch/arm/mach-s5pv210/Kconfig
>> +++ b/arch/arm/mach-s5pv210/Kconfig
>> @@ -151,12 +151,14 @@ config MACH_SMDKV210
>>          select S3C_DEV_HSMMC3
>>          select S3C_DEV_I2C1
>>          select S3C_DEV_I2C2
>> +       select S3C_DEV_I2C3
>>          select S3C_DEV_RTC
>>          select S3C_DEV_USB_HSOTG
>>          select S3C_DEV_WDT
>>          select S5PV210_SETUP_FB_24BPP
>>          select S5PV210_SETUP_I2C1
>>          select S5PV210_SETUP_I2C2
>> +       select S5PV210_SETUP_I2C3
>>          select S5PV210_SETUP_IDE
>>          select S5PV210_SETUP_KEYPAD
>>          select S5PV210_SETUP_SDHCI
> Sylwester, thank you very much for your suggestions! Now HDMI phy has
> been detected after I add HDMI phy i2c bus in
> arch/arm/mach-s5pv210/Kconfig:
> config MACH_SMDKV210
>          bool "SMDKV210"
>          select CPU_S5PV210
>          select S3C_DEV_FB
>          select S3C_DEV_HSMMC
>          select S3C_DEV_HSMMC1
>          select S3C_DEV_HSMMC2
>          select S3C_DEV_HSMMC3
>          select S3C_DEV_I2C1
>          select S3C_DEV_I2C2
> +       select S5P_DEV_I2C_HDMIPHY
>          select S3C_DEV_RTC
>          select S3C_DEV_USB_HSOTG
> and arch/arm/mach-s5pv210/mach-smdkv210.c:
> static struct platform_device *smdkv210_devices[] __initdata = {
>      &s3c_device_adc,
>      &s3c_device_cfcon,
>      &s3c_device_fb,
>      &s3c_device_hsmmc0,
>      &s3c_device_hsmmc1,
>      &s3c_device_hsmmc2,
>      &s3c_device_hsmmc3,
>      &s3c_device_i2c0,
>      &s3c_device_i2c1,
>      &s3c_device_i2c2,
> +    &s5p_device_i2c_hdmiphy,
>      &s3c_device_rtc,
>      &s3c_device_ts,
>      &s3c_device_usb_hsotg,
>      &s3c_device_wdt,
>      &s5p_device_fimc0,
>      &s5p_device_fimc1,
>      &s5p_device_fimc2,
>      &s5p_device_fimc_md,
>      &s5p_device_jpeg,
>      &s5p_device_mfc,
>      &s5p_device_mfc_l,
>      &s5p_device_mfc_r,
>      &s5pv210_device_ac97,
>      &s5pv210_device_iis0,
>      &s5pv210_device_spdif,
>      &samsung_asoc_idma,
>      &samsung_device_keypad,
>      &smdkv210_dm9000,
> //    &smdkv210_lcd_lte480wv,
>      &s5p_device_hdmi,
>      &s5p_device_mixer,
> };
> Now kernel prints the following HDMI related:
> m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as /dev/video0
> s5p-jpeg s5p-jpeg.0: encoder device registered as /dev/video1
> s5p-jpeg s5p-jpeg.0: decoder device registered as /dev/video2
> s5p-jpeg s5p-jpeg.0: Samsung S5P JPEG codec
> s5p-mfc s5p-mfc: decoder registered as /dev/video3
> s5p-mfc s5p-mfc: encoder registered as /dev/video4
> s5p-hdmi s5pv210-hdmi: probe start
> s5p-hdmi s5pv210-hdmi: HDMI resource init
> s5p-hdmiphy 3-0038: probe successful
> s5p-hdmi s5pv210-hdmi: probe successful
> Samsung TV Mixer driver, (c) 2010-2011 Samsung Electronics Co., Ltd.
>
> s5p-mixer s5p-mixer: probe start
> s5p-mixer s5p-mixer: resources acquired
> s5p-mixer s5p-mixer: added output 'S5P HDMI connector' from module
> 's5p-hdmi'
> s5p-mixer s5p-mixer: module s5p-sdo provides no subdev!
> s5p-mixer s5p-mixer: registered layer graph0 as /dev/video5
> s5p-mixer s5p-mixer: registered layer graph1 as /dev/video6
> s5p-mixer s5p-mixer: registered layer video0 as /dev/video7
> s5p-mixer s5p-mixer: probe successful
>
> How can I test the HDMI output whether it's OK? Which /dev/video is real
> HDMI output? I have used
> http://git.infradead.org/users/kmpark/public-apps hdmi test program buf
> failed:
> root@linaro-developer:/opt# ./tvdemo /dev/video7 720 480 0 0
> ERROR(main.c:80) : VIDIOC_S_FMT failed: Invalid argument
> Aborted
> root@linaro-developer:/opt#
> Maybe I still miss some configuration in mach-smdkv210.c.
>
>
The kernel print when run tvdemo:
root@linaro-developer:/opt# ./tvdemo /dev/video7 720 480 0 0
ERROR(main.c:80) : VIDIOC_S_FMT failed: Invalid argument
Aborted
root@linaro-developer:/opt# dmesg
s5p-mixer s5p-mixer: mxr_video_open:762
s5p-mixer s5p-mixer: resume - start
s5p-mixer s5p-mixer: resume - finished
s5p-hdmi s5pv210-hdmi: hdmi_g_mbus_fmt
s5p-mixer s5p-mixer: src.full_size = (720, 480)
s5p-mixer s5p-mixer: src.size = (720, 480)
s5p-mixer s5p-mixer: src.offset = (0, 0)
s5p-mixer s5p-mixer: dst.full_size = (720, 480)
s5p-mixer s5p-mixer: dst.size = (720, 480)
s5p-mixer s5p-mixer: dst.offset = (0, 0)
s5p-mixer s5p-mixer: ratio = (0, 0)
s5p-mixer s5p-mixer: src.full_size = (720, 480)
s5p-mixer s5p-mixer: src.size = (720, 480)
s5p-mixer s5p-mixer: src.offset = (0, 0)
s5p-mixer s5p-mixer: dst.full_size = (720, 480)
s5p-mixer s5p-mixer: dst.size = (720, 480)
s5p-mixer s5p-mixer: dst.offset = (0, 0)
s5p-mixer s5p-mixer: ratio = (65536, 65536)
s5p-mixer s5p-mixer: mxr_s_fmt:322
s5p-mixer s5p-mixer: not recognized fourcc: 34524742
s5p-mixer s5p-mixer: mxr_video_release:842
s5p-mixer s5p-mixer: suspend - start
s5p-mixer s5p-mixer: suspend - finished
root@linaro-developer:/opt#
