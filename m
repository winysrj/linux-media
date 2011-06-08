Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1FHMjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 08:39:42 -0400
Date: Wed, 8 Jun 2011 14:39:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Koen Kooi <koen@beagleboard.org>
cc: beagleboard@googlegroups.com,
	Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, carlighting@yahoo.co.nz,
	mch_kot@yahoo.com.cn
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron)
 mt9p031 sensor.
In-Reply-To: <4CF44DCA-BCCA-4AA6-AE14-DAADE66767B4@beagleboard.org>
Message-ID: <Pine.LNX.4.64.1106081439030.24274@axis700.grange>
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com>
 <201106081357.51578.laurent.pinchart@ideasonboard.com>
 <4CF44DCA-BCCA-4AA6-AE14-DAADE66767B4@beagleboard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 8 Jun 2011, Koen Kooi wrote:

> 
> Op 8 jun 2011, om 13:57 heeft Laurent Pinchart het volgende geschreven:
> 
> > Hi Javier,
> > 
> > I'm testing your patch on a 2.6.39 kernel. Here's what I get when loading the 
> > omap3-isp module.
> > 
> > root@arago:~# modprobe omap3-isp
> > [  159.523681] omap3isp omap3isp: Revision 15.0 found
> > [  159.528991] omap-iommu omap-iommu.0: isp: version 1.1
> > [  159.875701] omap_i2c omap_i2c.2: Arbitration lost
> > [  159.881622] mt9p031 2-0048: Failed to reset the camera
> > [  159.887054] omap3isp omap3isp: Failed to power on: -5
> > [  159.892425] mt9p031 2-0048: Failed to power on device: -5
> > [  159.898956] isp_register_subdev_group: Unable to register subdev mt9p031
> > 
> > Have you (or anyone else) seen that issue ?
> 
> I build in both statically to avoid that problem.

I used modules and it worked for me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
