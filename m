Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46677 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbeKLTVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 14:21:30 -0500
Message-ID: <1542014947.3440.3.camel@pengutronix.de>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>, nicolas@ndufresne.ca,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: pza@pengutronix.de,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Mon, 12 Nov 2018 10:29:07 +0100
In-Reply-To: <CAAFQd5BixjuLzmgGAK7Xz2CnovM8o00Zq2JQeSmEKpRShwve=A@mail.gmail.com>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
         <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
         <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
         <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de>
         <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
         <9ac3abb4a8dee94bd2adca6c781bf8c58f68b945.camel@ndufresne.ca>
         <CAAFQd5DcJ8XSseE-GJDoftsmfDa=Vo9_wwn-_pAx54HNhL1vWA@mail.gmail.com>
         <415abde4ccf854e58df2aaf68d45eae7150d03c7.camel@ndufresne.ca>
         <CAAFQd5BixjuLzmgGAK7Xz2CnovM8o00Zq2JQeSmEKpRShwve=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Sun, 2018-11-11 at 12:43 +0900, Tomasz Figa wrote:
> On Sat, Nov 10, 2018 at 6:06 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > 
> > Le jeudi 08 novembre 2018 à 16:45 +0900, Tomasz Figa a écrit :
> > > > In this patch we should consider a way to tell userspace that this has
> > > > been opt in, otherwise existing userspace will have to remain using
> > > > sub-optimal copy based reclaiming in order to ensure that renegotiation
> > > > can work on older kernel tool. At worst someone could probably do trial
> > > > and error (reqbufs(1)/mmap/reqbufs(0)) but on CMA with large buffers
> > > > this introduces extra startup time.
> > > 
> > > Would such REQBUFS dance be really needed? Couldn't one simply try
> > > reqbufs(0) when it's really needed and if it fails then do the copy,
> > > otherwise just proceed normally?
> > 
> > In simple program, maybe, in modularized code, where the consumer of
> > these buffer (the one that is forced to make a copy) does not know the
> > origin of the DMABuf, it's a bit complicated.
> > 
> > In GStreamer as an example, the producer is a plugin called
> > libgstvideo4linux2.so, while the common consumer would be libgstkms.so.
> > They don't know each other. The pipeline would be described as:
> > 
> >   v4l2src ! kmssink
> > 
> > GStreamer does not have an explicit reclaiming mechanism. No one knew
> > about V4L2 restrictions when this was designed, DMABuf didn't exist and
> > GStreamer didn't have OMX support.
> > 
> > What we ended up crafting, as a plaster, is that when upstream element
> > (v4l2src) query a new allocation from downstream (kmssink), we always
> > copy and return any ancient buffers by copying. kmssink holds on a
> > buffer because we can't remove the scannout buffer on the display. This
> > is slow and inefficient, and also totally unneeded if the dmabuf
> > originate from other kernel subsystems (like DRM).
> > 
> > So what I'd like to be able to do, to support this in a more optimal
> > and generic way, is to mark the buffers that needs reclaiming before
> > letting them go. But for that, I would need a flag somewhere to tell me
> > this kernel allow this.
> 
> Okay, got it. Thanks for explaining it.
> 
> > 
> > You got the context, maybe the conclusion is that I should simply do
> > kernel version check, though I'm sure a lot of people will backport
> > this, which means that check won't work so well.
> > 
> > Let me know, I understand adding more API is not fun, but as nothing is
> > ever versionned in the linux-media world, it's really hard to detect
> > and use new behaviour while supporting what everyone currently run on
> > their systems.
> > 
> > I would probably try and find a way to implement your suggestion, and
> > then introduce a flag in the query itself, but I would need to think
> > about it a little more. It's not as simple as it look like
> > unfortunately.
> 
> It sounds like a good fit for a new capability in v4l2_requestbuffers
> and v4l2_create_buffers structs [1]. Perhaps something like
> V4L2_BUF_CAP_SUPPORTS_FREE_AFTER_EXPORT? Hans, what do you think?

Maybe V4L2_BUF_CAP_SUPPORTS_ORPHANS? With this patch, while the buffers
are in use, reqbufs(0) doesn't free them, they are orphaned. Also, this
patch allows reqbufs(0) not only after export, but also while mmapped.

regards
Philipp
