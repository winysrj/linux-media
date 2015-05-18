Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsec101.isp.belgacom.be ([195.238.20.97]:61615 "EHLO
	mailsec101.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbbERSbm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 14:31:42 -0400
Date: Mon, 18 May 2015 20:31:40 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org,
	Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <1601184049.17932.1431973900041.open-xchange@webmail.nmp.proximus.be>
In-Reply-To: <555A2D88.7070808@linaro.org>
References: <1431971658-20986-1-git-send-email-fabf@skynet.be> <555A2D88.7070808@linaro.org>
Subject: Re: [PATCH 1/1 linux-next] omap_vout: use swap() in omapvid_init()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> On 18 May 2015 at 20:20 Vaibhav Hiremath <vaibhav.hiremath@linaro.org> wrote:
>
>
>
>
> On Monday 18 May 2015 11:24 PM, Fabian Frederick wrote:
> > Use kernel.h macro definition.
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >   drivers/media/platform/omap/omap_vout.c | 10 +++-------
> >   1 file changed, 3 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/media/platform/omap/omap_vout.c
> > b/drivers/media/platform/omap/omap_vout.c
> > index 17b189a..f09c5f1 100644
> > --- a/drivers/media/platform/omap/omap_vout.c
> > +++ b/drivers/media/platform/omap/omap_vout.c
> > @@ -445,7 +445,7 @@ static int omapvid_init(struct omap_vout_device *vout,
> > u32 addr)
> >     int ret = 0, i;
> >     struct v4l2_window *win;
> >     struct omap_overlay *ovl;
> > -   int posx, posy, outw, outh, temp;
> > +   int posx, posy, outw, outh;
> >     struct omap_video_timings *timing;
> >     struct omapvideo_info *ovid = &vout->vid_info;
> >
> > @@ -468,9 +468,7 @@ static int omapvid_init(struct omap_vout_device *vout,
> > u32 addr)
> >                     /* Invert the height and width for 90
> >                      * and 270 degree rotation
> >                      */
> > -                   temp = outw;
> > -                   outw = outh;
> > -                   outh = temp;
> > +                   swap(outw, outh);
> >                     posy = (timing->y_res - win->w.width) - win->w.left;
> >                     posx = win->w.top;
> >                     break;
> > @@ -481,9 +479,7 @@ static int omapvid_init(struct omap_vout_device *vout,
> > u32 addr)
> >                     break;
> >
> >             case dss_rotation_270_degree:
> > -                   temp = outw;
> > -                   outw = outh;
> > -                   outh = temp;
> > +                   swap(outw, outh);
> >                     posy = win->w.left;
> >                     posx = (timing->x_res - win->w.height) - win->w.top;
> >                     break;
> >
>
>
> Curious to know,
> How do you test this? Do you have any OMAP2/3 or AM335x board?
> Does this driver still works?

Hello Vaibhav,

   Unfortunately I can't test it.
 
Regards,
Fabian
>
> Thanks,
> Vaibhav
