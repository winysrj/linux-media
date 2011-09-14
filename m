Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab1INKep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 06:34:45 -0400
Received: by fxe4 with SMTP id 4so1617212fxe.19
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 03:34:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Sep 2011 12:34:43 +0200
Message-ID: <CACKLOr3ghY4aKDiGbgy98FcMMPiYW0zonrVKhrQN8oMhmSZk8A@mail.gmail.com>
Subject: How to handle different media bus format and actual video output
 format in soc camera?
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to add support for YUV420 format to mx2_camera.c soc-camera
host driver.

In my system, an imx27_visstrim_m10 board, this host is connected to a
tvp5151 chip which is only
able to transfer pixels in this format through the media  bus:
V4L2_MBUS_FMT_YUYV8_2X8. However,
imx27 eMMa has the possibility to get this data from the bus and
convert it to a YUV420 format on the fly.

What is the right way to handle this properly in soc-camera?

I've been analyzing some code related to the matter and it seems
"soc_camera_xlate_by_fourcc()" [1]
only supports raw formats from the sensor [2].


[1] http://lxr.linux.no/#linux+v3.0.4/drivers/media/video/mx2_camera.c#L912
[2] http://lxr.linux.no/#linux+v3.0.4/drivers/media/video/soc_camera.c#L329

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
