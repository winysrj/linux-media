Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47403 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaICUoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:44:01 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so9176120wes.5
        for <linux-media@vger.kernel.org>; Wed, 03 Sep 2014 13:44:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7784c0dade5a08d844babfe22eeb614b3327ae1b.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com> <7784c0dade5a08d844babfe22eeb614b3327ae1b.1409775488.git.m.chehab@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 3 Sep 2014 21:43:29 +0100
Message-ID: <CA+V-a8sxgOQ86beWQe6DD5weS84hmgbV2LBVMVyU9gNzQtvBgg@mail.gmail.com>
Subject: Re: [PATCH 39/46] [media] davinci: just return 0 instead of using a var
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 3, 2014 at 9:33 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Instead of allocating a var to store 0 and just return it,
> change the code to return 0 directly.
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index ed9dd27e3c63..c557eb5ebf6b 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -943,12 +943,11 @@ static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
>                                 struct v4l2_format *fmt)
>  {
>         struct vpfe_device *vpfe_dev = video_drvdata(file);
> -       int ret = 0;
>
>         v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
>         /* Fill in the information about format */
>         *fmt = vpfe_dev->fmt;
> -       return ret;
> +       return 0;
>  }
>
>  static int vpfe_enum_fmt_vid_cap(struct file *file, void  *priv,
> --
> 1.9.3
>
