Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGMiXMB032298
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 17:44:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGMiKon032609
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 17:44:21 -0500
Date: Sun, 16 Nov 2008 23:44:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0811162338540.16868@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811162342490.16868@axis700.grange>
References: <Pine.LNX.4.64.0811162320410.16868@axis700.grange>
	<1226874785-29073-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811162338540.16868@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH v2] Add new pixel format VYUY 16 bits wide.
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

On Sun, 16 Nov 2008, Guennadi Liakhovetski wrote:

> On Sun, 16 Nov 2008, Robert Jarzmik wrote:
> 
> > There were already 3 YUV formats defined :
> >  - YUYV
> >  - YVYU
> >  - UYVY
> > The only left combination is VYUY, which is added in this
> > patch.
> > 
> > As suggested by Hans Verkuil, all YUV 4:2:2 packet formats
> > were grouped together.
> > 
> > Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> > Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> Wow, that was fast!:-) As it doesn't look like we're going to receive a 
> reply from the Linux fourcc maintainer, I'll just pull it.

Ooh... I'm too late - Mauro has already pulled your v1... Ok, then Hans 
will have to reorder them himself:-) Sorry for having wasted your time.

Thanks
Guennadi
> 
> > ---
> >  include/linux/videodev2.h |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 4669d7e..615b05f 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -292,7 +292,9 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU 4:1:0     */
> >  #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
> >  #define V4L2_PIX_FMT_YUYV    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
> > +#define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16  YVU 4:2:2     */
> >  #define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
> > +#define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
> >  #define V4L2_PIX_FMT_YUV422P v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
> >  #define V4L2_PIX_FMT_YUV411P v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
> >  #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
> > @@ -342,7 +344,6 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S', '5', '6', '1') /* compressed GBRG bayer */
> >  #define V4L2_PIX_FMT_PAC207   v4l2_fourcc('P', '2', '0', '7') /* compressed BGGR bayer */
> >  #define V4L2_PIX_FMT_PJPG     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
> > -#define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16  YVU 4:2:2     */
> >  
> >  /*
> >   *	F O R M A T   E N U M E R A T I O N
> > -- 
> > 1.5.6.5
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
