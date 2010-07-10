Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3754 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0GJQ3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 12:29:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v2 7/7] v4l: subdev: Generic ioctl support
Date: Sat, 10 Jul 2010 18:31:49 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com> <4C387EEE.3000108@redhat.com>
In-Reply-To: <4C387EEE.3000108@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007101831.49445.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 10 July 2010 16:08:46 Mauro Carvalho Chehab wrote:
> Em 09-07-2010 12:31, Laurent Pinchart escreveu:
> > Instead of returning an error when receiving an ioctl call with an
> > unsupported command, forward the call to the subdev core::ioctl handler.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  Documentation/video4linux/v4l2-framework.txt |    5 +++++
> >  drivers/media/video/v4l2-subdev.c            |    2 +-
> >  2 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> > index 89bd881..581e7db 100644
> > --- a/Documentation/video4linux/v4l2-framework.txt
> > +++ b/Documentation/video4linux/v4l2-framework.txt
> > @@ -365,6 +365,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
> >  	To properly support events, the poll() file operation is also
> >  	implemented.
> >  
> > +Private ioctls
> > +
> > +	All ioctls not in the above list are passed directly to the sub-device
> > +	driver through the core::ioctl operation.
> > +
> >  
> >  I2C sub-device drivers
> >  ----------------------
> > diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> > index 31bec67..ce47772 100644
> > --- a/drivers/media/video/v4l2-subdev.c
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -120,7 +120,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> >  		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
> >  
> >  	default:
> > -		return -ENOIOCTLCMD;
> > +		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> >  	}
> >  
> >  	return 0;
> 
> Hmm... private ioctls at subdev... I'm not sure if I like this idea. I prefer to merge this patch
> only after having a driver actually needing it, after discussing why not using a standard ioctl
> for that driver.

Part of the reason for making these subdev device nodes is to actually allow
private ioctls (after properly discussing it and with documentation). SoCs tend
to have a lot of very hardware specific features that do not translate to generic
ioctls. Until now these are either ignored or handled through custom drivers, but
but it is much better to handle them in a 'controlled' fashion.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
