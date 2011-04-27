Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41496 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab1D0OGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 10:06:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Problems with omap3isp + mt9p031 in Beagleboard xM.
Date: Wed, 27 Apr 2011 16:06:19 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <BANLkTim9-Q2J18WMEzaMrTrXYDLqwkOgag@mail.gmail.com>
In-Reply-To: <BANLkTim9-Q2J18WMEzaMrTrXYDLqwkOgag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271606.19944.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Tuesday 26 April 2011 13:18:44 javier Martin wrote:
> Hi,
> I'm trying to port Guennadi's patches
> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/) to last
> mainline kernel 2.6.39-rc.
> 
> I've managed to compile and configure the video interface using the
> suggested commands:
> 
> root@beagleboard:~# ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP
> CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
> 
> root@beagleboard:~# ./media-ctl -f '"mt9p031 2-0048":0[SGRBG8
> 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> Setting up forma[   75.031677] mt9p031_set_format(320x240 : 1)
> t SGRBG8 320x240 on pad mt9p031 2-0048/0
> Format set: SGRBG8 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG8 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
> Format set: SGRBG8 320x240
> 
> However, when I try to capture some frames using yavta I get the following:
> 
> root@beagleboard:~# ./yavta -f SGRBG8 -s 320x240 -n 4 --capture=10
> --skip 3 -F `./media-ctl -e "OMAP3 ISP CCDC output"`
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> Video[   81.140228] mt9p031_get_format()
>  format set: width: 320 height: 240 buffer size: 76800
> Video format: GRBG (47425247) 320x240
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x400c2000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x40213000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x40293000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x40344000.
> [   81.268341] omap-iommu omap-iommu.0: isp: errs:0x00000000
> da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
> *pte:0x00000000

[snip]

> And the image files I get are filled with 5555 instead of useful data.
> 
> Does anybody know whether those iommu errors are harmless?
> Do I need to enable CAM mux inside
> arch/arm/mach-omap2/board-omap3beagle.c which are currently disabled
> using an ifdef?

Please try the patch at

http://thread.gmane.org/gmane.linux.ports.arm.omap/56662

-- 
Regards,

Laurent Pinchart
