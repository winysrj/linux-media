Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33097 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3BPMkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 07:40:33 -0500
Received: by mail-qc0-f173.google.com with SMTP id b12so1534032qca.32
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 04:40:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <435f6000435782780f3eb57633664517306a8e29.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
 <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl> <435f6000435782780f3eb57633664517306a8e29.1361006882.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Feb 2013 18:10:11 +0530
Message-ID: <CA+V-a8t-DqF9U-PCxOXf0tTHhy5M46gwrqgK=WY11PzVyvObuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/18] davinci_vpfe: fix copy-paste errors in several comments.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sat, Feb 16, 2013 at 2:58 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This removes some incorrect dv_preset references left over from copy-and-paste
> errors.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 99ccbeb..19dc5b0 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1016,12 +1016,12 @@ vpfe_query_dv_timings(struct file *file, void *fh,
>  }
>
>  /*
> - * vpfe_s_dv_timings() - set dv_preset on external subdev
> + * vpfe_s_dv_timings() - set dv_timings on external subdev
>   * @file: file pointer
>   * @priv: void pointer
>   * @timings: pointer to v4l2_dv_timings structure
>   *
> - * set dv_timings pointed by preset on external subdev through
> + * set dv_timings pointed by timings on external subdev through
>   * v4l2_device_call_until_err, this configures amplifier also
>   *
>   * Return 0 on success, error code otherwise
> @@ -1042,12 +1042,12 @@ vpfe_s_dv_timings(struct file *file, void *fh,
>  }
>
>  /*
> - * vpfe_g_dv_timings() - get dv_preset which is set on external subdev
> + * vpfe_g_dv_timings() - get dv_timings which is set on external subdev
>   * @file: file pointer
>   * @priv: void pointer
>   * @timings: pointer to v4l2_dv_timings structure
>   *
> - * get dv_preset which is set on external subdev through
> + * get dv_timings which is set on external subdev through
>   * v4l2_subdev_call
>   *
>   * Return 0 on success, error code otherwise
> @@ -1423,7 +1423,7 @@ static int vpfe_dqbuf(struct file *file, void *priv,
>  }
>
>  /*
> - * vpfe_streamon() - get dv_preset which is set on external subdev
> + * vpfe_streamon() - start streaming
>   * @file: file pointer
>   * @priv: void pointer
>   * @buf_type: enum v4l2_buf_type
> @@ -1472,7 +1472,7 @@ static int vpfe_streamon(struct file *file, void *priv,
>  }
>
>  /*
> - * vpfe_streamoff() - get dv_preset which is set on external subdev
> + * vpfe_streamoff() - stop streaming
>   * @file: file pointer
>   * @priv: void pointer
>   * @buf_type: enum v4l2_buf_type
> --
> 1.7.10.4
>
