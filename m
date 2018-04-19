Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35055 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeDSKmi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 06:42:38 -0400
Date: Thu, 19 Apr 2018 07:42:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Remaining COMPILE_TEST and smatch cleanups
Message-ID: <20180419074228.3c642240@vento.lan>
In-Reply-To: <20180418090414.6h5q3zfm3udzscd7@valkosipuli.retiisi.org.uk>
References: <cover.1523960171.git.mchehab@s-opensource.com>
        <20180418090414.6h5q3zfm3udzscd7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Apr 2018 12:04:14 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Tue, Apr 17, 2018 at 06:20:10AM -0400, Mauro Carvalho Chehab wrote:
> > There were several interactions at the COMPILE_TEST and smatch
> > patch series. While I applied most of them, there are 5 patches that
> > I kept out of it. The omap3 patch that were in my tree was the old
> > one. So, I'm re-posting it.
> > 
> > The ioctl32 patches are the latest version. Let's repost it to get some
> > acks, as this patch touches at V4L2 core, so a careful review is
> > always a good idea.
> > 
> > Arnd Bergmann (1):
> >   media: omap3isp: allow it to build with COMPILE_TEST
> > 
> > Laurent Pinchart (1):
> >   media: omap3isp: Enable driver compilation on ARM with COMPILE_TEST
> > 
> > Mauro Carvalho Chehab (3):
> >   omap: omap-iommu.h: allow building drivers with COMPILE_TEST
> >   media: v4l2-compat-ioctl32: fix several __user annotations
> >   media: v4l2-compat-ioctl32: better name userspace pointers
> > 
> >  drivers/media/platform/Kconfig                |   7 +-
> >  drivers/media/platform/omap3isp/isp.c         |   8 +
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 623 +++++++++++++-------------
> >  include/linux/omap-iommu.h                    |   5 +
> >  4 files changed, 338 insertions(+), 305 deletions(-)  
> 
> For patches 1 and 2:
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

What about patch 3?

> 
> I'd like to see a new versions of patches 4 and 5; I agree on the naming
> change.

With what changes?

> Could you set the To: header to a valid value going forward? It's not a
> valid e-mail address but still contains "<" character which causes trouble
> when replying to the patches.

I've no idea how to fix it. When I submit patches, I don't add any To:
header (as the "to" is meant to be the one that will apply the patches...
sending an e-mail to myself seems too mad for my taste). Somewhere
between git-send-email, my SMTP local host or the SMTP smart gateway,
or something afterwards, a "fake" To: gets introduced.


Thanks,
Mauro
