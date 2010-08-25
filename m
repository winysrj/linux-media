Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36878 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0HYJ0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 05:26:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lane Brooks <lane@brooks.nu>
Subject: Re: OMAP ISP and Overlay
Date: Wed, 25 Aug 2010 11:26:04 +0200
Cc: linux-media@vger.kernel.org
References: <4C73CBB1.4090605@brooks.nu>
In-Reply-To: <4C73CBB1.4090605@brooks.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008251126.05905.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Lane,

On Tuesday 24 August 2010 15:40:01 Lane Brooks wrote:
> 
> So far I have the everything working with the OMAP ISP to where I can stream
> video on our custom board.

Great news.

A new version of the ISP driver will soon be published with all the legacy 
code removed. We need a few days to setup the repository properly. You can 
already get a preview at http://git.linuxtv.org/pinchartl/media.git (omap3isp-
rx51 branch).

> On a previous generation of hardware with a completely different processor
> and sensor, we used the V4L2 overlay feature to stream directly to our LCD
> for preview. I am wondering what the plans are for overlay support in the
> omap ISP? How does the overlay feature fit into the new media bus feature?

The OMAP3 ISP driver won't support V4L2 overlay directly. However, you can use 
the USERPTR streaming mode and pass framebuffer memory directly to the ISP 
driver, resulting in DMA to the framebuffer and improved efficiency.

-- 
Regards,

Laurent Pinchart
