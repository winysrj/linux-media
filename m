Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752321AbeDBTp4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 15:45:56 -0400
Date: Mon, 2 Apr 2018 15:45:53 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Will Davis <wdavis@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180402194553.GC18231@redhat.com>
References: <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
 <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
 <20180330194519.GC3198@redhat.com>
 <31266710-f6bb-99ee-c73d-6e58afe5c38c@deltatee.com>
 <20180402172027.GA18231@redhat.com>
 <6f796779-0ba3-d056-de33-341ee55d6b38@deltatee.com>
 <20180402191649.GB18231@redhat.com>
 <4c672c71-6202-0775-7825-37f8077d1d35@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c672c71-6202-0775-7825-37f8077d1d35@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 02, 2018 at 01:32:37PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 02/04/18 01:16 PM, Jerome Glisse wrote:
> > There isn't good API at the moment AFAIK, closest thing would either be
> > lookup_resource() or region_intersects(), but a more appropriate one can
> > easily be added, code to walk down the tree is readily available. More-
> > over this can be optimize like vma lookup are, even more as resource are
> > seldomly added so read side (finding a resource) can be heavily favor
> > over write side (adding|registering a new resource).
> 
> So someone needs to create a highly optimized tree that registers all
> physical address on the system and maps them to devices? That seems a
> long way from being realized. I'd hardly characterize that as "easily".
> If we can pass both devices to the API I'd suspect it would be preferred
> over the complicated tree. This, of course, depends on what users of the
> API need.

This tree already exist, it is all there upstream see kernel/resource.c
What is missing is something that take a single address and return the
device struct. There is function that take a range region_intersects()
or one that take the start address lookup_resource(). It isn't hard to
think that using roughly same code as region_intersects() an helper
that return the device for a resource can be added.

And yes currently this does not have a pointer back to the device that
own the resource but this can be added. It wasn't needed until now.

It can latter be optimize if device lookup shows as a bottleneck in perf
profile.


> 
> > cache coherency protocol (bit further than PCIE snoop). But also the
> > other direction the CPU access to device memory can also be cache coherent,
> > which is not the case in PCIE.
> 
> I was not aware that CAPI allows PCI device memory to be cache coherent.
> That sounds like it would be very tricky...

And yet CAPI, CCIX, Gen-Z, NVLink, ... are all inter-connect that aim at
achieving this cache coherency between multiple devices and CPUs.

Jérôme
