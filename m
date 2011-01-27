Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59757 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1A0M2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:28:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil MacMunn <neil@gumstix.com>
Subject: Re: omap3-isp segfault
Date: Thu, 27 Jan 2011 13:28:05 +0100
Cc: linux-media@vger.kernel.org
References: <4D4076C3.4080201@gumstix.com> <4D40CDB3.7090106@gumstix.com>
In-Reply-To: <4D40CDB3.7090106@gumstix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101271328.05891.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi again,

On Thursday 27 January 2011 02:43:15 Neil MacMunn wrote:
> Ok I solved the segfault problem by updating some of my v4l2 files
> (specifically v4l2-common.c). Now I only get nice sounding console
> messages.
> 
>      Linux media interface: v0.10
>      Linux video capture interface: v2.00
>      omap3isp omap3isp: Revision 2.0 found
>      omap-iommu omap-iommu.0: isp: version 1.1
>      omap3isp omap3isp: hist: DMA channel = 4
>      mt9v032 3-005c: Probing MT9V032 at address 0x5c
>      omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 28800000 Hz
>      omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
>      mt9v032 3-005c: MT9V032 detected at address 0x5c

As you're using an MT9V032 sensor, I can help you with the pipeline setup. You
can run the following commands to capture 5 raw images.

./media-ctl -r -l '"mt9v032 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
./media-ctl -f '"mt9v032 2-005c":0[SGRBG10 752x480], "OMAP3 ISP CCDC":1[SGRBG10 752x480]'

./yavta -p -f SGRBG10 -s 752x480 -n 4 --capture=5 --skip 4 -F $(./media-ctl -e "OMAP3 ISP CCDC output")

-- 
Regards,

Laurent Pinchart
