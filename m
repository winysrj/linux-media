Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IVWEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 18:04:23 -0400
Date: Sun, 23 Sep 2012 00:04:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: P Jackson <pej02@yahoo.co.uk>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: mt9t031 driver support on OMAP3 system
In-Reply-To: <1348335758.70304.YahooMailNeo@web28902.mail.ir2.yahoo.com>
Message-ID: <Pine.LNX.4.64.1209230001390.26787@axis700.grange>
References: <1348335758.70304.YahooMailNeo@web28902.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete

On Sat, 22 Sep 2012, P Jackson wrote:

> I'm trying to incorporate an MT9T031-based sensor into a commercial 
> small form-factor OMAP3 DM3730-based system which is supplied with 
> sources for a 2.6.37 kernel and is somewhat out-dated.The application 
> I'm working on requires a single image to be acquired from the sensor 
> every once in a while which is then processed off-line by another 
> algorithm on the OMAP3
> 
> I'd appreciate any advice from the list as to what the most suitable up 
> to-date compatible kernel I should use would be and what other work I 
> need to do in order to get things sorted.

I would certainly advise to use a current kernel (e.g., 3.5). As for 
"how," I know, that Laurent has worked on a similar tasks, you can find 
his posts in mailing list archives, or maybe he'll be able to advise you 
more specifically.

> Thanks, Pete  

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
