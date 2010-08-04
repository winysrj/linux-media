Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2648 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0HDSal (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 14:30:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 2/7] v4l: subdev: Don't require core operations
Date: Wed, 4 Aug 2010 20:30:27 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278948352-17892-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278948352-17892-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042030.27796.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 July 2010 17:25:47 Laurent Pinchart wrote:
> There's no reason to require subdevices to implement the core
> operations. Remove the check for non-NULL core operations when
> initializing the subdev.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

> ---
>  include/media/v4l2-subdev.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 02c6f4d..6088316 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -437,8 +437,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
>  					const struct v4l2_subdev_ops *ops)
>  {
>  	INIT_LIST_HEAD(&sd->list);
> -	/* ops->core MUST be set */
> -	BUG_ON(!ops || !ops->core);
> +	BUG_ON(!ops);
>  	sd->ops = ops;
>  	sd->v4l2_dev = NULL;
>  	sd->flags = 0;
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
