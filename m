Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:55822 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0HZQzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 12:55:37 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Lane Brooks <lane@brooks.nu>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 26 Aug 2010 22:25:23 +0530
Subject: RE: OMAP ISP and Overlay
Message-ID: <19F8576C6E063C45BE387C64729E7394046836C4A1@dbde02.ent.ti.com>
References: <4C73CBB1.4090605@brooks.nu>
 <201008251126.05905.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008251126.05905.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, August 25, 2010 2:56 PM
> To: Lane Brooks
> Cc: linux-media@vger.kernel.org
> Subject: Re: OMAP ISP and Overlay
> 
> Hi Lane,
> 
> On Tuesday 24 August 2010 15:40:01 Lane Brooks wrote:
> >
> > So far I have the everything working with the OMAP ISP to where I can
> stream
> > video on our custom board.
> 
> Great news.
> 
> A new version of the ISP driver will soon be published with all the legacy
> code removed. We need a few days to setup the repository properly. You can
> already get a preview at http://git.linuxtv.org/pinchartl/media.git
> (omap3isp-
> rx51 branch).
> 
> > On a previous generation of hardware with a completely different
> processor
> > and sensor, we used the V4L2 overlay feature to stream directly to our
> LCD
> > for preview. I am wondering what the plans are for overlay support in
> the
> > omap ISP? How does the overlay feature fit into the new media bus
> feature?
> 
> The OMAP3 ISP driver won't support V4L2 overlay directly. However, you can
> use
> the USERPTR streaming mode and pass framebuffer memory directly to the ISP
> driver, resulting in DMA to the framebuffer and improved efficiency.
> 

Sorry for late reply,

Just wanted to add on top of this, you could use V4L2 Display driver here which supports 2 video planes (over /dev/video0 & /dev/video1) along with both User pointer mode and MMAP mode of operation.

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
