Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53805 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab0BOJzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 04:55:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4 2/7] V4L: Events: Add new ioctls for events
Date: Mon, 15 Feb 2010 10:55:15 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com
References: <4B72C965.7040204@maxwell.research.nokia.com> <1265813889-17847-2-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201002131419.55625.hverkuil@xs4all.nl>
In-Reply-To: <201002131419.55625.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151055.19102.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 13 February 2010 14:19:55 Hans Verkuil wrote:
> On Wednesday 10 February 2010 15:58:04 Sakari Ailus wrote:
> > This patch adds a set of new ioctls to the V4L2 API. The ioctls conform
> > to V4L2 Events RFC version 2.3:
> I've experimented with the events API to try and support it with ivtv and
> I realized that it had some problems.
> 
> See comments below.
> 
> > <URL:http://www.spinics.net/lists/linux-media/msg12033.html>
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> > 
> >  drivers/media/video/v4l2-compat-ioctl32.c |    3 +++
> >  drivers/media/video/v4l2-ioctl.c          |    3 +++
> >  include/linux/videodev2.h                 |   23 +++++++++++++++++++++++
> >  3 files changed, 29 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-compat-ioctl32.c
> > b/drivers/media/video/v4l2-compat-ioctl32.c index 997975d..cba704c
> > 100644
> > --- a/drivers/media/video/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> > @@ -1077,6 +1077,9 @@ long v4l2_compat_ioctl32(struct file *file,
> > unsigned int cmd, unsigned long arg)
> > 
> >  	case VIDIOC_DBG_G_REGISTER:
> >  	case VIDIOC_DBG_G_CHIP_IDENT:
> > 
> >  	case VIDIOC_S_HW_FREQ_SEEK:
> > +	case VIDIOC_DQEVENT:
> > +	case VIDIOC_SUBSCRIBE_EVENT:
> > 
> > +	case VIDIOC_UNSUBSCRIBE_EVENT:
> >  		ret = do_video_ioctl(file, cmd, arg);
> >  		break;
> > 
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> > b/drivers/media/video/v4l2-ioctl.c index 30cc334..bfc4696 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -283,6 +283,9 @@ static const char *v4l2_ioctls[] = {
> > 
> >  	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
> >  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
> > 
> > +	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
> > +	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
> > +	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> > 
> >  #endif
> >  };
> >  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 54af357..a19ae89 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1536,6 +1536,26 @@ struct v4l2_streamparm {
> > 
> >  };
> >  
> >  /*
> > 
> > + *	E V E N T S
> > + */
> > +
> > +struct v4l2_event {
> > +	__u32		count;
> 
> The name 'count' is confusing. Count of what? I think the name 'pending'
> might be more understandable. A comment after the definition would also
> help.
> 
> > +	__u32		type;
> > +	__u32		sequence;
> > +	struct timespec	timestamp;
> > +	__u32		reserved[9];
> > +	__u8		data[64];
> > +};
> 
> I also think we should reorder the fields and add a union. For ivtv I would
> need this:
> 
> #define V4L2_EVENT_ALL                          0
> #define V4L2_EVENT_VSYNC                        1
> #define V4L2_EVENT_EOS                          2
> #define V4L2_EVENT_PRIVATE_START                0x08000000
> 
> /* Payload for V4L2_EVENT_VSYNC */
> struct v4l2_event_vsync {
>         /* Can be V4L2_FIELD_ANY, _NONE, _TOP or _BOTTOM */
>         u8 field;
> } __attribute__ ((packed));
> 
> struct v4l2_event {
>         __u32           type;
>         union {
>                 struct v4l2_event_vsync vsync;
>                 __u8    data[64];
>         } u;
>         __u32           sequence;
>         struct timespec timestamp;
>         __u32           pending;
>         __u32           reserved[9];
> };
> 
> The reason for rearranging the fields has to do with the fact that the
> first two fields (type and the union) form the actual event data. The
> others are more for administrative purposes. Separating those two makes
> sense to me.
> 
> So when I define an event for queuing it is nice if I can do just this:
> 
> static const struct v4l2_event ev_top = {
> 	.type = V4L2_EVENT_VSYNC,
> 	.u.vsync.field = V4L2_FIELD_TOP,
> };
> 
> I would have preferred to have an anonymous union. Unfortunately gcc has
> problems with initializers for fields inside an anonymous union. Hence the
> need for a named union.

Will all drivers add private events to the union ? This would then soon become 
a mess. Wouldn't it be better for drivers to define their own event structures 
(standard ones could be shared between drivers in videodev2.h) and cast the 
pointer to data to a pointer to the appropriate event structure ?

-- 
Regards,

Laurent Pinchart
