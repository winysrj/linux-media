Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33056 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbeJKEhj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 00:37:39 -0400
MIME-Version: 1.0
References: <20180821170629.18408-1-matwey@sai.msu.ru> <20180821170629.18408-3-matwey@sai.msu.ru>
 <CAJs94EZ5Qh8q3tEABmH89NjDkA=jjzsB63yctRGdEqcvJTnASA@mail.gmail.com> <CAJs94EZBpUmRXnYRiSHJex+UdLX5tUfW-nxm1bWjy1oQW6vuFQ@mail.gmail.com>
In-Reply-To: <CAJs94EZBpUmRXnYRiSHJex+UdLX5tUfW-nxm1bWjy1oQW6vuFQ@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Thu, 11 Oct 2018 00:13:28 +0300
Message-ID: <CAJs94EZOFEJFrZCbfL8XZGmx1GfpJD+eZd08_1=3hPy3g8h0Mw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
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

=D0=B2=D1=82, 11 =D1=81=D0=B5=D0=BD=D1=82. 2018 =D0=B3. =D0=B2 21:58, Matwe=
y V. Kornilov <matwey.kornilov@gmail.com>:
>
> =D0=B2=D1=82, 28 =D0=B0=D0=B2=D0=B3. 2018 =D0=B3. =D0=B2 10:17, Matwey V.=
 Kornilov <matwey.kornilov@gmail.com>:
> >
> > =D0=B2=D1=82, 21 =D0=B0=D0=B2=D0=B3. 2018 =D0=B3. =D0=B2 20:06, Matwey =
V. Kornilov <matwey@sai.msu.ru>:
> > >
> > > DMA cocherency slows the transfer down on systems without hardware
> > > coherent DMA.
> > > Instead we use noncocherent DMA memory and explicit sync at data rece=
ive
> > > handler.
> > >
> > > Based on previous commit the following performance benchmarks have be=
en
> > > carried out. Average memcpy() data transfer rate (rate) and handler
> > > completion time (time) have been measured when running video stream a=
t
> > > 640x480 resolution at 10fps.
> > >
> > > x86_64 based system (Intel Core i5-3470). This platform has hardware
> > > coherent DMA support and proposed change doesn't make big difference =
here.
> > >
> > >  * kmalloc:            rate =3D (2.0 +- 0.4) GBps
> > >                        time =3D (5.0 +- 3.0) usec
> > >  * usb_alloc_coherent: rate =3D (3.4 +- 1.2) GBps
> > >                        time =3D (3.5 +- 3.0) usec
> > >
> > > We see that the measurements agree within error ranges in this case.
> > > So theoretically predicted performance downgrade cannot be reliably
> > > measured here.
> > >
> > > armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platf=
orm
> > > has no hardware coherent DMA support. DMA coherence is implemented vi=
a
> > > disabled page caching that slows down memcpy() due to memory controll=
er
> > > behaviour.
> > >
> > >  * kmalloc:            rate =3D  (114 +- 5) MBps
> > >                        time =3D   (84 +- 4) usec
> > >  * usb_alloc_coherent: rate =3D (28.1 +- 0.1) MBps
> > >                        time =3D  (341 +- 2) usec
> > >
> > > Note, that quantative difference leads (this commit leads to 4 times
> > > acceleration) to qualitative behavior change in this case. As it was
> > > stated before, the video stream cannot be successfully received at AM=
335x
> > > platforms with MUSB based USB host controller due to performance issu=
es
> > > [1].
> > >
> > > [1] https://www.spinics.net/lists/linux-usb/msg165735.html
> > >
> > > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> >
> > Ping
> >
>
> Ping
>

Ping

