Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55128 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1IQWAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 18:00:21 -0400
Message-ID: <4E751870.5080605@gmail.com>
Date: Sun, 18 Sep 2011 00:00:16 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Martin Hostettler <martin@neutronstar.dyndns.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based camera
 board.
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/17/2011 11:34 AM, Martin Hostettler wrote:
> Adds board support for an MT9M032 based camera to omap3evm.
...
> +
> +static int __init camera_init(void)
> +{
> +	int ret = -EINVAL;
> +	
> +	omap_mux_init_gpio(nCAM_VD_SEL, OMAP_PIN_OUTPUT);
> +	if (gpio_request(nCAM_VD_SEL, "nCAM_VD_SEL")<  0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_SEL(%d)\n",
> +		       nCAM_VD_SEL);
> +		goto err;
> +	}
> +	if (gpio_direction_output(nCAM_VD_SEL, 1)<  0) {
> +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_SEL(%d) direction\n",
> +		       nCAM_VD_SEL);
> +		goto err_vdsel;
> +	}

How about replacing gpio_request + gpio_direction_output with:

	gpio_request_one(nCAM_VD_SEL, GPIOF_OUT_INIT_HIGH, "nCAM_VD_SEL");

> +
> +	if (gpio_request(EVM_TWL_GPIO_BASE + 2, "T2_GPIO2")<  0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO T2_GPIO2(%d)\n",
> +		       EVM_TWL_GPIO_BASE + 2);
> +		goto err_vdsel;
> +	}
> +	if (gpio_direction_output(EVM_TWL_GPIO_BASE + 2, 0)<  0) {
> +		pr_err("omap3evm-camera: Failed to set GPIO T2_GPIO2(%d) direction\n",
> +		       EVM_TWL_GPIO_BASE + 2);
> +		goto err_2;
> +	}

 	gpio_request_one(EVM_TWL_GPIO_BASE + 2, GPIOF_OUT_INIT_LOW, "T2_GPIO2");

> +
> +	if (gpio_request(EVM_TWL_GPIO_BASE + 8, "nCAM_VD_EN")<  0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_EN(%d)\n",
> +		       EVM_TWL_GPIO_BASE + 8);
> +		goto err_2;
> +	}
> +	if (gpio_direction_output(EVM_TWL_GPIO_BASE + 8, 0)<  0) {
> +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_EN(%d) direction\n",
> +		       EVM_TWL_GPIO_BASE + 8);
> +		goto err_8;
> +	}

...and	gpio_request_one(EVM_TWL_GPIO_BASE + 8, GPIOF_OUT_INIT_LOW, "nCAM_VD_EN") ?

> +
> +	omap3evm_set_mux(MUX_CAMERA_SENSOR);
> +
> +	
> +	ret = omap3_init_camera(&isp_platform_data);
> +	if (ret<  0)
> +		goto err_8;
> +	return 0;
> +	
> +err_8:
> +	gpio_free(EVM_TWL_GPIO_BASE + 8);
> +err_2:
> +	gpio_free(EVM_TWL_GPIO_BASE + 2);
> +err_vdsel:
> +	gpio_free(nCAM_VD_SEL);
> +err:
> +	return ret;
> +}
> +
> +device_initcall(camera_init);

--
Regards,
Sylwester
