Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43362 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbeJZUS0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Oct 2018 16:18:26 -0400
Received: by mail-yb1-f196.google.com with SMTP id g75-v6so316307yba.10
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2018 04:41:40 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id j74-v6sm175109ywj.20.2018.10.26.04.41.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Oct 2018 04:41:38 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id a128-v6so307556ywg.9
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2018 04:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
In-Reply-To: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 26 Oct 2018 20:41:26 +0900
Message-ID: <CAAFQd5COSecRGOSUyQGAe0ob-do0C5=FqhQZoq-d1EULhMiWHg@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hirokazu Honda <hiroh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 11:42 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Some parts of the V4L2 API are awkward to use and I think it would be
> a good idea to look at possible candidates for that.
>
> Examples are the ioctls that use struct v4l2_buffer: the multiplanar support is
> really horrible, and writing code to support both single and multiplanar is hard.
> We are also running out of fields and the timeval isn't y2038 compliant.
>
> A proof-of-concept is here:
>
> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3
>
> It's a bit old, but it gives a good impression of what I have in mind.

On a related, but slightly different note, I'm wondering how we should
handle a case where we have an M format (e.g. NV12M with 2 memory
planes), but only 1 DMA-buf with all planes to import. That generally
means that we have to use the same DMA-buf FD with an offset for each
plane. In theory, v4l2_plane::data_offset could be used for this, but
the documentation says that it should be set by the application only
for OUTPUT planes. Moreover, existing drivers tend to just ignore
it...


There is also the opposite problem. Sometimes the application is given
3 different FDs but pointing to the same buffer. If it has to work
with a video device that only supports non-M formats, it can either
fail, making it unusable, or blindly assume that they all point to the
same buffer and just give the first FD to the video device (we do it
in Chromium, since our allocator is guaranteed to keep all planes of
planar formats in one buffer, if to be used with V4L2).

Something that we could do is allowing the QBUF semantics of M formats
for non-M formats, where the application would fill the planes[] array
for all planes with all the FDs it has and the kernel could then
figure out if they point to the same buffer (i.e. resolve to the same
dma_buf struct) or fail if not.

[...]

> Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, again in
> order to improve single vs multiplanar handling.

I'd definitely be more than happy to see the plane handling unified
between non-M and M formats, in general. The list of problems with
current interface:

1) The userspace has to hardcode the computations of bytesperline for
chroma planes of non-M formats (while they are reported for M
formats).

2) Similarly, offsets of the planes in the buffer for non-M formats
must be explicitly calculated in the application,

3) Drivers have to explicitly handle both non-M and M formats or
otherwise they would suffer from issues with application compatibility
or sharing buffers with other devices (one supporting only M and the
other only non-M),

4) Inconsistency in the meaning of planes[0].sizeimage for non-M
formats and M formats, making it impossible to use planes[0].sizeimage
to set the luma plane size in the hardware for non-M formats (since
it's the total size of all planes).

I might have probably forgotten about something, but generally fixing
the 4 above, would be a really big step forward.

Best regards,
Tomasz
