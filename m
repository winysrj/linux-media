Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33554 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3BZUdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 15:33:04 -0500
Message-ID: <512D1BFB.4000700@gmail.com>
Date: Tue, 26 Feb 2013 21:32:59 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Lonsn <lonsn2005@gmail.com>
CC: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
References: <51275DF7.4010600@gmail.com> <512CB1BE.1070401@gmail.com> <512D160D.1050706@gmail.com>
In-Reply-To: <512D160D.1050706@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2013 09:07 PM, Sylwester Nawrocki wrote:
> Hi Lonsn,
>
> On 02/26/2013 01:59 PM, Lonsn wrote:
>> Now I checked HDMI failed at:
>> drivers/media/platform/s5p-tv/hdmi_drv.c: 912 line
>> adapter = i2c_get_adapter(pdata->hdmiphy_bus);
>> if (adapter == NULL) {
>> dev_err(dev, "hdmiphy adapter request failed\n");
>> ret = -ENXIO;
>> goto fail_vdev;
>> }
>> Since pdata->hdmiphy_bus is 3, why i2c_get_adapter failed?
>
> Do you have I2C3 bus controller device added to the list of devices
> registered in the init_machine() callback, i.e. &s3c_device_i2c3
> entry in smdkv210_devices[] array ?
>
> You can refer to arch/arm/mach-exynos/mach-universal_c210.c board file
> for how a complete setup for the HDMI driver should look like. It's
> for Exynos4210 SoCs but it should not be much different from what you
> need for S5PV210.

To build the kernel with s3c_device_i2c3 S3C_DEV_I2C3 and 
S5PV210_SETUP_I2C3
need to be selected in Kconfig, e.g.

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index 92ad72f..51ce100 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -151,12 +151,14 @@ config MACH_SMDKV210
         select S3C_DEV_HSMMC3
         select S3C_DEV_I2C1
         select S3C_DEV_I2C2
+       select S3C_DEV_I2C3
         select S3C_DEV_RTC
         select S3C_DEV_USB_HSOTG
         select S3C_DEV_WDT
         select S5PV210_SETUP_FB_24BPP
         select S5PV210_SETUP_I2C1
         select S5PV210_SETUP_I2C2
+       select S5PV210_SETUP_I2C3
         select S5PV210_SETUP_IDE
         select S5PV210_SETUP_KEYPAD
         select S5PV210_SETUP_SDHCI
