Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43570 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbeJQPRJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 11:17:09 -0400
MIME-Version: 1.0
References: <20181013151707.32210-1-hch@lst.de> <20181013151707.32210-2-hch@lst.de>
 <CAJZ5v0ju2Y=yQn9uz6HpYGw5BZovxYh2YbYD7Ujq8kajJfvLSQ@mail.gmail.com> <20181017071942.GB23407@lst.de>
In-Reply-To: <20181017071942.GB23407@lst.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 17 Oct 2018 09:22:37 +0200
Message-ID: <CAJZ5v0h=niQOtdMGYWtE4P4NX=-xmgDvga7t2mTAtpbOYWQY0A@mail.gmail.com>
Subject: Re: [PATCH 1/8] cpufreq: tegra186: don't pass GFP_DMA32 to dma_alloc_coherent
To: Christoph Hellwig <hch@lst.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, linux-spi <linux-spi@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        "moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..."
        <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2018 at 9:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Oct 15, 2018 at 09:43:04AM +0200, Rafael J. Wysocki wrote:
> > On Sat, Oct 13, 2018 at 5:17 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > The DMA API does its own zone decisions based on the coherent_dma_mask.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Can you pick it up through the cpufreq tree?

Sure, I'll do that, thanks!
