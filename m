Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43866 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbeHMOaP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 10:30:15 -0400
MIME-Version: 1.0
References: <CA+V-a8vXEiZ6widPZRdiw-0QejFHwDcTtMz5iKfkHc9gZLZ79Q@mail.gmail.com>
 <20180806155025.8912-1-vasilyev@ispras.ru>
In-Reply-To: <20180806155025.8912-1-vasilyev@ispras.ru>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 13 Aug 2018 12:47:50 +0100
Message-ID: <CA+V-a8vw+1CF=DJuyDp=To-QNzzynritdDcCvvv3DeL+6KehWA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: davinci: vpif_display: Mix memory leak on
 probe error path
To: Anton Vasilyev <vasilyev@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch.

On Mon, Aug 6, 2018 at 4:50 PM Anton Vasilyev <vasilyev@ispras.ru> wrote:
>
> If vpif_probe() fails on v4l2_device_register() then memory allocated
> at initialize_vpif() for global vpif_obj.dev[i] become unreleased.
>
> The patch adds deallocation of vpif_obj.dev[i] on the probe error path.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
> ---
> v2: divided the original patch into two and made stylistic fixes based
> on the Prabhakar's rewiev.
> ---
>  drivers/media/platform/davinci/vpif_display.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
