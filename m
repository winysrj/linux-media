Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56545 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2D2QaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 12:30:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
Subject: Re: [PATCH] v4l: v4l2-ctrls: Add forward declaration of struct file
Date: Sun, 29 Apr 2012 18:30:24 +0200
Message-ID: <2444415.6B1b1hMN1o@avalon>
In-Reply-To: <1335180551-27856-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335180551-27856-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 April 2012 13:29:11 Laurent Pinchart wrote:
> This fixes the following warning:
> 
> In file included from drivers/media/video/v4l2-subdev.c:29:
> include/media/v4l2-ctrls.h:501: warning: 'struct file' declared inside
> parameter list
> include/media/v4l2-ctrls.h:501: warning: its scope is only this
> definition or declaration, which is probably not what you want
> include/media/v4l2-ctrls.h:509: warning: 'struct file' declared inside
> parameter list

Ping ? Should I include this in my next pull request ?

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-ctrls.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 33907a9..9022e1c 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -25,6 +25,7 @@
>  #include <linux/videodev2.h>
> 
>  /* forward references */
> +struct file;
>  struct v4l2_ctrl_handler;
>  struct v4l2_ctrl_helper;
>  struct v4l2_ctrl;

-- 
Regards,

Laurent Pinchart

