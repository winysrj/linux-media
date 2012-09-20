Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2ITOr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 10:47:29 -0400
Received: by pbbrr4 with SMTP id rr4so363525pbb.19
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 07:47:29 -0700 (PDT)
Date: Thu, 20 Sep 2012 22:47:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 11/34] media: mx1_camera: remove the driver
Message-ID: <20120920144722.GH2450@S2101-09.ap.freescale.net>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
 <1348123547-31082-12-git-send-email-shawn.guo@linaro.org>
 <505B1282.5020308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505B1282.5020308@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2012 at 09:56:34AM -0300, Mauro Carvalho Chehab wrote:
> It is better to mark it as BROKEN for the next Kernel, and then to
> move it to staging, before dropping a broken driver. That gives people
> some time to fix it, if someone has interests on fixing the issues.
> 
Ok.  The driver has already been broken, and the patch marking it BROKEN
does not necessarily need to be in this series.  I will drop the patch
from this series and send a separate patch based on media tree for that.

> >  drivers/media/video/Kconfig                     |   12 -
> >  drivers/media/video/Makefile                    |    1 -
> >  drivers/media/video/mx1_camera.c                |  889 -----------------------
> 
> Btw, this conflicts with the tree renaming patches already at -staging, as
> this driver location is elsewhere.
> 
mx1_camera.c is not a concern any more.  However the series touches
mx2_camera.c and mx3_camera.c as well.  I just tested to merge the
series with linux-next.  Strangely, git does not detect the renaming
for automatically merging changes.

Do you have a stable branch for media patches that I can pull as
dependency?

Shawn
