Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:54963 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0HPTZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 15:25:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: CCP2 on OMAP35x
Date: Mon, 16 Aug 2010 21:25:23 +0200
Cc: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
References: <4C695B83.90405@matrix-vision.de>
In-Reply-To: <4C695B83.90405@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008162125.25039.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Michael,

On Monday 16 August 2010 17:38:43 Michael Jones wrote:
> Hi Laurent,
> 
> I'm working on a sensor driver with a parallel interface to the ISP.  In my
> OMAP35x TRM (spruf98h.pdf), I only find 2 occurrences of "CCP2", with no
> discussion or description, whereas in the ISP sources on omap3camera/devel
> I see that it is a building block of the ISP.  From the sources, I'm
> guessing that it is involved in interfacing a serial sensor data stream to
> the CCDC, and would be uninvolved in parallel data from a sensor.

That's correct. CCP2 stands for Compact Camera Port 2 and is an interface 
standard for serial cameras used in mobile phones (and possibly elsewhere). A 
quick search on Google turns up this link 
http://www.sunex.com/SIMA/SMIA_CCP2_specification_1.0.pdf. If I'm not 
mistaken, CCP2 is a superset of the CSI-1 interface standard defined by the 
MIPI alliance.

> Is the CCP2 indeed documented somewhere for the OMAP35x?  Or is this
> perhaps only available in the OMAP34x?

The physical CCP2 interface is only available in the OMAP34xx and OMAP36xx 
processors. The OMAP35xx family has a parallel receiver only.

However, the CCP2 module can also read back raw data from memory. Even though 
the physical CCP2 interface is not present on the OMAP34xx/36xx families (at 
least according to the TRM, I don't think anymore has built an OMAP35xx board 
to verify this), the CCP2 module itself is available and can be used in memory 
input mode.

> In omap34xxcam_video_init(), the media_entity links are activated.  In this
> if/else there,
> 
> if (vdev->vdev_sensor->entity.links[0].sink->entity ==
>     &isp->isp_csi2a.subdev.entity) {...} else {...}
> 
> the assumption is made that a sensor is either connected
> A. (sensor->)CSI2A->CCDC or
> B. sensor->CCP2->CCDC

That's correct.

> but if I'm correct that the CCP2 is related to serial data, there is an
> option (C) missing for parallel data: sensor->CCDC.  In fact, this is the
> link that is created in omap34xxcam_probe() if 'case
> ISP_INTERFACE_PARALLEL'.  Is this correct, that I would need to add an
> 'else if' to get parallel data working?

You shouldn't use the video nodes /dev/video0 and /dev/video1. They're legacy 
and will soon be removed. You should instead use the new video nodes 
/dev/video[2-8] along with the media controller API. They should support 
parallel sensors properly.

-- 
Regards,

Laurent Pinchart
