Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45670 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZJTM3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 08:29:52 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>,
	"santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>
CC: "todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 20 Oct 2009 17:59:42 +0530
Subject: RE: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DDF23F62@dbde02.ent.ti.com>
References: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com>
 <87skdk7aul.fsf@deeprootsystems.com>
In-Reply-To: <87skdk7aul.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 16, 2009 at 00:17:46, Kevin Hilman wrote:
> <santiago.nunez@ridgerun.com> writes:
>
> > From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> >
> > This patch provides support for TVP7002 in architecture definitions
> > within DM365.
> >
> > Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> > ---
> >  arch/arm/mach-davinci/board-dm365-evm.c |  170 ++++++++++++++++++++++++++++++-
> >  1 files changed, 166 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> > index a1d5e7d..6c544d3 100644
> > --- a/arch/arm/mach-davinci/board-dm365-evm.c
> > +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> > @@ -38,6 +38,11 @@
> >  #include <mach/common.h>
> >  #include <mach/mmc.h>
> >  #include <mach/nand.h>
> > +#include <mach/gpio.h>
> > +#include <linux/videodev2.h>
> > +#include <media/tvp514x.h>
> > +#include <media/tvp7002.h>
> > +#include <media/davinci/videohd.h>
> >
> >
> >  static inline int have_imager(void)
> > @@ -48,8 +53,11 @@ static inline int have_imager(void)
> >
> >  static inline int have_tvp7002(void)
> >  {
> > -   /* REVISIT when it's supported, trigger via Kconfig */
> > +#ifdef CONFIG_VIDEO_TVP7002
> > +   return 1;
> > +#else
> >     return 0;
> > +#endif
>
> I've said this before, but I'll say it again.  I don't like the
> #ifdef-on-Kconfig-option here.
>
> Can you add a probe hook to the platform_data so that when the tvp7002
> is found it can call pdata->probe() which could then set a flag
> for use by have_tvp7002().
>
> This will have he same effect without the ifdef since if the driver
> is not compiled in, its probe can never be triggered.

But this wouldn't work when TVP7002 is built as a module. Correct?
The current patch does not take care of the module case as well.

Patch 6/6 of this series does seem to make the TVP7002 driver available
as module.

Thanks,
Sekhar
