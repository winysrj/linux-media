Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37799 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725746AbeJCQs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 12:48:28 -0400
Received: by mail-yw1-f67.google.com with SMTP id y14-v6so2027290ywa.4
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 03:00:46 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id j8-v6sm337156ywj.6.2018.10.03.03.00.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 03:00:44 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id e201-v6so2033191ywa.3
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 03:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20180831074743.235010-1-acourbot@chromium.org>
 <CAAFQd5ALyeeru36zVYjG6P2U_JWMgxiv0WPnF2DD2OHHd+nHbQ@mail.gmail.com> <CAPBb6MXjsY-JypvyW+m=GbAri9qMg21xpyMXzDbUTG4=eFhavw@mail.gmail.com>
In-Reply-To: <CAPBb6MXjsY-JypvyW+m=GbAri9qMg21xpyMXzDbUTG4=eFhavw@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 3 Oct 2018 19:00:32 +0900
Message-ID: <CAAFQd5CyC5N05SRZNYj5RJE5HPaC2AecsMvspoiP_a4yZ8P+XA@mail.gmail.com>
Subject: Re: [RFC PATCH] media: docs-rst: Document m2m stateless video decoder interface
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 11, 2018 at 3:09 PM Alexandre Courbot <acourbot@chromium.org> wrote:
> On Mon, Sep 10, 2018 at 4:17 PM Tomasz Figa <tfiga@chromium.org> wrote:
> > On Fri, Aug 31, 2018 at 4:48 PM Alexandre Courbot <acourbot@chromium.org> wrote:
[snip]
> > > +Querying capabilities
> > > +=====================
> > > +
> > > +1. To enumerate the set of coded formats supported by the driver, the client
> > > +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> > > +
> > > +   * The driver must always return the full set of supported formats for the
> > > +     currently set ``OUTPUT`` format, irrespective of the format currently set
> > > +     on the ``CAPTURE`` queue.
> > > +
> > > +2. To enumerate the set of supported raw formats, the client calls
> > > +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> > > +
> > > +   * The driver must return only the formats supported for the format currently
> > > +     active on the ``OUTPUT`` queue.
> > > +
> > > +   * In order to enumerate raw formats supported by a given coded format, the
> > > +     client must thus set that coded format on the ``OUTPUT`` queue first, and
> > > +     then enumerate the ``CAPTURE`` queue.
> >
> > One thing that we might want to note here is that available CAPTURE
> > formats may depend on more factors than just current OUTPUT format.
> > Depending on encoding options of the stream being decoded (e.g. VP9
> > profile), the list of supported format might be limited to one of YUV
> > 4:2:0, 4:2:2 or 4:4:4 family of formats, but might be any of them, if
> > the hardware supports conversion.
> >
> > I was wondering whether we shouldn't require the client to set all the
> > necessary initial codec-specific controls before querying CAPTURE
> > formats, but since we don't have any compatibility constraints here,
> > as opposed to the stateful API, perhaps we could just make CAPTURE
> > queue completely independent and have a source change event raised if
> > the controls set later make existing format invalid.
> >
> > I'd like to ask the userspace folks here (Nicolas?), whether:
> > 1) we need to know the exact list of formats that are guaranteed to be
> > supported for playing back the whole video, or
> > 2) we're okay with some rough approximation here, or
> > 3) maybe we don't even need to enumerate formats on CAPTURE beforehand?
>
> Since user-space will need to parse all the profile and other
> information and submit it to the kernel anyway, it seems to me that
> requiring it to submit that information before setting the CAPTURE
> format makes the most sense. Otherwise all clients should listen for
> events and be capable of renegotiating the format, which would
> complicate them some more.

I would indeed lean towards just setting the relevant controls here at
initialization and be done without any source change events.

>
> >
> > To be honest, I'm not sure 1) is even possible, since the resolution
> > (or some other stream parameters) could change mid-stream.
>
> Even in that case, the client is supposed to handle that change, so I
> don't think this makes a big difference compared to initial
> negotiation?

Indeed.

[snip]
> > > +6. *[optional]* Choose a different ``CAPTURE`` format than suggested via
> > > +   :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for the client to
> > > +   choose a different format than selected/suggested by the driver in
> > > +   :c:func:`VIDIOC_G_FMT`.
> > > +
> > > +    * **Required fields:**
> > > +
> > > +      ``type``
> > > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > > +
> > > +      ``pixelformat``
> > > +          a raw pixel format
> > > +
> > > +    .. note::
> > > +
> > > +       Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently available
> > > +       formats after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is useful to find
> > > +       out a set of allowed formats for given configuration, but not required,
> > > +       if the client can accept the defaults.
> >
> > V4L2_EVENT_SOURCE_CHANGE was not mentioned in earlier steps. I suppose
> > it's a leftover from the stateful API? :)
>
> Correct. :)
>
> >
> > Still, I think we may eventually need source change events, because of
> > the reasons I mentioned above.
>
> I'd personally prefer to do without, but if they become a requirement
> (which I am not convinced of yet) we will indeed have no choice.
>

