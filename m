Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36794 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbcJOARA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 20:17:00 -0400
Received: by mail-vk0-f45.google.com with SMTP id 2so130713659vkb.3
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2016 17:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476469229.4684.70.camel@gmail.com>
References: <CAOMLVLj9zwMCOCRawKZKDDtLkwHUN3VpLhpy2Qovn7Bv1X5SgA@mail.gmail.com>
 <1476469229.4684.70.camel@gmail.com>
From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?= <wuchengli@google.com>
Date: Sat, 15 Oct 2016 08:16:39 +0800
Message-ID: <CAOMLVLhM006pYiP7xEmZoVFzwV4Zzw25wS1e1EPDDLXps873Mw@mail.gmail.com>
Subject: Re: V4L2_DEC_CMD_STOP and last_buffer_dequeued
To: nicolas@ndufresne.ca
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        pawel@osciak.com, Tiffany Lin <tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 15, 2016 at 2:20 AM, Nicolas Dufresne
<nicolas.dufresne@gmail.com> wrote:
>
> Le mercredi 12 octobre 2016 =C3=A0 23:33 +0800, Wu-Cheng Li (=E6=9D=8E=E5=
=8B=99=E8=AA=A0) a =C3=A9crit :
> > I'm trying to use V4L2_DEC_CMD_STOP to implement flush. First the
> > userspace sent V4L2_DEC_CMD_STOP to initiate the flush. The driver
> > set
> > V4L2_BUF_FLAG_LAST on the last CAPTURE buffer. I thought implementing
> > V4L2_DEC_CMD_START in the driver was enough to start the decoder. But
> > last_buffer_dequeued had been set to true in v4l2 core. I couldn't
> > clear last_buffer_dequeued without calling STREAMOFF from the
> > userspace. If I need to call STREAMOFF/STREAMON after
> > V4L2_DEC_CMD_STOP, it looks like V4L2_DEC_CMD_START is not useful.
> > Did
> > I miss anything?
>
> It's likely what the driver do is slightly off what the spec say. All
> user space code so far seems to only drain at EOS. As the next buffer
> is a new stream, it make sense to completely reset the encoder. We'd
> need to review that, but using CMD_START should work if you queue a
> header first.

last_buffer_dequeued is only cleared to false when CAPTURE queue is
STREAMOFF (#1). Queuing a header to OUTPUT queue won't clear
last_buffer_dequeued of CAPTURE queue. It looks to me that v4l2 core
needs to intercept CMD_START and clear last_buffer_dequeued. What do
you think?

http://lxr.free-electrons.com/source/drivers/media/v4l2-core/videobuf2-core=
.c#L1951
>
>
> Note that for many a flush is the action of getting rid of the pending
> images and achieve by using STREAMOFF. While the effect of CMD_STOP is
> to signal the decoder that no more encoded image will be queued, hence
> remaining images should be delivered to userspace. They will
> differentiate as a flush operation vs as drain operation. This is no
> rocket science of course.

I see. What I want is drain operation. In Chromium terms, CMD_STOP
maps to flush and STREAMOFF maps to reset.
>
>
> regards,
> Nicolas
