Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42323 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1FBNw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 09:52:59 -0400
Received: by eyx24 with SMTP id 24so283822eyx.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 06:52:58 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Jun 2011 15:52:57 +0200
Message-ID: <BANLkTinpCigLcTD_3ucjzFVM_1PvNwQ3Rg@mail.gmail.com>
Subject: Does omap3isp driver inherit controls of attached sensors?
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I'm trying to add VFLIP control to the mt9p031 driver (don't worry
Guennadi, I won't send the patch yet). For that purpose I've followed
the code in mt9v032 sensor.
When I try to query available controls using yavta I get the following:

root@beagleboard:~# ./media-ctl -e "OMAP3 ISP CCDC output"
/dev/video2

root@beagleboard:~# ./yavta -l /dev/video2
Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
No control found.

As I have read here [1], drivers using subdevices should inherit their
controls. Is this the case with omap3isp?

[1] http://lxr.linux.no/#linux+v2.6.39/Documentation/video4linux/v4l2-controls.txt

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
