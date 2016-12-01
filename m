Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:9546 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751227AbcLAJ2E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 04:28:04 -0500
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Shailendra Verma <shailendra.v@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
CC: "vidushi.koul@samsung.com" <vidushi.koul@samsung.com>
Date: Thu, 1 Dec 2016 10:27:48 +0100
Subject: Re: [PATCH] Platform: Sti: Bdisp: Clean up file handle in open()
 error path.
Message-ID: <a598b016-ca1e-267e-469d-3701b092890d@st.com>
References: <1480567671-13239-1-git-send-email-shailendra.v@samsung.com>
In-Reply-To: <1480567671-13239-1-git-send-email-shailendra.v@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra


Thank you for the patch.


Could you please update the subject line (try to have it as short as 
possible):

- there is no need for the 'platform' keyword. This remark applies to 
your other patches.

- write all keywords in lower case (Bdisp -> bdisp). This remark applies 
also to your other patches.

- "sti" is not needed too

-> "bdisp: Clean up file handle in open() error path."

Sorry to bother you with such details, but I am sure this will not 
require a huge rework from you ;)


Fabien


On 12/01/2016 05:47 AM, Shailendra Verma wrote:
> The File handle is not yet added in the vdev list.So no need to call
> v4l2_fh_del(&ctx->fh)if it fails to create control.
>
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
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
