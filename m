Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50147 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1HaLX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 07:23:28 -0400
Date: Wed, 31 Aug 2011 14:23:23 +0300
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Netagunte, Nagabhushana" <nagabhushana.netagunte@ti.com>
Subject: Re: [RFC PATCH 1/8] davinci: vpfe: add dm3xx IPIPEIF hardware
 support module
Message-ID: <20110831112323.GL12368@valkosipuli.localdomain>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <1309439597-15998-2-git-send-email-manjunath.hadli@ti.com>
 <20110713185050.GC27451@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593025729ADDF@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593025729ADDF@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2011 at 08:49:30PM +0530, Hadli, Manjunath wrote:
> 
> Sakari,

Hi Manju,

> 	I have sent a fresh patch-set with your comments  fixed and and some
> cleanup and reorg of my own- mainly the headers. Please review.

I'll try to review at the patches when I have time.

> Also, I had to keep one of your comments without code change as I felt it
> was Ok to keep it here as it is only a local variable which actually gets
> the info from the device specific data structures. I removed the other
> however.
> 
> Looking forward for your comments on further patches as well.
> 
> -Manju
> 
> 
> On Thu, Jul 14, 2011 at 00:20:50, Sakari Ailus wrote:
> > Hi Manju,
> > 
> > Thanks for the patchset!
> > 
> > I have a few comments on this patch below. I haven't read the rest of the patches yet so I may have more comments on this one when I do that.
> > 
> > On Thu, Jun 30, 2011 at 06:43:10PM +0530, Manjunath Hadli wrote:
> > > add support for dm3xx IPIPEIF hardware setup. This is the lowest 
> > > software layer for the dm3x vpfe driver which directly accesses 
> > > hardware. Add support for features like default pixel correction, dark 
> > > frame substraction  and hardware setup.
> > > 
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
> > > ---
> > >  drivers/media/video/davinci/dm3xx_ipipeif.c |  368 +++++++++++++++++++++++++++
> > >  include/media/davinci/dm3xx_ipipeif.h       |  292 +++++++++++++++++++++
> > >  2 files changed, 660 insertions(+), 0 deletions(-)  create mode 
> > > 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
> > >  create mode 100644 include/media/davinci/dm3xx_ipipeif.h
> > > 
> > > diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.c 
> > > b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > > new file mode 100644
> > > index 0000000..36cb61b
> > > --- /dev/null
> > > +++ b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > > @@ -0,0 +1,368 @@
> ---code----
> > > +#include <linux/kernel.h> #include <linux/platform_device.h> #include 
> > > +<linux/uaccess.h> #include <linux/io.h> #include 
> > > +<linux/v4l2-mediabus.h> #include <media/davinci/dm3xx_ipipeif.h>
> > > +
> > > +#define DM355	0
> > > +#define DM365	1
> > > +
> > > +static void *__iomem ipipeif_base_addr;
> > 
> > This looks device specific. What about using dev_set/get_drvdata and remove this one?
> This one is actually gotten from the platform data structure in the manner you suggested but stored here for local usage.

You always will get this pointer from other sources, and it will be the
pointer to the very device you will be accessing. Look at the OMAP 3 ISP
driver, for example: there are no such static variables.

Basically keeping this in a static variable which is specific to a driver
rather than the device is just wrong.

-- 
Sakari Ailus
sakari.ailus@iki.fi
