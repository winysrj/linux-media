Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34091 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752880AbeFGHsE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:48:04 -0400
Received: by mail-vk0-f66.google.com with SMTP id q135-v6so5462062vkh.1
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 00:48:04 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id i13-v6sm6041949uak.18.2018.06.07.00.48.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Jun 2018 00:48:01 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id o71-v6so2313747vke.7
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 00:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180604103303.6a6b792b@vento.lan> <CAAFQd5A13oivxg-m2vpPxBjBAsn8NLJx4_ups2p+j0uHaoiOng@mail.gmail.com>
 <20180606132610.5615f46f@coco.lan>
In-Reply-To: <20180606132610.5615f46f@coco.lan>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 7 Jun 2018 16:47:50 +0900
Message-ID: <CAAFQd5CauqcqX-hWgn3BaKyCRtB=yZ0UUwtJmQm+YUN2FFf1PA@mail.gmail.com>
Subject: Re: [ANN v2] Complex Camera Workshop - Tokyo - Jun, 19
To: mchehab+samsung@kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        javier@dowhile0.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kieran.bingham@ideasonboard.com, niklas.soderlund@ragnatech.se,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        dave.stevenson@raspberrypi.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>, nicolas@ndufresne.ca
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 7, 2018 at 1:26 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Wed, 6 Jun 2018 13:19:39 +0900
> Tomasz Figa <tfiga@chromium.org> escreveu:
>
> > On Mon, Jun 4, 2018 at 10:33 PM Mauro Carvalho Chehab
> > <mchehab+samsung@kernel.org> wrote:
[snip]
> > > 3.2 libv4l2 support for 3A algorithms
> > > =====================================
> > >
> > > The 3A algorithm handing is highly dependent on the hardware. The
> > > idea here is to allow libv4l to have a set of 3A algorithms that
> > > will be specific to certain mc-based hardware.
> > >
> > > One requirement, if we want vendor stacks to use our solution, is that
> > > it should allow allow external closed-source algorithms to run as well.
> > >
> > > The 3A library API must be standardized, to allow the closed-source
> > > vendor implementation to be replaced by an open-source implementation
> > > should someone have the time and energy (and qualifications) to write
> > > one.
> > >
> > > Sandboxed execution of the 3A library must be possible as closed-source
> > > can't always be blindly trusted. This includes the ability to wrap the
> > > library in a daemon should the platform's multimedia stack wishes
> > > and to avoid any direct access to the kernel devices by the 3A library
> > > itself (all accesses should be marshaled by the camera stack).
> > >
> > > Please note that this daemon is *not* a camera daemon that would
> > > communicates with the V4L2 driver through a custom back channel.
> > >
> > > The decision to run the 3A library in a sandboxed process or to call
> > > it directly from the camera stack should be left to the camera stack
> > > and to the platform integrator, and should not be visible by the 3A
> > > library.
> > >
> > > The 3A library must be usable on major Linux-based camera stacks (the
> > > Android and Chrome OS camera HALs are certainly important targets,
> > > more can be added) unmodified, which will allow usage of the vendor
> > > binary provided for Chrome OS or Android on regular Linux systems.
> >
> > This is quite an interesting idea and it would be really useful if it
> > could be done. I'm kind of worried, though, about Android in
> > particular, since the execution environment in Android differs
> > significantly from a regular Linux distributions (including Chrome OS,
> > which is not so far from such), namely:
> > - different libc (bionic) and dynamic linker - I guess this could be
> > solved by static linking?
>
> Static link is one possible solution. IMHO, we should try to make it
> use just a C library (if possible) and be sure that it will also compile
> with bionic/ulibc in order to make it easier to be used by Android and
> other embedded distros.
>
> > - dedicated toolchains - perhaps not much of a problem if the per-arch
> > ABI is the same?
>
> Depending on library dependency, we could likely make it work with more
> than one toolchain. I guess acconfig works with Android, right?
> If so, it could auto-adjust to the different toolchains everywhere.

That works for open source libraries obviously. I was thinking more
about the closed source 3A libraries coming from Android, since we
can't recompile them.

Best regards,
Tomasz
