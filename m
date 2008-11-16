Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGMNo5f027264
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 17:23:50 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGMNO7H025699
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 17:23:24 -0500
Date: Sun, 16 Nov 2008 23:23:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <874p2jlaqb.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811162320410.16868@axis700.grange>
References: <1226012656-17334-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811070040130.8681@axis700.grange>
	<874p2jlaqb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add new pixel format VYUY 16 bits wide.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 7 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

[snip]

> > So, let's just get the naming consistent. Are you also planning to update 
> > your "Add new pixel format VYUY 16 bits wide" patch as requested by Hans 
> > Verkuil? Then you could put all these patches in a patch series to make it 
> > easier to manage them:-)
> I didn't get that mail, either on direct destination or from the mailing
> list. I'll look into the archives.

Here's his mail again quoted below.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer


On Wed, 5 Nov 2008, Hans Verkuil wrote:

> On Tuesday 04 November 2008 22:59:37 Robert Jarzmik wrote:
> > There were already 3 YUV formats defined :
> >  - YUYV
> >  - YVYU
> >  - UYVY
> > The only left combination is VYUY, which is added in this
> > patch.
> > 
> > Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> It's fine by me, but since you are making a change anyway, can you move the
> V4L2_PIX_FMT_YVYU define up and put it after V4L2_PIX_FMT_YUYV? Then all
> four combinations are together.
> 
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Regards,
> 
> 	Hans
> 
> > ---
> >  include/linux/videodev2.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 4669d7e..ec311d4 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -293,6 +293,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
> >  #define V4L2_PIX_FMT_YUYV    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
> >  #define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
> > +#define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
> >  #define V4L2_PIX_FMT_YUV422P v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
> >  #define V4L2_PIX_FMT_YUV411P v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
> >  #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
> > -- 
> > 1.5.6.5
> > 
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> > 
> > 
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
