Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA136C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADDE20656
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfANJs6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:48:58 -0500
Received: from verein.lst.de ([213.95.11.211]:45632 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbfANJs6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 04:48:58 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 9AF6967358; Mon, 14 Jan 2019 10:48:56 +0100 (CET)
Date:   Mon, 14 Jan 2019 10:48:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-media@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190114094856.GB29604@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110234218.GM6890@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 10, 2019 at 04:42:18PM -0700, Jason Gunthorpe wrote:
> > Changes since the RFC:
> > - Rework vmwgfx too [CH]
> > - Use a distinct type for the DMA page iterator [CH]
> > - Do not have a #ifdef [CH]
> 
> ChristophH: Will you ack?

This looks generally fine.

> 
> Are you still OK with the vmwgfx reworking, or should we go back to
> the original version that didn't have the type safety so this driver
> can be left broken?

I think the map method in vmgfx that just does virt_to_phys is
pretty broken.  Thomas, can you check if you see any performance
difference with just doing the proper dma mapping, as that gets the
driver out of interface abuse land?

While we're at it I think we need to merge my series in this area
for 5.0, because without that the driver is already broken.  Where
should we merge it?
