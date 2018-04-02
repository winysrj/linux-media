Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:40610 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753030AbeDBRhK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 13:37:10 -0400
To: Jerome Glisse <jglisse@redhat.com>
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Will Davis <wdavis@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
References: <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
 <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
 <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
 <20180330194519.GC3198@redhat.com>
 <31266710-f6bb-99ee-c73d-6e58afe5c38c@deltatee.com>
 <20180402172027.GA18231@redhat.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <6f796779-0ba3-d056-de33-341ee55d6b38@deltatee.com>
Date: Mon, 2 Apr 2018 11:37:07 -0600
MIME-Version: 1.0
In-Reply-To: <20180402172027.GA18231@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/04/18 11:20 AM, Jerome Glisse wrote:
> The point i have been trying to get accross is that you do have this
> information with dma_map_resource() you know the device to which you
> are trying to map (dev argument to dma_map_resource()) and you can
> easily get the device to which the memory belongs because you have the
> CPU physical address of the memory hence you can lookup the resource
> and get the device from that.

How do you go from a physical address to a struct device generally and
in a performant manner?

> IIRC CAPI make P2P mandatory but maybe this is with NVLink. We can ask
> the PowerPC folks to confirm. Note CAPI is Power8 and newer AFAICT.

PowerPC folks recently told us specifically that Power9 does not support
P2P between PCI root ports. I've said this many times. CAPI has nothing
to do with it.

> Mapping to userspace have nothing to do here. I am talking at hardware
> level. How thing are expose to userspace is a completely different
> problems that do not have one solution fit all. For GPU you want this
> to be under total control of GPU drivers. For storage like persistent
> memory, you might want to expose it userspace more directly ...

My understanding (and I worked on this a while ago) is that CAPI
hardware manages memory maps typically for userspace memory. When a
userspace program changes it's mapping, the CAPI hardware is updated so
that hardware is coherent with the user address space and it is safe to
DMA to any address without having to pin memory. (This is very similar
to ODP in RNICs.) This is *really* nice but doesn't solve *any* of the
problems we've been discussing. Moreover, many developers want to keep
P2P in-kernel, for the time being, where the problem of pinning memory
does not exist.

Logan
