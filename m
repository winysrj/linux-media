Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DDEC43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 11:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9E520872
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 11:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfAKL1J (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 06:27:09 -0500
Received: from 8bytes.org ([81.169.241.247]:56880 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbfAKL1J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 06:27:09 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B6068434; Fri, 11 Jan 2019 12:27:07 +0100 (CET)
Date:   Fri, 11 Jan 2019 12:27:06 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     yong.zhi@intel.com, iommu@lists.linux-foundation.org,
        linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        bingbu.cao@intel.com, tian.shu.qiu@intel.com
Subject: Re: [PATCH 1/1] iova: Allow compiling the library without IOMMU
 support
Message-ID: <20190111112706.cdjjw3jbkz3mg3ia@8bytes.org>
References: <20190102211657.13192-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190102211657.13192-1-sakari.ailus@linux.intel.com>
User-Agent: NeoMutt/20170421 (1.8.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 02, 2019 at 11:16:57PM +0200, Sakari Ailus wrote:
> Drivers such as the Intel IPU3 ImgU driver use the IOVA library to manage
> the device's own virtual address space while not implementing the IOMMU
> API. Currently the IOVA library is only compiled if the IOMMU support is
> enabled, resulting into a failure during linking due to missing symbols.
> 
> Fix this by defining IOVA library Kconfig bits independently of IOMMU
> support configuration, and descending to the iommu directory
> unconditionally during the build.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Applied, thanks.
