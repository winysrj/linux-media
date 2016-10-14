Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36247 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbcJNSUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 14:20:32 -0400
Received: by mail-qk0-f169.google.com with SMTP id o68so205947028qkf.3
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2016 11:20:32 -0700 (PDT)
Message-ID: <1476469229.4684.70.camel@gmail.com>
Subject: Re: V4L2_DEC_CMD_STOP and last_buffer_dequeued
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Wu-Cheng Li =?UTF-8?Q?=28=E6=9D=8E=E5=8B=99=E8=AA=A0=29?=
        <wuchengli@google.com>, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>, pawel@osciak.com
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
Date: Fri, 14 Oct 2016 14:20:29 -0400
In-Reply-To: <CAOMLVLj9zwMCOCRawKZKDDtLkwHUN3VpLhpy2Qovn7Bv1X5SgA@mail.gmail.com>
References: <CAOMLVLj9zwMCOCRawKZKDDtLkwHUN3VpLhpy2Qovn7Bv1X5SgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 12 octobre 2016 à 23:33 +0800, Wu-Cheng Li (李務誠) a écrit :
> I'm trying to use V4L2_DEC_CMD_STOP to implement flush. First the
> userspace sent V4L2_DEC_CMD_STOP to initiate the flush. The driver
> set
> V4L2_BUF_FLAG_LAST on the last CAPTURE buffer. I thought implementing
> V4L2_DEC_CMD_START in the driver was enough to start the decoder. But
> last_buffer_dequeued had been set to true in v4l2 core. I couldn't
> clear last_buffer_dequeued without calling STREAMOFF from the
> userspace. If I need to call STREAMOFF/STREAMON after
> V4L2_DEC_CMD_STOP, it looks like V4L2_DEC_CMD_START is not useful.
> Did
> I miss anything?

It's likely what the driver do is slightly off what the spec say. All
user space code so far seems to only drain at EOS. As the next buffer
is a new stream, it make sense to completely reset the encoder. We'd
need to review that, but using CMD_START should work if you queue a
header first.

Note that for many a flush is the action of getting rid of the pending
images and achieve by using STREAMOFF. While the effect of CMD_STOP is
to signal the decoder that no more encoded image will be queued, hence
remaining images should be delivered to userspace. They will
differentiate as a flush operation vs as drain operation. This is no
rocket science of course.

regards,
Nicolas
