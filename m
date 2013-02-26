Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52312 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3BZUHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 15:07:46 -0500
Message-ID: <512D160D.1050706@gmail.com>
Date: Tue, 26 Feb 2013 21:07:41 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Lonsn <lonsn2005@gmail.com>
CC: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
References: <51275DF7.4010600@gmail.com> <512CB1BE.1070401@gmail.com>
In-Reply-To: <512CB1BE.1070401@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lonsn,

On 02/26/2013 01:59 PM, Lonsn wrote:
> Now I checked HDMI failed at:
> drivers/media/platform/s5p-tv/hdmi_drv.c: 912 line
>      adapter = i2c_get_adapter(pdata->hdmiphy_bus);
>      if (adapter == NULL) {
>          dev_err(dev, "hdmiphy adapter request failed\n");
>          ret = -ENXIO;
>          goto fail_vdev;
>      }
> Since pdata->hdmiphy_bus is 3, why i2c_get_adapter failed?

Do you have I2C3 bus controller device added to the list of devices
registered in the init_machine() callback, i.e. &s3c_device_i2c3
entry in smdkv210_devices[] array ?

You can refer to arch/arm/mach-exynos/mach-universal_c210.c board file
for how a complete setup for the HDMI driver should look like. It's
for Exynos4210 SoCs but it should not be much different from what you
need for S5PV210.

--

Regards,
Sylwester
