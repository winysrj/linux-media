Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35123 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752667AbdHNXOw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 19:14:52 -0400
Subject: Re: [PATCH 6/6] [media] media: imx: capture: constify vb2_ops
 structures
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1501930033-18249-1-git-send-email-Julia.Lawall@lip6.fr>
 <1501930033-18249-7-git-send-email-Julia.Lawall@lip6.fr>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <2a79a4c7-b1e4-f142-6740-0b9f2d2a6f4d@gmail.com>
Date: Mon, 14 Aug 2017 16:14:49 -0700
MIME-Version: 1.0
In-Reply-To: <1501930033-18249-7-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Steve

On 08/05/2017 03:47 AM, Julia Lawall wrote:
> These vb2_ops structures are only stored in the ops field of a
> vb2_queue structure, which is declared as const.  Thus the vb2_ops
> structures themselves can be const.
>
> Done with the help of Coccinelle.
>
> // <smpl>
> @r disable optional_qualifier@
> identifier i;
> position p;
> @@
> static struct vb2_ops i@p = { ... };
>
> @ok@
> identifier r.i;
> struct vb2_queue e;
> position p;
> @@
> e.ops = &i@p;
>
> @bad@
> position p != {r.p,ok.p};
> identifier r.i;
> struct vb2_ops e;
> @@
> e@i@p
>
> @depends on !bad disable optional_qualifier@
> identifier r.i;
> @@
> static
> +const
>   struct vb2_ops i = { ... };
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>   drivers/staging/media/imx/imx-media-capture.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index ddab4c2..ea145ba 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -62,7 +62,7 @@ struct capture_priv {
>   /* In bytes, per queue */
>   #define VID_MEM_LIMIT	SZ_64M
>   
> -static struct vb2_ops capture_qops;
> +static const struct vb2_ops capture_qops;
>   
>   /*
>    * Video ioctls follow
> @@ -503,7 +503,7 @@ static void capture_stop_streaming(struct vb2_queue *vq)
>   	spin_unlock_irqrestore(&priv->q_lock, flags);
>   }
>   
> -static struct vb2_ops capture_qops = {
> +static const struct vb2_ops capture_qops = {
>   	.queue_setup	 = capture_queue_setup,
>   	.buf_init        = capture_buf_init,
>   	.buf_prepare	 = capture_buf_prepare,
>
