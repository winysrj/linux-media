Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50171 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbbBXJ26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 04:28:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 6/7] v4l2-subdev: remove enum_framesizes/intervals
Date: Tue, 24 Feb 2015 11:30 +0200
Message-ID: <4783230.jrK7mDZbhP@avalon>
In-Reply-To: <54EC3169.4060103@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl> <1423827006-32878-7-git-send-email-hverkuil@xs4all.nl> <54EC3169.4060103@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 24 February 2015 09:08:09 Hans Verkuil wrote:
> On 02/13/2015 12:30 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Replace the video ops enum_framesizes and enum_frameintervals by the pad
> > ops enum_frame_size and enum_frame_interval.
> > 
> > The video and pad ops are duplicates, so get rid of the more limited video
> > op.
> > 
> > The whole point of the subdev API is to allow reuse of subdev drivers by
> > bridge drivers. Having duplicate ops makes that much harder. We should
> > never have allowed duplicate ops in the first place. A lesson for the
> > future.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> 
> Laurent, can you Ack the v4l2 core change?

For the core,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Jon, can you take a look at the changes to your drivers?
> 
> Thanks!
> 
> 	Hans
> 
> > ---
> > 
> >  drivers/media/i2c/ov7670.c                      | 37 +++++++++++--------
> >  drivers/media/platform/marvell-ccic/mcam-core.c | 48 +++++++++++++++++---
> >  drivers/media/platform/soc_camera/soc_camera.c  | 30 +++++++++++-----
> >  drivers/media/platform/via-camera.c             | 15 ++++++--
> >  include/media/v4l2-subdev.h                     |  2 --
> >  5 files changed, 101 insertions(+), 31 deletions(-)

[snip]

> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 6192f66..933f767 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -332,8 +332,6 @@ struct v4l2_subdev_video_ops {
> >  				struct v4l2_subdev_frame_interval *interval);
> >  	int (*s_frame_interval)(struct v4l2_subdev *sd,
> >  				struct v4l2_subdev_frame_interval *interval);
> > -	int (*enum_framesizes)(struct v4l2_subdev *sd, struct
> > v4l2_frmsizeenum *fsize);
> > -	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> > v4l2_frmivalenum *fival);
> >  	int (*s_dv_timings)(struct v4l2_subdev *sd,
> >  			struct v4l2_dv_timings *timings);
> >  	int (*g_dv_timings)(struct v4l2_subdev *sd,

-- 
Regards,

Laurent Pinchart

