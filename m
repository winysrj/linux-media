Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.copreci.es ([194.30.93.3]:62799 "EHLO srvdmz.cp.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753201Ab2BBNsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 08:48:17 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: OV2640 and iMX25PDK - help needed
Date: Thu, 2 Feb 2012 14:48:13 +0100
Message-ID: <C85ED22A0FD4B54195E2F05309F9D3FF0727F19F@CORREO.cp.local>
References: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local> <Pine.LNX.4.64.1202020040500.28897@axis700.grange>
From: "Fernandez Gonzalo" <gfernandez@copreci.es>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>Hello Gonzalo
>
>On Tue, 31 Jan 2012, Fernandez Gonzalo wrote:
>
>>> Hi all,
>>> 
>>> I've been working for a while with an iMX25PDK using the BSP
provided by
>>> Freescale (L2.6.31). The camera driver (V4L2-int) and examples do
the
>>> job quite well but I need to move my design to a more recent kernel.
>>> I've been extensively googling but haven't found any info/examples
about
>>> how to run the mx2_camera driver in the i.MX25PDK. I'm stuck at
this,
>>> could someone point me in the right direction? Thank you in
advance...
>
>i.MX25PDK is supported in the mainline kernel 
>(arch/arm/mach-imx/mach-mx25_3ds.c), but it doesn't attach any cameras.

>Unfortunately, I also don't currently see any i.MX2x platforms in the 
>mainline with cameras, so, you have to begin by looking at 
>arch/arm/plat-mxc/include/mach/mx2_cam.h, at 
>arch/arm/plat-mxc/devices/platform-mx2-camera.c for the 
>imx27_add_mx2_camera() function and maybe some i.MX3x or i.MX1
examples.
>
>Thanks
>Guennadi

Thank you very much for the tip !!! 
I'll look at the files you have pointed.

Regards,
Gonzalo.
