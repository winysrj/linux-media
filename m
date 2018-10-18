Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35176 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbeJRUAU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 16:00:20 -0400
Received: by mail-oi1-f193.google.com with SMTP id 22-v6so23781547oiz.2
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 04:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20181013151707.32210-1-hch@lst.de> <20181013151707.32210-7-hch@lst.de>
 <CA+M3ks66FL-F8dk+UcG-gR8Gz4N6gz7eYuT_Ht_scw7foPaP0A@mail.gmail.com>
 <CA+M3ks6a-D4j425JGBof+ma3NX5Fo52k5fadRNRauexOBXuaaw@mail.gmail.com> <20181017071958.GC23407@lst.de>
In-Reply-To: <20181017071958.GC23407@lst.de>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Thu, 18 Oct 2018 13:59:27 +0200
Message-ID: <CA+M3ks5WW9WviTNr3VLHc-ijYLu-fp8XMtAbr3p9cFe3J+n39Q@mail.gmail.com>
Subject: Re: [PATCH 6/8] drm: sti: don't pass GFP_DMA32 to dma_alloc_wc
To: Christoph Hellwig <hch@lst.de>
Cc: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mer. 17 oct. 2018 =C3=A0 09:19, Christoph Hellwig <hch@lst.de> a =C3=A9c=
rit :
>
> On Tue, Oct 16, 2018 at 02:41:23PM +0200, Benjamin Gaignard wrote:
> > Le lun. 15 oct. 2018 =C3=A0 11:12, Benjamin Gaignard
> > <benjamin.gaignard@linaro.org> a =C3=A9crit :
> > >
> > > Le sam. 13 oct. 2018 =C3=A0 17:17, Christoph Hellwig <hch@lst.de> a =
=C3=A9crit :
> > > >
> > > > The DMA API does its own zone decisions based on the coherent_dma_m=
ask.
> > > >
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > >
> > > Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> >
> > Christoph do you plan to merge this patch on your own tree ? or would
> > like I put it directly in drm-misc-next branch ?
>
> Please pull it in through drm-misc-next, thanks!

Applied on drm-misc-next,
Thanks,
Benjamin
