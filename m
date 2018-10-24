Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39437 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbeJXRoC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 13:44:02 -0400
Received: by mail-oi1-f196.google.com with SMTP id y81-v6so3478120oia.6
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2018 02:16:44 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id v9sm1442900ote.3.2018.10.24.02.16.42
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 02:16:42 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id u74-v6so3474750oia.11
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2018 02:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <20181019080928.208446-1-acourbot@chromium.org> <a02b50ee-37e1-0202-b999-8e32b7bd1a96@xs4all.nl>
In-Reply-To: <a02b50ee-37e1-0202-b999-8e32b7bd1a96@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 24 Oct 2018 18:16:30 +0900
Message-ID: <CAPBb6MUA5zNL9SsY2AEDNKgazyAqOMxGGSwidMV+RJnnrz7kTg@mail.gmail.com>
Subject: Re: [RFC] Stateless codecs: how to refer to reference frames
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Oct 19, 2018 at 6:40 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From Alexandre's '[RFC PATCH v3] media: docs-rst: Document m2m stateless
> video decoder interface':
>
> On 10/19/18 10:09, Alexandre Courbot wrote:
> > Two points being currently discussed have not been changed in this
> > revision due to lack of better idea. Of course this is open to change:
>
> <snip>
>
> > * The other hot topic is the use of capture buffer indexes in order to
> >   reference frames. I understand the concerns, but I doesn't seem like
> >   we have come with a better proposal so far - and since capture buffers
> >   are essentially well, frames, using their buffer index to directly
> >   reference them doesn't sound too inappropriate to me. There is also
> >   the restriction that drivers must return capture buffers in queue
> >   order. Do we have any concrete example where this scenario would not
> >   work?
>
> I'll stick to decoders in describing the issue. Stateless encoders probably
> do not have this issue.
>
> To recap: the application provides a buffer with compressed data to the
> decoder. After the request is finished the application can dequeue the
> decompressed frame from the capture queue.
>
> In order to decompress the decoder needs to access previously decoded
> reference frames. The request passed to the decoder contained state
> information containing the buffer index (or indices) of capture buffers
> that contain the reference frame(s).
>
> This approach puts restrictions on the framework and the application:
>
> 1) It assumes that the application can predict the capture indices.
> This works as long as there is a simple relationship between the
> buffer passed to the decoder and the buffer you get back.
>
> But that may not be true for future codecs. And what if one buffer
> produces multiple capture buffers? (E.g. if you want to get back
> decompressed slices instead of full frames to reduce output latency).
>
> This API should be designed to be future-proof (within reason of course),
> and I am not at all convinced that future codecs will be just as easy
> to predict.
>
> 2) It assumes that neither drivers nor applications mess with the buffers.
> One case that might happen today is if the DMA fails and a buffer is
> returned marked ERROR and the DMA is retried with the next buffer. There
> is nothing in the spec that prevents you from doing that, but it will mess
> up the capture index numbering. And does the application always know in
> what order capture buffers are queued? Perhaps there are two threads: one
> queueing buffers with compressed data, and the other dequeueing the
> decompressed buffers, and they are running mostly independently.
>
>
> I believe that assuming that you can always predict the indices of the
> capture queue is dangerous and asking for problems in the future.
>
>
> I am very much in favor of using a dedicated cookie. The application sets
> it for the compressed buffer and the driver copies it to the uncompressed
> capture buffer. It keeps track of the association between capture index
> and cookie. If a compressed buffer decompresses into multiple capture
> buffers, then they will all be associated with the same cookie, so
> that simplifies how you refer to reference frames if they are split
> over multiple buffers.
>
> The codec controls refer to reference frames by cookie(s).

So as discussed yesterday, I understand your issue with using buffer
indexes. The cookie idea sounds like it could work, but I'm afraid you
could still run into issues when you don't have buffer symmetry.

For instance, imagine that the compressed buffer contains 2 frames
worth of data. In this case, the 2 dequeued capture buffers would
carry the same cookie, making it impossible to reference either frame
unambiguously.

There may also be a similar, yet simpler solution already in place
that we can use. The v4l2_buffer structure contains a "sequence"
member, that is supposed to sequentially count the delivered frames.
What if we used this field in the same spirit as your cookie?
Userspace would just need to keep count of the number of frames sent
to the driver in order to accurately predict which sequence number a
given frame is going to carry. Then the driver/framework just needs to
associate the last sequence number of each buffer so it can find the
reference frames, and we have an way to refer every frame. Would that
work? We would need to make sure that error buffers are returned for
every frame that fails (otherwise the counter could deviate between
kernel and user-space), but if we take care of that it seems to me
that this would stand, while being simpler and taking advantage of an
already existing field.
