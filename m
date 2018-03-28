Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbeC1Mib (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 08:38:31 -0400
Date: Wed, 28 Mar 2018 05:38:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180328123830.GB25060@infradead.org>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180325110000.2238-2-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 25, 2018 at 12:59:54PM +0200, Christian König wrote:
> From: "wdavis@nvidia.com" <wdavis@nvidia.com>
> 
> Add an interface to find the first device which is upstream of both
> devices.

Please work with Logan and base this on top of the outstanding peer
to peer patchset.
