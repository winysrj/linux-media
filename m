Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:47247 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752995Ab0HEKc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Aug 2010 06:32:57 -0400
Date: Thu, 5 Aug 2010 12:32:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L Kconfig defaults
Message-ID: <Pine.LNX.4.64.1008051214310.19691@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

At some point the usefullness of the VIDEO_HELPER_CHIPS_AUTO option has 
been questioned and a patch has even been submitted to disable this on 
embedded systems [1], which, somehow, doesn't seem to have been 
successful, even though there haven't been any objections. Or was I 
expected to push it via my tree?

Now, since a few kernel versions there are _many_ more of "default y" 
options in drivers/media/*/Kconfig around IR / remote drivers. Can we kill 
them (defaults, of course, not drivers), please?

Thanks
Guennadi

[1] http://article.gmane.org/gmane.linux.kernel.embedded/2721
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
