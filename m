Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754928Ab0EaVvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 17:51:45 -0400
Date: Mon, 31 May 2010 23:51:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Soc-camera and 2.6.33
In-Reply-To: <87fx17vmzd.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1005312338280.16053@axis700.grange>
References: <87fx17vmzd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert

On Mon, 31 May 2010, Robert Jarzmik wrote:

> I tried to upgrade from 2.6.30 to 2.6.33 and verify my board (ie. the mt9m111
> sensor with pxa_camera host).
> 
> I'm a bit surprised it didn't work. I dig just a bit, and found that :
>  - in soc_camera_init_i2c(), the following call fails
> 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
> 				icl->module_name, icl->board_info, NULL);
>    I have subdev = NULL.
> 
>  - as a result, I'm getting that kind of log :
>      camera 0-0: Probing 0-0
>      pxa27x-camera pxa27x-camera.0: Registered platform device at c3010900 data c03f0c24
>      pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to camera 0
>      RJK: subdev=NULL, module=mt9m111
>      pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
>      camera: probe of 0-0 failed with error -12

a lot of things changed in and around soc-camera between 2.6.30 and 
.33... E.g., previously you could load driver modules in any order, it 
would work in any case. Now if you load your host driver (pxa) and your 
client driver is not there yet, it should be automatically loaded. 
However, if your user-space doesn't support this, it won't work. Can this 
be the reason gor your problem? Otherwise, I'd suspect a problem with your 
platform data (cf. other platforms), or, eventually with mt9m111.

>  - if I try 2.6.34, I have no error report, and mt9m111 driver is not probed
>    either.
> 
> Is there an explanation as to why I have this regression ? Is something to be
> done with the v4l2 migration ?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
