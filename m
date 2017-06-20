Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:33829 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFTNGd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 09:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <20170609213616.410415-1-arnd@arndb.de>
References: <20170609213616.410415-1-arnd@arndb.de>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 20 Jun 2017 14:06:01 +0100
Message-ID: <CA+V-a8vFYtOc1tARPL1tH3XafXY30p0pAeJjy7qEzF0RkL9cNQ@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci/dm644x: work around ccdc_update_raw_params
 trainwreck
To: Sekhar Nori <nsekhar@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the patch.

On Fri, Jun 9, 2017 at 10:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Now that the davinci drivers can be enabled in compile tests on other
> architectures, I ran into this warning on a 64-bit build:
>
> drivers/media/platform/davinci/dm644x_ccdc.c: In function 'ccdc_update_ra=
w_params':
> drivers/media/platform/davinci/dm644x_ccdc.c:279:7: error: cast to pointe=
r from integer of different size [-Werror=3Dint-to-pointer-cast]
>
> While that looks fairly harmless (it would be fine on 32-bit), it was
> just the tip of the iceberg:
>
> - The function constantly mixes up pointers and phys_addr_t numbers
> - This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
>   described as an 'experimental ioctl that will change in future kernels'=
,
>   but if we have users that probably won't happen.
> - The code to allocate the table never gets called after we copy_from_use=
r
>   the user input over the kernel settings, and then compare them
>   for inequality.
> - We then go on to use an address provided by user space as both the
>   __user pointer for input and pass it through phys_to_virt to come up
>   with a kernel pointer to copy the data to. This looks like a trivially
>   exploitable root hole.
>
> This patch disables all the obviously broken code, by zeroing out the
> sensitive data provided by user space. I also fix the type confusion
> here. If we think the ioctl has no stable users, we could consider
> just removing it instead.
>
I suspect there shouldn=E2=80=99t  be possible users of this IOCTL, better =
of  removing
the IOCTL itself.

Sekhar your call, as the latest PSP releases for 644x use the media
controller framework.

Cheers,
--Prabhakar Lad
