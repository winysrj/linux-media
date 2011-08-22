Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60458 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1HVJle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 05:41:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: CJ <cjpostor@gmail.com>
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
Date: Mon, 22 Aug 2011 11:41:40 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Koen Kooi <koen@beagleboard.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mch_kot@yahoo.com.cn
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <201108191212.49729.laurent.pinchart@ideasonboard.com> <4E51D739.7010000@gmail.com>
In-Reply-To: <4E51D739.7010000@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221141.40818.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Monday 22 August 2011 06:12:41 CJ wrote:
> On 19/08/11 22:12, Laurent Pinchart wrote:
> >> I am trying to get the mt9p031 working from nand with a ubifs file
> >> system and I am having a few problems.
> >> 
> >> /dev/media0 is not present unless I run:
> >> #mknod /dev/media0 c 251 0
> >> #chown root:video /dev/media0
> >> 
> >> #media-ctl -p
> >> Enumerating entities
> >> media_open: Unable to enumerate entities for device /dev/media0
> >> (Inappropriate ioctl for device)
> >> 
> >> With the same rig/files it works fine running from EXT4 on an SD card.
> >> Any idea why this does not work on nand with ubifs?
> > 
> > Is the OMAP3 ISP driver loaded ? Has it probed the device successfully ?
> > Check the kernel log for OMAP3 ISP-related messages.
> 
> Here is the version running from SD card:
> # dmesg | grep isp
> [    0.265502] omap-iommu omap-iommu.0: isp registered
> [    2.986541] omap3isp omap3isp: Revision 2.0 found
> [    2.991577] omap-iommu omap-iommu.0: isp: version 1.1
> [    2.997406] omap3isp omap3isp: hist: DMA channel = 0
> [    3.006256] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
> 21600000 Hz
> [    3.011932] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
> 
>  From NAND using UBIFS:
> # dmesg | grep isp
> [    3.457061] omap3isp omap3isp: Revision 2.0 found
> [    3.462036] omap-iommu omap-iommu.0: isp: version 1.1
> [    3.467620] omap3isp omap3isp: hist: DMA channel = 0
> [    3.472564] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
> 21600000 Hz
> [    3.478027] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
> 
> Seems to be missing:
> omap-iommu omap-iommu.0: isp registered
> 
> Is that the issue? Why would this not work when running from NAND?

I'm not sure why it doesn't work from NAND, but the iommu2 module needs to be 
loaded before the omap3-isp module. Alternatively you can compile the iommu2 
module in the kernel with

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 49a4c75..3c87644 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -132,7 +132,7 @@ config OMAP_MBOX_KFIFO_SIZE
 	  module parameter).
 
 config OMAP_IOMMU
-       tristate
+       bool
 
 config OMAP_IOMMU_DEBUG
        tristate "Export OMAP IOMMU internals in DebugFS"

-- 
Regards,

Laurent Pinchart
