Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45019 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3LCKoz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 05:44:55 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX800E5W8ITIV70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 10:44:53 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'randy' <lxr1234@hotmail.com>, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.chehab@samsung.com,
	jtp.park@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
References: <BLU0-SMTP92430758342451CF087FC3ADD50@phx.gbl>
In-reply-to: <BLU0-SMTP92430758342451CF087FC3ADD50@phx.gbl>
Subject: RE: Can't open mfc v5 encode but decode can
Date: Tue, 03 Dec 2013 11:44:51 +0100
Message-id: <058401cef014$b29674e0$17c35ea0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

We also experienced this issue. One of the changes in the v4l2 core
affected the MFC driver. A fix for MFC has been prepared by Marek
Szyprowski and should be sent out soon.

Also another tip - in 3.13 a check on bytesused and length fields
in planes array has been implemented. So make sure to set them
appropriately.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: randy [mailto:lxr1234@hotmail.com]
> Sent: Tuesday, December 03, 2013 11:15 AM
> To: linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; k.debski@samsung.com;
> m.chehab@samsung.com; jtp.park@samsung.com
> Subject: Can't open mfc v5 encode but decode can
> 
> The kernel is 3.13-rc2, the mfc has been configured by dts, the dts is
> attached below. I have placed s5p-mfc.fw in /lib/firmware/ .
> I can use v4l2-ctl(from v4l2-utils) the encoder in the manufacturer
> kernel, but I can't in here. What is the problem?
> Thank you
> ==================================log==================================
> 
> root@mifu:~# dmesg|grep mfc
> [    3.165000] s5p-mfc 13400000.codec: decoder registered as
> /dev/video0
> [    3.170000] s5p-mfc 13400000.codec: encoder registered as
> /dev/video1
> root@mifu:~# v4l2-ctl -d /dev/video0 --all Driver Info (not using
> libv4l2):
>         Driver name   : 13400000.codec[  153.415000] vidioc_g_crop:777:
> Cannont set crop
> 
>         Card type     : 13400000.codec
>         Bus info      :
>         Driver version: 1.0.0
>         Capabilities  : 0x04007000
>                 Video Capture Multiplanar
>                 Video Output Multiplanar
>                 Streaming
> root@mifu:~# v4l2-ctl -d /dev/video1 --all Failed to open /dev/video1:
> No such file or directory
> =============================dts=====================
> diff --git a/arch/arm/boot/dts/exynos4412-tiny4412.dts
> b/arch/arm/boot/dts/exynos4412-tiny4412.dts
> new file mode 100644
> index 0000000..fedd9cc
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos4412-tiny4412.dts
> @@ -0,0 +1,173 @@
> +/*
> + * Hardkernel's Exynos4412 based tiny4412 1306 board device tree
> source
> + *
> + * Copyright (c) 2013 Tomoya Gitsufuki <ayaka@mail.soulik.info>
> + *
> + * Device tree source file for Friendyarm tiny4412 1306 board which
> is based on
> + * Samsung's Exynos4412 SoC.
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +/dts-v1/;
> +#include "exynos4412.dtsi"
> +
> +/ {
> +	model = "Friendly Arm Tiny4412 1306 board based on Exynos4412";
> +	compatible = "friendlyarm,tiny4412-1306", "samsung,exynos4412";
> +
> +	memory {
> +		reg = <0x40000000 0x40000000>;
> +	};
> +
> +	chosen {
> +		bootargs ="root=/dev/mmcblk0p1 rootfstype=ext4 rw
> console=ttySAC0,115200 init=/sbin/init";
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +		led1 {
> +			label = "led1:heart";
> +			gpios = <&gpm4 0 1>;
> +			default-state = "on";
> +			linux,default-trigger = "heartbeat";
> +		};
> +		led2 {
> +			label = "led2:mmc0";
> +			gpios = <&gpm4 1 1>;
> +			default-state = "on";
> +			linux,default-trigger = "mmc0";
> +		};
> +
> +	};
> +
> +	regulators {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +
> +		vemmc_reg: regulator-0 {
> +			compatible = "regulator-fixed";
> +			regulator-name = "VMEM_VDD_2.8V";
> +			regulator-min-microvolt = <2800000>;
> +			regulator-max-microvolt = <2800000>;
> +			gpio = <&gpk0 2 0>;
> +			enable-active-high;
> +		};
> +
> +	};
> +
> +	/*
> +	mshc@12550000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
> +		pinctrl-names = "default";
> +		status = "okay";
> +
> +		vmmc-supply = <&vemmc_reg>;
> +		clocks = <&clock 301>, <&clock 149>;
> +		clocks-name = "biu", "ciu";
> +
> +		num-slots = <1>;
> +		supports-highspeed;
> +		broken-cd;
> +		fifo-depth = <0x80>;
> +		card-detect-delay = <200>;
> +		samsung,dw-mshc-ciu-div = <3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;
> +
> +		slot@0 {
> +			reg = <0>;
> +			bus-width = <8>;
> +
> +		};
> +	};
> +	*/
> +
> +	rtc@10070000 {
> +		status = "okay";
> +	};
> +
> +	sdhci@12530000 {
> +		bus-width = <4>;
> +		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4 &sd2_cd>;
> +		pinctrl-names = "default";
> +		status = "okay";
> +	};
> +	sdhci@1254000 {
> +		bus-width = <4>;
> +		pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4 &sd3_cd>;
> +		pinctrl-names = "default";
> +		status = "okay";
> +	};
> +
> +	usb_phy: usbphy@125B0000 {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "samsung,exynos4210-usb2phy";
> +		reg = <0x125B0000 0x100>;
> +		ranges;
> +		status = "okay";
> +
> +		clocks = <&clock 2>, <&clock 305>;
> +		clock-names = "xusbxti", "otg";
> +		usbphy-sys {
> +			/* USB device and host PHY_CONTROL registers */
> +			/*reg = <0x10020704 0xc 0x1001021c 0x4>;*/
> +			reg = <0x10020704 0x8>;
> +		};
> +	};
> +
> +	ehci@12580000 {
> +		usb-phy = <&usb_phy>;
> +		status = "okay";
> +	};
> +
> +	codec@13400000 {
> +		samsung,mfc-r = <0x43000000 0x800000>;
> +		samsung,mfc-l = <0x51000000 0x800000>;
> +		status = "okay";
> +	};
> +
> +	serial@13800000 {
> +		status = "okay";
> +	};
> +
> +	serial@13810000 {
> +		status = "okay";
> +	};
> +
> +	serial@13820000 {
> +		status = "okay";
> +	};
> +
> +	serial@13830000 {
> +		status = "okay";
> +	};
> +
> +	fixed-rate-clocks {
> +		xxti {
> +			compatible = "samsung,clock-xxti";
> +			clock-frequency = <0>;
> +		};
> +
> +		xusbxti {
> +			compatible = "samsung,clock-xusbxti";
> +			clock-frequency = <24000000>;
> +		};
> +	};
> +
> +	i2c@13860000 {
> +		status = "okay";
> +		samsung,i2c-sda-delay = <100>;
> +		samsung,i2c-max-bus-freq = <200000>;
> +
> +		wm8960@10 {
> +			compatible = "wlf,wm8960";
> +			reg = <0x10>;
> +		};
> +	};
> +};

