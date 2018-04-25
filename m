Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDYHVl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:21:41 -0400
Date: Wed, 25 Apr 2018 00:21:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
Message-ID: <20180425072138.GA16375@infradead.org>
References: <20180424204158.2764095-1-arnd@arndb.de>
 <20180425061537.GA23383@infradead.org>
 <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 09:08:13AM +0200, Arnd Bergmann wrote:
> > That probably also means it can use dma_mmap_coherent instead of the
> > handcrafted remap_pfn_range loop and the PageReserved abuse.
> 
> I'd rather not touch that code. How about adding a comment about
> the fact that it should use dma_mmap_coherent()?

Maybe the real question is if there is anyone that actually cares
for this driver, or if we are better off just removing it?

Same is true for various other virt_to_bus using drivers, e.g. the
grotty atm drivers.
