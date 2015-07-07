Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34355 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbbGGLN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2015 07:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <1435612746-3999-1-git-send-email-bparrot@ti.com>
References: <1435612746-3999-1-git-send-email-bparrot@ti.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 7 Jul 2015 12:12:56 +0100
Message-ID: <CA+V-a8tqhoWmcBrGMJ7fVXbjLkLrVVKfDYAJh51Dq8a39spXgw@mail.gmail.com>
Subject: Re: [Patch v3 1/1] media: am437x-vpfe: Requested frame size and fmt
 overwritten by current sensor setting
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 29, 2015 at 10:19 PM, Benoit Parrot <bparrot@ti.com> wrote:
> Upon a S_FMT the input/requested frame size and pixel format is
> overwritten by the current sub-device settings.
> Fix this so application can actually set the frame size and format.
>
> Fixes: 417d2e507edc ("[media] media: platform: add VPFE capture driver support for AM437X")
> Cc: <stable@vger.kernel.org> # v4.0+
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
> Changes since v2:
> - fix the stable commit reference syntax
>
>  drivers/media/platform/am437x/am437x-vpfe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index eb25c43da126..0fa62c50f62d 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -1584,7 +1584,7 @@ static int vpfe_s_fmt(struct file *file, void *priv,
>                 return -EBUSY;
>         }
>
> -       ret = vpfe_try_fmt(file, priv, fmt);
> +       ret = vpfe_try_fmt(file, priv, &format);
>         if (ret)
>                 return ret;
>
> --
> 1.8.5.1
>
