Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1659 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3AWHXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 02:23:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] v4l2-core: do not enable the buffer ioctls for radio devices
Date: Wed, 23 Jan 2013 08:22:42 +0100
Cc: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, Mike Isely <isely@isely.net>
References: <1358884315-2810-1-git-send-email-fschaefer.oss@googlemail.com> <20130122201450.2f337ee1@sabia.mchehab>
In-Reply-To: <20130122201450.2f337ee1@sabia.mchehab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301230822.42054.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue January 22 2013 23:14:50 Mauro Carvalho Chehab wrote:
> Em Tue, 22 Jan 2013 20:51:55 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> 
> > The buffer ioctls (VIDIOC_REQBUFS, VIDIOC_QUERYBUF, VIDIOC_QBUF, VIDIOC_DQBUF,
> > VIDIOC_EXPBUF, VIDIOC_CREATE_BUFS, VIDIOC_PREPARE_BUF) are not applicable for
> > radio devices. Hence, they should be set valid only for non-radio devices in
> > determine_valid_ioctls().
> 
> Hmm... wouldn't it could break or cause regressions to pvrusb2 (and cx18/ivtv?)?

cx18/ivtv do not stream audio over the radio node, they have a specialized video
device for that (and these days an alsa driver as well).

pvrusb2 does stream over the radio node, but only using read(). It doesn't use the
stream I/O ioctls at all.

So I'm giving this patch my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Regards,
> Mauro
> > 
> > Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-dev.c |   14 +++++++-------
> >  1 Datei geändert, 7 Zeilen hinzugefügt(+), 7 Zeilen entfernt(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> > index 98dcad9..51b3a77 100644
> > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > @@ -568,11 +568,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
> >  	if (ops->vidioc_s_priority ||
> >  			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
> >  		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
> > -	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
> > -	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
> > -	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
> > -	SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
> > -	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
> >  	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
> >  	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
> >  	/* Note: the control handler can also be passed through the filehandle,
> > @@ -605,8 +600,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
> >  	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
> >  	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
> >  	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
> > -	SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
> > -	SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
> >  	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
> >  		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
> >  
> > @@ -672,6 +665,13 @@ static void determine_valid_ioctls(struct video_device *vdev)
> >  	}
> >  	if (!is_radio) {
> >  		/* ioctls valid for video or vbi */
> > +		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
> > +		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
> > +		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
> > +		SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
> > +		SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
> > +		SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
> > +		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
> >  		if (ops->vidioc_s_std)
> >  			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
> >  		if (ops->vidioc_g_std || vdev->current_norm)
> 
> 
> 
> 
> Cheers,
> Mauro
> 
