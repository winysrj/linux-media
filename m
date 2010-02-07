Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2627 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0BGMUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 07:20:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 4/8] V4L: Events: Support event handling in do_ioctl
Date: Sun, 7 Feb 2010 13:22:42 +0100
Cc: linux-media@vger.kernel.org, hans.verkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com, iivanov@mm-sol.com
References: <4B6DAE5A.5090508@maxwell.research.nokia.com> <1265479331-20595-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <4B6EAED0.4060304@maxwell.research.nokia.com>
In-Reply-To: <4B6EAED0.4060304@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002071322.42556.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 07 February 2010 13:15:12 Sakari Ailus wrote:
> Sakari Ailus wrote:
> > Add support for event handling to do_ioctl.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ...
> > @@ -239,6 +241,13 @@ struct v4l2_ioctl_ops {
> >  	int (*vidioc_enum_frameintervals) (struct file *file, void *fh,
> >  					   struct v4l2_frmivalenum *fival);
> >  
> > +	int (*vidioc_dqevent)	       (struct v4l2_fh *fh,
> > +					struct v4l2_event *ev);
> > +	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
> > +					struct v4l2_event_subscription *sub);
> > +	int (*vidioc_unsubscribe_event) (struct v4l2_fh *fh,
> > +					 struct v4l2_event_subscription *sub);
> > +
> >  	/* For other private ioctls */
> >  	long (*vidioc_default)	       (struct file *file, void *fh,
> >  					int cmd, void *arg);
> 
> Replying to myself, there seems to be valid use for the struct file as
> an argument to the function fields. That is a way to get the video
> device pointer using video_devdata(). Otherwise the video device pointer
> has to be stored in the file handle instead.
> 
> So I'm going to add the file pointers as first arguments here as they
> are in other functions unless there are objections. The type of second
> argument is still going to be struct v4l2_fh *.

No, instead v4l2_fh should have a pointer to video_device. Much cleaner and
consistent with the other v4l2 internal structures.

And see also my review I'm posting soon.

Regards,

	Hans

> 
> Regards,
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
