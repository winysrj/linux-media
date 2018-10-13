Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58171 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbeJNANb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 20:13:31 -0400
Date: Sat, 13 Oct 2018 18:35:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 4/8] sound: hpios: don't pass GFP_DMA32 to
 dma_alloc_coherent
Message-ID: <20181013163540.GA2947@lst.de>
References: <20181013151707.32210-1-hch@lst.de> <20181013151707.32210-5-hch@lst.de> <s5hpnwdn7l7.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hpnwdn7l7.wl-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 13, 2018 at 06:18:28PM +0200, Takashi Iwai wrote:
> On Sat, 13 Oct 2018 17:17:03 +0200,
> Christoph Hellwig wrote:
> > 
> > The DMA API does its own zone decisions based on the coherent_dma_mask.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Takashi Iwai <tiwai@suse.de>
> 
> 
> Would you like to take this as a series, or shall I take individually
> through sound tree?

There is nothing that depends on this, so feel free to apply the
two sound patches to your tree.
