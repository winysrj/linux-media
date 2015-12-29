Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33385 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbbL2TFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 14:05:40 -0500
Received: by mail-yk0-f172.google.com with SMTP id k129so114681553yke.0
        for <linux-media@vger.kernel.org>; Tue, 29 Dec 2015 11:05:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451415215-8854-1-git-send-email-wuninsu@gmail.com>
References: <1451415215-8854-1-git-send-email-wuninsu@gmail.com>
Date: Tue, 29 Dec 2015 14:05:40 -0500
Message-ID: <CAGoCfizkR_1hiayvfM2UVQYGpVGfMBJp5tveghRpphejSH+4gg@mail.gmail.com>
Subject: Re: [PATCH] cx231xx: correctly handling failed allocation
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Insu Yun <wuninsu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	scott.jiang.linux@gmail.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 29, 2015 at 1:53 PM, Insu Yun <wuninsu@gmail.com> wrote:
> Since kmalloc can be failed in memory pressure,
> if not properly handled, NULL dereference can be happend
>
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/media/usb/cx231xx/cx231xx-417.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
> index 47a98a2..9725e4f 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-417.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-417.c
> @@ -1382,6 +1382,8 @@ static int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
>         buffer_size = urb->actual_length;
>
>         buffer = kmalloc(buffer_size, GFP_ATOMIC);
> +       if (!buffer)
> +               return -ENOMEM;

A kmalloc() call inside a bulk handler running in softirq context?
That doesn't look right.

That said, I don't have any specific objection to the patch (which I'm
assuming came from some automated tool), but I suspect the cx231xx-417
code is probably completely broken.  The only device I've ever seen
that has the cx23102 and cx23417 is one of the Polaris EVKs, which
AFAIK nobody has ever shipped a production design based on.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
