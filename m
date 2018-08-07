Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:40509 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeHGJSt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 05:18:49 -0400
Received: by mail-yb0-f194.google.com with SMTP id n10-v6so1961990ybd.7
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 00:05:52 -0700 (PDT)
Received: from mail-yb0-f172.google.com (mail-yb0-f172.google.com. [209.85.213.172])
        by smtp.gmail.com with ESMTPSA id l62-v6sm294876ywb.29.2018.08.07.00.05.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 00:05:50 -0700 (PDT)
Received: by mail-yb0-f172.google.com with SMTP id s1-v6so6272932ybk.3
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 00:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <a6af3dc9-1d09-a414-ce31-bc1b3e69894f@xs4all.nl>
In-Reply-To: <a6af3dc9-1d09-a414-ce31-bc1b3e69894f@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 7 Aug 2018 16:05:38 +0900
Message-ID: <CAAFQd5AnC+hWy4QUGE-s+qgRvvgGC7rMhH6x8koTfYJzTLw8Cg@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 26, 2018 at 7:57 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 26/07/18 12:20, Tomasz Figa wrote:
> > Hi Hans,
> >
> > On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> Hi Tomasz,
> >>
> >> Many, many thanks for working on this! It's a great document and when done
> >> it will be very useful indeed.
> >>
> >> Review comments follow...
> >
> > Thanks for review!
> >
> >>
> >> On 24/07/18 16:06, Tomasz Figa wrote:
>
> > [snip]
>
> >> Note that the v4l2_pix_format/S_FMT documentation needs to be updated as well
> >> since we never allowed 0x0 before.
> >
> > Is there any text that disallows this? I couldn't spot any. Generally
> > there are already drivers which return 0x0 for coded formats (s5p-mfc)
> > and it's not even strange, because in such case, the buffer contains
> > just a sequence of bytes, not a 2D picture.
>
> All non-m2m devices will always have non-zero width/height values. Only with
> m2m devices do we see this.
>
> This was probably never documented since before m2m appeared it was 'obvious'.
>
> This definitely needs to be documented, though.
>

Fair enough. Let me try to add a note there.

> >
> >> What if you set the format to 0x0 but the stream does not have meta data with
> >> the resolution? How does userspace know if 0x0 is allowed or not? If this is
> >> specific to the chosen coded pixel format, should be add a new flag for those
> >> formats indicating that the coded data contains resolution information?
> >
> > Yes, this would definitely be on a per-format basis. Not sure what you
> > mean by a flag, though? E.g. if the format is set to H264, then it's
> > bound to include resolution information. If the format doesn't include
> > it, then userspace is already aware of this fact, because it needs to
> > get this from some other source (e.g. container).
> >
> >>
> >> That way userspace knows if 0x0 can be used, and the driver can reject 0x0
> >> for formats that do not support it.
> >
> > As above, but I might be misunderstanding your suggestion.
>
> So my question is: is this tied to the pixel format, or should we make it
> explicit with a flag like V4L2_FMT_FLAG_CAN_DECODE_WXH.
>
> The advantage of a flag is that you don't need a switch on the format to
> know whether or not 0x0 is allowed. And the flag can just be set in
> v4l2-ioctls.c.

As far as my understanding goes, what data is included in the stream
is definitely specified by format. For example, a H264 elementary
stream will always include those data as a part of SPS.

However, having such flag internally, not exposed to userspace, could
indeed be useful to avoid all drivers have such switch. That wouldn't
belong to this documentation, though, since it would be just kernel
API.

>
> >>> +STREAMOFF-STREAMON sequence on it is intended solely for changing buffer
> >>> +sets.
> >>
> >> 'changing buffer sets': not clear what is meant by this. It's certainly not
> >> 'solely' since it can also be used to achieve an instantaneous seek.
> >>
> >
> > To be honest, I'm not sure whether there is even a need to include
> > this whole section. It's obvious that if you stop feeding a mem2mem
> > device, it will pause. Moreover, other sections imply various
> > behaviors triggered by STREAMOFF/STREAMON/DECODER_CMD/etc., so it
> > should be quite clear that they are different from a simple pause.
> > What do you think?
>
> Yes, I'd drop this last sentence ('Similarly...sets').
>

Ack.

> >>> +2.  After all buffers containing decoded frames from before the resolution
> >>> +    change point are ready to be dequeued on the ``CAPTURE`` queue, the
> >>> +    driver sends a ``V4L2_EVENT_SOURCE_CHANGE`` event for source change
> >>> +    type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> >>> +
> >>> +    * The last buffer from before the change must be marked with
> >>> +      :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as in the
> >>
> >> spurious 'as'?
> >>
> >
> > It should be:
> >
> >     * The last buffer from before the change must be marked with
> >       the ``V4L2_BUF_FLAG_LAST`` flag in :c:type:`v4l2_buffer` ``flags`` field,
> >       similarly to the
>
> Ah, OK. Now I get it.
>
> >> I wonder if we should make these min buffer controls required. It might be easier
> >> that way.
> >
> > Agreed. Although userspace is still free to ignore it, because REQBUFS
> > would do the right thing anyway.
>
> It's never been entirely clear to me what the purpose of those min buffers controls
> is. REQBUFS ensures that the number of buffers is at least the minimum needed to
> make the HW work. So why would you need these controls? It only makes sense if they
> return something different from REQBUFS.
>

The purpose of those controls is to let the client allocate a number
of buffers bigger than minimum, without the need to allocate the
minimum number of buffers first (to just learn the number), free them
and then allocate a bigger number again.

> >
> >>
> >>> +7.  If all the following conditions are met, the client may resume the
> >>> +    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
> >>> +    ``V4L2_DEC_CMD_START`` command, as in case of resuming after the drain
> >>> +    sequence:
> >>> +
> >>> +    * ``sizeimage`` of new format is less than or equal to the size of
> >>> +      currently allocated buffers,
> >>> +
> >>> +    * the number of buffers currently allocated is greater than or equal to
> >>> +      the minimum number of buffers acquired in step 6.
> >>
> >> You might want to mention that if there are insufficient buffers, then
> >> VIDIOC_CREATE_BUFS can be used to add more buffers.
> >>
> >
> > This might be a bit tricky, since at least s5p-mfc and coda can only
> > work on a fixed buffer set and one would need to fully reinitialize
> > the decoding to add one more buffer, which would effectively be the
> > full resolution change sequence, as below, just with REQBUFS(0),
> > REQBUFS(N) replaced with CREATE_BUFS.
>
> What happens today in those drivers if you try to call CREATE_BUFS?

s5p-mfc doesn't set the .vidioc_create_bufs pointer in its
v4l2_ioctl_ops, so I suppose that would be -ENOTTY?

Best regards,
Tomasz
