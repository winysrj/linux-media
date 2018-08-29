Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:43238 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbeH2Mpy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 08:45:54 -0400
Received: by mail-yb0-f193.google.com with SMTP id k5-v6so1704548ybo.10
        for <linux-media@vger.kernel.org>; Wed, 29 Aug 2018 01:50:03 -0700 (PDT)
Received: from mail-yb0-f169.google.com (mail-yb0-f169.google.com. [209.85.213.169])
        by smtp.gmail.com with ESMTPSA id o63-v6sm1231388ywc.36.2018.08.29.01.50.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Aug 2018 01:50:01 -0700 (PDT)
Received: by mail-yb0-f169.google.com with SMTP id d34-v6so1711243yba.3
        for <linux-media@vger.kernel.org>; Wed, 29 Aug 2018 01:50:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180824082156.6986-1-hverkuil@xs4all.nl> <20180824082156.6986-5-hverkuil@xs4all.nl>
 <CAAFQd5A+UCSxBM11-maLbe-0WAKVFnk-mDCn+o06Xd9JO7=0_g@mail.gmail.com> <ef161d62-bf9b-427d-9fb5-f022f2b0d83b@xs4all.nl>
In-Reply-To: <ef161d62-bf9b-427d-9fb5-f022f2b0d83b@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 29 Aug 2018 17:49:49 +0900
Message-ID: <CAAFQd5Bdvxw_=qrKuFPt87LfM1aR+1LuWQ7L3jZo9JuGWVykUA@mail.gmail.com>
Subject: Re: [PATCH 4/5] videodev2.h: add new capabilities for buffer types
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hansverk@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 28, 2018 at 9:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 24/08/18 16:36, Tomasz Figa wrote:
> > Hi Hans,
> >
> > On Fri, Aug 24, 2018 at 5:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> From: Hans Verkuil <hansverk@cisco.com>
> >>
> >> VIDIOC_REQBUFS and VIDIOC_CREATE_BUFFERS will return capabilities
> >> telling userspace what the given buffer type is capable of.
> >>
> >
> > Please see my comments below.
> >
> >> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> >> ---
> >>  .../media/uapi/v4l/vidioc-create-bufs.rst     | 10 +++++-
> >>  .../media/uapi/v4l/vidioc-reqbufs.rst         | 36 ++++++++++++++++++-
> >>  include/uapi/linux/videodev2.h                | 13 +++++--
> >>  3 files changed, 55 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
> >> index a39e18d69511..fd34d3f236c9 100644
> >> --- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
> >> +++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
> >> @@ -102,7 +102,15 @@ than the number requested.
> >>        - ``format``
> >>        - Filled in by the application, preserved by the driver.
> >>      * - __u32
> >> -      - ``reserved``\ [8]
> >> +      - ``capabilities``
> >> +      - Set by the driver. If 0, then the driver doesn't support
> >> +        capabilities. In that case all you know is that the driver is
> >> +       guaranteed to support ``V4L2_MEMORY_MMAP`` and *might* support
> >> +       other :c:type:`v4l2_memory` types. It will not support any others
> >> +       capabilities. See :ref:`here <v4l2-buf-capabilities>` for a list of the
> >> +       capabilities.
> >
> > Perhaps it would make sense to document how the application is
> > expected to query for these capabilities? Right now, the application
> > is expected to fill in the "memory" field in this struct (and reqbufs
> > counterpart), but it sounds a bit strange that one needs to know what
> > "memory" value to write there to query what set of "memory" values is
> > supported. In theory, MMAP is expected to be always supported, but it
> > sounds strange anyway. Also, is there a way to call REQBUFS without
> > altering the buffer allocation?
>
> No, this is only possible with CREATE_BUFS.
>
> But it is reasonable to call REQBUFS with a count of 0, since you want to
> start with a clean slate anyway.
>
> The only option I see would be to introduce a new memory type (e.g.
> V4L2_MEMORY_CAPS) to just return the capabilities. But that's more ugly
> then just requiring that you use MMAP when calling this.
>
> I'm inclined to just document that you need to set memory to MMAP if
> you want to get the capabilities since MMAP is always guaranteed to
> exist.

I guess it's the least evil we can get without changing the API too
much. Fair enough.

Best regards,
Tomasz
