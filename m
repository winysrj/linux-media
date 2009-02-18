Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752652AbZBRPVU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:21:20 -0500
Date: Wed, 18 Feb 2009 16:21:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
cc: Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness improvements
In-Reply-To: <951330.963.qm@web32108.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0902181619090.6371@axis700.grange>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch>
 <alpine.DEB.2.00.0902180044120.6986@axis700.grange>
 <alpine.DEB.2.00.0902180049580.6986@axis700.grange> <951330.963.qm@web32108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009, Agustin wrote:

> I am having some stoopid trouble while trying to apply this patch to 'mxc-master':
> $ patch -p1 --dry-run < p1
> patching file drivers/dma/ipu/ipu_idmac.c
> patch: **** malformed patch at line 29: /*
> 
> Looks like your patches lost their format while on their way, specially 
> every single line with a starting space has had it removed. Or is it my 
> e-mail reader? I am trying to fix it manually, no luck.

I would tip at your reader - I just saved my emails, that I received back 
from the list and applied them - no problem.

In fact, there is a small problem with the main camera patch - Kconfig and 
Makefile hunks do not apply to Linus' ToT, but that's easy to fix, I'll 
fix it up for pull.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
