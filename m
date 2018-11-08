Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41781 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbeKHRUG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 12:20:06 -0500
Received: by mail-yb1-f194.google.com with SMTP id t13-v6so7954043ybb.8
        for <linux-media@vger.kernel.org>; Wed, 07 Nov 2018 23:45:53 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id q126-v6sm740113ywf.7.2018.11.07.23.45.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 23:45:51 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id w17-v6so483128ybl.6
        for <linux-media@vger.kernel.org>; Wed, 07 Nov 2018 23:45:51 -0800 (PST)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
 <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
 <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de> <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
 <9ac3abb4a8dee94bd2adca6c781bf8c58f68b945.camel@ndufresne.ca>
In-Reply-To: <9ac3abb4a8dee94bd2adca6c781bf8c58f68b945.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Nov 2018 16:45:38 +0900
Message-ID: <CAAFQd5DcJ8XSseE-GJDoftsmfDa=Vo9_wwn-_pAx54HNhL1vWA@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: nicolas@ndufresne.ca
Cc: pza@pengutronix.de, Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Sat, Oct 27, 2018 at 6:38 PM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le lundi 22 octobre 2018 =C3=A0 12:37 +0900, Tomasz Figa a =C3=A9crit :
> > Hi Philipp,
> >
> > On Mon, Oct 22, 2018 at 1:28 AM Philipp Zabel <pza@pengutronix.de> wrot=
e:
> > >
> > > On Wed, Oct 03, 2018 at 05:24:39PM +0900, Tomasz Figa wrote:
> > > [...]
> > > > > Yes, but that would fall in a complete redesign I guess. The buff=
er
> > > > > allocation scheme is very inflexible. You can't have buffers of t=
wo
> > > > > dimensions allocated at the same time for the same queue. Worst, =
you
> > > > > cannot leave even 1 buffer as your scannout buffer while realloca=
ting
> > > > > new buffers, this is not permitted by the framework (in software)=
. As a
> > > > > side effect, there is no way to optimize the resolution changes, =
you
> > > > > even have to copy your scannout buffer on the CPU, to free it in =
order
> > > > > to proceed. Resolution changes are thus painfully slow, by design=
.
> > >
> > > [...]
> > > > Also, I fail to understand the scanout issue. If one exports a vb2
> > > > buffer to a DMA-buf and import it to the scanout engine, it can kee=
p
> > > > scanning out from it as long as it want, because the DMA-buf will h=
old
> > > > a reference on the buffer, even if it's removed from the vb2 queue.
> > >
> > > REQBUFS 0 fails if the vb2 buffer is still in use, including from dma=
buf
> > > attachments: vb2_buffer_in_use checks the num_users memop. The refcou=
nt
> > > returned by num_users shared between the vmarea handler and dmabuf op=
s,
> > > so any dmabuf attachment counts towards in_use.
> >
> > Ah, right. I've managed to completely forget about it, since we have a
> > downstream patch that we attempted to upstream earlier [1], but didn't
> > have a chance to follow up on the comments and there wasn't much
> > interest in it in general.
> >
> > [1] https://lore.kernel.org/patchwork/patch/607853/
> >
> > Perhaps it would be worth reviving?
>
> In this patch we should consider a way to tell userspace that this has
> been opt in, otherwise existing userspace will have to remain using
> sub-optimal copy based reclaiming in order to ensure that renegotiation
> can work on older kernel tool. At worst someone could probably do trial
> and error (reqbufs(1)/mmap/reqbufs(0)) but on CMA with large buffers
> this introduces extra startup time.

Would such REQBUFS dance be really needed? Couldn't one simply try
reqbufs(0) when it's really needed and if it fails then do the copy,
otherwise just proceed normally?

Best regards,
Tomasz
