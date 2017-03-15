Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36711 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbdCOKIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 06:08:11 -0400
Received: by mail-wr0-f195.google.com with SMTP id l37so1406250wrc.3
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 03:08:10 -0700 (PDT)
Date: Wed, 15 Mar 2017 11:08:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laura Abbott <labbott@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC][PATCH] dma-buf: Introduce dma-buf test module
Message-ID: <20170315100806.xibewpizce7iky6d@phenom.ffwll.local>
References: <1489521859-20701-1-git-send-email-labbott@redhat.com>
 <20170314201303.2o6bhyn5yudjx4m6@phenom.ffwll.local>
 <93fc4722-bffc-e96b-0191-bd3bf875aaf8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93fc4722-bffc-e96b-0191-bd3bf875aaf8@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 14, 2017 at 01:30:30PM -0700, Laura Abbott wrote:
> On 03/14/2017 01:13 PM, Daniel Vetter wrote:
> > On Tue, Mar 14, 2017 at 01:04:19PM -0700, Laura Abbott wrote:
> >>
> >> dma-buf is designed to share buffers. Sharing means that there needs to
> >> be another subsystem to accept those buffers. Introduce a simple test
> >> module to act as a dummy system to accept dma_bufs from elsewhere. The
> >> goal is to provide a very simple interface to validate exported buffers
> >> do something reasonable. This is based on ion_test.c that existed for
> >> the Ion framework.
> >>
> >> Signed-off-by: Laura Abbott <labbott@redhat.com>
> >> ---
> >> This is basically a drop in of what was available as
> >> drivers/staging/android/ion/ion_test.c. Given it has no Ion specific
> >> parts it might be useful as a more general test module. RFC mostly
> >> to see if this is generally useful or not.
> > 
> > We already have a test dma-buf driver, which also handles reservation
> > objects and can create fences to provoke signalling races an all kinds of
> > other fun. It's drivers/gpu/drm/vgem.
> > 
> > If there's anything missing in there, patches very much welcome.
> > -Daniel
> > 
> 
> Thanks for that pointer. It certainly looks more complete vs. allocating
> a platform_device. I'll look and see if there's anything that needs
> extension. Plus this means I can probably delete more code from Ion (woo)

\o/ for less code!

btw for the tests, I think we should really hard to either get them into
kselftests or igt.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
