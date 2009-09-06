Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52912 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758021AbZIFQwm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Sep 2009 12:52:42 -0400
Date: Sun, 6 Sep 2009 18:52:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
In-Reply-To: <200909060550.23681.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909061755020.10484@axis700.grange>
References: <200908031031.00676.marek.vasut@gmail.com>
 <200909052317.24048.marek.vasut@gmail.com> <Pine.LNX.4.64.0909052358080.4670@axis700.grange>
 <200909060550.23681.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 6 Sep 2009, Marek Vasut wrote:

> Ah damn, I see what you mean. What the camera does is it swaps the RED and BLUE 
> channel:
> 15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
> B4  B3  B2  B1  B0  G4  G3  G2  G1  G1  R4  R3  R2  R1  R1  --
> so it's more a BGR555/565 then. I had to patch fswebcam for this.

Ok, this is, of course, something different. In this case you, probably, 
could deceive the PXA to handle blue as red and the other way round, but 
still, I would prefer not to do that. Hence my suggestion remains - pass 
these formats as raw data.

The only case when you might want to put the PXA into RGB555 mode, while 
feeding BGR555 to it, is you want to use the QCI to set the transparency 
bit for you. But we currently do not support this any way, not in a 
configurable way at least. You would need to implement some sort of a 
"global (one-bit) alpha" control for pxa_camera to use this. Any need for 
this?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
