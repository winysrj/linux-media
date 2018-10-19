Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41858 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726816AbeJSQtM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 12:49:12 -0400
Subject: Re: [RFC PATCH v3] media: docs-rst: Document m2m stateless video
 decoder interface
To: Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20181019080928.208446-1-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9375d854-2be5-4f69-2516-a3349fa5b50d@xs4all.nl>
Date: Fri, 19 Oct 2018 10:43:58 +0200
MIME-Version: 1.0
In-Reply-To: <20181019080928.208446-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/18 10:09, Alexandre Courbot wrote:
> Thanks everyone for the feedback on v2! I have not replied to all the
> individual emails but hope this v3 will address some of the problems
> raised and become a continuation point for the topics still in
> discussion (probably during the ELCE Media Summit).
> 
> This patch documents the protocol that user-space should follow when
> communicating with stateless video decoders. It is based on the
> following references:
> 
> * The current protocol used by Chromium (converted from config store to
>   request API)
> 
> * The submitted Cedrus VPU driver
> 
> As such, some things may not be entirely consistent with the current
> state of drivers, so it would be great if all stakeholders could point
> out these inconsistencies. :)
> 
> This patch is supposed to be applied on top of the Request API V18 as
> well as the memory-to-memory video decoder interface series by Tomasz
> Figa.
> 
> Changes since v2:
> 
> * Specify that the frame header controls should be set prior to
>   enumerating the CAPTURE queue, instead of the profile which as Paul
>   and Tomasz pointed out is not enough to know which raw formats will be
>   usable.
> * Change V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM to
>   V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS.
> * Various rewording and rephrasing
> 
> Two points being currently discussed have not been changed in this
> revision due to lack of better idea. Of course this is open to change:
> 
> * The restriction of having to send full frames for each input buffer is
>   kept as-is. As Hans pointed, we currently have a hard limit of 32
>   buffers per queue, and it may be non-trivial to lift. Also some codecs
>   (at least Venus AFAIK) do have this restriction in hardware, so unless
>   we want to do some buffer-rearranging in-kernel, it is probably better
>   to keep the default behavior as-is. Finally, relaxing the rule should
>   be easy enough if we add one extra control to query whether the
>   hardware can work with slice units, as opposed to frame units.

Makes sense, as long as the restriction can be lifted in the future.

> * The other hot topic is the use of capture buffer indexes in order to
>   reference frames. I understand the concerns, but I doesn't seem like
>   we have come with a better proposal so far - and since capture buffers
>   are essentially well, frames, using their buffer index to directly
>   reference them doesn't sound too inappropriate to me. There is also
>   the restriction that drivers must return capture buffers in queue
>   order. Do we have any concrete example where this scenario would not
>   work?

I'll start a separate discussion thread for this to avoid polluting the
review of this documentation.

Regards,

	Hans
