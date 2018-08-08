Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37220 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbeHHG0z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 02:26:55 -0400
Received: by mail-yw1-f67.google.com with SMTP id w76-v6so618490ywg.4
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 21:09:16 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id v71-v6sm1342213ywg.68.2018.08.07.21.09.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 21:09:12 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id y203-v6so608172ywd.9
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 21:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20180627103408.33003-1-keiichiw@chromium.org> <11886963.8nkeRH3xvi@avalon>
In-Reply-To: <11886963.8nkeRH3xvi@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 13:08:59 +0900
Message-ID: <CAAFQd5CM63BQ1oxmrhZuxTVj7pc=6XUJKa-cJ3gFBHxiF3HPfQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before processing
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: keiichiw@chromium.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Douglas Anderson <dianders@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2018 at 1:00 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Keiichi,
>
> (CC'ing Alan, Ezequiel and Matwey)
>
> Thank you for the patch.
>
> On Wednesday, 27 June 2018 13:34:08 EEST Keiichi Watanabe wrote:
> > On some platforms with non-coherent DMA (e.g. ARM), USB drivers use
> > uncached memory allocation methods. In such situations, it sometimes
> > takes a long time to access URB buffers.  This can be a cause of video
> > flickering problems if a resolution is high and a USB controller has
> > a very tight time limit. (e.g. dwc2) To avoid this problem, we copy
> > header data from (uncached) URB buffer into (cached) local buffer.
> >
> > This change should make the elapsed time of the interrupt handler
> > shorter on platforms with non-coherent DMA. We measured the elapsed
> > time of each callback of uvc_video_complete without/with this patch
> > while capturing Full HD video in
> > https://webrtc.github.io/samples/src/content/getusermedia/resolution/.
> > I tested it on the top of Kieran Bingham's Asynchronous UVC series
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg128359.html.
> > The test device was Jerry Chromebook (RK3288) with Logitech Brio 4K.
> > I collected data for 5 seconds. (There were around 480 callbacks in
> > this case.) The following result shows that this patch makes
> > uvc_video_complete about 2x faster.
> >
> >            | average | median  | min     | max     | standard deviation
> >
> > w/o caching| 45319ns | 40250ns | 33834ns | 142625ns| 16611ns
> > w/  caching| 20620ns | 19250ns | 12250ns | 56583ns | 6285ns
> >
> > In addition, we confirmed that this patch doesn't make it worse on
> > coherent DMA architecture by performing the same measurements on a
> > Broadwell Chromebox with the same camera.
> >
> >            | average | median  | min     | max     | standard deviation
> >
> > w/o caching| 21026ns | 21424ns | 12263ns | 23956ns | 1932ns
> > w/  caching| 20728ns | 20398ns |  8922ns | 45120ns | 3368ns
>
> This is very interesting, and it seems related to https://
> patchwork.kernel.org/patch/10468937/. You might have seen that discussion as
> you got CC'ed at some point.
>
> I wonder whether performances couldn't be further improved by allocating the
> URB buffers cached, as that would speed up the memcpy() as well. Have you
> tested that by any chance ?

We haven't measure it, but the issue being solved here was indeed
significantly reduced by using cached URB buffers, even without
Kieran's async series. After we discovered the latter, we just
backported it and decided to further tweak the last remaining bit, to
avoid playing too much with the DMA API in code used in production on
several different platforms (including both ARM and x86).

If you think we could change the driver to use cached buffers instead
(as the pwc driver mentioned in another thread), I wouldn't have
anything against it obviously.

Best regards,
Tomasz
