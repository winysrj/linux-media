Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61106 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031Ab0GWNMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 09:12:39 -0400
MIME-Version: 1.0
In-Reply-To: <20100723100920.GC26313@bicker>
References: <20100723100920.GC26313@bicker>
Date: Fri, 23 Jul 2010 09:12:37 -0400
Message-ID: <AANLkTi=4-973-tomyGeF1X6EXGzhcgWXeNZ6mZ=awMF+@mail.gmail.com>
Subject: Re: [patch -next] V4L: au0828: move dereference below sanity checks
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 23, 2010 at 6:09 AM, Dan Carpenter <error27@gmail.com> wrote:
> This function has sanity checks to make sure that "dev" is non-null.  I
> moved the dereference down below the checks.  In the current code "dev"
> is never actually null.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
> index d97e0a2..7989a7b 100644
> --- a/drivers/media/video/au0828/au0828-video.c
> +++ b/drivers/media/video/au0828/au0828-video.c
> @@ -441,7 +441,7 @@ static void au0828_copy_vbi(struct au0828_dev *dev,
>                              unsigned char *outp, unsigned long len)
>  {
>        unsigned char *startwrite, *startread;
> -       int bytesperline = dev->vbi_width;
> +       int bytesperline;
>        int i, j = 0;
>
>        if (dev == NULL) {
> @@ -464,6 +464,8 @@ static void au0828_copy_vbi(struct au0828_dev *dev,
>                return;
>        }
>
> +       bytesperline = dev->vbi_width;
> +
>        if (dma_q->pos + len > buf->vb.size)
>                len = buf->vb.size - dma_q->pos;
>
>

In reality the check for "dev" can be removed since it will *never*
happen (I added it during some debugging, as can be seen by the rest
of the NULL checks).

Either way though, this patch is fine.

Acked-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
