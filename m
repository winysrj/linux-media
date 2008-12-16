Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGA9XO3016742
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 05:09:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBGA9EKr026526
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 05:09:15 -0500
Date: Tue, 16 Dec 2008 11:09:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <ud4fsh3h6.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812161051240.5450@axis700.grange>
References: <uk5a0hna0.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812160904131.4630@axis700.grange>
	<uej08h569.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812161001000.4630@axis700.grange>
	<ud4fsh3h6.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add tw9910 driver
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

Mauro, please, see below.

On Tue, 16 Dec 2008, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi
> 
> > > Sorry I forget to tell you about this.
> > > I tried it.
> > > but pix->field was V4L2_FIELD_NONE when tw9910_try_fmt was 1st called.
> > 
> > Yes, that's fine. This depends on your application - whatever you use. And 
> > I would expect, if you first return -EINVAL in reply to FIELD_NONE, the 
> > application then will try either ANY or INTERLACED, and you will get a 
> > chance to select a suitable field.
> 
> really ???
> Now I'm using mplayer.
> but mplayer doesn't try ANY or INTERLACED.
> 
> And if try_fmt return -EINVAL, mplayer will just finish.
> 
> Is mplayer's option wrong ?
> 
> --------------
> > VGA="-tv width=640:height=480 -zoom -x 320 -y 240"
> > VIDIX="-vo fbdev:vidix:sh_veu"
> > OUT="tv://"
> > NTSC="-tv norm=NTSC"
> 
> > mplayer ${VIDIX} ${VGA} ${NTSC} ${OUT}
> --------------
> 
> answer of mplayer.
> (try_fmt return -EINVAL when field is NONE)
> 
> --------------
> MPlayer dev-SVN-r27776-4.2-SH4-LINUX_v0701 (C) 2000-2008 MPlayer Team
> 
> Playing tv://.
> TV file format detected.camera 0-0: SuperH Mobile CEU driver attached to camera 0
> 
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> Selected device: SuperH_
> Mobile_CEU
>  Capcamera 0-0: SuperH Mobile CEU driver detached from camera 0
> abilites:  video capture  streaming
>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = PAL; 5 = PAL-BG; 6 = PAL-H; 7 = PAL-I; 8 = PAL-DK;
>  inputs: 0 = Video;
>  Current input: 0
>  Current format: NV12
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set mute failed: Invalid argument
> v4l2: 0 frames successfully processed, 0 frames dropped.
> --------------

Cannot say for sure, but here is a code snippet from some random mplayer 
version I have here (some 1.0-rc2):

    case TVI_CONTROL_VID_SET_FORMAT:
        if (getfmt(priv) < 0) return TVI_CONTROL_FALSE;
        priv->format.fmt.pix.pixelformat = fcc_mp2vl(*(int *)arg);
        priv->format.fmt.pix.field = V4L2_FIELD_ANY;
            
        priv->mp_format = *(int *)arg;
        mp_msg(MSGT_TV, MSGL_V, "%s: set format: %s\n", info.short_name,
               pixfmt2name(priv->format.fmt.pix.pixelformat));
        if (ioctl(priv->video_fd, VIDIOC_S_FMT, &priv->format) < 0) {
            mp_msg(MSGT_TV, MSGL_ERR, "%s: ioctl set format failed: %s\n",
                   info.short_name, strerror(errno));
            return TVI_CONTROL_FALSE;
        }
        /* according to the v4l2 specs VIDIOC_S_FMT should not fail, inflexible drivers
          might even always return the default parameters -> update the format here*/
        priv->mp_format = fcc_vl2mp(priv->format.fmt.pix.pixelformat);
        return TVI_CONTROL_TRUE;

so, here it is trying ANY... OTOH, the comment above says the driver 
shouldn't fail this call, and http://v4l2spec.bytesex.org/spec/r10944.htm 
confirms that. Which also means, that vivi.c does it wrongly. Mauro, you 
are listed as one of the authors of vivi.c, and it looks like calling 
S_FMT on it with field != ANY && field != INTERLACED will produce -EINVAL, 
which seems to contradict the API. What is the correct behavious? Is this 
a bug in vivi.c?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
