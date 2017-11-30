Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35501 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdK3T5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 14:57:32 -0500
Received: by mail-wm0-f67.google.com with SMTP id f9so14692782wmh.0
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 11:57:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <159308106aa0aa0873ee6e000b05db08a9413f58.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
 <159308106aa0aa0873ee6e000b05db08a9413f58.1511952372.git.mchehab@s-opensource.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 30 Nov 2017 19:57:00 +0000
Message-ID: <CA+V-a8vGNJJGoqarMN871j-rqeCfEmwfytXWGaGDwT23Le-b1Q@mail.gmail.com>
Subject: Re: [PATCH 06/12] media: vpif: don't generate a kernel-doc warning on
 a constant
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 29, 2017 at 10:46 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Constants documentation is not supported by kernel-doc markups.
> So, change the comment label to avoid this warning:
>         drivers/media/platform/davinci/vpif.c:54: warning: cannot understand function prototype: 'const struct vpif_channel_config_params vpif_ch_params[] = '
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/davinci/vpif.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
