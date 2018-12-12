Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3888C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 13:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FBF420880
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 13:56:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FBF420880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbeLLN41 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbeLLN41 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 08:56:27 -0500
Received: from gandalf.local.home (cpe-66-24-56-78.stny.res.rr.com [66.24.56.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9076F20839;
        Wed, 12 Dec 2018 13:56:24 +0000 (UTC)
Date:   Wed, 12 Dec 2018 08:56:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181212085622.6b590540@gandalf.local.home>
In-Reply-To: <CAJs94EbrOqdn5=xEnyQEC6aqYh=Wojh3-wGxT325f5Q7wnc36w@mail.gmail.com>
References: <20181109190327.23606-1-matwey@sai.msu.ru>
        <20181109190327.23606-3-matwey@sai.msu.ru>
        <CAJs94Eb6Ev5O+Q_THYruxozSW2sTjWCrHhU8wciFNgYx7oCRuQ@mail.gmail.com>
        <CAJs94EYmRpUSnxzyt-8bdSwp3WgvOuqpt4b55wKQ41jDynFceg@mail.gmail.com>
        <CAJs94EbrOqdn5=xEnyQEC6aqYh=Wojh3-wGxT325f5Q7wnc36w@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


Can someone please take this patch or at least say what's wrong with it
if you have a problem?

Matwey has been patiently pinging us once every other week for over a
month asking for a reply. I've already given my Reviewed-by from a
tracing perspective.

Ignoring patches is not a friendly gesture.

-- Steve


On Wed, 12 Dec 2018 16:07:38 +0300
"Matwey V. Kornilov" <matwey.kornilov@gmail.com> wrote:

> пт, 30 нояб. 2018 г. в 15:20, Matwey V. Kornilov <matwey.kornilov@gmail.com>:
> >
> > ср, 21 нояб. 2018 г. в 21:15, Matwey V. Kornilov <matwey.kornilov@gmail.com>:  
> > >
> > > пт, 9 нояб. 2018 г. в 22:03, Matwey V. Kornilov <matwey@sai.msu.ru>:  
> > > >
> > > > DMA cocherency slows the transfer down on systems without hardware
> > > > coherent DMA.
> > > > Instead we use noncocherent DMA memory and explicit sync at data receive
> > > > handler.
> > > >
> > > > Based on previous commit the following performance benchmarks have been
> > > > carried out. Average memcpy() data transfer rate (rate) and handler
> > > > completion time (time) have been measured when running video stream at
> > > > 640x480 resolution at 10fps.
> > > >
> > > > x86_64 based system (Intel Core i5-3470). This platform has hardware
> > > > coherent DMA support and proposed change doesn't make big difference here.
> > > >
> > > >  * kmalloc:            rate = (2.0 +- 0.4) GBps
> > > >                        time = (5.0 +- 3.0) usec
> > > >  * usb_alloc_coherent: rate = (3.4 +- 1.2) GBps
> > > >                        time = (3.5 +- 3.0) usec
> > > >
> > > > We see that the measurements agree within error ranges in this case.
> > > > So theoretically predicted performance downgrade cannot be reliably
> > > > measured here.
> > > >
> > > > armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platform
> > > > has no hardware coherent DMA support. DMA coherence is implemented via
> > > > disabled page caching that slows down memcpy() due to memory controller
> > > > behaviour.
> > > >
> > > >  * kmalloc:            rate =  ( 94 +- 4) MBps
> > > >                        time =  (101 +- 4) usec
> > > >  * usb_alloc_coherent: rate = (28.1 +- 0.1) MBps
> > > >                        time =  (341 +- 2) usec
> > > >
> > > > Note, that quantative difference leads (this commit leads to 3.3 times
> > > > acceleration) to qualitative behavior change in this case. As it was
> > > > stated before, the video stream cannot be successfully received at AM335x
> > > > platforms with MUSB based USB host controller due to performance issues
> > > > [1].
> > > >
> > > > [1] https://www.spinics.net/lists/linux-usb/msg165735.html
> > > >
> > > > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>  
> > >
> > > Ping  
> >
> > Ping  
> 
> Ping
> 
> >  
> > >  
> > > > ---
> > > >  drivers/media/usb/pwc/pwc-if.c | 62 +++++++++++++++++++++++++++++++++---------
> > > >  1 file changed, 49 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> > > > index 53c111bd5a22..a81fb319b339 100644
> > > > --- a/drivers/media/usb/pwc/pwc-if.c
> > > > +++ b/drivers/media/usb/pwc/pwc-if.c
> > > > @@ -159,6 +159,32 @@ static const struct video_device pwc_template = {
> > > >  /***************************************************************************/
> > > >  /* Private functions */
> > > >
> > > > +static void *pwc_alloc_urb_buffer(struct device *dev,
> > > > +                                 size_t size, dma_addr_t *dma_handle)
> > > > +{
> > > > +       void *buffer = kmalloc(size, GFP_KERNEL);
> > > > +
> > > > +       if (!buffer)
> > > > +               return NULL;
> > > > +
> > > > +       *dma_handle = dma_map_single(dev, buffer, size, DMA_FROM_DEVICE);
> > > > +       if (dma_mapping_error(dev, *dma_handle)) {
> > > > +               kfree(buffer);
> > > > +               return NULL;
> > > > +       }
> > > > +
> > > > +       return buffer;
> > > > +}
> > > > +
> > > > +static void pwc_free_urb_buffer(struct device *dev,
> > > > +                               size_t size,
> > > > +                               void *buffer,
> > > > +                               dma_addr_t dma_handle)
> > > > +{
> > > > +       dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
> > > > +       kfree(buffer);
> > > > +}
> > > > +
> > > >  static struct pwc_frame_buf *pwc_get_next_fill_buf(struct pwc_device *pdev)
> > > >  {
> > > >         unsigned long flags = 0;
> > > > @@ -306,6 +332,11 @@ static void pwc_isoc_handler(struct urb *urb)
> > > >         /* Reset ISOC error counter. We did get here, after all. */
> > > >         pdev->visoc_errors = 0;
> > > >
> > > > +       dma_sync_single_for_cpu(&urb->dev->dev,
> > > > +                               urb->transfer_dma,
> > > > +                               urb->transfer_buffer_length,
> > > > +                               DMA_FROM_DEVICE);
> > > > +
> > > >         /* vsync: 0 = don't copy data
> > > >                   1 = sync-hunt
> > > >                   2 = synched
> > > > @@ -352,6 +383,11 @@ static void pwc_isoc_handler(struct urb *urb)
> > > >                 pdev->vlast_packet_size = flen;
> > > >         }
> > > >
> > > > +       dma_sync_single_for_device(&urb->dev->dev,
> > > > +                                  urb->transfer_dma,
> > > > +                                  urb->transfer_buffer_length,
> > > > +                                  DMA_FROM_DEVICE);
> > > > +
> > > >  handler_end:
> > > >         trace_pwc_handler_exit(urb, pdev);
> > > >
> > > > @@ -428,16 +464,15 @@ static int pwc_isoc_init(struct pwc_device *pdev)
> > > >                 urb->dev = udev;
> > > >                 urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
> > > >                 urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> > > > -               urb->transfer_buffer = usb_alloc_coherent(udev,
> > > > -                                                         ISO_BUFFER_SIZE,
> > > > -                                                         GFP_KERNEL,
> > > > -                                                         &urb->transfer_dma);
> > > > +               urb->transfer_buffer_length = ISO_BUFFER_SIZE;
> > > > +               urb->transfer_buffer = pwc_alloc_urb_buffer(&udev->dev,
> > > > +                                                           urb->transfer_buffer_length,
> > > > +                                                           &urb->transfer_dma);
> > > >                 if (urb->transfer_buffer == NULL) {
> > > >                         PWC_ERROR("Failed to allocate urb buffer %d\n", i);
> > > >                         pwc_isoc_cleanup(pdev);
> > > >                         return -ENOMEM;
> > > >                 }
> > > > -               urb->transfer_buffer_length = ISO_BUFFER_SIZE;
> > > >                 urb->complete = pwc_isoc_handler;
> > > >                 urb->context = pdev;
> > > >                 urb->start_frame = 0;
> > > > @@ -488,15 +523,16 @@ static void pwc_iso_free(struct pwc_device *pdev)
> > > >
> > > >         /* Freeing ISOC buffers one by one */
> > > >         for (i = 0; i < MAX_ISO_BUFS; i++) {
> > > > -               if (pdev->urbs[i]) {
> > > > +               struct urb *urb = pdev->urbs[i];
> > > > +
> > > > +               if (urb) {
> > > >                         PWC_DEBUG_MEMORY("Freeing URB\n");
> > > > -                       if (pdev->urbs[i]->transfer_buffer) {
> > > > -                               usb_free_coherent(pdev->udev,
> > > > -                                       pdev->urbs[i]->transfer_buffer_length,
> > > > -                                       pdev->urbs[i]->transfer_buffer,
> > > > -                                       pdev->urbs[i]->transfer_dma);
> > > > -                       }
> > > > -                       usb_free_urb(pdev->urbs[i]);
> > > > +                       if (urb->transfer_buffer)
> > > > +                               pwc_free_urb_buffer(&urb->dev->dev,
> > > > +                                                   urb->transfer_buffer_length,
> > > > +                                                   urb->transfer_buffer,
> > > > +                                                   urb->transfer_dma);
> > > > +                       usb_free_urb(urb);
> > > >                         pdev->urbs[i] = NULL;
> > > >                 }
> > > >         }
> > > > --
> > > > 2.16.4
> > > >  
> > >
> > >
> > > --
> > > With best regards,
> > > Matwey V. Kornilov  
> >
> >
> >
> > --
> > With best regards,
> > Matwey V. Kornilov  
> 
> 
> 

