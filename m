Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59273 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdGFWlX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 18:41:23 -0400
Subject: Re: [PATCH] rcar_fdp1: constify vb2_ops structure
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170706202532.GA12160@embeddedgus>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <76532629-9ab3-117a-d849-46c7ade8688c@ideasonboard.com>
Date: Thu, 6 Jul 2017 23:41:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170706202532.GA12160@embeddedgus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

Thank you for the patch.

On 06/07/17 21:25, Gustavo A. R. Silva wrote:
> Check for vb2_ops structures that are only stored in the ops field of a
> vb2_queue structure. That field is declared const, so vb2_ops structures
> that have this property can be declared as const also.
> 
> This issue was detected using Coccinelle and the following semantic patch:
> 
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
> struct vb2_ops i = { ... };
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar_fdp1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> index 3ee51fc..3245bc4 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -2032,7 +2032,7 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
>  	}
>  }
>  
> -static struct vb2_ops fdp1_qops = {
> +static const struct vb2_ops fdp1_qops = {
>  	.queue_setup	 = fdp1_queue_setup,
>  	.buf_prepare	 = fdp1_buf_prepare,
>  	.buf_queue	 = fdp1_buf_queue,
> 
