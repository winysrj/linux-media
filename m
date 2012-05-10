Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:7141 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2EJI2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:28:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFCv1 PATCH 2/5] v4l2-dev/ioctl: determine the valid ioctls upfront.
Date: Thu, 10 May 2012 10:27:38 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com> <4FAB77ED.9000105@redhat.com>
In-Reply-To: <4FAB77ED.9000105@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205101027.38882.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 10 May 2012 10:10:21 Hans de Goede wrote:
> Hi,
> 
> Comments inline.
> 
> On 05/10/2012 09:05 AM, Hans Verkuil wrote:
> > From: Hans Verkuil<hans.verkuil@cisco.com>
> >
> > Rather than testing whether an ioctl is implemented in the driver or not
> > every time the ioctl is called, do it upfront when the device is registered.
> >
> > This also allows a driver to disable certain ioctls based on the capabilities
> > of the detected board, something you can't do today without creating separate
> > v4l2_ioctl_ops structs for each new variation.
> >
> > For the most part it is pretty straightforward, but for control ioctls a flag
> > is needed since it is possible that you have per-filehandle controls, and that
> > can't be determined upfront of course.
> >
> > Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> > ---
> >   drivers/media/video/v4l2-dev.c   |  171 +++++++++++++++++
> >   drivers/media/video/v4l2-ioctl.c |  391 +++++++++++---------------------------
> >   include/media/v4l2-dev.h         |   11 ++
> >   3 files changed, 297 insertions(+), 276 deletions(-)
> >

...

> > diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> > index 3f34098..21da16d 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -526,19 +518,28 @@ static long __video_do_ioctl(struct file *file,
> >   		return ret;
> >   	}
> >
> > -	if ((vfd->debug&  V4L2_DEBUG_IOCTL)&&
> > -				!(vfd->debug&  V4L2_DEBUG_IOCTL_ARG)) {
> > -		v4l_print_ioctl(vfd->name, cmd);
> > -		printk(KERN_CONT "\n");
> > -	}
> > -
> >   	if (test_bit(V4L2_FL_USES_V4L2_FH,&vfd->flags)) {
> >   		vfh = file->private_data;
> >   		use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO,&vfd->flags);
> > +		if (use_fh_prio)
> > +			ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
> >   	}
> >
> > -	if (use_fh_prio)
> > -		ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
> > +	if (v4l2_is_valid_ioctl(cmd)) {
> 
> I would prefer for this check to be the first check in the function
> in the form of:
> 
> 	if (!v4l2_is_valid_ioctl(cmd))
> 		return -ENOTTY;
> 
> This will drop an indentation level from the code below and also drop an
> indentation level from the prio check introduced in a later patch,
> making the end result much more readable IMHO.

Ah, no. That's why I renamed v4l2_is_valid_ioctl to v4l2_is_known_ioctl in my
new ioctlv2 branch. v4l2_is_known_ioctl means whether it is a known, standard
v4l2 ioctl. If it is, then it is handled by the table, if it isn't, then it
will be handled by the vidioc_default callback.

I realized myself that that name was very ambiguous.

> 
> > +		struct v4l2_ioctl_info *info =&v4l2_ioctls[_IOC_NR(cmd)];
> > +
> > +		if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls)) {
> > +			if (!(info->flags&  INFO_FL_CTRL) ||
> > +			    !(vfh&&  vfh->ctrl_handler))
> > +				return -ENOTTY;
>  > +		}
>  > +	}
> 
> Sort of hard to read, IMHO the below is easier to parse by us humans:
> 
> 	if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls) &&
> 	    !((info->flags & INFO_FL_CTRL) && vfh && vfh->ctrl_handler))
> 		return -ENOTTY;

Yeah, I agree. That's better.

Regards,

	Hans
