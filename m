Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:45840 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbeHQUtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 16:49:18 -0400
MIME-Version: 1.0
References: <66694963.VB7x4V86dC@avalon> <Pine.LNX.4.44L0.1808101019550.1425-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1808101019550.1425-100000@iolanthe.rowland.org>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Fri, 17 Aug 2018 20:44:49 +0300
Message-ID: <CAJs94EYH2BrHseveJV_xqYs5zK0NxrdQ8NhjrCp7tytK=KsF0g@mail.gmail.com>
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

=D0=BF=D1=82, 10 =D0=B0=D0=B2=D0=B3. 2018 =D0=B3. =D0=B2 17:27, Alan Stern =
<stern@rowland.harvard.edu>:
>
> On Fri, 10 Aug 2018, Laurent Pinchart wrote:
>
> > > > Aren't you're missing a dma_sync_single_for_device() call before
> > > > submitting the URB ? IIRC that's required for correct operation of =
the DMA
> > > > mapping API on some platforms, depending on the cache architecture.=
 The
> > > > additional sync can affect performances, so it would be useful to r=
e-run
> > > > the perf test.
> > >
> > > This was already discussed:
> > >
> > > https://lkml.org/lkml/2018/7/23/1051
> > >
> > > I rely on Alan's reply:
> > >
> > > > According to Documentation/DMA-API-HOWTO.txt, the CPU should not wr=
ite
> > > > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() i=
s
> > > > not needed.
> >
> > I fully agree that the CPU should not write to the buffer. However, I t=
hink
> > the sync call is still needed. It's been a long time since I touched th=
is
> > area, but IIRC, some cache architectures (VIVT ?) require both cache cl=
ean
> > before the transfer and cache invalidation after the transfer. On platf=
orms
> > where no cache management operation is needed before the transfer in th=
e
> > DMA_FROM_DEVICE direction, the dma_sync_*_for_device() calls should be =
no-ops
> > (and if they're not, it's a bug of the DMA mapping implementation).
>
> In general, I agree that the cache has to be clean before a transfer
> starts.  This means some sort of mapping operation (like
> dma_sync_*_for-device) is indeed required at some point between the
> allocation and the first transfer.
>
> For subsequent transfers, however, the cache is already clean and it
> will remain clean because the CPU will not do any writes to the buffer.
> (Note: clean !=3D empty.  Rather, clean =3D=3D !dirty.)  Therefore transf=
ers
> following the first should not need any dma_sync_*_for_device.
>
> If you don't accept this reasoning then you should ask the people who
> wrote DMA-API-HOWTO.txt.  They certainly will know more about this
> issue than I do.

Laurent,

I have not seen any data corruption or glitches without
dma_sync_single_for_device() on ARM and x86.
It takes additional ~20usec for dma_sync_single_for_device() to run on
ARM. So It would be great to ensure that we can reliable save another
15% running time.

>
> Alan Stern
>


--
With best regards,
Matwey V. Kornilov
