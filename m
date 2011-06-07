Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:55849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FGONn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 10:13:43 -0400
Date: Tue, 7 Jun 2011 16:13:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-media@vger.kernel.org, Kassey Lee <ygli@marvell.com>
Subject: Re: [PATCH 7/7] marvell-cam: Basic working MMP camera driver
In-Reply-To: <20110607080356.39b3db95@bike.lwn.net>
Message-ID: <Pine.LNX.4.64.1106071612000.31635@axis700.grange>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
 <1307400003-94758-8-git-send-email-corbet@lwn.net>
 <Pine.LNX.4.64.1106070941140.31635@axis700.grange> <20110607080356.39b3db95@bike.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 7 Jun 2011, Jonathan Corbet wrote:

> On Tue, 7 Jun 2011 09:44:45 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > > +obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/  
> > 
> > Wouldn't it be better to have only one symbol, selecting the marvell-ccic 
> > directory in the Makefile and have all CAFE implementations select that 
> > symbol?
> 
> Except there's two drivers in that directory and you'll almost never want
> to build them both.  I guess I could replace one Makefile line with two
> Kconfig lines, but I'm not sure it would improve things.

Yes, indeed I meant 3 Kconfig symbols: 1 common and 1 per driver, each of 
which selects the common one. Sorry for being unclear:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
