Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:57192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1A2Ayi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 19:54:38 -0500
Date: Sat, 29 Jan 2011 01:53:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Baruch Siach <baruch@tkos.co.il>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH/RFC 0/3] soc-camera: convert to videobuf2
Message-ID: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

This is the first early draft of the soc-camera conversion to the 
videobuf2 API. For this RFC I've trivially split the conversion into core 
and driver, which, actually, we shouldn't do, because after the core is 
converted all the soc-camera host drivers are broken. Ideally, we should 
be adding videobuf2 support in parallel to the existing videobuf1 support, 
then converting each driver individually, and then removing videobuf1, but 
I'm not sure, how easy this is going to be... Although, I think, some 
drivers will be more difficult, than sh-ceu, e.g., pxa270 and omap1 with 
their support for dma-sg. Also, at least sh.ceu and pxa270 support planar 
formats, so far I've just put all three buffers in one vb2 plane on 
sh-ceu, not sure, which disadvantages this has. So far 
sh_mobile_camera_ceu.c is the only driver I've converted and tested, but 
it too might need more care, e.g., to properly support the multi-planar 
configurations.

I'mm CC-ing individual driver maintainers / authors with a request to try 
to comvert their respective drivers to vb2 too. I will be attempting that 
myself too, as the time permits, but at least someone will have to test 
that - I don't have all the hardware.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
