Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1408EC43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 22:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D824120856
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 22:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="j4GpF59q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfABWvD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 17:51:03 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:55644 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfABWvC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 17:51:02 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EB4AF505;
        Wed,  2 Jan 2019 23:50:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546469459;
        bh=HSu1NaCkVhfhDp/MsxC55wa3bg6uej0jCtwEcB4CqSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4GpF59q8t273xVt0pMwclePPVe2khDRP+uKp5cTz0w7fpLEsoc6eRHrMylpYAJ2/
         Yhl5CTXAxmi/kIq51CCjaLcJBxGcavuQZ4eDh115BfejEODGIL91/D2+rXZUFst+TU
         yMJUs9J4x0KsI4/Qlre6QzsNk+7v837MSebCYxYE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, yong.zhi@intel.com,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com
Subject: Re: [PATCH 1/1] iova: Allow compiling the library without IOMMU support
Date:   Thu, 03 Jan 2019 00:52:00 +0200
Message-ID: <12009133.IFJkWA3Ofo@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190102211657.13192-1-sakari.ailus@linux.intel.com>
References: <20190102211657.13192-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thank you for the patch.

On Wednesday, 2 January 2019 23:16:57 EET Sakari Ailus wrote:
> Drivers such as the Intel IPU3 ImgU driver use the IOVA library to manage
> the device's own virtual address space while not implementing the IOMMU
> API.

Why is that ? Could the IPU3 IOMMU be implemented as an IOMMU driver ?

> Currently the IOVA library is only compiled if the IOMMU support is
> enabled, resulting into a failure during linking due to missing symbols.
> 
> Fix this by defining IOVA library Kconfig bits independently of IOMMU
> support configuration, and descending to the iommu directory
> unconditionally during the build.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/Makefile      | 2 +-
>  drivers/iommu/Kconfig | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 578f469f72fb..d9c469983592 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -56,7 +56,7 @@ obj-y				+= tty/
>  obj-y				+= char/
> 
>  # iommu/ comes before gpu as gpu are using iommu controllers
> -obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
> +obj-y				+= iommu/
> 
>  # gpu/ comes after char for AGP vs DRM startup and after iommu
>  obj-y				+= gpu/
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index d9a25715650e..d2c83e62873d 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -1,3 +1,7 @@
> +# The IOVA library may also be used by non-IOMMU_API users
> +config IOMMU_IOVA
> +	tristate
> +
>  # IOMMU_API always gets selected by whoever wants it.
>  config IOMMU_API
>  	bool
> @@ -81,9 +85,6 @@ config IOMMU_DEFAULT_PASSTHROUGH
> 
>  	  If unsure, say N here.
> 
> -config IOMMU_IOVA
> -	tristate
> -
>  config OF_IOMMU
>         def_bool y
>         depends on OF && IOMMU_API


-- 
Regards,

Laurent Pinchart



