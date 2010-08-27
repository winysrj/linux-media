Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55272 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0H0PfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 11:35:15 -0400
Date: Fri, 27 Aug 2010 17:35:12 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH 04/11] mt9m111: added new bit offset defines
Message-ID: <20100827153512.GA15967@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de> <1280833069-26993-5-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008271710400.28043@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008271710400.28043@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Aug 27, 2010 at 05:11:18PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> 
> > Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> I don't see these being used in any of your patches...
Yes, these are not used. They are a left over from the previous patchstack.
But they are checked against the datasheet and are correct.
Is it a problem to take them anyway?

Thanks,
Michael

> > ---
> >  drivers/media/video/mt9m111.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> > index 8c076e5..1b21522 100644
> > --- a/drivers/media/video/mt9m111.c
> > +++ b/drivers/media/video/mt9m111.c
> > @@ -63,6 +63,12 @@
> >  #define MT9M111_RESET_RESTART_FRAME	(1 << 1)
> >  #define MT9M111_RESET_RESET_MODE	(1 << 0)
> >  
> > +#define MT9M111_RM_FULL_POWER_RD	(0 << 10)
> > +#define MT9M111_RM_LOW_POWER_RD		(1 << 10)
> > +#define MT9M111_RM_COL_SKIP_4X		(1 << 5)
> > +#define MT9M111_RM_ROW_SKIP_4X		(1 << 4)
> > +#define MT9M111_RM_COL_SKIP_2X		(1 << 3)
> > +#define MT9M111_RM_ROW_SKIP_2X		(1 << 2)
> >  #define MT9M111_RMB_MIRROR_COLS		(1 << 1)
> >  #define MT9M111_RMB_MIRROR_ROWS		(1 << 0)
> >  #define MT9M111_CTXT_CTRL_RESTART	(1 << 15)
> > -- 
> > 1.7.1
> > 
> > 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
