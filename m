Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59223 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EaPMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 11:12:47 -0400
Received: by wwk4 with SMTP id 4so2528516wwk.1
        for <linux-media@vger.kernel.org>; Tue, 31 May 2011 08:12:45 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <201105311647.01034.laurent.pinchart@ideasonboard.com>
Date: Tue, 31 May 2011 17:12:42 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5C0A9B76-5EAD-4FBD-94C0-CE7D80A992A2@beagleboard.org>
References: <1306835210-1345-1-git-send-email-javier.martin@vista-silicon.com> <0A19142F-45A6-44AB-8EFB-94D60875E7DC@beagleboard.org> <Pine.LNX.4.64.1105311553230.10863@axis700.grange> <201105311647.01034.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 31 mei 2011, om 16:46 heeft Laurent Pinchart het volgende geschreven:

> On Tuesday 31 May 2011 15:55:04 Guennadi Liakhovetski wrote:
>> On Tue, 31 May 2011, Koen Kooi wrote:
>>> Op 31 mei 2011, om 11:46 heeft Javier Martin het volgende geschreven:
>>>> diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c
>>>> b/arch/arm/mach-omap2/board-omap3beagle-camera.c new file mode 100644
>>>> index 0000000..04365b2
>>>> --- /dev/null
>>>> +++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
>>>> 
>>>> +static int __init beagle_camera_init(void)
>>>> +{
>>>> +	reg_1v8 = regulator_get(NULL, "cam_1v8");
>>>> +	if (IS_ERR(reg_1v8))
>>>> +		pr_err("%s: cannot get cam_1v8 regulator\n", __func__);
>>>> +	else
>>>> +		regulator_enable(reg_1v8);
>>>> +
>>>> +	reg_2v8 = regulator_get(NULL, "cam_2v8");
>>>> +	if (IS_ERR(reg_2v8))
>>>> +		pr_err("%s: cannot get cam_2v8 regulator\n", __func__);
>>>> +	else
>>>> +		regulator_enable(reg_2v8);
>>>> +
>>>> +	omap_register_i2c_bus(2, 100, NULL, 0);
>>>> +	gpio_request(MT9P031_RESET_GPIO, "cam_rst");
>>>> +	gpio_direction_output(MT9P031_RESET_GPIO, 0);
>>>> +	omap3_init_camera(&beagle_isp_platform_data);
>>>> +	return 0;
>>>> +}
>>>> +late_initcall(beagle_camera_init);
>>> 
>>> There should probably a if (cpu_is_omap3630()) {} wrapped around that, so
>>> the camera doesn't get initted on a 3530 beagle.
>> 
>> ...speaking of which - if multiarch kernels are supported by OMAP3 you
>> probably want to use something like
>> 
>> 	if (!machine_is_omap3_beagle() || !cpu_is_omap3630())
>> 		return;
> 
> Shouldn't you check the Beagleboard version instead? The OMAP3530 has an ISP, 
> so there's nothing wrong with it per-se.

It has an ISP, but the pins aren't brought out, so you will never be able to use it. We could check the version, but that will look like:

if (omap3_beagle_get_rev() = OMAP3BEAGLE_BOARD_XM || omap3_beagle_get_rev() = OMAP3BEAGLE_BOARD_XMC || omap3_beagle_get_rev() = OMAP3BEAGLE_BOARD_XMD )

or check if you're not on     OMAP3BEAGLE_BOARD_AXBX, OMAP3BEAGLE_BOARD_C1_3 or OMAP3BEAGLE_BOARD_C4. I find the 3630 check a lot simpler :)

regards,

Koen



regards,

Koen