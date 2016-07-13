Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34767 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcGMNwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:52:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so1536433wma.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 06:52:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467621310-8203-4-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl> <1467621310-8203-4-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 13 Jul 2016 14:51:44 +0100
Message-ID: <CA+V-a8sGQr+v73+x_veaKD5O9xYwYi4qttL0xnaMnSYHs2vorw@mail.gmail.com>
Subject: Re: [PATCH 03/14] davinci: drop unused control callbacks
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 4, 2016 at 9:34 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> These callbacks are no longer used since the davinci drivers use the
> control framework.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/platform/davinci/ccdc_hw_device.h | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/ccdc_hw_device.h b/drivers/media/platform/davinci/ccdc_hw_device.h
> index 86b9b35..ae5605d 100644
> --- a/drivers/media/platform/davinci/ccdc_hw_device.h
> +++ b/drivers/media/platform/davinci/ccdc_hw_device.h
> @@ -80,13 +80,6 @@ struct ccdc_hw_ops {
>         /* Pointer to function to get line length */
>         unsigned int (*get_line_length) (void);
>
> -       /* Query CCDC control IDs */
> -       int (*queryctrl)(struct v4l2_queryctrl *qctrl);
> -       /* Set CCDC control */
> -       int (*set_control)(struct v4l2_control *ctrl);
> -       /* Get CCDC control */
> -       int (*get_control)(struct v4l2_control *ctrl);
> -
>         /* Pointer to function to set frame buffer address */
>         void (*setfbaddr) (unsigned long addr);
>         /* Pointer to function to get field id */
> --
> 2.8.1
>
