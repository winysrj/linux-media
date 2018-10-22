Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38531 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJVOjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 10:39:46 -0400
Received: by mail-yw1-f65.google.com with SMTP id d126-v6so15561486ywa.5
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:22:38 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id z126-v6sm1010866ywd.48.2018.10.21.23.22.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 23:22:36 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id v92-v6so2945685ybi.5
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20181019080928.208446-1-acourbot@chromium.org>
 <9375d854-2be5-4f69-2516-a3349fa5b50d@xs4all.nl> <CAPBb6MVt4WEEd+83UTPJcqUHZ6ss=TDU5C_kbTQhGqT0fWcYPQ@mail.gmail.com>
In-Reply-To: <CAPBb6MVt4WEEd+83UTPJcqUHZ6ss=TDU5C_kbTQhGqT0fWcYPQ@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 22 Oct 2018 15:22:25 +0900
Message-ID: <CAAFQd5B2i+kpP7rpvCGuAGRV13Crxk61Xk23XBoR_CEZte3ARg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] media: docs-rst: Document m2m stateless video
 decoder interface
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 22, 2018 at 3:05 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> On Fri, Oct 19, 2018 at 5:44 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 10/19/18 10:09, Alexandre Courbot wrote:
> > > Thanks everyone for the feedback on v2! I have not replied to all the
> > > individual emails but hope this v3 will address some of the problems
> > > raised and become a continuation point for the topics still in
> > > discussion (probably during the ELCE Media Summit).
> > >
> > > This patch documents the protocol that user-space should follow when
> > > communicating with stateless video decoders. It is based on the
> > > following references:
> > >
> > > * The current protocol used by Chromium (converted from config store to
> > >   request API)
> > >
> > > * The submitted Cedrus VPU driver
> > >
> > > As such, some things may not be entirely consistent with the current
> > > state of drivers, so it would be great if all stakeholders could point
> > > out these inconsistencies. :)
> > >
> > > This patch is supposed to be applied on top of the Request API V18 as
> > > well as the memory-to-memory video decoder interface series by Tomasz
> > > Figa.
> > >
> > > Changes since v2:
> > >
> > > * Specify that the frame header controls should be set prior to
> > >   enumerating the CAPTURE queue, instead of the profile which as Paul
> > >   and Tomasz pointed out is not enough to know which raw formats will be
> > >   usable.
> > > * Change V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM to
> > >   V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS.
> > > * Various rewording and rephrasing
> > >
> > > Two points being currently discussed have not been changed in this
> > > revision due to lack of better idea. Of course this is open to change:
> > >
> > > * The restriction of having to send full frames for each input buffer is
> > >   kept as-is. As Hans pointed, we currently have a hard limit of 32
> > >   buffers per queue, and it may be non-trivial to lift. Also some codecs
> > >   (at least Venus AFAIK) do have this restriction in hardware, so unless
> > >   we want to do some buffer-rearranging in-kernel, it is probably better
> > >   to keep the default behavior as-is. Finally, relaxing the rule should
> > >   be easy enough if we add one extra control to query whether the
> > >   hardware can work with slice units, as opposed to frame units.
> >
> > Makes sense, as long as the restriction can be lifted in the future.
>
> Lifting this limitation once we support more than 32 buffers should
> not be an issue. Just add a new capability control and process things
> in slice units. Right now we have hardware that can only work with
> whole frames (venus)

Note that venus is a stateful hardware and the restriction might just
come from the firmware.

> but I suspect that some slice-only hardware must
> exist, so it may actually become a necessity at some point (lest
> drivers do some splitting themselves).
>

The drivers could do it trivially, because the UAPI will include the
array of slices, with offsets and sizes. It would just run the same
OUTPUT buffer multiple time, once for each slice.

The primary use case I personally see for splitting slices into
multiple buffers would be lowering the latency, as Hans mentioned
earlier and we should be able to do it easily later.

Best regards,
Tomasz
