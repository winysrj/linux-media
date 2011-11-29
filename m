Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab1K2Xo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 18:44:29 -0500
Date: Wed, 30 Nov 2011 00:44:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Lei Wen <adrian.wenl@gmail.com>
cc: Lei Wen <leiwen@marvell.com>, linux-media@vger.kernel.org,
	jqsu@marvell.com, qingx@marvell.com, fswu@marvell.com,
	twang13@marvell.com, ytang5@marvell.com, wwang27@marvell.com,
	wzhu10@marvell.com
Subject: Re: [PATCH] [media] V4L: soc-camera: change order of removing device
In-Reply-To: <CALZhoSR6+E41KsJL6ChbF26y4nRR+TXEOHk8HPnvxiYnuC=fGA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1111300038550.23114@axis700.grange>
References: <1321970669-23423-1-git-send-email-leiwen@marvell.com>
 <CALZhoSR6+E41KsJL6ChbF26y4nRR+TXEOHk8HPnvxiYnuC=fGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lei

On Tue, 29 Nov 2011, Lei Wen wrote:

> Hi,
> 
> On Tue, Nov 22, 2011 at 10:04 PM, Lei Wen <leiwen@marvell.com> wrote:
> > As our general practice, we use stream off before we close
> > the video node. So that the drivers its stream off function
> > would be called before its remove function.
> >
> > But for the case for ctrl+c, the program would be force closed.
> > We have no chance to call that vb2 stream off from user space,
> > but directly call the remove function in soc_camera.
> >
> > In that common code of soc_camera:
> >
> >                ici->ops->remove(icd);
> >                if (ici->ops->init_videobuf2)
> >                        vb2_queue_release(&icd->vb2_vidq);
> >
> > It would first call the device remove function, then release vb2,
> > in which stream off function is called. Thus it create different
> > order for the driver.
> >
> > This patch change the order to make driver see the same sequence
> > to make it happy.

This is a change, that would affect all soc-camera host drivers. Since you 
don't describe the actual problem and the platform, on which it occurs, I 
suppose, it is not a regression, and, possibly, it only affects an 
off-tree driver from your employer. Therefore I don't think it would be 
reasonable to push it in the middle of an -rc* period. Still, this change 
seems logical, and I'll consider including it in the 3.3 kernel. I'll come 
back to you if I have further questions.

Thanks
Guennadi

> >
> > Signed-off-by: Lei Wen <leiwen@marvell.com>
> > ---
> >  drivers/media/video/soc_camera.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index b72580c..fdc6167 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -600,9 +600,9 @@ static int soc_camera_close(struct file *file)
> >                pm_runtime_suspend(&icd->vdev->dev);
> >                pm_runtime_disable(&icd->vdev->dev);
> >
> > -               ici->ops->remove(icd);
> >                if (ici->ops->init_videobuf2)
> >                        vb2_queue_release(&icd->vb2_vidq);
> > +               ici->ops->remove(icd);
> >
> >                soc_camera_power_off(icd, icl);
> >        }
> > --
> > 1.7.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Any comments?
> 
> Thanks,
> Lei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
