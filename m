Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46684 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab1FBAuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 20:50:10 -0400
Received: by vxi39 with SMTP id 39so296708vxi.19
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 17:50:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Thu, 2 Jun 2011 09:50:09 +0900
Message-ID: <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com>
Subject: Re: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug messages
From: Kyungmin Park <kmpark@infradead.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Kyungmin Park <kyunginn.,park@samsung.com>

---

I think it's better to add the videobuf2 maintainer entry for proper
person to know the changes.
In this case, Marek is missing.

If any objection, I will make a patch.

Thank you,
Kyungmin Park

2011/6/2 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Otherwise they clutter the dmesg buffer even on a production kernel.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/media/video/videobuf2-memops.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
> index 5370a3a..1987e1b1 100644
> --- a/drivers/media/video/videobuf2-memops.c
> +++ b/drivers/media/video/videobuf2-memops.c
> @@ -177,7 +177,7 @@ int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
>
>        vma->vm_ops->open(vma);
>
> -       printk(KERN_DEBUG "%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
> +       pr_debug("%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
>                        __func__, paddr, vma->vm_start, size);
>
>        return 0;
> @@ -195,7 +195,7 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
>  {
>        struct vb2_vmarea_handler *h = vma->vm_private_data;
>
> -       printk(KERN_DEBUG "%s: %p, refcount: %d, vma: %08lx-%08lx\n",
> +       pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
>               __func__, h, atomic_read(h->refcount), vma->vm_start,
>               vma->vm_end);
>
> @@ -213,7 +213,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
>  {
>        struct vb2_vmarea_handler *h = vma->vm_private_data;
>
> -       printk(KERN_DEBUG "%s: %p, refcount: %d, vma: %08lx-%08lx\n",
> +       pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
>               __func__, h, atomic_read(h->refcount), vma->vm_start,
>               vma->vm_end);
>
> --
> 1.7.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
