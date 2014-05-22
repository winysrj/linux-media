Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33295 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaEVIgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 May 2014 04:36:45 -0400
Received: by mail-ob0-f173.google.com with SMTP id wm4so3455603obc.4
        for <linux-media@vger.kernel.org>; Thu, 22 May 2014 01:36:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400696402-1805-3-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com> <1400696402-1805-3-git-send-email-m.chehab@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 22 May 2014 10:36:24 +0200
Message-ID: <CAPybu_3FbfNXHd8Dp-7UPCuLsrhdjo0kKbLAyfAcu5QpwjWPng@mail.gmail.com>
Subject: Re: [PATCH 2/8] [media] au0828: Improve debug messages for urb_completion
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro

Are you aware that using dynamic printk you can decide to print
__func__ on demand?

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/dynamic-debug-howto.txt#n213


Perhaps it is better to not add __func__

Regards!

On Wed, May 21, 2014 at 8:19 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Sometimes, it helps to know how much data was received by
> urb_completion. Add that information to the optional debug
> log.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-dvb.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> index 2019e4a168b2..ab5f93643021 100755
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -114,16 +114,20 @@ static void urb_completion(struct urb *purb)
>         int ptype = usb_pipetype(purb->pipe);
>         unsigned char *ptr;
>
> -       dprintk(2, "%s()\n", __func__);
> +       dprintk(2, "%s: %d\n", __func__, purb->actual_length);
>
> -       if (!dev)
> +       if (!dev) {
> +               dprintk(2, "%s: no dev!\n", __func__);
>                 return;
> +       }
>
> -       if (dev->urb_streaming == 0)
> +       if (dev->urb_streaming == 0) {
> +               dprintk(2, "%s: not streaming!\n", __func__);
>                 return;
> +       }
>
>         if (ptype != PIPE_BULK) {
> -               printk(KERN_ERR "%s() Unsupported URB type %d\n",
> +               printk(KERN_ERR "%s: Unsupported URB type %d\n",
>                        __func__, ptype);
>                 return;
>         }
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ricardo Ribalda
