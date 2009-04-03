Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49208 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751531AbZDCNBN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 09:01:13 -0400
Date: Fri, 3 Apr 2009 15:01:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius Augulis <augulis.darius@gmail.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
In-Reply-To: <49D60692.9050204@gmail.com>
Message-ID: <Pine.LNX.4.64.0904031500120.4729@axis700.grange>
References: <20090403113054.11098.67516.stgit@localhost.localdomain>
 <Pine.LNX.4.64.0904031352350.4729@axis700.grange> <20090403122939.GT23731@pengutronix.de>
 <Pine.LNX.4.64.0904031437540.4729@axis700.grange> <49D60692.9050204@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Apr 2009, Darius Augulis wrote:

> Guennadi Liakhovetski wrote:
> > 
> > Confused... Then why the whole that "IMX/MX1" in the driver? And why will it
> > never get it - are they compatible or not? Or just there's no demand / chips
> > are EOLed or something...
> 
> in Linux kernel "imx" is the old name of "mx1".
> mx1 contains of two processors: i.MX1 and i.MXL.

Ah, ok, I see now. I thought i.MXL was under ARCH_IMX and _not_ ARCH_MX1. 
That was my confusion.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
