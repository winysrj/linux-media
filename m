Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:34996 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759101Ab2CFNWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 08:22:46 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 6 Mar 2012 15:22:01 +0200
Subject: RE: mx3-camera
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8909@MEP-EXCH.meprolight.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>,<Pine.LNX.4.64.1203061406500.9300@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1203061406500.9300@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


 Thanks Guennadi, 

>Hi Alex

>(adding v4l and Sascha to CC)

>On Tue, 6 Mar 2012, Alex Gershgorin wrote:

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
>       err = PTR_ERR(mx3_cam->clk);
>       goto eclkget;
> }

>I think, the reason is, that the i.MX35 platform doesn't register a camera
>clock, similar to i.MX31 (arch/arm/mach-imx/clock-imx31.c):

 >       _REGISTER_CLOCK("mx3-camera.0", NULL, csi_clk)

In i.MX35 (arch/arm/mach-imx/clock-imx35.c) it looks like this:

_REGISTER_CLOCK(NULL, "csi", csi_clk)

> I will be glad for any help.
>

Regards,
Alex Gershgorin

 
