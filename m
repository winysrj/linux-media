Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33887 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbbCFMQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 07:16:14 -0500
Received: by lbvn10 with SMTP id n10so3237088lbv.1
        for <linux-media@vger.kernel.org>; Fri, 06 Mar 2015 04:16:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425500004-17467-1-git-send-email-yamato@redhat.com>
References: <1425500004-17467-1-git-send-email-yamato@redhat.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 6 Mar 2015 12:15:43 +0000
Message-ID: <CA+V-a8t7VnT10TT+BHBhuFLE=0hm7xzVsw+amrV8JZgrcPQ+og@mail.gmail.com>
Subject: Re: [PATCH] am437x: include linux/videodev2.h for expanding BASE_VIDIOC_PRIVATE
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Masatake,

Thanks for the patch.

On Wed, Mar 4, 2015 at 8:13 PM, Masatake YAMATO <yamato@redhat.com> wrote:
> In am437x-vpfe.h BASE_VIDIOC_PRIVATE is used for
> making the name of ioctl command(VIDIOC_AM437X_CCDC_CFG).
> The definition of BASE_VIDIOC_PRIVATE is in linux/videodev2.h.
> However, linux/videodev2.h is not included in am437x-vpfe.h.
> As the result an application using has to include both
> am437x-vpfe.h and linux/videodev2.h.
>
> With this patch, the application can include just am437x-vpfe.h.
>
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  include/uapi/linux/am437x-vpfe.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/am437x-vpfe.h b/include/uapi/linux/am437x-vpfe.h
> index 9b03033f..d757743 100644
> --- a/include/uapi/linux/am437x-vpfe.h
> +++ b/include/uapi/linux/am437x-vpfe.h
> @@ -21,6 +21,8 @@
>  #ifndef AM437X_VPFE_USER_H
>  #define AM437X_VPFE_USER_H
>
> +#include <linux/videodev2.h>
> +
>  enum vpfe_ccdc_data_size {
>         VPFE_CCDC_DATA_16BITS = 0,
>         VPFE_CCDC_DATA_15BITS,
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
