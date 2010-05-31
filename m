Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51151 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751241Ab0EaMgM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 08:36:12 -0400
Date: Mon, 31 May 2010 14:36:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"manjunathan.padua@wipro.com" <manjunathan.padua@wipro.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Regarding  OMAP 35xx  ISP subsystem and SoC-Camera
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E6D27F7@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1005311427380.16053@axis700.grange>
References: <336834A7A2D8B34BA5A8906E6E71DF870113EC41@BLR-SJP-MBX01.wipro.com>
 <201005310959.18029.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E7394044E6D27F7@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 May 2010, Hiremath, Vaibhav wrote:

> > > 2. Since V4L2-INT and SoC-Camera frameworks are deprecated, can you please
> > > let me know the roadmap for Sub-Device framework ?
> > 
> > The soc-camera framework isn't deprecated, but it isn't used by the OMAP3
> > ISP
> > driver either.
> > 
> [Hiremath, Vaibhav] Laurent, I believe going forward this SoC-Camera 
> will get also deprecated and all drivers will be migrated to sub-device 
> framework.

Vaibhav, I think you're misunderstanding. The soc-camera framework has 
been designed to fulfill two tasks: (1) create a standard interface 
between (SoC) camera hosts and video clients, and (2) to simplify 
implementation of new camera host drivers by taking a part of common 
for many SoC camera controllers functionality into the soc-camera core. 
The first task is being replaced by v4l2-subdev, that's correct. But I so 
far don't see a compelling reason to obsolete the 2nd task, which would 
migrate that common functionality into each camera host driver. New camera 
host driver authors are free to either use or not to use soc-camera. If 
they think, the functionality provided by soc-camera core fits well with 
their hardware, they can use it. If they think, it is imposing too many 
restrictions and their hardware is more complicated, than what soc-camera 
offers, then they can write a complete v4l2-device driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
