Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:51087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1EaNzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 09:55:14 -0400
Date: Tue, 31 May 2011 15:55:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Koen Kooi <koen@beagleboard.org>
cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, carlighting@yahoo.co.nz,
	mch_kot@yahoo.com.cn,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03
 module) in Beagleboard xM.
In-Reply-To: <0A19142F-45A6-44AB-8EFB-94D60875E7DC@beagleboard.org>
Message-ID: <Pine.LNX.4.64.1105311553230.10863@axis700.grange>
References: <1306835210-1345-1-git-send-email-javier.martin@vista-silicon.com>
 <1306835210-1345-2-git-send-email-javier.martin@vista-silicon.com>
 <0A19142F-45A6-44AB-8EFB-94D60875E7DC@beagleboard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 31 May 2011, Koen Kooi wrote:

> Op 31 mei 2011, om 11:46 heeft Javier Martin het volgende geschreven:
> 
> > diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> > new file mode 100644
> > index 0000000..04365b2
> > --- /dev/null
> > +++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
> > 
> > +static int __init beagle_camera_init(void)
> > +{
> > +	reg_1v8 = regulator_get(NULL, "cam_1v8");
> > +	if (IS_ERR(reg_1v8))
> > +		pr_err("%s: cannot get cam_1v8 regulator\n", __func__);
> > +	else
> > +		regulator_enable(reg_1v8);
> > +
> > +	reg_2v8 = regulator_get(NULL, "cam_2v8");
> > +	if (IS_ERR(reg_2v8))
> > +		pr_err("%s: cannot get cam_2v8 regulator\n", __func__);
> > +	else
> > +		regulator_enable(reg_2v8);
> > +
> > +	omap_register_i2c_bus(2, 100, NULL, 0);
> > +	gpio_request(MT9P031_RESET_GPIO, "cam_rst");
> > +	gpio_direction_output(MT9P031_RESET_GPIO, 0);
> > +	omap3_init_camera(&beagle_isp_platform_data);
> > +	return 0;
> > +}
> > +late_initcall(beagle_camera_init);
> 
> There should probably a if (cpu_is_omap3630()) {} wrapped around that, so the camera doesn't get initted on a 3530 beagle.

...speaking of which - if multiarch kernels are supported by OMAP3 you 
probably want to use something like

	if (!machine_is_omap3_beagle() || !cpu_is_omap3630())
		return;

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
