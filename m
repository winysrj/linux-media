Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3287 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DRJef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 05:34:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: fix a compiler warning
Date: Wed, 18 Apr 2012 11:33:44 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1204180959050.30514@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1204180959050.30514@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204181133.44119.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, April 18, 2012 09:59:58 Guennadi Liakhovetski wrote:
> Fix the warning:
> 
> In file included from /home/lyakh/software/project/24/src/linux-2.6/drivers/media/video/v4l2-subdev.c:29:
> linux-2.6/include/media/v4l2-ctrls.h:497: warning: 'struct file' declared inside parameter list
> linux-2.6/include/media/v4l2-ctrls.h:497: warning: its scope is only this definition or declaration, which is probably not what you want
> linux-2.6/include/media/v4l2-ctrls.h:505: warning: 'struct file' declared inside parameter list
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  include/media/v4l2-ctrls.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 11e6756..c519841 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -492,6 +492,7 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
>  void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
>  		struct v4l2_subscribed_event *sev);
>  
> +struct file;
>  /* Can be used as a vidioc_log_status function that just dumps all controls
>     associated with the filehandle. */
>  int v4l2_ctrl_log_status(struct file *file, void *fh);
> 
