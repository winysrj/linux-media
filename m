Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41366 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1K2CWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 21:22:18 -0500
Received: by bke11 with SMTP id 11so9426267bke.19
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 18:22:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321970669-23423-1-git-send-email-leiwen@marvell.com>
References: <1321970669-23423-1-git-send-email-leiwen@marvell.com>
Date: Tue, 29 Nov 2011 10:22:17 +0800
Message-ID: <CALZhoSR6+E41KsJL6ChbF26y4nRR+TXEOHk8HPnvxiYnuC=fGA@mail.gmail.com>
Subject: Re: [PATCH] [media] V4L: soc-camera: change order of removing device
From: Lei Wen <adrian.wenl@gmail.com>
To: Lei Wen <leiwen@marvell.com>
Cc: linux-media@vger.kernel.org, jqsu@marvell.com, qingx@marvell.com,
	fswu@marvell.com, twang13@marvell.com, ytang5@marvell.com,
	wwang27@marvell.com, wzhu10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Nov 22, 2011 at 10:04 PM, Lei Wen <leiwen@marvell.com> wrote:
> As our general practice, we use stream off before we close
> the video node. So that the drivers its stream off function
> would be called before its remove function.
>
> But for the case for ctrl+c, the program would be force closed.
> We have no chance to call that vb2 stream off from user space,
> but directly call the remove function in soc_camera.
>
> In that common code of soc_camera:
>
>                ici->ops->remove(icd);
>                if (ici->ops->init_videobuf2)
>                        vb2_queue_release(&icd->vb2_vidq);
>
> It would first call the device remove function, then release vb2,
> in which stream off function is called. Thus it create different
> order for the driver.
>
> This patch change the order to make driver see the same sequence
> to make it happy.
>
> Signed-off-by: Lei Wen <leiwen@marvell.com>
> ---
>  drivers/media/video/soc_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index b72580c..fdc6167 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -600,9 +600,9 @@ static int soc_camera_close(struct file *file)
>                pm_runtime_suspend(&icd->vdev->dev);
>                pm_runtime_disable(&icd->vdev->dev);
>
> -               ici->ops->remove(icd);
>                if (ici->ops->init_videobuf2)
>                        vb2_queue_release(&icd->vb2_vidq);
> +               ici->ops->remove(icd);
>
>                soc_camera_power_off(icd, icl);
>        }
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Any comments?

Thanks,
Lei
