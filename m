Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56859 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbeJQPOC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 11:14:02 -0400
Date: Wed, 17 Oct 2018 09:19:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, linux-spi <linux-spi@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        "moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..."
        <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] cpufreq: tegra186: don't pass GFP_DMA32 to
 dma_alloc_coherent
Message-ID: <20181017071942.GB23407@lst.de>
References: <20181013151707.32210-1-hch@lst.de> <20181013151707.32210-2-hch@lst.de> <CAJZ5v0ju2Y=yQn9uz6HpYGw5BZovxYh2YbYD7Ujq8kajJfvLSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0ju2Y=yQn9uz6HpYGw5BZovxYh2YbYD7Ujq8kajJfvLSQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 15, 2018 at 09:43:04AM +0200, Rafael J. Wysocki wrote:
> On Sat, Oct 13, 2018 at 5:17 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The DMA API does its own zone decisions based on the coherent_dma_mask.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Can you pick it up through the cpufreq tree?
