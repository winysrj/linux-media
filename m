Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1818 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0E3JJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 05:09:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v3 1/4] V4L2: Add features to the interface.
Date: Sun, 30 May 2010 11:11:06 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1274703703-11670-1-git-send-email-matti.j.aaltonen@nokia.com> <1274703703-11670-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1274703703-11670-2-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005301111.06777.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 24 May 2010 14:21:40 Matti J. Aaltonen wrote:
> Add fields spacing, level_min, level_max and level to struct v4l2_hw_freq_seek.
> The level is used for determining which channels are considered receivable
> during HW scan.

As mentioned I don't think the level stuff should be added at the moment.
The spacing field is no problem, but don't forget to update the V4L2 spec as
well. Also document there what should happen if spacing == 0 (which is the
case for existing apps). It basically boils down to the fact that the driver
uses the spacing as a hint only and will adjust it to whatever the hardware
supports.

> Add  VIDIOC_G_HW_FREQ_SEEK to IOCTL codes. This is used for getting the minimum and
> maximum values for the level field in the v4l2_hw_freq_seek struct.

Without level support we can drop this for now.

Regards,

	Hans

> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  include/linux/videodev2.h  |    6 +++++-
>  include/media/v4l2-ioctl.h |    2 ++
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 418dacf..7a81a9c 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1377,7 +1377,11 @@ struct v4l2_hw_freq_seek {
>  	enum v4l2_tuner_type  type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
> -	__u32		      reserved[8];
> +	__u32		      spacing;
> +	__s32		      level_min;
> +	__s32		      level_max;
> +	__s32		      level;
> +	__u32		      reserved[4];
>  };
>  
>  /*
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index e8ba0f2..828cf13 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -220,6 +220,8 @@ struct v4l2_ioctl_ops {
>  	/* Log status ioctl */
>  	int (*vidioc_log_status)       (struct file *file, void *fh);
>  
> +	int (*vidioc_g_hw_freq_seek)   (struct file *file, void *fh,
> +					struct v4l2_hw_freq_seek *a);
>  	int (*vidioc_s_hw_freq_seek)   (struct file *file, void *fh,
>  					struct v4l2_hw_freq_seek *a);
>  
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
