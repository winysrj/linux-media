Return-path: <mchehab@pedra>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:3728 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1DSOwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 10:52:55 -0400
Date: Tue, 19 Apr 2011 16:51:49 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU
 (IOMMU) driver
Message-ID: <20110419145149.GU2192@amd.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <201104191449.50824.arnd@arndb.de>
 <20110419135003.GR2192@amd.com>
 <201104191628.39446.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201104191628.39446.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 19, 2011 at 10:28:39AM -0400, Arnd Bergmann wrote:
> On Tuesday 19 April 2011, Roedel, Joerg wrote:
> > On Tue, Apr 19, 2011 at 08:49:50AM -0400, Arnd Bergmann wrote:
> > > > Ok, it looks I don't fully get how this iommu.h should be used. It looks
> > > > that there can be only one instance of iommu ops registered in the system,
> > > > so only one iommu driver can be activated. You are right that the iommu
> > > > driver has to be registered on first probe().
> > > 
> > > That is a limitation of the current implementation. We might want to
> > > change that anyway, e.g. to handle the mali IOMMU along with yours.
> > > I believe the reason for allowing only one IOMMU type so far has been
> > > that nobody required more than one. As I mentioned, the IOMMU API is
> > > rather new and has not been ported to much variety of hardware, unlike
> > > the dma-mapping API, which does support multiple different IOMMUs
> > > in a single system.
> > 
> > The current IOMMU-API interface is very simple. It delegates the
> > selection of the particular IOMMU device to the IOMMU driver. Handle
> > this selection above the IOMMU driver is a complex thing to do. We will
> > need some kind of generic IOMMU support in the device-core and
> > attach IOMMUs to device sub-trees.
> > 
> > A simpler and less intrusive solution is to implement some wrapper code
> > which dispatches the IOMMU-API calls to the IOMMU driver implementation
> > required for that device.
> 
> Right. We already do that for the dma-mapping API on some architectures,
> and I suppose we can consolidate the mechanism here, possibly into
> something that ends up in the common struct device rather than in
> the archdata.

The struct device solution is very much what I meant by adding this into
the device-core code :)

> > Question: Does every platform device has a different type of IOMMU? Or
> > are the IOMMUs on all of these platform devices similar enough to be
> > handled by a single driver?
> 
> As Marek explained in the thread before you got on Cc, they are all the
> same, except for the graphics core (Mali) that has a different one but
> currently disables that.

Then it is no problem at all. The IOMMU driver can find out itself which
IOMMU needs to be used for which device. The x86 implementations already
do this.

> > > > For the drivers the most important are the following functions:
> > > > iommu_{attach,detach}_device(struct iommu_domain *domain, struct device *dev);
> > 
> > Right, and each driver can allocate its own domains.
> 
> For the cases that use the normal dma-mapping API, I guess there only
> needs to be one domain to cover the kernel, which can then be hidden
> in the driver provides the dma_map_ops based on an iommu_ops.

Yes, for dma-api usage one domain is sufficient. But using one domain
for each device has benefits too. It reduces lock-contention on the
domain side and also increases security by isolating the devices from
each other.

> > > It's not quite how the domains are meant to be used. In the AMD IOMMU
> > > that the API is based on, any number of devices can share one domain,
> > > and devices might be able to have mappings in multiple domains.
> > 
> > Yes, any number of devices can be assigned to one domain, but each
> > device only belongs to one domain at each point in time. But it is
> > possible to detach a device from one domain and attach it to another.
> 
> I was thinking of the SR-IOV case, where a single hardware device is
> represented as multiple logical devices. As far as I understand, each
> logical devices can only belong to one domain, but they don't all have to
> be the same.

Well, right, the IOMMU-API makes no distinction between PF and VF. Each
function is just a pci_dev which can independently assigned to a domain.
So if 'device' means a physical card with virtual functions then yes, a
device can be attached to multiple domains, one domain per VF.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

