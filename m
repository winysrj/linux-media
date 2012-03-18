Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46586 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2CRTEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 15:04:12 -0400
Received: by wibhj6 with SMTP id hj6so2962155wib.1
        for <linux-media@vger.kernel.org>; Sun, 18 Mar 2012 12:04:11 -0700 (PDT)
Date: Sun, 18 Mar 2012 20:04:53 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <rob.clark@linaro.org>,
	patches@linaro.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, daniel@ffwll.ch,
	airlied@redhat.com, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add get_dma_buf()
Message-ID: <20120318190453.GJ4286@phenom.ffwll.local>
References: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
 <CAPM=9txFA1M4CK2njLDJRwLn6ZaPQMUsiqMCybqLSwWmZ7Y=mw@mail.gmail.com>
 <CAO_48GH_zkgQQgvbiD8MQ5dHb3pD5mTSxtA_z4+KhGQJWQhC1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GH_zkgQQgvbiD8MQ5dHb3pD5mTSxtA_z4+KhGQJWQhC1g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 18, 2012 at 01:12:22PM +0530, Sumit Semwal wrote:
> On 16 March 2012 23:23, Dave Airlie <airlied@gmail.com> wrote:
> > On Fri, Mar 16, 2012 at 4:04 PM, Rob Clark <rob.clark@linaro.org> wrote:
> >> From: Rob Clark <rob@ti.com>
> >>
> >> Works in a similar way to get_file(), and is needed in cases such as
> >> when the exporter needs to also keep a reference to the dmabuf (that
> >> is later released with a dma_buf_put()), and possibly other similar
> >> cases.
> >>
> >> Signed-off-by: Rob Clark <rob@ti.com>
> >
> > Reviewed-by: Dave Airlie <airlied@redhat.com>
> >
> Thanks; pulled into for-next.

I'm back from vacation and already grumpily complaining about dma-buf
patches ;-) For consistency with dma_buf_put we should call this
dma_buf_get instead of get_dma_buf ... I'll write a bikeshed patch on top
of your tree.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