Agreed.

[snip]
> > > +Decoding
> > > +========
> > > +
> > > +For each frame, the client is responsible for submitting a request to which the
> > > +following is attached:
> > > +
> > > +* Exactly one frame worth of encoded data in a buffer submitted to the
> > > +  ``OUTPUT`` queue,
> >
> > Just to make sure, in case of H.264, that would include all the slices
> > of the frame in one buffer, right?
>
> Yes. I thought "one frame worth of encoded data" already carried that
> meaning, but do you think this should be said more explicitly?

No strong opinion. Perhaps we could further specify this in the
description of each format.

[snip]
> > > Decoding errors are signaled by the ``CAPTURE`` buffers being
> > > +dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag.
> > > +
> > > +The contents of source ``OUTPUT`` buffers, as well as the controls that must be
> > > +set on the request, depend on active coded pixel format and might be affected by
> > > +codec-specific extended controls, as stated in documentation of each format
> > > +individually.
> > > +
> > > +MPEG-2 buffer content and controls
> > > +----------------------------------
> > > +The following information is valid when the ``OUTPUT`` queue is set to the
> > > +``V4L2_PIX_FMT_MPEG2_SLICE`` format.
> >
> > Perhaps we should document the controls there instead? I think that
> > was the conclusion from the discussions over the stateful API.
>
> Do you mean, on the format page? Sounds reasonable.
>

Yep.

[snip]
> > > +Dynamic resolution change
> > > +=========================
> > > +
> > > +If the client detects a resolution change in the stream, it may need to
> > > +reallocate the ``CAPTURE`` buffers to fit the new size.
> > > +
> > > +1. Wait until all submitted requests have completed and dequeue the
> > > +   corresponding output buffers.
> > > +
> > > +2. Call :c:func:`VIDIOC_STREAMOFF` on the ``CAPTURE`` queue.
> > > +
> > > +3. Free all ``CAPTURE`` buffers by calling :c:func:`VIDIOC_REQBUFS` on the
> > > +   ``CAPTURE`` queue with a buffer count of zero.
> > > +
> > > +4. Set the new format and resolution on the ``CAPTURE`` queue.
> > > +
> > > +5. Allocate new ``CAPTURE`` buffers for the new resolution.
> > > +
> > > +6. Call :c:func:`VIDIOC_STREAMON` on the ``CAPTURE`` queue to resume the stream.
> > > +
> > > +The client can then start queueing new ``CAPTURE`` buffers and submit requests
> > > +to decode the next buffers at the new resolution.
> >
> > There is some inconsistency here. In initialization sequence, we set
> > OUTPUT format to coded width and height and had the driver set a sane
> > default CAPTURE format. What happens to OUTPUT format? It definitely
> > wouldn't make sense if it stayed at the initial coded size.
>
> You're right. We need to set the resolution on OUTPUT first, and maybe
> reallocate input buffers as well since a resolution increase may mean
> they are now too small to contain one encoded frame.
>
> Actually, in the case of stateless codecs a resolution change may mean
> re-doing initialization from step #2. I suppose a resolution change
> can only happen on an IDR frame, so all the user-maintained state
> could be dropped anyway.
>

One could reinitialize, which would work, but could be costly.
Technically one could just use bigger frame buffers from the start,
which would make a resolution change just a no-op . The only thing
that would change would be visible size, but that's fully handled by
the user and nothing a stateless driver should be concerned with.

> >
> > > +
> > > +Drain
> > > +=====
> > > +
> > > +In order to drain the stream on a stateless decoder, the client just needs to
> > > +wait until all the submitted requests are completed. There is no need to send a
> > > +``V4L2_DEC_CMD_STOP`` command since requests are processed sequentially by the
> > > +driver.
> >
> > Is there a need to include this section? I feel like it basically says
> > "Drain sequence: There is no drain sequence." ;)
>
> This is mostly to match what we have in the stateful doc. Not saying
> anything may make it look like this has not been thoroughly tought. :)
>

I guess we can keep it indeed. Leaving to other to comment.

Best regards,
Tomasz
