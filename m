Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37319 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbaIWXSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 19:18:45 -0400
Date: Tue, 23 Sep 2014 20:18:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] em28xx: fix VBI handling logic
Message-ID: <20140923201838.48cddea1@recife.lan>
In-Reply-To: <5421CAB2.3030804@googlemail.com>
References: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>
	<8444ab3f16a454ab8d2eaefb8990193313c2ac33.1411142521.git.mchehab@osg.samsung.com>
	<5421CAB2.3030804@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Sep 2014 21:32:02 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> 
> Am 19.09.2014 um 18:02 schrieb Mauro Carvalho Chehab:
> > When both VBI and video are streaming, and video stream is stopped,
> > a subsequent trial to restart it will fail, because S_FMT will
> > return -EBUSY.
> >
> > That prevents applications like zvbi to work properly.
> >
> > Please notice that, while this fix it fully for zvbi, the
> > best is to get rid of streaming_users and res_get logic as a hole.
> >
> > However, this single-line patch is better to be merged at -stable.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > index 08569cbccd95..d75e7f82dfb9 100644
> > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > @@ -1351,7 +1351,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> >  	struct em28xx *dev = video_drvdata(file);
> >  	struct em28xx_v4l2 *v4l2 = dev->v4l2;
> >  
> > -	if (v4l2->streaming_users > 0)
> > +	if (vb2_is_busy(&v4l2->vb_vidq))
> Looks dangerous.

Why Dangerous? 

Did you identify any problem? With what application?

Regards,
Mauro
