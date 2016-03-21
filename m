Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37969 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbcCURNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 13:13:18 -0400
Received: by mail-wm0-f54.google.com with SMTP id l68so130485713wml.1
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2016 10:13:17 -0700 (PDT)
Date: Mon, 21 Mar 2016 18:14:05 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Tiago Vignatti <tiago.vignatti@intel.com>,
	=?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] dma-buf: Update docs for SYNC ioctl
Message-ID: <20160321171405.GP28483@phenom.ffwll.local>
References: <CAO_48GGT48RZaLjg9C+51JyPKzYkkDCFCTrMgfUB+PxQyV8d+Q@mail.gmail.com>
 <1458546705-3564-1-git-send-email-daniel.vetter@ffwll.ch>
 <CANq1E4S0skXbWBOv2bgVddLmZXZE6B7es=+NHKDuJehggnzSvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4S0skXbWBOv2bgVddLmZXZE6B7es=+NHKDuJehggnzSvw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 21, 2016 at 01:26:58PM +0100, David Herrmann wrote:
> Hi
> 
> On Mon, Mar 21, 2016 at 8:51 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > Just a bit of wording polish plus mentioning that it can fail and must
> > be restarted.
> >
> > Requested by Sumit.
> >
> > v2: Fix them typos (Hans).
> >
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Tiago Vignatti <tiago.vignatti@intel.com>
> > Cc: Stéphane Marchesin <marcheu@chromium.org>
> > Cc: David Herrmann <dh.herrmann@gmail.com>
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: Daniel Vetter <daniel.vetter@intel.com>
> > CC: linux-media@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linaro-mm-sig@lists.linaro.org
> > Cc: intel-gfx@lists.freedesktop.org
> > Cc: devel@driverdev.osuosl.org
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  Documentation/dma-buf-sharing.txt | 11 ++++++-----
> >  drivers/dma-buf/dma-buf.c         |  2 +-
> >  2 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> > index 32ac32e773e1..ca44c5820585 100644
> > --- a/Documentation/dma-buf-sharing.txt
> > +++ b/Documentation/dma-buf-sharing.txt
> > @@ -352,7 +352,8 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
> >
> >     No special interfaces, userspace simply calls mmap on the dma-buf fd, making
> >     sure that the cache synchronization ioctl (DMA_BUF_IOCTL_SYNC) is *always*
> > -   used when the access happens. This is discussed next paragraphs.
> > +   used when the access happens. Note that DMA_BUF_IOCTL_SYNC can fail with
> > +   -EAGAIN or -EINTR, in which case it must be restarted.
> 
> What is "restart on EAGAIN" supposed to mean? Or more generally, what
> does EAGAIN tell the caller?

Do what drmIoctl does essentially.

while (ret == -1 && (errno == EAGAIN || errno == EINTR)
	ret = ioctl();

Typed from memery, too lazy to look it up in the source ;-) I'm trying to
sell the idea of a real dma-buf manpage to Sumit, we should clarify this
in detail there.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
