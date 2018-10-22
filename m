Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34171 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbeJVLyx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 07:54:53 -0400
Received: by mail-yb1-f196.google.com with SMTP id n140-v6so726941yba.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 20:38:11 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id k82-v6sm8375226ywe.24.2018.10.21.20.38.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 20:38:09 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id j193-v6so4322685ybj.6
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 20:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
 <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com> <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de>
In-Reply-To: <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 22 Oct 2018 12:37:57 +0900
Message-ID: <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: pza@pengutronix.de
Cc: nicolas@ndufresne.ca, Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Mon, Oct 22, 2018 at 1:28 AM Philipp Zabel <pza@pengutronix.de> wrote:
>
> On Wed, Oct 03, 2018 at 05:24:39PM +0900, Tomasz Figa wrote:
> [...]
> > > Yes, but that would fall in a complete redesign I guess. The buffer
> > > allocation scheme is very inflexible. You can't have buffers of two
> > > dimensions allocated at the same time for the same queue. Worst, you
> > > cannot leave even 1 buffer as your scannout buffer while reallocating
> > > new buffers, this is not permitted by the framework (in software). As a
> > > side effect, there is no way to optimize the resolution changes, you
> > > even have to copy your scannout buffer on the CPU, to free it in order
> > > to proceed. Resolution changes are thus painfully slow, by design.
> [...]
> > Also, I fail to understand the scanout issue. If one exports a vb2
> > buffer to a DMA-buf and import it to the scanout engine, it can keep
> > scanning out from it as long as it want, because the DMA-buf will hold
> > a reference on the buffer, even if it's removed from the vb2 queue.
>
> REQBUFS 0 fails if the vb2 buffer is still in use, including from dmabuf
> attachments: vb2_buffer_in_use checks the num_users memop. The refcount
> returned by num_users shared between the vmarea handler and dmabuf ops,
> so any dmabuf attachment counts towards in_use.

Ah, right. I've managed to completely forget about it, since we have a
downstream patch that we attempted to upstream earlier [1], but didn't
have a chance to follow up on the comments and there wasn't much
interest in it in general.

[1] https://lore.kernel.org/patchwork/patch/607853/

Perhaps it would be worth reviving?

Best regards,
Tomasz
