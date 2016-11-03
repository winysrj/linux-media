Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45625 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753975AbcKCMW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 08:22:28 -0400
Subject: Re: [PATCH 17/34] [media] DaVinci-VPFE-Capture: Improve another size
 determination in vpfe_enum_input()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <88b3de4c-5f3f-9f70-736b-039dca6b8a2e@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f214edb8-0af3-e1f5-8b45-9cfa0537f8b5@xs4all.nl>
Date: Thu, 3 Nov 2016 13:22:24 +0100
MIME-Version: 1.0
In-Reply-To: <88b3de4c-5f3f-9f70-736b-039dca6b8a2e@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/10/16 16:55, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 12 Oct 2016 10:33:42 +0200
>
> Replace the specification of a data structure by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/platform/davinci/vpfe_capture.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 8314c39..87ee35d 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1091,7 +1091,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
>  		return -EINVAL;
>  	}
>  	sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
> -	memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
> +	memcpy(inp, &sdinfo->inputs[index], sizeof(*inp));

If I am not mistaken this can be written as:

	*inp = sdinfo->inputs[index];

Much better.

Regards,

	Hans

>  	return 0;
>  }
>
>
