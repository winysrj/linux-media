Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41774 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2HNKzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 06:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120814065814.GB4791@elgon.mountain>
References: <20120814065814.GB4791@elgon.mountain>
Date: Tue, 14 Aug 2012 07:50:12 -0300
Message-ID: <CALF0-+UU8dGBdihLgm==d0gCE4aHKdAbEVfe54U1LDjBHss8XQ@mail.gmail.com>
Subject: Re: [patch] [media] em28xx: use after free in em28xx_v4l2_close()
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Gianluca Gennari <gennarone@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Tue, Aug 14, 2012 at 3:58 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We need to move the unlock before the kfree(dev);
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Applies to linux-next.
>
> diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> index ecb23df..78d6ebd 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -2264,9 +2264,9 @@ static int em28xx_v4l2_close(struct file *filp)
>                 if (dev->state & DEV_DISCONNECTED) {
>                         em28xx_release_resources(dev);

Why not unlocking here?

>                         kfree(dev->alt_max_pkt_size);
> +                       mutex_unlock(&dev->lock);
>                         kfree(dev);
>                         kfree(fh);
> -                       mutex_unlock(&dev->lock);

Thanks,
Ezequiel.
