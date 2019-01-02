Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E08C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 20:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C1020874
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 20:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfABULV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 15:11:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:47068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfABULV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Jan 2019 15:11:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2019 12:11:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,432,1539673200"; 
   d="scan'208";a="306953597"
Received: from mmazarel-mobl.ger.corp.intel.com (HELO mara.localdomain) ([10.252.12.141])
  by fmsmga006.fm.intel.com with ESMTP; 02 Jan 2019 12:11:18 -0800
Received: from sailus by mara.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gemrE-0000Id-8d; Wed, 02 Jan 2019 22:11:16 +0200
Date:   Wed, 2 Jan 2019 22:11:15 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Yong Zhi <yong.zhi@intel.com>
Cc:     linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        bingbu.cao@intel.com, tian.shu.qiu@intel.com
Subject: Re: [PATCH 1/1] media: staging/intel-ipu3: Fix Kconfig for unmet
 direct dependencies
Message-ID: <20190102201112.cuxy7y37mcophrvw@mara.localdomain>
References: <1546278403-8306-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546278403-8306-1-git-send-email-yong.zhi@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Mon, Dec 31, 2018 at 11:46:43AM -0600, Yong Zhi wrote:
> Fix link error for specific .config reported by lkp robot:
> 
> drivers/staging/media/ipu3/ipu3-dmamap.o: In function `ipu3_dmamap_alloc':
> drivers/staging/media/ipu3/ipu3-dmamap.c:111: undefined reference to `alloc_iova'
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
> Happy New Year!!
> 
>  drivers/staging/media/ipu3/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/ipu3/Kconfig b/drivers/staging/media/ipu3/Kconfig
> index 75cd889f18f7..c486cbbe859a 100644
> --- a/drivers/staging/media/ipu3/Kconfig
> +++ b/drivers/staging/media/ipu3/Kconfig
> @@ -3,7 +3,7 @@ config VIDEO_IPU3_IMGU
>  	depends on PCI && VIDEO_V4L2
>  	depends on MEDIA_CONTROLLER && VIDEO_V4L2_SUBDEV_API
>  	depends on X86
> -	select IOMMU_IOVA
> +	select IOMMU_IOVA if IOMMU_SUPPORT

I don't think this really addresses the issue: the IOVA library is needed
in any case. I'll submit a patch...

>  	select VIDEOBUF2_DMA_SG
>  	---help---
>  	  This is the Video4Linux2 driver for Intel IPU3 image processing unit,
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
