Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:54067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1DSPhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 11:37:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Tue, 19 Apr 2011 17:37:30 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
	"'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com> <20110419150018.GV2192@amd.com>
In-Reply-To: <20110419150018.GV2192@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191737.30916.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 19 April 2011, Roedel, Joerg wrote:
> > Getting back to our video codec - it has 2 IOMMU controllers. The codec
> > hardware is able to address only 256MiB of space. Do you have an idea how
> > this can be handled with dma-mapping API? The only idea that comes to my
> > mind is to provide a second, fake 'struct device' and use it for allocations
> > for the second IOMMU controller.
> 
> The GPU IOMMUs can probably be handled in the GPU driver if they are
> that different. Recent PCIe GPUs on x86 have their own IOMMUs too which
> are very device specific and are handled in the device driver.

I tend to disagree with this one, and would suggest that the GPUs should
actually provide their own iommu_ops, even if they are the only users
of these.

However, this is a minor point that we don't need to worry about today.

	Arnd
