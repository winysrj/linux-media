Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56886 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727292AbeJQPOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 11:14:40 -0400
Date: Wed, 17 Oct 2018 09:20:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] media: sti/bdisp: don't pass GFP_DMA32 to
 dma_alloc_attrs
Message-ID: <20181017072020.GD23407@lst.de>
References: <20181013151707.32210-1-hch@lst.de> <20181013151707.32210-8-hch@lst.de> <CA+M3ks5KO-Yr_PEczaENhTfirthFz2gW1uv4bwZe5mjy3-jZyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+M3ks5KO-Yr_PEczaENhTfirthFz2gW1uv4bwZe5mjy3-jZyg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 15, 2018 at 11:12:55AM +0200, Benjamin Gaignard wrote:
> Le sam. 13 oct. 2018 à 17:18, Christoph Hellwig <hch@lst.de> a écrit :
> >
> > The DMA API does its own zone decisions based on the coherent_dma_mask.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Can you pick it up through the media tree?
