Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:53076 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbeJVSHY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 14:07:24 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.23/8.16.0.23) with SMTP id w9M9nYec023416
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 10:49:34 +0100
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        by mx08-00252a01.pphosted.com with ESMTP id 2n7ruerwne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 10:49:34 +0100
Received: by mail-pl1-f198.google.com with SMTP id d63-v6so29761425pld.18
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 02:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
 <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
 <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de> <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
In-Reply-To: <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Mon, 22 Oct 2018 10:49:19 +0100
Message-ID: <CAAoAYcMS1vUMVjCucQvvLRHpbRw=J0fY-8kUfqA7K_CvmWaDxw@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: Tomasz Figa <tfiga@chromium.org>
Cc: pza@pengutronix.de, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz

On Mon, 22 Oct 2018 at 04:38, Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Philipp,
>
> On Mon, Oct 22, 2018 at 1:28 AM Philipp Zabel <pza@pengutronix.de> wrote:
> >
> > On Wed, Oct 03, 2018 at 05:24:39PM +0900, Tomasz Figa wrote:
> > [...]
> > > > Yes, but that would fall in a complete redesign I guess. The buffer
> > > > allocation scheme is very inflexible. You can't have buffers of two
> > > > dimensions allocated at the same time for the same queue. Worst, you
> > > > cannot leave even 1 buffer as your scannout buffer while reallocating
> > > > new buffers, this is not permitted by the framework (in software). As a
> > > > side effect, there is no way to optimize the resolution changes, you
> > > > even have to copy your scannout buffer on the CPU, to free it in order
> > > > to proceed. Resolution changes are thus painfully slow, by design.
> > [...]
> > > Also, I fail to understand the scanout issue. If one exports a vb2
> > > buffer to a DMA-buf and import it to the scanout engine, it can keep
> > > scanning out from it as long as it want, because the DMA-buf will hold
> > > a reference on the buffer, even if it's removed from the vb2 queue.
> >
> > REQBUFS 0 fails if the vb2 buffer is still in use, including from dmabuf
> > attachments: vb2_buffer_in_use checks the num_users memop. The refcount
> > returned by num_users shared between the vmarea handler and dmabuf ops,
> > so any dmabuf attachment counts towards in_use.
>
> Ah, right. I've managed to completely forget about it, since we have a
> downstream patch that we attempted to upstream earlier [1], but didn't
> have a chance to follow up on the comments and there wasn't much
> interest in it in general.
>
> [1] https://lore.kernel.org/patchwork/patch/607853/
>
> Perhaps it would be worth reviving?

There's been recent interest in this from the LibreElec folk as they
are wanting to shift to using V4L2 M2M for codecs on as many platforms
as possible. They'll use it wrapped by FFmpeg, and they're working on
patches to get FFmpeg exporting dmabufs to be consumed by DRM.

Hans had pointed me at your patch, and I've been using it to get
around the issue.
I did start writing the requested docs changes [1], but I'm afraid
upstreaming stuff has been a low priority for me recently. If that
patch suffices, then feel free to pick it up. Otherwise I'll do so
when I get some time (likely to be a fair number of weeks away).

  Dave

[1] https://github.com/6by9/linux/commit/09619d9427d9d44ae5e72e0e85e64cb3ea9727da
