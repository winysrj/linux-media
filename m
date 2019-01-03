Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B50C43444
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 20:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2894021872
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 20:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfACULi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 15:11:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:54025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfACULi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 15:11:38 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2019 12:11:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,436,1539673200"; 
   d="scan'208";a="115263347"
Received: from moneill-mobl2.ger.corp.intel.com (HELO mara.localdomain) ([10.252.30.114])
  by orsmga003.jf.intel.com with ESMTP; 03 Jan 2019 12:11:33 -0800
Received: from sailus by mara.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gf9Ky-0000Ik-Kw; Thu, 03 Jan 2019 22:11:29 +0200
Date:   Thu, 3 Jan 2019 22:11:27 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Joerg Roedel <joro@8bytes.org>, yong.zhi@intel.com,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com
Subject: Re: [PATCH 1/1] iova: Allow compiling the library without IOMMU
 support
Message-ID: <20190103201126.zzqpn2eylm4m2zxn@mara.localdomain>
References: <20190102211657.13192-1-sakari.ailus@linux.intel.com>
 <12009133.IFJkWA3Ofo@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12009133.IFJkWA3Ofo@avalon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Thu, Jan 03, 2019 at 12:52:00AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Wednesday, 2 January 2019 23:16:57 EET Sakari Ailus wrote:
> > Drivers such as the Intel IPU3 ImgU driver use the IOVA library to manage
> > the device's own virtual address space while not implementing the IOMMU
> > API.
> 
> Why is that ? Could the IPU3 IOMMU be implemented as an IOMMU driver ?

You could do that, but:

- it's a single PCI device so there's no advantage in doing so and

- doing that would render the device inoperable if an IOMMU is enabled in
  the system, as chaining IOMMUs is not supported in the IOMMU framework
  AFAIK.

> 
> > Currently the IOVA library is only compiled if the IOMMU support is
> > enabled, resulting into a failure during linking due to missing symbols.
> > 
> > Fix this by defining IOVA library Kconfig bits independently of IOMMU
> > support configuration, and descending to the iommu directory
> > unconditionally during the build.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/Makefile      | 2 +-
> >  drivers/iommu/Kconfig | 7 ++++---
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/Makefile b/drivers/Makefile
> > index 578f469f72fb..d9c469983592 100644
> > --- a/drivers/Makefile
> > +++ b/drivers/Makefile
> > @@ -56,7 +56,7 @@ obj-y				+= tty/
> >  obj-y				+= char/
> > 
> >  # iommu/ comes before gpu as gpu are using iommu controllers
> > -obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
> > +obj-y				+= iommu/
> > 
> >  # gpu/ comes after char for AGP vs DRM startup and after iommu
> >  obj-y				+= gpu/
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index d9a25715650e..d2c83e62873d 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -1,3 +1,7 @@
> > +# The IOVA library may also be used by non-IOMMU_API users
> > +config IOMMU_IOVA
> > +	tristate
> > +
> >  # IOMMU_API always gets selected by whoever wants it.
> >  config IOMMU_API
> >  	bool
> > @@ -81,9 +85,6 @@ config IOMMU_DEFAULT_PASSTHROUGH
> > 
> >  	  If unsure, say N here.
> > 
> > -config IOMMU_IOVA
> > -	tristate
> > -
> >  config OF_IOMMU
> >         def_bool y
> >         depends on OF && IOMMU_API
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
