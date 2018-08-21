Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35427 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbeHUL4P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 07:56:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAJs94EYH2BrHseveJV_xqYs5zK0NxrdQ8NhjrCp7tytK=KsF0g@mail.gmail.com>
References: <66694963.VB7x4V86dC@avalon> <Pine.LNX.4.44L0.1808101019550.1425-100000@iolanthe.rowland.org>
 <CAJs94EYH2BrHseveJV_xqYs5zK0NxrdQ8NhjrCp7tytK=KsF0g@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Tue, 21 Aug 2018 11:36:40 +0300
Message-ID: <CAJs94EY3ipwLA4w=aH8TfwTVRLRhxHwyh3H+NUE_n4Ee4CgtEg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-08-17 20:44 GMT+03:00 Matwey V. Kornilov <matwey.kornilov@gmail.com>:
> =D0=BF=D1=82, 10 =D0=B0=D0=B2=D0=B3. 2018 =D0=B3. =D0=B2 17:27, Alan Ster=
n <stern@rowland.harvard.edu>:
>>
>> On Fri, 10 Aug 2018, Laurent Pinchart wrote:
>>
>> > > > Aren't you're missing a dma_sync_single_for_device() call before
>> > > > submitting the URB ? IIRC that's required for correct operation of=
 the DMA
>> > > > mapping API on some platforms, depending on the cache architecture=
. The
>> > > > additional sync can affect performances, so it would be useful to =
re-run
>> > > > the perf test.
>> > >
>> > > This was already discussed:
>> > >
>> > > https://lkml.org/lkml/2018/7/23/1051
>> > >
>> > > I rely on Alan's reply:
>> > >
>> > > > According to Documentation/DMA-API-HOWTO.txt, the CPU should not w=
rite
>> > > > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() =
is
>> > > > not needed.
>> >
>> > I fully agree that the CPU should not write to the buffer. However, I =
think
>> > the sync call is still needed. It's been a long time since I touched t=
his
>> > area, but IIRC, some cache architectures (VIVT ?) require both cache c=
lean
>> > before the transfer and cache invalidation after the transfer. On plat=
forms
>> > where no cache management operation is needed before the transfer in t=
he
>> > DMA_FROM_DEVICE direction, the dma_sync_*_for_device() calls should be=
 no-ops
>> > (and if they're not, it's a bug of the DMA mapping implementation).
>>
>> In general, I agree that the cache has to be clean before a transfer
>> starts.  This means some sort of mapping operation (like
>> dma_sync_*_for-device) is indeed required at some point between the
>> allocation and the first transfer.
>>
>> For subsequent transfers, however, the cache is already clean and it
>> will remain clean because the CPU will not do any writes to the buffer.
>> (Note: clean !=3D empty.  Rather, clean =3D=3D !dirty.)  Therefore trans=
fers
>> following the first should not need any dma_sync_*_for_device.
>>
>> If you don't accept this reasoning then you should ask the people who
>> wrote DMA-API-HOWTO.txt.  They certainly will know more about this
>> issue than I do.
>
> Laurent,
>
> I have not seen any data corruption or glitches without
> dma_sync_single_for_device() on ARM and x86.
> It takes additional ~20usec for dma_sync_single_for_device() to run on
> ARM. So It would be great to ensure that we can reliable save another
> 15% running time.

DMA-API-HOWTO.txt has and example with my_card_interrupt_handler()
function where it says that "CPU should not write to
DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is not
needed here."

I've found that, for instance, drivers/crypto/caam/caamrng.c follows
DMA-API-HOWTO.txt and don't use dma_sync_single_for_device() in the
same case as we have in pwc.

>
>>
>> Alan Stern
>>
>
>
> --
> With best regards,
> Matwey V. Kornilov



--=20
With best regards,
Matwey V. Kornilov
