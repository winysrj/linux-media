Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:22703 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757939AbcLBI3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 03:29:47 -0500
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Shailendra Verma <shailendra.v@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
CC: "vidushi.koul@samsung.com" <vidushi.koul@samsung.com>
Date: Fri, 2 Dec 2016 09:29:30 +0100
Subject: Re: [PATCH] bdisp: Clean up file handle in open() error path.
Message-ID: <bb9146fa-31a8-67d1-113c-a7707add0271@st.com>
References: <1480654081-6983-1-git-send-email-shailendra.v@samsung.com>
In-Reply-To: <1480654081-6983-1-git-send-email-shailendra.v@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra,
Thank you for the patch, it's good for me.


On 12/02/2016 05:48 AM, Shailendra Verma wrote:
> The File handle is not yet added in the vdev list.So no need to call
> v4l2_fh_del(&ctx->fh)if it fails to create control.
>
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>

> ---
>   drivers/media/platform/sti/bdisp/bdisp-v4l2.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> index 45f82b5..fbf302f 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> @@ -632,8 +632,8 @@ static int bdisp_open(struct file *file)
>   
>   error_ctrls:
>   	bdisp_ctrls_delete(ctx);
> -error_fh:
>   	v4l2_fh_del(&ctx->fh);
> +error_fh:
>   	v4l2_fh_exit(&ctx->fh);
>   	bdisp_hw_free_nodes(ctx);
>   mem_ctx:
