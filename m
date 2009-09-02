Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39226 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750778AbZIBMd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 08:33:28 -0400
Date: Wed, 2 Sep 2009 14:33:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: [PATCH 0/3] image-bus API
Message-ID: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

Now that we definitely know on the OMAP 3 example, that a parameter like 
"packing" is indeed needed to fully describe video on-the-bus data, I 
haven't heard any more objections against my proposed API, so, this 
version could well be for inclusion. Of course, if there are improvement 
suggestions, we can address them. I am CC-ing people, that took part in 
discussing the RFC for this API (sent exactly a week ago:-)), and also 
authors of drivers and systems that I cannot test myself. Specifically, I 
only compile-tested the mx1_camera, and mt9m111 drivers, also would be 
good to test on the ap325rxa SuperH platform. Notice, it looks like the 
soc_camera_platform driver is currently broken, I am open for suggestions 
regarding what we should do with it - deprecate and schedule for removal, 
mark as broken, or fix:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
