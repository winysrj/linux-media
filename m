Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2DIMLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 08:11:16 -0400
Date: Mon, 9 Apr 2012 14:11:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert <bluebellice@gmail.com>
cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Albert Wang <twang13@marvell.com>,
	Chao Xie <cxie4@marvell.com>, Kassey Lee <kassey1216@gmail.com>
Subject: Re: [PATCH 2/7] marvell-cam: Remove broken "owner" logic
In-Reply-To: <CAJ3tNouhpRvm29aFEaDVMGh1668FMVNpq0tJTySoGdm_iJtTkQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1204091353430.1002@axis700.grange>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
 <1331939696-12482-3-git-send-email-corbet@lwn.net>
 <CAJ3tNouhpRvm29aFEaDVMGh1668FMVNpq0tJTySoGdm_iJtTkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Mon, 9 Apr 2012, Albert wrote:

> Hi, Jonathan & Guennadi
> 
> I'm Albert Wang from Marvell, nice to meet you!

Nice to meet you too.

> We found there is a soc camera framework in open source, and we made a
> Marvell camera driver which based on Soc camera framework + videobuf2.
> And now it can serve several Marvell SOC chips, such as MMP2 (PXA688), MMP3
> (PXA2128) and TD (PXA910) which has same CCIC IP.
> 
> But it looks Jonathan had write a Marvell ccic camera driver based on
> café-ccic + videobuf2 for MMP2 on OLPC in open source.
> 
> So do you think it’s still OK to push our Marvell camera driver to open
> source?

A colleague of yours - Kassey Lee - has been working on this driver:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/33775

and it has been agreed, that the camera driver for PXA910 and other SoCs, 
mentioned above should re-use the same code-base, as the cafe_ccic driver 
from Jon. One of obstacles has been, that the cafe driver didn't use a 
standard videobuf scheme, implementing one of its own. Now this has been 
fixed too, the driver has also been broken down in parts to simplify such 
code re-use. All this speaks in favour of implementing your driver by 
using common parts of the marvell-ccic driver. This is also what Kassey 
has agreed to. Whether or not your new driver will be also using the 
soc-camera framework is your decision, I think, both ways are possible. 
Please, try to re-use the marvell-ccic code and report any problems.

Thanks
Guennadi

> Looking for your comments!
> Thanks a lot in advance!
> 
> Thanks
> Albert Wang
> On Sat, Mar 17, 2012 at 7:14 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> 
> > The marvell cam driver retained just enough of the owner-tracking logic
> > from cafe_ccic to be broken; it could, conceivably, cause the driver to
> > release DMA memory while the controller is still active.  Simply remove the
> > remaining pieces and ensure that the controller is stopped before we free
> > things.
> >
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > ---
> >  drivers/media/video/marvell-ccic/mcam-core.c |    5 +----
> >  drivers/media/video/marvell-ccic/mcam-core.h |    1 -
> >  2 files changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/media/video/marvell-ccic/mcam-core.c
> > b/drivers/media/video/marvell-ccic/mcam-core.c
> > index 35cd89d..b261182 100644
> > --- a/drivers/media/video/marvell-ccic/mcam-core.c
> > +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> > @@ -1564,11 +1564,8 @@ static int mcam_v4l_release(struct file *filp)
> >                        singles, delivered);
> >        mutex_lock(&cam->s_mutex);
> >        (cam->users)--;
> > -       if (filp == cam->owner) {
> > -               mcam_ctlr_stop_dma(cam);
> > -               cam->owner = NULL;
> > -       }
> >        if (cam->users == 0) {
> > +               mcam_ctlr_stop_dma(cam);
> >                mcam_cleanup_vb2(cam);
> >                mcam_ctlr_power_down(cam);
> >                if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
> > diff --git a/drivers/media/video/marvell-ccic/mcam-core.h
> > b/drivers/media/video/marvell-ccic/mcam-core.h
> > index 917200e..bd6acba 100644
> > --- a/drivers/media/video/marvell-ccic/mcam-core.h
> > +++ b/drivers/media/video/marvell-ccic/mcam-core.h
> > @@ -107,7 +107,6 @@ struct mcam_camera {
> >        enum mcam_state state;
> >        unsigned long flags;            /* Buffer status, mainly (dev_lock)
> > */
> >        int users;                      /* How many open FDs */
> > -       struct file *owner;             /* Who has data access (v4l2) */
> >
> >        /*
> >         * Subsystem structures.
> > --
> > 1.7.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