> > > ---
> > >  drivers/media/usb/pwc/pwc-if.c | 57 ++++++++++++++++++++++++++++++++=
----------
> > >  1 file changed, 44 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/p=
wc-if.c
> > > index 72d2897a4b9f..1360722ab423 100644
> > > --- a/drivers/media/usb/pwc/pwc-if.c
> > > +++ b/drivers/media/usb/pwc/pwc-if.c
> > > @@ -159,6 +159,32 @@ static const struct video_device pwc_template =
=3D {
> > >  /*******************************************************************=
********/
> > >  /* Private functions */
> > >
> > > +static void *pwc_alloc_urb_buffer(struct device *dev,
> > > +                                 size_t size, dma_addr_t *dma_handle=
)
> > > +{
> > > +       void *buffer =3D kmalloc(size, GFP_KERNEL);
> > > +
> > > +       if (!buffer)
> > > +               return NULL;
> > > +
> > > +       *dma_handle =3D dma_map_single(dev, buffer, size, DMA_FROM_DE=
VICE);
> > > +       if (dma_mapping_error(dev, *dma_handle)) {
> > > +               kfree(buffer);
> > > +               return NULL;
> > > +       }
> > > +
> > > +       return buffer;
> > > +}
> > > +
> > > +static void pwc_free_urb_buffer(struct device *dev,
> > > +                               size_t size,
> > > +                               void *buffer,
> > > +                               dma_addr_t dma_handle)
> > > +{
> > > +       dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
> > > +       kfree(buffer);
> > > +}
> > > +
> > >  static struct pwc_frame_buf *pwc_get_next_fill_buf(struct pwc_device=
 *pdev)
> > >  {
> > >         unsigned long flags =3D 0;
> > > @@ -306,6 +332,11 @@ static void pwc_isoc_handler(struct urb *urb)
> > >         /* Reset ISOC error counter. We did get here, after all. */
> > >         pdev->visoc_errors =3D 0;
> > >
> > > +       dma_sync_single_for_cpu(&urb->dev->dev,
> > > +                               urb->transfer_dma,
> > > +                               urb->transfer_buffer_length,
> > > +                               DMA_FROM_DEVICE);
> > > +
> > >         /* vsync: 0 =3D don't copy data
> > >                   1 =3D sync-hunt
> > >                   2 =3D synched
> > > @@ -428,16 +459,15 @@ static int pwc_isoc_init(struct pwc_device *pde=
v)
> > >                 urb->dev =3D udev;
> > >                 urb->pipe =3D usb_rcvisocpipe(udev, pdev->vendpoint);
> > >                 urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFE=
R_DMA_MAP;
> > > -               urb->transfer_buffer =3D usb_alloc_coherent(udev,
> > > -                                                         ISO_BUFFER_=
SIZE,
> > > -                                                         GFP_KERNEL,
> > > -                                                         &urb->trans=
fer_dma);
> > > +               urb->transfer_buffer_length =3D ISO_BUFFER_SIZE;
> > > +               urb->transfer_buffer =3D pwc_alloc_urb_buffer(&udev->=
dev,
> > > +                                                           urb->tran=
sfer_buffer_length,
> > > +                                                           &urb->tra=
nsfer_dma);
> > >                 if (urb->transfer_buffer =3D=3D NULL) {
> > >                         PWC_ERROR("Failed to allocate urb buffer %d\n=
", i);
> > >                         pwc_isoc_cleanup(pdev);
> > >                         return -ENOMEM;
> > >                 }
> > > -               urb->transfer_buffer_length =3D ISO_BUFFER_SIZE;
> > >                 urb->complete =3D pwc_isoc_handler;
> > >                 urb->context =3D pdev;
> > >                 urb->start_frame =3D 0;
> > > @@ -488,15 +518,16 @@ static void pwc_iso_free(struct pwc_device *pde=
v)
> > >
> > >         /* Freeing ISOC buffers one by one */
> > >         for (i =3D 0; i < MAX_ISO_BUFS; i++) {
> > > -               if (pdev->urbs[i]) {
> > > +               struct urb *urb =3D pdev->urbs[i];
> > > +
> > > +               if (urb) {
> > >                         PWC_DEBUG_MEMORY("Freeing URB\n");
> > > -                       if (pdev->urbs[i]->transfer_buffer) {
> > > -                               usb_free_coherent(pdev->udev,
> > > -                                       pdev->urbs[i]->transfer_buffe=
r_length,
> > > -                                       pdev->urbs[i]->transfer_buffe=
r,
> > > -                                       pdev->urbs[i]->transfer_dma);
> > > -                       }
> > > -                       usb_free_urb(pdev->urbs[i]);
> > > +                       if (urb->transfer_buffer)
> > > +                               pwc_free_urb_buffer(&urb->dev->dev,
> > > +                                                   urb->transfer_buf=
fer_length,
> > > +                                                   urb->transfer_buf=
fer,
> > > +                                                   urb->transfer_dma=
);
> > > +                       usb_free_urb(urb);
> > >                         pdev->urbs[i] =3D NULL;
> > >                 }
> > >         }
> > > --
> > > 2.16.4
> > >
> >
> >
> > --
> > With best regards,
> > Matwey V. Kornilov
>
>
>
> --
> With best regards,
> Matwey V. Kornilov



--=20
With best regards,
Matwey V. Kornilov
