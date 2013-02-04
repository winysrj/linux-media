Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2359 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3BDIep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 03:34:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [RFC PATCH 04/18] tlg2300: remove ioctls that are invalid for radio devices.
Date: Mon, 4 Feb 2013 09:34:36 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <fa815493501dbc166181e228f66319ac3398cd2c.1359627298.git.hans.verkuil@cisco.com> <510F3620.2040004@gmail.com>
In-Reply-To: <510F3620.2040004@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302040934.36150.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 4 2013 05:16:32 Huang Shijie wrote:
> 于 2013年01月31日 05:25, Hans Verkuil 写道:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > The input and audio ioctls are only valid for video/vbi nodes.
> 
> I remember that if you do not set these ioctrls, the mplayer will not works.

I have no problem with using mplayer for radio devices without those ioctls.

Regards,

	Hans

> 
> I can not download the mplayer in my home, so i can not test it.
> I will test it in my office.
> 
> thanks
> Huang Shijie
> 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/usb/tlg2300/pd-radio.c |   27 ---------------------------
> >  1 file changed, 27 deletions(-)
> >
> > diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> > index c4feffb..4c76e089 100644
> > --- a/drivers/media/usb/tlg2300/pd-radio.c
> > +++ b/drivers/media/usb/tlg2300/pd-radio.c
> > @@ -350,36 +350,9 @@ static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
> >  {
> >  	return vt->index > 0 ? -EINVAL : 0;
> >  }
> > -static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *va)
> > -{
> > -	return (va->index != 0) ? -EINVAL : 0;
> > -}
> > -
> > -static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
> > -{
> > -	a->index    = 0;
> > -	a->mode    = 0;
> > -	a->capability = V4L2_AUDCAP_STEREO;
> > -	strcpy(a->name, "Radio");
> > -	return 0;
> > -}
> > -
> > -static int vidioc_s_input(struct file *filp, void *priv, u32 i)
> > -{
> > -	return (i != 0) ? -EINVAL : 0;
> > -}
> > -
> > -static int vidioc_g_input(struct file *filp, void *priv, u32 *i)
> > -{
> > -	return (*i != 0) ? -EINVAL : 0;
> > -}
> >  
> >  static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
> >  	.vidioc_querycap    = vidioc_querycap,
> > -	.vidioc_g_audio     = vidioc_g_audio,
> > -	.vidioc_s_audio     = vidioc_s_audio,
> > -	.vidioc_g_input     = vidioc_g_input,
> > -	.vidioc_s_input     = vidioc_s_input,
> >  	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
> >  	.vidioc_querymenu   = tlg_fm_vidioc_querymenu,
> >  	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,
> 
