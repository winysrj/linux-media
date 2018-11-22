Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44666 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbeKVONF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 09:13:05 -0500
Received: by mail-oi1-f195.google.com with SMTP id p82-v6so6344956oih.11
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 19:35:40 -0800 (PST)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id q19sm24790582otc.60.2018.11.21.19.35.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Nov 2018 19:35:38 -0800 (PST)
Received: by mail-ot1-f47.google.com with SMTP id w25so6866956otm.13
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 19:35:38 -0800 (PST)
MIME-Version: 1.0
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
In-Reply-To: <20181114134743.18993-1-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 22 Nov 2018 12:35:26 +0900
Message-ID: <CAPBb6MUo00z1tNWPJH+gPuB54RtVQtEkRxhHABShuPEF221c1g@mail.gmail.com>
Subject: Re: [PATCHv2 0/9] vb2/cedrus: add tag support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2018 at 10:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hansverk@cisco.com>
>
> As was discussed here (among other places):
>
> https://lkml.org/lkml/2018/10/19/440
>
> using capture queue buffer indices to refer to reference frames is
> not a good idea. A better idea is to use a 'tag' where the
> application can assign a u64 tag to an output buffer, which is then
> copied to the capture buffer(s) derived from the output buffer.
>
> A u64 is chosen since this allows userspace to also use pointers to
> internal structures as 'tag'.
>
> The first three patches add core tag support, the next patch document
> the tag support, then a new helper function is added to v4l2-mem2mem.c
> to easily copy data from a source to a destination buffer that drivers
> can use.
>
> Next a new supports_tags vb2_queue flag is added to indicate that
> the driver supports tags. Ideally this should not be necessary, but
> that would require that all m2m drivers are converted to using the
> new helper function introduced in the previous patch. That takes more
> time then I have now since we want to get this in for 4.20.
>
> Finally the vim2m, vicodec and cedrus drivers are converted to support
> tags.
>
> I also removed the 'pad' fields from the mpeg2 control structs (it
> should never been added in the first place) and aligned the structs
> to a u32 boundary (u64 for the tag values).
>
> Note that this might change further (Paul suggested using bitfields).
>
> Also note that the cedrus code doesn't set the sequence counter, that's
> something that should still be added before this driver can be moved
> out of staging.
>
> Note: if no buffer is found for a certain tag, then the dma address
> is just set to 0. That happened before as well with invalid buffer
> indices. This should be checked in the driver!
>
> The previous RFC series was tested successfully with the cedrus driver.
>
> Regards,
>
>         Hans
>
> Changes since v1:
>
> - changed to a u32 tag. Using a 64 bit tag was overly complicated due
>   to the bad layout of the v4l2_buffer struct, and there is no real
>   need for it by applications.
>
> Main changes since the RFC:
>
> - Added new buffer capability flag
> - Added m2m helper to copy data between buffers
> - Added documentation
> - Added tag logging in v4l2-ioctl.c
>
> Hans Verkuil (9):
>   videodev2.h: add tag support
>   vb2: add tag support
>   v4l2-ioctl.c: log v4l2_buffer tag
>   buffer.rst: document the new buffer tag feature.
>   v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
>   vb2: add new supports_tags queue flag
>   vim2m: add tag support
>   vicodec: add tag support
>   cedrus: add tag support

Good call on the v4l2_m2m_buf_copy_data() function!

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>

>
>  Documentation/media/uapi/v4l/buffer.rst       | 32 +++++++++----
>  .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 45 ++++++++++++++++---
>  drivers/media/platform/vicodec/vicodec-core.c | 14 ++----
>  drivers/media/platform/vim2m.c                | 14 ++----
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
>  drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++--
>  drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 ++++++++++
>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++--
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
>  .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
>  include/media/v4l2-mem2mem.h                  | 21 +++++++++
>  include/media/videobuf2-core.h                |  2 +
>  include/media/videobuf2-v4l2.h                | 21 ++++++++-
>  include/uapi/linux/v4l2-controls.h            | 14 +++---
>  include/uapi/linux/videodev2.h                |  9 +++-
>  17 files changed, 178 insertions(+), 73 deletions(-)
>
> --
> 2.19.1
>
