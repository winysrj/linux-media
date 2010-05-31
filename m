Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46207 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab0EaJrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 05:47:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: manjunathan.padua@wipro.com
Subject: Re: Regarding  OMAP 35xx  ISP subsystem and SoC-Camera
Date: Mon, 31 May 2010 11:49:30 +0200
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
References: <336834A7A2D8B34BA5A8906E6E71DF870113EC41@BLR-SJP-MBX01.wipro.com> <201005310959.18029.laurent.pinchart@ideasonboard.com> <336834A7A2D8B34BA5A8906E6E71DF879D17EA@BLR-SJP-MBX01.wipro.com>
In-Reply-To: <336834A7A2D8B34BA5A8906E6E71DF879D17EA@BLR-SJP-MBX01.wipro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005311149.30848.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunathan,

On Monday 31 May 2010 11:40:55 manjunathan.padua@wipro.com wrote:
> > On Friday 28 May 2010 15:54:57 manjunathan.padua@wipro.com wrote:
> > > Dear Linux-media group
> > >
> > > I am a newbie and have recently started working on integration of a new
> > > camera sensor MT9M112 sensor with OMAP ISP Camera subsystem on a OMAP
> > > 3530 based custom board.  So I checked in mainline kernel if driver is
> > > available for this camera sensor and  I found it in the
> > > Linux/driver/media/video/mt9m11.c, this supports both MT9M111 and
> > > MT9M112. It is based on SoC-Camera framework.   But unfortunately this
> > > is not compatible with OMAP 35xx  Camera ISP subsystem  as OMAP camera
> > > ISP subsystem is based on V4L2-INT.
> >
> > The OMAP3 ISP driver doesn't use the deprecated V4L2 int-device API
> > anymore. The latest version of the driver can be found in the omap3camera
> > tree on gitorious (make sure you checkout the devel branch).
> 
> Does this mean current code of OMAP3 ISP in gitorious is updated to use
> sub-device framework?

Yes it does.

> > > Also I got know that there are there are 3 different frameworks for
> > > camera sensor drivers in Linux
> > > a. V4L2-INT is deprecated but currently supported by OMAP35xx ISP Linux
> > > BSP
> > > b. SoC-Camera is  also deprecated.
> > > c. Sub-Device is the current architecture supported from Open source
> > > community
> > > 
> > > 1. Is this understanding correct ?
> > >
> > That's correct. The OMAP35xx ISP driver in the Linux BSP is also
> > deprecated :-)
> 
> It is surprising to hear that OMAP35xx ISP driver is also deprecated.

The OMAP34xx and OMAP35xx ISP are very similar and should be supported by the 
same driver. The most up-to-date driver is available in the omap3camera tree, 
and that's the one that will be merged to mainline when it will be ready. All 
other drivers are either deprecated or temporary solutions.

> > > 2. Since V4L2-INT and SoC-Camera frameworks are deprecated, can you
> > > please let me know the roadmap for Sub-Device framework ?
> >
> > The soc-camera framework isn't deprecated, but it isn't used by the OMAP3
> > ISP driver either.
> 
> Wow, that's what I heard from folks at TI. I will re-check with them as why
> it they said so.
> 
> > > 3. What is the best option/recommendation from community for me to
> > > integrate MT9M112 with Camera ISP system on OMAP 3530 based board ?
> >
> > The dependencies on the soc-camera framework in the MT9M112 driver need to
> > be removed. I've CC'ed Guennadi Liakhovetski to this e-mail, he's the
> > author of the soc-camera framework and should be able to provide
> > information on what is required.
> 
> Thanks, I had already contacted Guennadi on this about a week ago, he
> provided me recommendation and some details on how this can be done and
> also request me to post query on linux-media mailing list.
> 
> > > 4. And lastly are there any other different camera sensors which have
> > > Sub- Device based drivers available in Mainline Linux?
> >
> > Not that I know of, but there's a video decoder driver (tvp5150).

-- 
Regards,

Laurent Pinchart
