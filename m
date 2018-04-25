Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40430 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbeDYJZw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 05:25:52 -0400
Date: Wed, 25 Apr 2018 10:25:33 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Thierry Reding <treding@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        iommu@lists.linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        linux-arm-kernel@lists.infradead.org,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: noveau vs arm dma ops
Message-ID: <20180425092533.GO16141@n2100.armlinux.org.uk>
References: <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425085439.GA29996@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 01:54:39AM -0700, Christoph Hellwig wrote:
> [discussion about this patch, which should have been cced to the iommu
>  and linux-arm-kernel lists, but wasn't:
>  https://www.spinics.net/lists/dri-devel/msg173630.html]
> 
> On Wed, Apr 25, 2018 at 09:41:51AM +0200, Thierry Reding wrote:
> > > API from the iommu/dma-mapping code.  Drivers have no business poking
> > > into these details.
> > 
> > The interfaces that the above patch uses are all EXPORT_SYMBOL_GPL,
> > which is rather misleading if they are not meant to be used by drivers
> > directly.

EXPORT_SYMBOL* means nothing as far as whether a driver should
be able to use the symbol or not - it merely means that the symbol is
made available to a module.  Modules cover much more than just device
drivers - we have library modules, filesystem modules, helper modules
to name a few non-driver classes of modules.

We also have symbols that are exported as part of the architecture
implementation detail of a public interface.  For example, the
public interface "copy_from_user" is implemented as an inline
function (actually several layers of inline functions) eventually
calling into arm_copy_from_user().  arm_copy_from_user() is exported,
but drivers (in fact no module) is allowed to make direct reference
to arm_copy_from_user() - it'd fail when software PAN is enabled.

The whole idea that "if a symbol is exported, it's fine for a driver
to use it" is a complete work of fiction, always has been, and always
will be.

We've had this with the architecture implementation details of the
DMA API before, and with the architecture implementation details of
the CPU cache flushing.  There's only so much commentry, or __
prefixes you can add to a symbol before things get rediculous, and
none of it stops people creating this abuse.  The only thing that
seems to prevent it is to make life hard for folk wanting to use
the symbols (eg, hiding the symbol prototype in a private header,
etc.)

Never, ever go under the covers of an interface.  If the interface
doesn't do what you want, _discuss_ it, don't just think "oh, that
architecture private facility looks like what I need, I'll use that
directly."

If you ever are on the side of trying to maintain those implementation
details that are abused in this way, you'll soon understand why this
behaviour by driver authors is soo annoying, and the maintainability
problems it creates.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
