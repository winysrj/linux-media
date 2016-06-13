Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34758 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422893AbcFMNmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 09:42:45 -0400
Received: by mail-it0-f65.google.com with SMTP id d71so7254418ith.1
        for <linux-media@vger.kernel.org>; Mon, 13 Jun 2016 06:42:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465436115-13880-1-git-send-email-shuahkh@osg.samsung.com>
References: <1465436115-13880-1-git-send-email-shuahkh@osg.samsung.com>
Date: Mon, 13 Jun 2016 09:42:43 -0400
Message-ID: <CABxcv=nT_zp2BkvSV04sqaXmZGnQz=z-cGURDJwUW7hthD6-Fw@mail.gmail.com>
Subject: Re: [PATCH] media: s5p-mfc fix memory leak in s5p_mfc_remove()
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On Wed, Jun 8, 2016 at 9:35 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> s5p_mfc_remove() fails to release encoder and decoder video devices.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 274b4f1..af61f54 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1317,7 +1317,9 @@ static int s5p_mfc_remove(struct platform_device *pdev)
>         destroy_workqueue(dev->watchdog_workqueue);
>
>         video_unregister_device(dev->vfd_enc);
> +       video_device_release(dev->vfd_enc);
>         video_unregister_device(dev->vfd_dec);
> +       video_device_release(dev->vfd_dec);
>         v4l2_device_unregister(&dev->v4l2_dev);
>         s5p_mfc_release_firmware(dev);
>         vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
> --

Can you please do the remove operations in the inverse order of their
counterparts? IOW to do the release for both encoder and decoder after
their unregistration.

After that change:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
