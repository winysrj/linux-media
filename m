Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57614 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1A0MZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:25:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil MacMunn <neil@gumstix.com>
Subject: Re: omap3-isp segfault
Date: Thu, 27 Jan 2011 13:25:38 +0100
Cc: linux-media@vger.kernel.org
References: <4D4076C3.4080201@gumstix.com> <4D40CDB3.7090106@gumstix.com>
In-Reply-To: <4D40CDB3.7090106@gumstix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101271325.39630.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Neil,

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
> 
> And a bunch of devices.
> 
>      # ls /dev
>      ...
>      v4l-subdev0
>      v4l-subdev1
>      v4l-subdev2
>      v4l-subdev3
>      v4l-subdev4
>      v4l-subdev5
>      v4l-subdev6
>      v4l-subdev7
>      v4l-subdev8
>      ...
>      video0
>      video1
>      video2
>      video3
>      video4
>      video5
>      video6
>      ...
> 
> But don't know how to start the camera. How can I test the module?

You can get the media-ctl and yavta test applications from 
http://git.ideasonboard.org/

media-ctl is used to configure the OMAP3 ISP pipeline, and yavta to test video 
capture.

You can run

media-ctl --print-dot > omap3-isp.dot

to create a .dot description of the OMAP3 ISP topology. Process the file with

dot -Tps omap3-isp.dot > omap3-isp.ps

to generate a graph.

I'll unfortunately be offline from tomorrow evening until Monday the 7th of 
February, but I think other users of the OMAP3 ISP driver will be able to help 
you.

-- 
Regards,

Laurent Pinchart
