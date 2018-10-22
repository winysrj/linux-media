Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34673 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJVPIf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 11:08:35 -0400
Received: by mail-yb1-f195.google.com with SMTP id n140-v6so860659yba.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:51:22 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id k189-v6sm7884169ywf.37.2018.10.21.23.51.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 23:51:20 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id d18-v6so1607424yba.4
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20181019080928.208446-1-acourbot@chromium.org>
 <9375d854-2be5-4f69-2516-a3349fa5b50d@xs4all.nl> <CAPBb6MVt4WEEd+83UTPJcqUHZ6ss=TDU5C_kbTQhGqT0fWcYPQ@mail.gmail.com>
 <CAAFQd5B2i+kpP7rpvCGuAGRV13Crxk61Xk23XBoR_CEZte3ARg@mail.gmail.com> <CAPBb6MV0QEbHFbj0v+ttGWik1TRY32zXTe5kfp6PiU2h-nstjw@mail.gmail.com>
In-Reply-To: <CAPBb6MV0QEbHFbj0v+ttGWik1TRY32zXTe5kfp6PiU2h-nstjw@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 22 Oct 2018 15:51:08 +0900
Message-ID: <CAAFQd5CKe5bya7V9vyB4oUfEb=qBv5BJ6s-eFmPig+15qtrt4Q@mail.gmail.com>
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

On Mon, Oct 22, 2018 at 3:39 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> On Mon, Oct 22, 2018 at 3:22 PM Tomasz Figa <tfiga@chromium.org> wrote:
> >
> > On Mon, Oct 22, 2018 at 3:05 PM Alexandre Courbot <acourbot@chromium.org> wrote:
> > >
> > > On Fri, Oct 19, 2018 at 5:44 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > >
> > > > On 10/19/18 10:09, Alexandre Courbot wrote:
> > > > > Thanks everyone for the feedback on v2! I have not replied to all the
> > > > > individual emails but hope this v3 will address some of the problems
> > > > > raised and become a continuation point for the topics still in
> > > > > discussion (probably during the ELCE Media Summit).
> > > > >
> > > > > This patch documents the protocol that user-space should follow when
> > > > > communicating with stateless video decoders. It is based on the
> > > > > following references:
> > > > >
> > > > > * The current protocol used by Chromium (converted from config store to
> > > > >   request API)
> > > > >
> > > > > * The submitted Cedrus VPU driver
> > > > >
> > > > > As such, some things may not be entirely consistent with the current
> > > > > state of drivers, so it would be great if all stakeholders could point
> > > > > out these inconsistencies. :)
> > > > >
> > > > > This patch is supposed to be applied on top of the Request API V18 as
> > > > > well as the memory-to-memory video decoder interface series by Tomasz
> > > > > Figa.
> > > > >
> > > > > Changes since v2:
> > > > >
> > > > > * Specify that the frame header controls should be set prior to
> > > > >   enumerating the CAPTURE queue, instead of the profile which as Paul
> > > > >   and Tomasz pointed out is not enough to know which raw formats will be
> > > > >   usable.
> > > > > * Change V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM to
> > > > >   V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS.
> > > > > * Various rewording and rephrasing
> > > > >
> > > > > Two points being currently discussed have not been changed in this
> > > > > revision due to lack of better idea. Of course this is open to change:
> > > > >
> > > > > * The restriction of having to send full frames for each input buffer is
> > > > >   kept as-is. As Hans pointed, we currently have a hard limit of 32
> > > > >   buffers per queue, and it may be non-trivial to lift. Also some codecs
> > > > >   (at least Venus AFAIK) do have this restriction in hardware, so unless
> > > > >   we want to do some buffer-rearranging in-kernel, it is probably better
> > > > >   to keep the default behavior as-is. Finally, relaxing the rule should
> > > > >   be easy enough if we add one extra control to query whether the
> > > > >   hardware can work with slice units, as opposed to frame units.
> > > >
> > > > Makes sense, as long as the restriction can be lifted in the future.
> > >
> > > Lifting this limitation once we support more than 32 buffers should
> > > not be an issue. Just add a new capability control and process things
> > > in slice units. Right now we have hardware that can only work with
> > > whole frames (venus)
> >
> > Note that venus is a stateful hardware and the restriction might just
> > come from the firmware.
>
> Right, and it most certainly does indeed. Yet firmwares are not always
> easy to get updated by vendors, so we may have to deal with it anyway.
>

Right. I'm just not convinced that venus is relevant to the stateless interface.

I'd use the Rockchip VPU hardware as an example of a hardware that
seems to require all the slices in one buffer, tightly packed one
after another, since it only accepts one address and size into its
registers.

> >
> > > but I suspect that some slice-only hardware must
> > > exist, so it may actually become a necessity at some point (lest
> > > drivers do some splitting themselves).
> > >
> >
> > The drivers could do it trivially, because the UAPI will include the
> > array of slices, with offsets and sizes. It would just run the same
> > OUTPUT buffer multiple time, once for each slice.
>
> Alignment issues notwithstanding. :)

Good point. That could be handled by a memcpy() into a bounce buffer,
but it wouldn't be as trivial as I suggested anymore indeed.

Best regards,
Tomasz
