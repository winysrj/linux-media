Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab0EaI1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 04:27:51 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"manjunathan.padua@wipro.com" <manjunathan.padua@wipro.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 31 May 2010 13:57:42 +0530
Subject: RE: Regarding  OMAP 35xx  ISP subsystem and SoC-Camera
Message-ID: <19F8576C6E063C45BE387C64729E7394044E6D26FF@dbde02.ent.ti.com>
References: <336834A7A2D8B34BA5A8906E6E71DF870113EC41@BLR-SJP-MBX01.wipro.com>
 <201005310959.18029.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201005310959.18029.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Monday, May 31, 2010 1:29 PM
> To: manjunathan.padua@wipro.com; Guennadi Liakhovetski
> Cc: linux-media@vger.kernel.org
> Subject: Re: Regarding OMAP 35xx ISP subsystem and SoC-Camera
> 
> Hi Manjunathan,
> 
> On Friday 28 May 2010 15:54:57 manjunathan.padua@wipro.com wrote:
> > Dear Linux-media group
> >   I am a newbie and have recently started working on integration of a new
> > camera sensor MT9M112 sensor with OMAP ISP Camera subsystem on a OMAP 3530
> > based custom board.  So I checked in mainline kernel if driver is
> > available for this camera sensor and  I found it in the
> > Linux/driver/media/video/mt9m11.c, this supports both MT9M111 and MT9M112.
> > It is based on SoC-Camera framework.   But unfortunately this is not
> > compatible with OMAP 35xx  Camera ISP subsystem  as OMAP camera ISP
> > subsystem is based on V4L2-INT.
> 
> The OMAP3 ISP driver doesn't use the deprecated V4L2 int-device API anymore.
> The latest version of the driver can be found in the omap3camera tree on
> gitorious (make sure you checkout the devel branch).
> 
> > Also I got know that there are there are 3 different frameworks for camera
> > sensor drivers in Linux
> > a. V4L2-INT is deprecated but currently supported by OMAP35xx ISP Linux
> BSP
> > b. SoC-Camera is  also deprecated.
> > c. Sub-Device is the current architecture supported from Open source
> > community
> >
> > 1. Is this understanding correct ?
> 
> That's correct. The OMAP35xx ISP driver in the Linux BSP is also deprecated
> :-)
> 
> > 2. Since V4L2-INT and SoC-Camera frameworks are deprecated, can you please
> > let me know the roadmap for Sub-Device framework ?
> 
> The soc-camera framework isn't deprecated, but it isn't used by the OMAP3
> ISP
> driver either.
> 
> > 3. What is the best option/recommendation from community for me to
> integrate
> > MT9M112 with Camera ISP system on OMAP 3530 based board ?
> 
> The dependencies on the soc-camera framework in the MT9M112 driver need to
> be
> removed. I've CC'ed Guennadi Liakhovetski to this e-mail, he's the author of
> the soc-camera framework and should be able to provide information on what
> is
> required.
> 
> > 4. And lastly are there any other different camera sensors which have Sub-
> > Device based drivers available in Mainline Linux?
> 
> Not that I know of, but there's a video decoder driver (tvp5150).
[Hiremath, Vaibhav] Also we have TVP514x video decoder driver.

Thanks,
Vaibhav
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
