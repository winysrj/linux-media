Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1790 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2G3Gop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 02:44:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Fix VIDIOC_TRY_EXT_CTRLS regression
Date: Mon, 30 Jul 2012 08:43:56 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
References: <201207181534.59499.hverkuil@xs4all.nl> <5015E2A6.4020809@redhat.com>
In-Reply-To: <5015E2A6.4020809@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207300843.56351.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 30 2012 03:25:58 Mauro Carvalho Chehab wrote:
> Em 18-07-2012 10:34, Hans Verkuil escreveu:
> > Hi all,
> > 
> > This patch fixes an omission in the new v4l2_ioctls table: VIDIOC_TRY_EXT_CTRLS
> > must get the INFO_FL_CTRL flag, just like all the other control related ioctls.
> > 
> > Otherwise the ioctl core won't know it also has to check whether v4l2_fh->ctrl_handler
> > is non-zero before it can decide that this ioctl is not implemented.
> > 
> > Caught by v4l2-compliance while I was testing the mem2mem_testdev driver.
> 
> Missing SOB. It seems Steven asked for this fix. Did he test? If so, it would be
> nice to get his tested-by:.

Oops!

Here it is:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Welcome back!

Regards,

	Hans

> 
> Regards,
> Mauro
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> > index 70e0efb..17dff31 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -1900,7 +1900,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
> >   	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
> >   	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
> >   	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
> > -	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
> > +	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
> >   	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
> >   	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
> >   	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
