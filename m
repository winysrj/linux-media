Return-path: <video4linux-list-bounces@redhat.com>
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 7 Jan 2009 15:51:53 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403ECEDD702@dbde02.ent.ti.com>
In-Reply-To: <20090107075832.4889c816@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter Card
 Support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> Sent: Wednesday, January 07, 2009 3:29 PM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; video4linux-list@redhat.com; linux-
> media@vger.kernel.org
> Subject: Re: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter
> Card Support
> 
> On Wed,  7 Jan 2009 11:37:50 +0530
> hvaibhav@ti.com wrote:
> 
> >  arch/arm/mach-omap2/Kconfig             |    4 +
> >  arch/arm/mach-omap2/Makefile            |    1 +
> >  arch/arm/mach-omap2/. |  417 +++++++++++++++++++++++++++++++
> >  arch/arm/mach-omap2/board-omap3evm-dc.h |   43 ++++
> >  arch/arm/mach-omap2/mux.c               |    7 +
> >  arch/arm/plat-omap/include/mach/mux.h   |    4 +
> 
> 
> > +#if defined(CONFIG_VIDEO_TVP514X) ||
> defined(CONFIG_VIDEO_TVP514X_MODULE)
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-int-device.h>
> > +#include <media/tvp514x.h>
> 
> This smells like a V4L driver, not an arch driver.
> We shoud take some care here, to avoid having the drivers on wrong
> place.
> The proper place on kernel tree for V4L driver is under
> drivers/media/video,
> not under arch/arm. All other architecture-specific V4L drivers are
> there.
> 
[Hiremath, Vaibhav] Mauro, the Daughter card not only supports TVP1546/sensor but also supports USB EHCI. So this driver may not be fit into V4L driver. Daughter card driver (board-omap3evm-dc.c) only does basic initialization which happens during arch_init. The underneath V4L drivers are omap34xxcam.c (drivers/media/video) and TVP514x.c (drivers/media/video).

> > +/* include V4L2 camera driver related header file */
> > +#if defined(CONFIG_VIDEO_OMAP3) ||
> defined(CONFIG_VIDEO_OMAP3_MODULE)
> > +#include <../drivers/media/video/omap34xxcam.h>
> > +#include <../drivers/media/video/isp/ispreg.h>
> > +#endif				/* #ifdef CONFIG_VIDEO_OMAP3 */
> > +#endif				/* #ifdef CONFIG_VIDEO_TVP514X*/
> 
> Please, don't use ../* at your includes. IMO, the better is to
> create a
> drivers/media/video/omap dir, and put omap2/omap3 files there,
> including board-omap3evm-dc.c.
> This will avoid those ugly includes.
> 
[Hiremath, Vaibhav] I do agree with this. I have mentioned this in my TODO list.

> Btw, drivers/media/video/isp/ currently doesn't exist. Please submit
> the patch for it first.
> 
[Hiremath, Vaibhav] Following up with Sergio on this, and soon will be available.

> Cheers,
> Mauro


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
