Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3FAUEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jun 2013 16:04:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 13/15] [media] omap3isp: include linux/mm_types.h
Date: Sat, 1 Jun 2013 22:04:30 +0200
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-14-git-send-email-arnd@arndb.de> <3507557.BiLMFItQuE@avalon>
In-Reply-To: <3507557.BiLMFItQuE@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306012204.30778.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 01 June 2013, Laurent Pinchart wrote:
> > diff --git a/drivers/media/platform/omap3isp/ispqueue.h
> > b/drivers/media/platform/omap3isp/ispqueue.h index 908dfd7..e6e720c 100644
> > --- a/drivers/media/platform/omap3isp/ispqueue.h
> > +++ b/drivers/media/platform/omap3isp/ispqueue.h
> > @@ -31,6 +31,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/videodev2.h>
> >  #include <linux/wait.h>
> > +#include <linux/mm_types.h>
> 
> Could you please make sure the headers are sorted alphabetically ?

I normally do. Sorry for missing it this time.

> Would you like me to take the patch in my tree ? If so I'll sort the headers 
> myself.

Yes, that would be nice, thanks!

	Arnd
