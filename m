Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65397 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1CJPZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:25:23 -0500
Received: by yxs7 with SMTP id 7so691467yxs.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 07:25:23 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Mar 2011 16:25:22 +0100
Message-ID: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
Subject: mt9p031 support for Beagleboard.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
we are going to receive a Beagleaboard xM board in a couple of days.
One of the things we would like to test is video capture.

When it comes to the DM3730 SoC, it seems the support is given through
these two files:
http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/vpfe_capture.c
--> to capture from sensor
http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/dm644x_ccdc.c
--> to convert from Bayer RGB to YUV

On the other hand, the sensor we would like to test is mt9p031 which
comes with LI-5M03, a module that can be attached to Beagleboard xM
directly:
https://www.leopardimaging.com/Beagle_Board_xM_Camera.html

By a lot of googling I found this version of a driver for mt9p031
which is developed by Guennadi Liakhovetski. It is located in a 2.6.32
based branch:
http://arago-project.org/git/projects/?p=linux-davinci.git;a=blob;f=drivers/media/video/mt9p031.c;h=66b5e54d0368052bf76796aa846e9464e42204bb;hb=HEAD

The question is, what does this driver lack for not entering into
mainline? We would be very interested on helping it make it.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
