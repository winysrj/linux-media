Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36180 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdF0LIh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 07:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <1b0671fa-fec7-11fa-6b91-0afad904c651@ti.com>
References: <20170609213616.410415-1-arnd@arndb.de> <CA+V-a8vFYtOc1tARPL1tH3XafXY30p0pAeJjy7qEzF0RkL9cNQ@mail.gmail.com>
 <1b0671fa-fec7-11fa-6b91-0afad904c651@ti.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 27 Jun 2017 13:08:26 +0200
Message-ID: <CAK8P3a0Jd4Eh_CGK4FPGzw5Q3J0hZPD6GASbgCNFi01xwYwV3w@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci/dm644x: work around ccdc_update_raw_params
 trainwreck
To: Sekhar Nori <nsekhar@ti.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 27, 2017 at 12:13 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On Tuesday 20 June 2017 06:36 PM, Lad, Prabhakar wrote:
>> Hi Arnd,
>>
>> Thanks for the patch.
>>
>> On Fri, Jun 9, 2017 at 10:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> Now that the davinci drivers can be enabled in compile tests on other
>>> architectures, I ran into this warning on a 64-bit build:
>>>
>>> drivers/media/platform/davinci/dm644x_ccdc.c: In function 'ccdc_update_=
raw_params':
>>> drivers/media/platform/davinci/dm644x_ccdc.c:279:7: error: cast to poin=
ter from integer of different size [-Werror=3Dint-to-pointer-cast]
>>>
>>> While that looks fairly harmless (it would be fine on 32-bit), it was
>>> just the tip of the iceberg:
>>>
>>> - The function constantly mixes up pointers and phys_addr_t numbers
>>> - This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
>>>   described as an 'experimental ioctl that will change in future kernel=
s',
>>>   but if we have users that probably won't happen.
>>> - The code to allocate the table never gets called after we copy_from_u=
ser
>>>   the user input over the kernel settings, and then compare them
>>>   for inequality.
>>> - We then go on to use an address provided by user space as both the
>>>   __user pointer for input and pass it through phys_to_virt to come up
>>>   with a kernel pointer to copy the data to. This looks like a triviall=
y
>>>   exploitable root hole.
>>>
>>> This patch disables all the obviously broken code, by zeroing out the
>>> sensitive data provided by user space. I also fix the type confusion
>>> here. If we think the ioctl has no stable users, we could consider
>>> just removing it instead.
>>>
>> I suspect there shouldn=E2=80=99t  be possible users of this IOCTL, bett=
er of  removing
>> the IOCTL itself.
>>
>> Sekhar your call, as the latest PSP releases for 644x use the media
>> controller framework.
>
> I do not have any personal experience with anyone using this support
> with latest kernels. I too am okay with removing the broken support.

Ok, I think that would be good. Can one of you create that patch?
Note that we have two implementations of the ioctl, with different
data structures, depending on the specific hardware.

> Since the header file that defines the ioctl is not in include/uapi/*, I
> guess it cannot be considered stable userspace ABI? Also, there are
> enough warnings about instability thrown in the comments surrounding the
> ioctl in include/media/davinci/vpfe_capture.h.

This is not relevant really. The only thing that counts is whether there
is existing user space that has active users who complain if it breaks.

If you think nobody is using it, that is more important than code
comments or the location of the header file, but if someone complains
later anyway, we may end up reverting the removal and fix it differently.

       Arnd
