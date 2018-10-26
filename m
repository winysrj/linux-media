Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f180.google.com ([209.85.167.180]:38303 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbeJZQON (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Oct 2018 12:14:13 -0400
Received: by mail-oi1-f180.google.com with SMTP id k19-v6so189921oiw.5
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2018 00:38:18 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id v9sm3671996ote.3.2018.10.26.00.38.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Oct 2018 00:38:16 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id x4so212319otg.3
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2018 00:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20181019080928.208446-1-acourbot@chromium.org>
 <a02b50ee-37e1-0202-b999-8e32b7bd1a96@xs4all.nl> <CAPBb6MUA5zNL9SsY2AEDNKgazyAqOMxGGSwidMV+RJnnrz7kTg@mail.gmail.com>
 <515520e4-51d6-e4bb-138a-84453ea6e189@xs4all.nl>
In-Reply-To: <515520e4-51d6-e4bb-138a-84453ea6e189@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 26 Oct 2018 16:38:04 +0900
Message-ID: <CAPBb6MUou54=yhEv2g27an-ASefnaLZOyBbE-1E-CD+w0t_apg@mail.gmail.com>
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

On Wed, Oct 24, 2018 at 6:52 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> HI Alexandre,
>
> On 10/24/2018 10:16 AM, Alexandre Courbot wrote:
> > Hi Hans,
> >
> > On Fri, Oct 19, 2018 at 6:40 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> From Alexandre's '[RFC PATCH v3] media: docs-rst: Document m2m stateless
> >> video decoder interface':
> >>
> >> On 10/19/18 10:09, Alexandre Courbot wrote:
> >>> Two points being currently discussed have not been changed in this
> >>> revision due to lack of better idea. Of course this is open to change:
> >>
> >> <snip>
> >>
> >>> * The other hot topic is the use of capture buffer indexes in order to
> >>>   reference frames. I understand the concerns, but I doesn't seem like
> >>>   we have come with a better proposal so far - and since capture buffers
> >>>   are essentially well, frames, using their buffer index to directly
> >>>   reference them doesn't sound too inappropriate to me. There is also
> >>>   the restriction that drivers must return capture buffers in queue
> >>>   order. Do we have any concrete example where this scenario would not
> >>>   work?
> >>
> >> I'll stick to decoders in describing the issue. Stateless encoders probably
> >> do not have this issue.
> >>
> >> To recap: the application provides a buffer with compressed data to the
> >> decoder. After the request is finished the application can dequeue the
> >> decompressed frame from the capture queue.
> >>
> >> In order to decompress the decoder needs to access previously decoded
> >> reference frames. The request passed to the decoder contained state
> >> information containing the buffer index (or indices) of capture buffers
> >> that contain the reference frame(s).
> >>
> >> This approach puts restrictions on the framework and the application:
> >>
> >> 1) It assumes that the application can predict the capture indices.
> >> This works as long as there is a simple relationship between the
> >> buffer passed to the decoder and the buffer you get back.
> >>
> >> But that may not be true for future codecs. And what if one buffer
> >> produces multiple capture buffers? (E.g. if you want to get back
> >> decompressed slices instead of full frames to reduce output latency).
> >>
> >> This API should be designed to be future-proof (within reason of course),
> >> and I am not at all convinced that future codecs will be just as easy
> >> to predict.
> >>
> >> 2) It assumes that neither drivers nor applications mess with the buffers.
> >> One case that might happen today is if the DMA fails and a buffer is
> >> returned marked ERROR and the DMA is retried with the next buffer. There
> >> is nothing in the spec that prevents you from doing that, but it will mess
> >> up the capture index numbering. And does the application always know in
> >> what order capture buffers are queued? Perhaps there are two threads: one
> >> queueing buffers with compressed data, and the other dequeueing the
> >> decompressed buffers, and they are running mostly independently.
> >>
> >>
> >> I believe that assuming that you can always predict the indices of the
> >> capture queue is dangerous and asking for problems in the future.
> >>
> >>
> >> I am very much in favor of using a dedicated cookie. The application sets
> >> it for the compressed buffer and the driver copies it to the uncompressed
> >> capture buffer. It keeps track of the association between capture index
> >> and cookie. If a compressed buffer decompresses into multiple capture
> >> buffers, then they will all be associated with the same cookie, so
> >> that simplifies how you refer to reference frames if they are split
> >> over multiple buffers.
> >>
> >> The codec controls refer to reference frames by cookie(s).
> >
> > So as discussed yesterday, I understand your issue with using buffer
> > indexes. The cookie idea sounds like it could work, but I'm afraid you
> > could still run into issues when you don't have buffer symmetry.
> >
> > For instance, imagine that the compressed buffer contains 2 frames
> > worth of data. In this case, the 2 dequeued capture buffers would
> > carry the same cookie, making it impossible to reference either frame
> > unambiguously.
>
> But this is a stateless codec, so each compressed buffer contains only
> one frame. That's the responsibility of the bitstream parser to ensure
> that.

Just as we are making the design future-proof by considering the case
where we get one buffer per slice, shouldn't we think about the
(currently hypothetical) case of a future codec specification in which
slices contain information that is relevant for several consecutive
frames? It may be a worthless design as classic reference frames are
probably enough to carry redundant information, but wanted to point
the scenario just in case.

>
> The whole idea of the stateless codec is that you supply only one frame
> at a time to the codec.
>
> If someone indeed puts multiple frames into a single buffer, then
> the behavior is likely undefined. Does anyone have any idea what
> would happen with the cedrus driver in that case? This is actually
> a good test.
>
> Anyway, I would consider this an application bug. Garbage in, garbage out.

Yeah, at least for the existing codecs this should be a bug.

>
> >
> > There may also be a similar, yet simpler solution already in place
> > that we can use. The v4l2_buffer structure contains a "sequence"
> > member, that is supposed to sequentially count the delivered frames.
>
> The sequence field suffers from exactly the same problems as the
> buffer index: it doesn't work if one compressed frame results in
> multiple capture buffers (one for each slice), since the sequence
> number will be increased for each capture buffer. Also if capture
> buffers are marked as error for some reason, the sequence number is
> also incremented for that buffer, again making it impossible to
> predict in userspace what the sequence counter will be.

Well if we get one capture buffer per slice, user-space can count them
just as well as in the one buffer per frame scenario.

That being said, I agree that requiring user-space to keep track of
that could be tricky. Lose track once, and all your future reference
frames will use an incorrect buffer.

So cookies it is, I guess! I will include them in the next version of the RFC.

Cheers,
Alex.
