Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:49542 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab0EaUYP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 16:24:15 -0400
To: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Soc-camera and 2.6.33
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 31 May 2010 22:24:06 +0200
Message-ID: <87fx17vmzd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I tried to upgrade from 2.6.30 to 2.6.33 and verify my board (ie. the mt9m111
sensor with pxa_camera host).

I'm a bit surprised it didn't work. I dig just a bit, and found that :
 - in soc_camera_init_i2c(), the following call fails
	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
				icl->module_name, icl->board_info, NULL);
   I have subdev = NULL.

 - as a result, I'm getting that kind of log :
     camera 0-0: Probing 0-0
     pxa27x-camera pxa27x-camera.0: Registered platform device at c3010900 data c03f0c24
     pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to camera 0
     RJK: subdev=NULL, module=mt9m111
     pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
     camera: probe of 0-0 failed with error -12

 - if I try 2.6.34, I have no error report, and mt9m111 driver is not probed
   either.

Is there an explanation as to why I have this regression ? Is something to be
done with the v4l2 migration ?

Cheers.

--
Robert
