Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1BIXoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 18:44:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil MacMunn <neil@gumstix.com>
Subject: Re: omap3-isp segfault
Date: Thu, 10 Feb 2011 00:44:03 +0100
Cc: linux-media@vger.kernel.org
References: <4D4076C3.4080201@gumstix.com> <201101271328.05891.laurent.pinchart@ideasonboard.com> <4D4C7E24.6000004@gumstix.com>
In-Reply-To: <4D4C7E24.6000004@gumstix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102100044.04096.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Neil,

On Friday 04 February 2011 23:31:00 Neil MacMunn wrote:
> On 11-01-27 04:28 AM, Laurent Pinchart wrote:
> > On Thursday 27 January 2011 02:43:15 Neil MacMunn wrote:
> >> Ok I solved the segfault problem by updating some of my v4l2 files
> >> (specifically v4l2-common.c). Now I only get nice sounding console
> >> messages.
> >> 
> >>       Linux media interface: v0.10
> >>       Linux video capture interface: v2.00
> >>       omap3isp omap3isp: Revision 2.0 found
> >>       omap-iommu omap-iommu.0: isp: version 1.1
> >>       omap3isp omap3isp: hist: DMA channel = 4
> >>       mt9v032 3-005c: Probing MT9V032 at address 0x5c
> >>       omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 28800000 Hz
> >>       omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
> >>       mt9v032 3-005c: MT9V032 detected at address 0x5c
> > 
> > As you're using an MT9V032 sensor, I can help you with the pipeline
> > setup. You can run the following commands to capture 5 raw images.
> > 
> > ./media-ctl -r -l '"mt9v032 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> > CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> 
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
> 
> > ./media-ctl -f '"mt9v032 2-005c":0[SGRBG10 752x480], "OMAP3 ISP
> > CCDC":1[SGRBG10 752x480]'
> 
> Setting up format SGRBG10 752x480 on pad mt9v032 3-005c/0
> Format set: SGRBG10 752x480
> Setting up format SGRBG10 752x480 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG10 752x480
> Setting up format SGRBG10 752x480 on pad OMAP3 ISP CCDC/1
> Format set: SGRBG10 752x480
> 
> > ./yavta -p -f SGRBG10 -s 752x480 -n 4 --capture=5 --skip 4 -F
> > $(./media-ctl -e "OMAP3 ISP CCDC output")
> 
> Device /dev/video2 opened: OMAP3isp_video_pix_to_mbus: mbus->code=0x0000
>   ISP CCDC output (media).
> isp_video_mbus_to_pix: mbus->code=0x300A
> Video format set: width: 752 height: 480 buffer size: 721920
> Video format: BA10 (30314142) 752x480
> 4 buffers requested.
> length: 721920 offset: 0
> Buffer 0 mapped at address 0x402e6000.
> length: 721920 offset: 724992
> Buffer 1 mapped at address 0x40427000.
> length: 721920 offset: 1449984
> Buffer 2 mapped at address 0x405bc000.
> length: 721920 offset: 2174976
> Buffer 3 mapped at address 0x40704000.
> Press enter to start capture
> 
> isp_video_mbus_to_pix: mbus->code=0x300A
> 
> And then it hangs. I'm trying to run a bt but I think mbus->code=0x0000
> is the problem. Not sure where it stems from though. Thoughts?

As that message is printed by modifications you made to the code, I'm not sure 
it's an issue.

Could you cat /proc/interrupts several times when yavta is running to see if 
the ISP gets any interrupt ?

-- 
Regards,

Laurent Pinchart
