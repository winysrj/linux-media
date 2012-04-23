Return-path: <linux-media-owner@vger.kernel.org>
Received: from v38276.1blu.de ([88.84.155.223]:53387 "EHLO barth.jannau.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab2DWMMB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 08:12:01 -0400
Date: Mon, 23 Apr 2012 14:01:46 +0200
From: Janne Grunau <janne@jannau.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 5/8] v4l: fix compiler warnings.
Message-ID: <20120423120146.GA32632@jannau.net>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
 <c21418a68a0851986513afbb4dc5fa92c004b1ba.1335181658.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c21418a68a0851986513afbb4dc5fa92c004b1ba.1335181658.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-04-23 13:51:25 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>

[...]

> ---
>  drivers/media/video/au0828/au0828-video.c    |    4 ++--
>  drivers/media/video/cx23885/cx23888-ir.c     |    4 +---
>  drivers/media/video/cx25840/cx25840-ir.c     |    6 +-----
>  drivers/media/video/em28xx/em28xx-audio.c    |    9 +++++----
>  drivers/media/video/et61x251/et61x251_core.c |   11 ++++-------
>  drivers/media/video/hdpvr/hdpvr-control.c    |    2 ++
>  drivers/media/video/hdpvr/hdpvr-video.c      |    2 +-
>  drivers/media/video/saa7134/saa7134-video.c  |    2 +-
>  drivers/media/video/sn9c102/sn9c102_core.c   |    4 +---
>  9 files changed, 18 insertions(+), 26 deletions(-)
> 

[...]

> diff --git a/drivers/media/video/hdpvr/hdpvr-control.c b/drivers/media/video/hdpvr/hdpvr-control.c
> index 068df4b..ae8f229 100644
> --- a/drivers/media/video/hdpvr/hdpvr-control.c
> +++ b/drivers/media/video/hdpvr/hdpvr-control.c
> @@ -113,6 +113,8 @@ int get_input_lines_info(struct hdpvr_device *dev)
>  			 "get input lines info returned: %d, %s\n", ret,
>  			 print_buf);
>  	}
> +#else
> +	(void)ret;	/* suppress compiler warning */
>  #endif
>  	lines = dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
>  	mutex_unlock(&dev->usbc_mutex);
> diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
> index 11ffe9c..0e9e156 100644
> --- a/drivers/media/video/hdpvr/hdpvr-video.c
> +++ b/drivers/media/video/hdpvr/hdpvr-video.c
> @@ -994,7 +994,7 @@ static int hdpvr_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
>  	default:
>  		return -EINVAL;
>  	}
> -	return 0;
> +	return ret;
>  }
>  
>  static int vidioc_try_ext_ctrls(struct file *file, void *priv,

Acked-by: Janne Grunau <j@jannau.net>
