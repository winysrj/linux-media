Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:44619 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3GaJsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 05:48:20 -0400
Received: by mail-vb0-f49.google.com with SMTP id w16so458008vbb.8
        for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 02:48:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375101661-6493-7-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
	<1375101661-6493-7-git-send-email-hverkuil@xs4all.nl>
Date: Wed, 31 Jul 2013 17:48:20 +0800
Message-ID: <CAHG8p1DrszQEcR-a1DkBvUyVf=NyMQJ7t4Ld0R-H7tmi61BTzg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/7/29 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Use the new defines to calculate the full blanking and frame sizes.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> ---

>  drivers/media/platform/blackfin/bfin_capture.c | 9 ++-------


> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 7f838c6..4c11059 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -388,13 +388,8 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>
>                 params.hdelay = bt->hsync + bt->hbackporch;
>                 params.vdelay = bt->vsync + bt->vbackporch;
> -               params.line = bt->hfrontporch + bt->hsync
> -                               + bt->hbackporch + bt->width;
> -               params.frame = bt->vfrontporch + bt->vsync
> -                               + bt->vbackporch + bt->height;
> -               if (bt->interlaced)
> -                       params.frame += bt->il_vfrontporch + bt->il_vsync
> -                                       + bt->il_vbackporch;
> +               params.line = V4L2_DV_BT_FRAME_WIDTH(bt);
> +               params.frame = V4L2_DV_BT_FRAME_HEIGHT(bt);
>         } else if (bcap_dev->cfg->inputs[bcap_dev->cur_input].capabilities
>                         & V4L2_IN_CAP_STD) {
>                 params.hdelay = 0;

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
