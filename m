Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35763 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750976AbcILP4W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 11:56:22 -0400
Received: by mail-oi0-f67.google.com with SMTP id 2so22798587oif.2
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2016 08:56:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473670047-24670-1-git-send-email-vincent.abriou@st.com>
References: <1473670047-24670-1-git-send-email-vincent.abriou@st.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Mon, 12 Sep 2016 11:56:21 -0400
Message-ID: <CABxcv=mXfRg+ocF5wVmWU8cwaqh-TJS_cO-s296kmpS6+Cyx2w@mail.gmail.com>
Subject: Re: [PATCH v2] [media] vivid: support for contiguous DMA buffers
To: Vincent Abriou <vincent.abriou@st.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Vincent,

On Mon, Sep 12, 2016 at 4:47 AM, Vincent Abriou <vincent.abriou@st.com> wrote:
> It allows to simulate the behavior of hardware with such limitations or
> to connect vivid to real hardware with such limitations.
>
> Add the "allocators" module parameter option to let vivid use the
> dma-contig instead of vmalloc.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---

The patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

I've also tested on an Exynos5 board to share DMA buffers between a
vivid capture device and the Exynos DRM driver, so:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Before $SUBJECT, when vivid was always using the vb2 vmalloc memory
allocator, the Exynos DRM driver wasn't able to import the dma-buf
because the GEM buffers are non-contiguous:

$ gst-launch-1.0 v4l2src device=/dev/video7 io-mode=dmabuf ! kmssink
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
Setting pipeline to PLAYING ...
New clock: GstSystemClock
0:00:00.853895814  2957    0xd6260 ERROR           kmsallocator
gstkmsallocator.c:334:gst_kms_allocator_add_fb:<KMSMemory::allocator>
Failed to bind to framebuffer: Invalid argument (-22)

[ 1757.390564] [drm:exynos_drm_framebuffer_init] *ERROR* cannot use
this gem memory type for fb.

The issue goes away when using the the vb2 DMA contig memory allocator.

Best regards,
Javier
