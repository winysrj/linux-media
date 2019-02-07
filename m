Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66098C282CC
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 23:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A0020823
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 23:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfBGXXZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 18:23:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:30212 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfBGXXZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 18:23:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 15:23:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,345,1544515200"; 
   d="scan'208";a="136766309"
Received: from meisenhu-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.43.220])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2019 15:23:20 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id EC61C21D9A; Fri,  8 Feb 2019 01:23:16 +0200 (EET)
Date:   Fri, 8 Feb 2019 01:23:16 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190207232316.3min76e2xy3aqrxh@kekkonen.localdomain>
References: <20190104223531.GA1705@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104223531.GA1705@ziepe.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> backing pages") introduced the sg_page_iter_dma_address() function without
> providing a way to use it in the general case. If the sg_dma_len is not
> equal to the dma_length callers cannot safely use the
> for_each_sg_page/sg_page_iter_dma_address combination.
> 
> Resolve this API mistake by providing a DMA specific iterator,
> for_each_sg_dma_page(), that uses the right length so
> sg_page_iter_dma_address() works as expected with all sglists. A new
> iterator type is introduced to provide compile-time safety against wrongly
> mixing accessors and iterators.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com> (ipu3-cio2)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
