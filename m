Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51158 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbeC1Mhp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 08:37:45 -0400
Date: Wed, 28 Mar 2018 05:37:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] lib/scatterlist: add sg_set_dma_addr() helper
Message-ID: <20180328123744.GA25060@infradead.org>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 25, 2018 at 12:59:53PM +0200, Christian König wrote:
> Use this function to set an sg entry to point to device resources mapped
> using dma_map_resource(). The page pointer is set to NULL and only the DMA
> address, length and offset values are valid.

NAK.  Please provide a higher level primitive.

Btw, you series seems to miss a cover letter.
