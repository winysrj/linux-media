Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62470 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1EaNXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 09:23:44 -0400
Received: by wwa36 with SMTP id 36so4868991wwa.1
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 06:23:43 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <1306835210-1345-2-git-send-email-javier.martin@vista-silicon.com>
Date: Tue, 31 May 2011 15:23:40 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, carlighting@yahoo.co.nz,
	mch_kot@yahoo.com.cn,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0A19142F-45A6-44AB-8EFB-94D60875E7DC@beagleboard.org>
References: <1306835210-1345-1-git-send-email-javier.martin@vista-silicon.com> <1306835210-1345-2-git-send-email-javier.martin@vista-silicon.com>
To: beagleboard@googlegroups.com
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Op 31 mei 2011, om 11:46 heeft Javier Martin het volgende geschreven:

> diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> new file mode 100644
> index 0000000..04365b2
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> 
> +static int __init beagle_camera_init(void)
> +{
> +	reg_1v8 = regulator_get(NULL, "cam_1v8");
> +	if (IS_ERR(reg_1v8))
> +		pr_err("%s: cannot get cam_1v8 regulator\n", __func__);
> +	else
> +		regulator_enable(reg_1v8);
> +
> +	reg_2v8 = regulator_get(NULL, "cam_2v8");
> +	if (IS_ERR(reg_2v8))
> +		pr_err("%s: cannot get cam_2v8 regulator\n", __func__);
> +	else
> +		regulator_enable(reg_2v8);
> +
> +	omap_register_i2c_bus(2, 100, NULL, 0);
> +	gpio_request(MT9P031_RESET_GPIO, "cam_rst");
> +	gpio_direction_output(MT9P031_RESET_GPIO, 0);
> +	omap3_init_camera(&beagle_isp_platform_data);
> +	return 0;
> +}
> +late_initcall(beagle_camera_init);

There should probably a if (cpu_is_omap3630()) {} wrapped around that, so the camera doesn't get initted on a 3530 beagle.

regards,

Koen