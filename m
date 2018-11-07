Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37147 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387839AbeKGOHN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 09:07:13 -0500
Received: by mail-yw1-f66.google.com with SMTP id v77-v6so6128115ywc.4
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 20:38:33 -0800 (PST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id m193-v6sm2663112ywd.92.2018.11.06.20.38.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 20:38:31 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id n140-v6so6354447yba.1
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 20:38:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <CAAFQd5CQEhmuLbs0dmGfu66x1Xq1V_kOT0bV_DoPitkkOX5Q4A@mail.gmail.com> <4fa1b96d-912c-ec07-f08e-d8de164a0186@ideasonboard.com>
In-Reply-To: <4fa1b96d-912c-ec07-f08e-d8de164a0186@ideasonboard.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 7 Nov 2018 13:38:19 +0900
Message-ID: <CAAFQd5CKuGRGevKRgqHjQ6nU=EXz720-yxS6uoe3CF-AY5+knQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] media: uvcvideo: Move decode processing to process context
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        olivier.braun@stereolabs.com, troy.kisky@boundarydevices.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, Nov 7, 2018 at 12:13 AM Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On 07/08/2018 10:54, Tomasz Figa wrote:
> > Hi Kieran,
> >
> > On Wed, Mar 28, 2018 at 1:47 AM Kieran Bingham
> > <kieran.bingham@ideasonboard.com> wrote:
> > [snip]
> >> @@ -1544,25 +1594,29 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
> >>   */
> >>  static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
> >>  {
> >> -       struct urb *urb;
> >> -       unsigned int i;
> >> +       struct uvc_urb *uvc_urb;
> >>
> >>         uvc_video_stats_stop(stream);
> >>
> >> -       for (i = 0; i < UVC_URBS; ++i) {
> >> -               struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
> >> +       /*
> >> +        * We must poison the URBs rather than kill them to ensure that even
> >> +        * after the completion handler returns, any asynchronous workqueues
> >> +        * will be prevented from resubmitting the URBs
> >> +        */
> >> +       for_each_uvc_urb(uvc_urb, stream)
> >> +               usb_poison_urb(uvc_urb->urb);
> >>
> >> -               urb = uvc_urb->urb;
> >> -               if (urb == NULL)
> >> -                       continue;
> >> +       flush_workqueue(stream->async_wq);
> >>
> >> -               usb_kill_urb(urb);
> >> -               usb_free_urb(urb);
> >> +       for_each_uvc_urb(uvc_urb, stream) {
> >> +               usb_free_urb(uvc_urb->urb);
> >>                 uvc_urb->urb = NULL;
> >>         }
> >>
> >>         if (free_buffers)
> >>                 uvc_free_urb_buffers(stream);
> >> +
> >> +       destroy_workqueue(stream->async_wq);
> >
> > In our testing, this function ends up being called twice, if before
> > suspend the camera is streaming and if the camera disconnects between
> > suspend and resume. This is because uvc_video_suspend() calls this
> > function (with free_buffers = 0), but uvc_video_resume() wouldn't call
> > uvc_init_video() due to an earlier failure and uvc_v4l2_release()
> > would end up calling this function again, while the workqueue is
> > already destroyed.
> >
> > The following diff seems to take care of it:
>
> Thank you for this. After discussing with Laurent, I have gone with the
> approach of keeping the workqueue for the lifetime of the stream, rather
> than the lifetime of the streamon.
>

Sounds good to me. Thanks for heads up!

Best regards,
Tomasz
