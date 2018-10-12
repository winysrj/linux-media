Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46986 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJLNeJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 09:34:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id n11-v6so11964215wru.13
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 23:03:19 -0700 (PDT)
Date: Fri, 12 Oct 2018 07:03:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD
 driver
Message-ID: <20181012060314.GU4939@dell>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-5-vz@mleia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181008211205.2900-5-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:

> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> 
> The change adds I2C device driver for TI DS90Ux9xx de-/serializers,
> support of subdevice controllers is done in separate drivers, because
> not all IC functionality may be needed in particular situations, and
> this can be fine grained controlled in device tree.
> 
> The development of the driver was a collaborative work, the
> contribution done by Balasubramani Vivekanandan includes:
> * original implementation of the driver based on a reference driver,
> * regmap powered interrupt controller support on serializers,
> * support of implicitly or improperly specified in device tree ICs,
> * support of device properties and attributes: backward compatible
>   mode, low frequency operation mode, spread spectrum clock generator.
> 
> Contribution by Steve Longerbeam:
> * added ds90ux9xx_read_indirect() function,
> * moved number of links property and added ds90ux9xx_num_fpd_links(),
> * moved and updated ds90ux9xx_get_link_status() function to core driver,
> * added fpd_link_show device attribute.
> 
> Sandeep Jain added support of pixel clock edge configuration.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> ---
>  drivers/mfd/Kconfig           |  14 +
>  drivers/mfd/Makefile          |   1 +
>  drivers/mfd/ds90ux9xx-core.c  | 879 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ds90ux9xx.h |  42 ++
>  4 files changed, 936 insertions(+)
>  create mode 100644 drivers/mfd/ds90ux9xx-core.c
>  create mode 100644 include/linux/mfd/ds90ux9xx.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 8c5dfdce4326..a969fa123f64 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1280,6 +1280,20 @@ config MFD_DM355EVM_MSP
>  	  boards.  MSP430 firmware manages resets and power sequencing,
>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
>  
> +config MFD_DS90UX9XX
> +	tristate "TI DS90Ux9xx FPD-Link de-/serializer driver"
> +	depends on I2C && OF
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  Say yes here to enable support for TI DS90UX9XX de-/serializer ICs.
> +
> +	  This driver provides basic support for setting up the de-/serializer
> +	  chips. Additional functionalities like connection handling to
> +	  remote de-/serializers, I2C bridging, pin multiplexing, GPIO
> +	  controller and so on are provided by separate drivers and should
> +	  enabled individually.

This is not an MFD driver.

After a 30 second Google of what this device actually does, perhaps
drivers/media might be a better fit?

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
