Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:51951 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0HPPq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 11:46:57 -0400
Message-ID: <4C695B83.90405@matrix-vision.de>
Date: Mon, 16 Aug 2010 17:38:43 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: laurent.pinchart@ideasonboard.com
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
Subject: CCP2 on OMAP35x
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent,

I'm working on a sensor driver with a parallel interface to the ISP.  In my OMAP35x TRM (spruf98h.pdf), I only find 2 occurrences of "CCP2", with no discussion or description, whereas in the ISP sources on omap3camera/devel I see that it is a building block of the ISP.  From the sources, I'm guessing that it is involved in interfacing a serial sensor data stream to the CCDC, and would be uninvolved in parallel data from a sensor.

Is the CCP2 indeed documented somewhere for the OMAP35x?  Or is this perhaps only available in the OMAP34x?

In omap34xxcam_video_init(), the media_entity links are activated.  In this if/else there,

if (vdev->vdev_sensor->entity.links[0].sink->entity ==
    &isp->isp_csi2a.subdev.entity) {...} else {...}

the assumption is made that a sensor is either connected
A. (sensor->)CSI2A->CCDC or
B. sensor->CCP2->CCDC

but if I'm correct that the CCP2 is related to serial data, there is an option (C) missing for parallel data: sensor->CCDC.  In fact, this is the link that is created in omap34xxcam_probe() if 'case ISP_INTERFACE_PARALLEL'.  Is this correct, that I would need to add an 'else if' to get parallel data working?

sincerely,
Michael


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Hans-Joachim Reich
