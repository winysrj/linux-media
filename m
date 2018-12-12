Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4768CC04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 13:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECA3120839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 13:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7eZjBfa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECA3120839
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbeLLNHw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:07:52 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35670 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbeLLNHv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 08:07:51 -0500
Received: by mail-oi1-f193.google.com with SMTP id v6so14959789oif.2;
        Wed, 12 Dec 2018 05:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+uiLBk4noeZtPZW+Y7JJbmN8TvyfyDY3zLWhFnh6duw=;
        b=h7eZjBfaywc3itUqDMyPMGLhPeSGqurG5RA8jYnmG3hBo5je13C5o3m8NC+IB/6Weg
         DTw4mkgTX9dCmWYHcIw0uln4ETQZrnQYbHEWonOh3ULdiKFSKkV49aXXa8PK4vdUcvOp
         IFDY5lDKXBtcQx0zsc5DiWs1hQ53PI2CcgO4BHXfIUvK4mYi2sz0ss1ZWo0t7W5Lnq4F
         33XoGDREhAWjOi/OI2x2/HaO4BzWcbvY/KTgAScCQd+iNKgYdKl05jGq5xEeXCI9yywZ
         T5+Vkv5LaXvHPHUAkjsVddUAeP38ifblgQNxrmhh9Hj/qFVBeBTwTmrtr6jiUyIkto5I
         pStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+uiLBk4noeZtPZW+Y7JJbmN8TvyfyDY3zLWhFnh6duw=;
        b=UuLwW7kqQP7jswhUwRxiUROtslYMbFv5pXskRqV7k6+TnVLX4cUQO2ZZrdx/NjMNiY
         mD1E3JKdsSXbTD9jTKsV2EbXJvaLtoMcMaU2JTnub+ENULGQzGwNPsUVKbe+m9VGYXnx
         mvqBbHrOdQcx6peMMW/S/72svqZc+El1lEvUv2HLNozSzI5j4p+EVbJEcwpjtLxzU2Aw
         s9eUsFwrbSihCMP1w8l5MmJBTDJSHN+qmISHbnr+Hf7x03/52gUn5JpG4NFRSihhdMwk
         BoHpTvmY9qUtsDcGWKMonvC/elaRnZaCMqwjezAgx10d78hP4wQm/CiErq5FhfWVso1k
         Q8Jg==
X-Gm-Message-State: AA+aEWaQssV/bVPr6tG1GthnfnyH/964+osWdtlxwfITbxmur/IGGbLC
        8lxUCtVwwFQ1N1FqJE4vIX2MD5bNIvVIQ2WUlcOvhw==
X-Google-Smtp-Source: AFSGD/WJFGtXR+yXwbRV/brwjx6Kbxz5IkcioPUsn+m89M8HsIF4TWH3bJQYUi673eYSCxRvYcvQVT7RvNBL5PkZRSQ=
X-Received: by 2002:aca:6545:: with SMTP id j5mr366836oiw.70.1544620069931;
 Wed, 12 Dec 2018 05:07:49 -0800 (PST)
MIME-Version: 1.0
References: <20181109190327.23606-1-matwey@sai.msu.ru> <20181109190327.23606-3-matwey@sai.msu.ru>
 <CAJs94Eb6Ev5O+Q_THYruxozSW2sTjWCrHhU8wciFNgYx7oCRuQ@mail.gmail.com> <CAJs94EYmRpUSnxzyt-8bdSwp3WgvOuqpt4b55wKQ41jDynFceg@mail.gmail.com>
In-Reply-To: <CAJs94EYmRpUSnxzyt-8bdSwp3WgvOuqpt4b55wKQ41jDynFceg@mail.gmail.com>
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date:   Wed, 12 Dec 2018 16:07:38 +0300
Message-ID: <CAJs94EbrOqdn5=xEnyQEC6aqYh=Wojh3-wGxT325f5Q7wnc36w@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Tomasz Figa <tfiga@chromium.org>,
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
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

=D0=BF=D1=82, 30 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 15:20, Matwe=
y V. Kornilov <matwey.kornilov@gmail.com>:
>
> =D1=81=D1=80, 21 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 21:15, Mat=
wey V. Kornilov <matwey.kornilov@gmail.com>:
> >
> > =D0=BF=D1=82, 9 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 22:03, Ma=
twey V. Kornilov <matwey@sai.msu.ru>:
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
> > >  * kmalloc:            rate =3D  ( 94 +- 4) MBps
> > >                        time =3D  (101 +- 4) usec
> > >  * usb_alloc_coherent: rate =3D (28.1 +- 0.1) MBps
> > >                        time =3D  (341 +- 2) usec
> > >
> > > Note, that quantative difference leads (this commit leads to 3.3 time=
s
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
>
> Ping

Ping

>
> >
> > > ---
> > >  drivers/media/usb/pwc/pwc-if.c | 62 ++++++++++++++++++++++++++++++++=
+---------
> > >  1 file changed, 49 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/p=
wc-if.c
> > > index 53c111bd5a22..a81fb319b339 100644
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
> > > @@ -352,6 +383,11 @@ static void pwc_isoc_handler(struct urb *urb)
> > >                 pdev->vlast_packet_size =3D flen;
> > >         }
> > >
> > > +       dma_sync_single_for_device(&urb->dev->dev,
> > > +                                  urb->transfer_dma,
> > > +                                  urb->transfer_buffer_length,
> > > +                                  DMA_FROM_DEVICE);
> > > +
> > >  handler_end:
> > >         trace_pwc_handler_exit(urb, pdev);
> > >
> > > @@ -428,16 +464,15 @@ static int pwc_isoc_init(struct pwc_device *pde=
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
> > > @@ -488,15 +523,16 @@ static void pwc_iso_free(struct pwc_device *pde=
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
