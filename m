Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4130 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab2FDVnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 17:43:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [RFC/PATCH v2] media: Add stk1160 new driver
Date: Mon, 4 Jun 2012 23:42:58 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
References: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com> <201206041047.40804.hverkuil@xs4all.nl> <CALF0-+XZ_LTgk8n32gD7H4+dJTyxADPzs-1tw2AVjNzXU9waXg@mail.gmail.com>
In-Reply-To: <CALF0-+XZ_LTgk8n32gD7H4+dJTyxADPzs-1tw2AVjNzXU9waXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206042342.58718.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 4 2012 21:50:46 Ezequiel Garcia wrote:
> On Mon, Jun 4, 2012 at 5:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> >> Would you care to explain me this change in your patch?
> >> +       set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
> >
> > See Documentation/video4linux/v4l2-framework.txt:
> >
> > "flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the framework
> >  handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you use struct
> >  v4l2_fh. Eventually this flag will disappear once all drivers use the core
> >  priority handling. But for now it has to be set explicitly."
> >
> 
> So, by using v4l2_fh and setting V4L2_FL_USE_FH_PRIO, I can have
> {g,s}_priority ioctls for free, right?

Yes.

> As far as I can see __video_do_ioctl checks if the ioctl is possible, like this:
> 
>  520     if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
>  521         vfh = file->private_data;
>  522         use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  523     }
>  524
>  525     if (use_fh_prio)
>  526         ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);

And V4L2_FL_USES_V4L2_FH is set by v4l2_fh_init() (called by v4l2_fh_open()).

Regards,

	Hans
