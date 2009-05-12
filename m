Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59916 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751388AbZELPNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 11:13:17 -0400
Date: Tue, 12 May 2009 17:13:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 0/3] Convert SuperH camera-enabled platforms to soc-camera
 as platform_device
Message-ID: <Pine.LNX.4.64.0905121649420.5087@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that soc-camera compatibility patch is in the mainline, we can convert 
all platforms to the new scheme. This patch series converts SuperH boards. 
Unfortunately, the first patch has to also (slightly) modify two camera 
drivers, but that looks like a minor inconvenience to me, at least when 
compared to my original convert-all-at-once mega-patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
