Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 7 Jan 2009 08:39:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Message-ID: <20090107083931.226e1898@pedra.chehab.org>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403ECEDD702@dbde02.ent.ti.com>
References: <20090107075832.4889c816@pedra.chehab.org>
	<19F8576C6E063C45BE387C64729E739403ECEDD702@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter Card
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

On Wed, 7 Jan 2009 15:51:53 +0530
"Hiremath, Vaibhav" <hvaibhav@ti.com> wrote:


> [Hiremath, Vaibhav] Mauro, the Daughter card not only supports TVP1546/sensor but also supports USB EHCI. So this driver may not be fit into V4L driver. Daughter card driver (board-omap3evm-dc.c) only does basic initialization which happens during arch_init. The underneath V4L drivers are omap34xxcam.c (drivers/media/video) and TVP514x.c (drivers/media/video).

Understood. This makes things a little more complicated. I suggest then to
split the V4L specific part into a separate file, in order to allow a better
maintenance (something like board-omap3evm-dc-v4l.c), since I'd like to review
the changes there.
> 
> > > +/* include V4L2 camera driver related header file */
> > > +#if defined(CONFIG_VIDEO_OMAP3) ||
> > defined(CONFIG_VIDEO_OMAP3_MODULE)
> > > +#include <../drivers/media/video/omap34xxcam.h>
> > > +#include <../drivers/media/video/isp/ispreg.h>
> > > +#endif				/* #ifdef CONFIG_VIDEO_OMAP3 */
> > > +#endif				/* #ifdef CONFIG_VIDEO_TVP514X*/
> > 
> > Please, don't use ../* at your includes. IMO, the better is to
> > create a
> > drivers/media/video/omap dir, and put omap2/omap3 files there,
> > including board-omap3evm-dc.c.
> > This will avoid those ugly includes.
> > 
> [Hiremath, Vaibhav] I do agree with this. I have mentioned this in my TODO list.

A cleaner solution is to add something like this at the Makefile:

EXTRA_CFLAGS += -Idrivers/media/video
EXTRA_CFLAGS += -Idrivers/media/video/isp

Then, all you need to do is to use:

#include <omap34xxcam.h>
#include <ispreg.h>

> 
> > Btw, drivers/media/video/isp/ currently doesn't exist. Please submit
> > the patch for it first.
> > 
> [Hiremath, Vaibhav] Following up with Sergio on this, and soon will be available.

Ok, thanks.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
