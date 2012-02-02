Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2BBIdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 03:33:05 -0500
Date: Thu, 2 Feb 2012 01:08:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fernandez Gonzalo <gfernandez@copreci.es>
cc: linux-media@vger.kernel.org
Subject: Re: OV2640 and iMX25PDK - help needed
In-Reply-To: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local>
Message-ID: <Pine.LNX.4.64.1202020040500.28897@axis700.grange>
References: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Gonzalo

On Tue, 31 Jan 2012, Fernandez Gonzalo wrote:

> Hi all,
> 
> I've been working for a while with an iMX25PDK using the BSP provided by
> Freescale (L2.6.31). The camera driver (V4L2-int) and examples do the
> job quite well but I need to move my design to a more recent kernel.
> I've been extensively googling but haven't found any info/examples about
> how to run the mx2_camera driver in the i.MX25PDK. I'm stuck at this,
> could someone point me in the right direction? Thank you in advance...

i.MX25PDK is supported in the mainline kernel 
(arch/arm/mach-imx/mach-mx25_3ds.c), but it doesn't attach any cameras. 
Unfortunately, I also don't currently see any i.MX2x platforms in the 
mainline with cameras, so, you have to begin by looking at 
arch/arm/plat-mxc/include/mach/mx2_cam.h, at 
arch/arm/plat-mxc/devices/platform-mx2-camera.c for the 
imx27_add_mx2_camera() function and maybe some i.MX3x or i.MX1 examples.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
