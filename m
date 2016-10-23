Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36564 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756576AbcJWR0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 13:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sun, 23 Oct 2016 18:26:07 +0100
Message-ID: <CA+V-a8tChcZp406VSbtnALrmJQgw6nkNDVwe5SFqm6t0fpPmjw@mail.gmail.com>
Subject: Re: [PATCH 00/34] [media] DaVinci-Video Processing: Fine-tuning for
 several function implementations
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thanks for the patches.

On Wed, Oct 12, 2016 at 3:26 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 12 Oct 2016 16:20:02 +0200
>
> Several update suggestions were taken into account
> from static source code analysis.
>
> Markus Elfring (34):
>   Use kmalloc_array() in vpbe_initialize()
>   Delete two error messages for a failed memory allocation
>   Adjust 16 checks for null pointers
>   Combine substrings for four messages
>   Return an error code only as a constant in vpbe_probe()
>   Return an error code only by a single variable in vpbe_initialize()
>   Delete an unnecessary variable initialisation in vpbe_initialize()
>   Return the success indication only as a constant in vpbe_set_mode()
>   Reduce the scope for a variable in vpbe_set_default_output()
>   Check return value of a setup_if_config() call in vpbe_set_output()
>   Rename a jump label in vpbe_set_output()
>   Delete an unnecessary variable initialisation in vpbe_set_output()
>   Capture: Use kmalloc_array() in vpfe_probe()
>   Capture: Delete three error messages for a failed memory allocation
>   Capture: Improve another size determination in vpfe_probe()
>   Capture: Delete an unnecessary variable initialisation in vpfe_probe()
>   Capture: Improve another size determination in vpfe_enum_input()
>   Capture: Combine substrings for an error message in vpfe_enum_input()
>   Capture: Improve another size determination in vpfe_open()
>   Capture: Adjust 13 checks for null pointers
>   Capture: Delete an unnecessary variable initialisation in 11 functions
>   Capture: Move two assignments in vpfe_s_input()
>   Capture: Delete unnecessary braces in vpfe_isr()
>   Capture: Delete an unnecessary return statement in vpfe_unregister_ccdc_device()
>   Capture: Use kcalloc() in vpif_probe()
>   Capture: Delete an error message for a failed memory allocation
>   Capture: Adjust ten checks for null pointers
>   Capture: Delete an unnecessary variable initialisation in vpif_querystd()
>   Capture: Delete an unnecessary variable initialisation in vpif_channel_isr()
>   Display: Use kcalloc() in vpif_probe()
>   Display: Delete an error message for a failed memory allocation
>   Display: Adjust 11 checks for null pointers
>   Display: Delete an unnecessary variable initialisation in vpif_channel_isr()
>   Display: Delete an unnecessary variable initialisation in process_progressive_mode()
>
>  drivers/media/platform/davinci/vpbe.c         | 93 ++++++++++++---------------
>  drivers/media/platform/davinci/vpfe_capture.c | 88 ++++++++++++-------------
>  drivers/media/platform/davinci/vpif_capture.c | 28 ++++----
>  drivers/media/platform/davinci/vpif_display.c | 30 ++++-----
>  4 files changed, 109 insertions(+), 130 deletions(-)
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
