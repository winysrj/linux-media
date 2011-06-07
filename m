Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:58678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1FGJ6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 05:58:00 -0400
Date: Tue, 7 Jun 2011 11:57:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 0/3 v2] V4L: pxa-camera: minor updates
Message-ID: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series updates the pxa-camera driver to match recent API 
changes and to better integrate into the framework. It splits the 
previously posted patch

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/33616

that erroneously contained unrelated changes in it, thanks go to Robert 
for spotting that:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
