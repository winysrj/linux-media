Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:34483 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbcCDEeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 23:34:06 -0500
Received: by mail-qg0-f66.google.com with SMTP id t4so2773510qge.1
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 20:34:05 -0800 (PST)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com. [209.85.192.43])
        by smtp.gmail.com with ESMTPSA id h5sm866180qge.48.2016.03.03.20.34.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Mar 2016 20:34:04 -0800 (PST)
Received: by mail-qg0-f43.google.com with SMTP id t4so35220075qge.0
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 20:34:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457058298-7782-1-git-send-email-shuahkh@osg.samsung.com>
References: <1457058298-7782-1-git-send-email-shuahkh@osg.samsung.com>
Date: Fri, 4 Mar 2016 06:34:04 +0200
Message-ID: <CAAZRmGyuEQ=LY=21VEXwz-yy3sodrGaMxSVoPj4zZrdZOr1zgQ@mail.gmail.com>
Subject: Re: [PATCH] media: fix null pointer dereference in v4l_vb2q_enable_media_source()
From: Olli Salonen <olli.salonen@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Thanks for your quick reaction. This patch seems to fix the oops I got earlier.

Tested-by: Olli Salonen <olli.salonen@iki.fi>

Cheers,
-olli

On 4 March 2016 at 04:24, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Fix the null pointer dereference in v4l_vb2q_enable_media_source().
> DVB only drivers don't have valid struct v4l2_fh pointer.
>
> [  548.443272] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000010
> [  548.452036] IP: [<ffffffffc020ffc9>]
> v4l_vb2q_enable_media_source+0x9/0x50 [videodev]
> [  548.460792] PGD b820e067 PUD bb3df067 PMD 0
> [  548.465582] Oops: 0000 [#1] SMP
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Reported-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-mc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 643686d..a39a3cd 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -214,6 +214,8 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>  {
>         struct v4l2_fh *fh = q->owner;
>
> -       return v4l_enable_media_source(fh->vdev);
> +       if (fh && fh->vdev)
> +               return v4l_enable_media_source(fh->vdev);
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
> --
> 2.5.0
>
