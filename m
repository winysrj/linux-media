Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37820 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab1H2PTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 11:19:47 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Netagunte, Nagabhushana" <nagabhushana.netagunte@ti.com>
Date: Mon, 29 Aug 2011 20:49:30 +0530
Subject: RE: [RFC PATCH 1/8] davinci: vpfe: add dm3xx IPIPEIF hardware
 support module
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025729ADDF@dbde02.ent.ti.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <1309439597-15998-2-git-send-email-manjunath.hadli@ti.com>
 <20110713185050.GC27451@valkosipuli.localdomain>
In-Reply-To: <20110713185050.GC27451@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Sakari,
	I have sent a fresh patch-set with your comments  fixed and and some cleanup and reorg of my own- mainly the headers. Please review.

Also, I had to keep one of your comments without code change as I felt it was Ok to keep it here as it is only a local variable which actually gets the info from the device specific data structures. I removed the other however.

Looking forward for your comments on further patches as well.

-Manju


On Thu, Jul 14, 2011 at 00:20:50, Sakari Ailus wrote:
> Hi Manju,
> 
> Thanks for the patchset!
> 
> I have a few comments on this patch below. I haven't read the rest of the patches yet so I may have more comments on this one when I do that.
> 
> On Thu, Jun 30, 2011 at 06:43:10PM +0530, Manjunath Hadli wrote:
> > add support for dm3xx IPIPEIF hardware setup. This is the lowest 
> > software layer for the dm3x vpfe driver which directly accesses 
> > hardware. Add support for features like default pixel correction, dark 
> > frame substraction  and hardware setup.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
> > ---
> >  drivers/media/video/davinci/dm3xx_ipipeif.c |  368 +++++++++++++++++++++++++++
> >  include/media/davinci/dm3xx_ipipeif.h       |  292 +++++++++++++++++++++
> >  2 files changed, 660 insertions(+), 0 deletions(-)  create mode 
> > 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
> >  create mode 100644 include/media/davinci/dm3xx_ipipeif.h
> > 
> > diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.c 
> > b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > new file mode 100644
> > index 0000000..36cb61b
> > --- /dev/null
> > +++ b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > @@ -0,0 +1,368 @@
---code----
> > +#include <linux/kernel.h> #include <linux/platform_device.h> #include 
> > +<linux/uaccess.h> #include <linux/io.h> #include 
> > +<linux/v4l2-mediabus.h> #include <media/davinci/dm3xx_ipipeif.h>
> > +
> > +#define DM355	0
> > +#define DM365	1
> > +
> > +static void *__iomem ipipeif_base_addr;
> 
> This looks device specific. What about using dev_set/get_drvdata and remove this one?
This one is actually gotten from the platform data structure in the manner you suggested but stored here for local usage.
> 
> > +static int device_type;
> 
> Ditto. Both should be in a device specific struct.
This one I have removed.
> 
> > +static inline u32 regr_if(u32 offset) {
> > +	return readl(ipipeif_base_addr + offset); }
> > +
> > +static inline void regw_if(u32 val, u32 offset) {
> > +	writel(val, ipipeif_base_addr + offset); }
