Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38929 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab1DHPCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:02:49 -0400
Received: by gxk21 with SMTP id 21so1457751gxk.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 08:02:48 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Apr 2011 17:02:48 +0200
Message-ID: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com>
Subject: mt9t111 sensor on Beagleboard xM
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I've just received a LI-LBCM3M1 camera module from Leopard Imaging and
I want to test it with my Beagleboard xM. This module has a mt9t111
sensor.

At first glance, this driver
(http://lxr.linux.no/#linux+v2.6.38/drivers/media/video/mt9t112.c)
supports mt9t111 sensor and uses both soc-camera and v4l2-subdev
frameworks.
I am trying to somehow connect this sensor with the omap3isp driver
recently merged (I'm working with latest mainline kernel), however, I
found an issue when trying to pass "mt9t112_camera_info" data to the
sensor driver in my board specific file.

It seems that this data is passed through soc-camera but omap3isp
doesn't use soc-camera. Do you know what kind of changes are required
to adapt this driver so that it can be used with omap3isp?

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
