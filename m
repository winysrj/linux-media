Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224Ab2CFNLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 08:11:25 -0500
Date: Tue, 6 Mar 2012 14:11:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: mx3-camera
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1203061406500.9300@axis700.grange>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex

(adding v4l and Sascha to CC)

On Tue, 6 Mar 2012, Alex Gershgorin wrote:

> Hi Guennadi,
> 
> I'm working on I.MX35 PDK platform with use 3.3.0-rc6 version of the Linux Kernel.  
> Here is my Kernel boot message
> 
> "Linux video capture interface: v2.00
> mx3-camera: probe of mx3-camera.0 failed with error -2"
> 
> This error comes from probe function of mx3 camera host driver.
> Precisely in this part of the code:
>  
> mx3_cam->clk = clk_get(&pdev->dev, NULL);
> if (IS_ERR(mx3_cam->clk)) {
> 	err = PTR_ERR(mx3_cam->clk);
> 	goto eclkget;
> }

I think, the reason is, that the i.MX35 platform doesn't register a camera 
clock, similar to i.MX31 (arch/arm/mach-imx/clock-imx31.c):

	_REGISTER_CLOCK("mx3-camera.0", NULL, csi_clk)

Thanks
Guennadi

> I will be glad for any help.
> 
> Regards,
> Alex Gershgorin

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
