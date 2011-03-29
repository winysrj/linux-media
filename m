Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47061 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1C2PJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 11:09:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
Subject: Re: OMAP3 isp single-shot
Date: Tue, 29 Mar 2011 17:09:38 +0200
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
References: <CA7B7D6C54015B459601D68441548157C5A3AE@prevas1.prevas.se> <201103241135.06025.laurent.pinchart@ideasonboard.com> <CA7B7D6C54015B459601D68441548157C5A3B3@prevas1.prevas.se>
In-Reply-To: <CA7B7D6C54015B459601D68441548157C5A3B3@prevas1.prevas.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291709.38515.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Daniel,

On Friday 25 March 2011 14:10:28 Daniel Lundborg wrote:
> > On Thursday 24 March 2011 11:26:01 Daniel Lundborg wrote:

[snip]

> > > I can see on the oscilloscope that the sensor is sending something when
> > > I trigger it, but no picture is received..
> > 
> > "something" is a bit vague, can you check the hsync/vsync signals and make
> > sure they're identical in both modes ?
> 
> I have now tested this and I can say that I am having problems triggering
> the sensor. I wrongly thought I was triggering the sensor with my other
> driver correctly, but that was not the case.
> 
> What I want is to put the Omap ISP to generate a signal (CAM_WEN) to
> make the camera sensor take a picture.

That's not possible. The cam_wen signal is an input to the ISP. The ISP Timing 
Control module can generate pulses on the cam_shutter, cam_strobe and 
cam_global_reset signals only.

What you could do is configure the cam_wen pin as a GPIO and control it using 
the GPIO framework (either in kernelspace or userspace).

> In my working mt9v034 driver which is using kernel 2.6.31-rc7 with the
> patches from <http://gitorious.org/omap3camera/mainline/commits/slave> I
> set the ISP to this on power on:
> 
>   isp_reg_and_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
> 0x9a1b63ff, 0x98036000);  // Set CAM_GLOBAL_RESET pin as output, enable
> shutter, set DIVC = 216

What ISP driver version are you using ? isp_reg_and_or has been replaced by 
isp_reg_clr_set a very long time ago. You should really upgrade.

>   isp_reg_and(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN,
> ISP_TCTRL_SHUT_DELAY, 0xfe000000);  // Set no shutter delay
>   isp_reg_and_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN,
> ISP_TCTRL_SHUT_LENGTH, 0xfe000000, 0x000003e8);  // Set shutter signal
> length to 1000 (=> 1000 * 1/216MHz * 216 = 1 ms)
>   isp_reg_and_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN,
> ISP_TCTRL_GRESET_LENGTH, 0xfe000000, 0x000003e8);  // Set shutter signal
> length to 1000 (=> 1000 * 1/216MHz * 216 = 1 ms)
>   isp_reg_and(isp_ccdc_dev, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG,
> ~ISPCCDC_LSC_ENABLE);  // Make sure you disable LSC
> 
> And when I want to take a picture I do:
> 
>   isp_reg_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
> 0x00e00000);  // Enable shutter (SHUTEN bit = 1)
>   isp_reg_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
> 0x20000000);  // Start generation of CAM_GLOBAL_RESET signal (GRESETEN
> bit = 1)
> 
> When I try to do this in the newer driver I manage to generate a pulse
> on the CAM_WEN pin, but no VSYNC, HSYNC or data is transmitted.

I fail to see how that code can generate a pulse on the cam_wen signal. It 
should only control the cam_shutter, cam_strobe and cam_global_shutter pins.

> Am I missing something?

Is your sensor correctly configured ? Is there a publicly available datasheet 
for the MT9V034 ?

-- 
Regards,

Laurent Pinchart
