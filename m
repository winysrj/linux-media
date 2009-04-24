Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752659AbZDXQjX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:39:23 -0400
Date: Fri, 24 Apr 2009 18:39:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/8] soc-camera: smoothly switch platforms to platform-driver
Message-ID: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Having done the two conversion steps and getting ready to push them, the 
problem that I pushed back for later came forward: applying a patch that 
affects multiple v4l drivers and 6 (!) (the 7th one is approaching) 
platforms would be difficult... So, here comes a solution. With this patch 
I add a new platform-driver style probing to soc-camera without removing 
the old one. This way all current users still work and we can easily 
convert platforms one by one to the new scheme. Please, have a look, I'll 
reply to this message with one core and 7 platform patches, of which the 
latter should only be applied after the first one.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
