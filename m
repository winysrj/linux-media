Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:51346 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaFNU6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 16:58:30 -0400
Date: Sat, 14 Jun 2014 22:58:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: linux-media@vger.kernel.org
Subject: Re: soc_camera and device-tree
In-Reply-To: <87ppibtes8.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1406142256010.23099@axis700.grange>
References: <87ppibtes8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sat, 14 Jun 2014, Robert Jarzmik wrote:

> Hi Guennadi,
> 
> I'm slowly converting all of my drivers to device-tree.
> In the process, I met ... soc_camera.
> 
> I converted mt9m111.c and pxa_camera.c, but now I need the linking
> soc_camera. And I don't have a clear idea on how it should be done.

Have a look at this thread

http://thread.gmane.org/gmane.linux.ports.sh.devel/34412/focus=36244

Thanks
Guennadi

> I was thinking of having soc_camera_pdrv_probe() changed, to handle
> device-tree. What bothers me a bit is that amongst the needed data for me are
> the bus_id and a soc_camera_subdev_desc. I was thinking that this could be
> expressed in device-tree like :
> 	soc_camera {
> 		icd = <&mt9m111>;
>         	ici = <&pxa_camera>;
>         }
> ...
> 	pxai2c1: i2c@40301680 {
> 		status = "okay";
> 
> 		mt9m111@5d {
> 			compatible = "micron,mt9m111";
> 			reg = <0x5d>;
> 		};
> 	};
> 
> 	pxa_camera {
> 		compatible = "mrvl,pxa_camera";
> 		mclk_10khz = <5000>;
> 		flags = <0xc9>;
> 	};
> 
> Do you have any hints and advices to help me ?
> 
> Cheers.
> 
> -- 
> Robert
> 
