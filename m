Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26338 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbeDEN0i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 09:26:38 -0400
Date: Thu, 5 Apr 2018 16:25:59 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH] media: v4l2-dev: use pr_foo() for printing messages
Message-ID: <20180405132559.bj5z3kwpkgmdl52a@paasikivi.fi.intel.com>
References: <3cead57d0a484bf589f4da3b86f4470cde6a1480.1522924475.git.mchehab@s-opensource.com>
 <20180405111210.5jh77oke35uyg3yj@valkosipuli.retiisi.org.uk>
 <20180405085202.0fd39f0b@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405085202.0fd39f0b@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Apr 05, 2018 at 08:52:02AM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 5 Apr 2018 14:12:10 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Thu, Apr 05, 2018 at 07:34:39AM -0300, Mauro Carvalho Chehab wrote:
> > > Instead of using printk() directly, use the pr_foo()
> > > macros.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > ---
> > >  drivers/media/v4l2-core/v4l2-dev.c | 45 ++++++++++++++++++++++----------------
> > >  1 file changed, 26 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> > > index 1d0b2208e8fb..530db8e482fb 100644
> > > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > > @@ -16,6 +16,8 @@
> > >   *		- Added procfs support
> > >   */
> > >  
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > >  #include <linux/module.h>
> > >  #include <linux/types.h>
> > >  #include <linux/kernel.h>
> > > @@ -34,6 +36,12 @@
> > >  #define VIDEO_NUM_DEVICES	256
> > >  #define VIDEO_NAME              "video4linux"
> > >  
> > > +#define dprintk(fmt, arg...) do {					\
> > > +		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
> > > +		       __func__, ##arg);				\
> > > +} while (0)  
> > 
> > Any particular reason for introducing a new macro rather than using
> > pr_debug()? I know it's adding the name of the function without requiring
> > to explicitly add that below, but pr_debug("%s: ...", __func__); would be
> > easier to read IMO.
> 
> Yes, there is. Nowadays, most systems are built with CONFIG_DYNAMIC_DEBUG,
> as it is default on most distros.
> 
> It means that, in order to enable a debug message, one has to
> explicitly enable the debug messages via /sys/kernel/debug/dynamic_debug.
> 
> In the case of videodev core, the debug messages are enabled, instead,
> via vdev->dev_debug. It is really messy to have both mechanisms at the
> same time to enable a debug message. We need to use either one or the
> other.
> 
> Also, a change from vdev->dev_debug approach to dynamic_debug approach
> is something that should happen at the entire subsystem.
> 
> Even if this is a good idea (I'm not convinced), this should be
> done on a separate patch series.

Fair enough. Please add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
