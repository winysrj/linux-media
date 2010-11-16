Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:57314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0KPTWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 14:22:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 20:23:17 +0100
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011161749.05844.hverkuil@xs4all.nl> <201011161938.11476.hverkuil@xs4all.nl>
In-Reply-To: <201011161938.11476.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011162023.17671.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010, Hans Verkuil wrote:
> I consider class 3 unacceptable for commonly seen devices. I did a quick scan
> of the v4l drivers and the only common driver that falls in that class is uvc.

If uvc is the only important one, that should be easy enough to fix by adding
a per-device mutex around uvc_v4l2_do_ioctl() or uvc_v4l2_ioctl().

> There is one other option, although it is very dirty: don't take the lock if
> the ioctl command is VIDIOC_DQBUF. It works and reliably as well for uvc and
> videobuf (I did a quick code analysis). But I don't know if it works everywhere.
> 
> I would like to get the opinion of others before I implement such a check. But
> frankly, I think this may be our best bet.
> 
> So the patch below would look like this if I add the check:
> 
> -               mutex_lock(&v4l2_ioctl_mutex);
> +               if (cmd != VIDIOC_DQBUF)
> +                       mutex_lock(m);
>                 if (video_is_registered(vdev))
>                         ret = vdev->fops->ioctl(filp, cmd, arg);
> -               mutex_unlock(&v4l2_ioctl_mutex);
> +               if (cmd != VIDIOC_DQBUF)
> +                       mutex_unlock(m);
> 

I was thinking of this as well, but didn't bring it up because I considered
it too hacky.

The patch you posted looks good, thanks for bringing up the problem with
my patch and the solution!

Acked-by: Arnd Bergmann <arnd@arndb.de>
