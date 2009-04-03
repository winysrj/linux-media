Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41096 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760943AbZDCMPa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 08:15:30 -0400
Date: Fri, 3 Apr 2009 14:15:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius Augulis <augulis.darius@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
In-Reply-To: <20090403113054.11098.67516.stgit@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0904031352350.4729@axis700.grange>
References: <20090403113054.11098.67516.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Apr 2009, Darius Augulis wrote:

> From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Ok, I'll just swap these two Sob's to reflect the processing chain, add a 
description like

Add support for CMOS Sensor Interface on i.MX1 and i.MXL SoCs.

and fix a couple of trivial conflicts, which probably appear, because you 
based your patches on an MXC tree, and not on current linux-next. 
Wondering, if it still will work then... At least it compiles. BTW, should 
it really also work with IMX? Then you might want to change this

	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA

to

	depends on VIDEO_DEV && (ARCH_MX1 || ARCH_IMX) && SOC_CAMERA

but you can do this later, maybe, when you actually get a chance to test 
it on IMX (if you haven't done so yet).

Sascha, we need your ack for the ARM part.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
