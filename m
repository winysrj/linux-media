Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45207 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbeHMO3A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 10:29:00 -0400
MIME-Version: 1.0
References: <20180806155025.8912-1-vasilyev@ispras.ru> <20180806155025.8912-2-vasilyev@ispras.ru>
In-Reply-To: <20180806155025.8912-2-vasilyev@ispras.ru>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 13 Aug 2018 12:46:35 +0100
Message-ID: <CA+V-a8tD1oYHX3XtN1kc4mHyXxsDZ-toLWiOZTBttrghh31LGQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: davinci: vpif_display: remove duplicate check
To: Anton Vasilyev <vasilyev@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch.

On Mon, Aug 6, 2018 at 4:51 PM Anton Vasilyev <vasilyev@ispras.ru> wrote:
>
> The patch removes the duplicate platform_data check from vpif_probe().
>
> Fixes: 4a5f8ae50b66 ("[media] davinci: vpif_capture: get subdevs from DT when available")
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
> ---
> v2: divided the original patch into two and made stylistic fixes based
> on the Prabhakar's rewiev.
> ---
>  drivers/media/platform/davinci/vpif_display.c | 5 -----
>  1 file changed, 5 deletions(-)
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
