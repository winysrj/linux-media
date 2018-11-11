Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43465 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbeKKNaf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Nov 2018 08:30:35 -0500
Received: by mail-yb1-f193.google.com with SMTP id h187-v6so2642875ybg.10
        for <linux-media@vger.kernel.org>; Sat, 10 Nov 2018 19:43:17 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id 205-v6sm3181304ywd.1.2018.11.10.19.43.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Nov 2018 19:43:15 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id k6-v6so3130857ywa.11
        for <linux-media@vger.kernel.org>; Sat, 10 Nov 2018 19:43:14 -0800 (PST)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
 <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
 <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de> <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
 <9ac3abb4a8dee94bd2adca6c781bf8c58f68b945.camel@ndufresne.ca>
 <CAAFQd5DcJ8XSseE-GJDoftsmfDa=Vo9_wwn-_pAx54HNhL1vWA@mail.gmail.com> <415abde4ccf854e58df2aaf68d45eae7150d03c7.camel@ndufresne.ca>
In-Reply-To: <415abde4ccf854e58df2aaf68d45eae7150d03c7.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sun, 11 Nov 2018 12:43:01 +0900
Message-ID: <CAAFQd5BixjuLzmgGAK7Xz2CnovM8o00Zq2JQeSmEKpRShwve=A@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: nicolas@ndufresne.ca, Hans Verkuil <hverkuil@xs4all.nl>
Cc: pza@pengutronix.de,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 10, 2018 at 6:06 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le jeudi 08 novembre 2018 =C3=A0 16:45 +0900, Tomasz Figa a =C3=A9crit :
> > > In this patch we should consider a way to tell userspace that this ha=
s
> > > been opt in, otherwise existing userspace will have to remain using
> > > sub-optimal copy based reclaiming in order to ensure that renegotiati=
on
> > > can work on older kernel tool. At worst someone could probably do tri=
al
> > > and error (reqbufs(1)/mmap/reqbufs(0)) but on CMA with large buffers
> > > this introduces extra startup time.
> >
> > Would such REQBUFS dance be really needed? Couldn't one simply try
> > reqbufs(0) when it's really needed and if it fails then do the copy,
> > otherwise just proceed normally?
>
> In simple program, maybe, in modularized code, where the consumer of
> these buffer (the one that is forced to make a copy) does not know the
> origin of the DMABuf, it's a bit complicated.
>
> In GStreamer as an example, the producer is a plugin called
> libgstvideo4linux2.so, while the common consumer would be libgstkms.so.
> They don't know each other. The pipeline would be described as:
>
>   v4l2src ! kmssink
>
> GStreamer does not have an explicit reclaiming mechanism. No one knew
> about V4L2 restrictions when this was designed, DMABuf didn't exist and
> GStreamer didn't have OMX support.
>
> What we ended up crafting, as a plaster, is that when upstream element
> (v4l2src) query a new allocation from downstream (kmssink), we always
> copy and return any ancient buffers by copying. kmssink holds on a
> buffer because we can't remove the scannout buffer on the display. This
> is slow and inefficient, and also totally unneeded if the dmabuf
> originate from other kernel subsystems (like DRM).
>
> So what I'd like to be able to do, to support this in a more optimal
> and generic way, is to mark the buffers that needs reclaiming before
> letting them go. But for that, I would need a flag somewhere to tell me
> this kernel allow this.

Okay, got it. Thanks for explaining it.

>
> You got the context, maybe the conclusion is that I should simply do
> kernel version check, though I'm sure a lot of people will backport
> this, which means that check won't work so well.
>
> Let me know, I understand adding more API is not fun, but as nothing is
> ever versionned in the linux-media world, it's really hard to detect
> and use new behaviour while supporting what everyone currently run on
> their systems.
>
> I would probably try and find a way to implement your suggestion, and
> then introduce a flag in the query itself, but I would need to think
> about it a little more. It's not as simple as it look like
> unfortunately.

It sounds like a good fit for a new capability in v4l2_requestbuffers
and v4l2_create_buffers structs [1]. Perhaps something like
V4L2_BUF_CAP_SUPPORTS_FREE_AFTER_EXPORT? Hans, what do you think?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tre=
e/include/uapi/linux/videodev2.h?h=3Dnext-20181109#n866

Best regards,
Tomasz
