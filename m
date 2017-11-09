Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51153 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdKIVdn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Nov 2017 16:33:43 -0500
Received: by mail-wm0-f67.google.com with SMTP id s66so19869494wmf.5
        for <linux-media@vger.kernel.org>; Thu, 09 Nov 2017 13:33:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c0f1eacb1871395845a89668f18a6663c9dabbfd.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
 <c0f1eacb1871395845a89668f18a6663c9dabbfd.1509569763.git.mchehab@s-opensource.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 9 Nov 2017 21:33:11 +0000
Message-ID: <CA+V-a8t0viUc2BePvuvEJS-FqYgA=VgVH_fi906Mtnyj5dS2BA@mail.gmail.com>
Subject: Re: [PATCH v2 12/26] media: davinci: fix a debug printk
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 1, 2017 at 9:05 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Two orthogonal changesets caused a breakage at a printk
> inside davinci. Changeset a2d17962c9ca
> ("[media] davinci: Switch from V4L2 OF to V4L2 fwnode")
> made davinci to use struct fwnode_handle instead of
> struct device_node. Changeset 68d9c47b1679
> ("media: Convert to using %pOF instead of full_name")
> changed the printk to not use ->full_name, but, instead,
> to rely on %pOF.
>
> With both patches applied, the Kernel will do the wrong
> thing, as warned by smatch:
>         drivers/media/platform/davinci/vpif_capture.c:1399 vpif_async_bound() error: '%pOF' expects argument of type 'struct device_node*', argument 5 has type 'void*'
>
> So, change the logic to actually print the device name
> that was obtained before the print logic.
>
> Fixes: 68d9c47b1679 ("media: Convert to using %pOF instead of full_name")
> Fixes: a2d17962c9ca ("[media] davinci: Switch from V4L2 OF to V4L2 fwnode")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
