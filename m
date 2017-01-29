Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward2j.cmail.yandex.net ([5.255.227.20]:37309 "EHLO
        forward2j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750739AbdA2Hpg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Jan 2017 02:45:36 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
To: Avraham Shukron <avraham.shukron@gmail.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
References: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
Subject: Re: [PATCH] Staging: omap4iss: fix coding style issues
MIME-Version: 1.0
Message-Id: <6973561485675117@web6h.yandex.ru>
Date: Sun, 29 Jan 2017 09:31:57 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



28.01.2017, 20:11, "Avraham Shukron" <avraham.shukron@gmail.com>:
> This is a patch that fixes issues in omap4iss/iss_video.c
> Specifically, it fixes "line over 80 characters" issues

Hello,

are you have a sent this changes patch before?
And Greg KH answered you, are you read?

Please send the change once, there is no need for a repeat. 

> Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
>
> ---
>  drivers/staging/media/omap4iss/iss_video.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index c16927a..cdab053 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -298,7 +298,8 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
>
>  static int iss_video_queue_setup(struct vb2_queue *vq,
>                                   unsigned int *count, unsigned int *num_planes,
> - unsigned int sizes[], struct device *alloc_devs[])
> + unsigned int sizes[],
> + struct device *alloc_devs[])

it should be on the same line, maintainer's up to 80 characters allowed.
this "alloc_devs" variable start with int?

Example:

struct device {
  int (struct device *alloc_devs[);

Check the top lines of the codes.


>  {
>          struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
>          struct iss_video *video = vfh->video;
> @@ -678,8 +679,8 @@ iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
>          if (subdev == NULL)
>                  return -EINVAL;
>
> - /* Try the get selection operation first and fallback to get format if not
> - * implemented.
> + /* Try the get selection operation first and fallback to get format if
> + * not implemented.
>           */

There is no change here, it opens with comment /* and closes with */.
Please read submittting patch document.

Regards,

>          sdsel.pad = pad;
>          ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
> --
> 2.7.4

~Ozgur
