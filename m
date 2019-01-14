Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237FFC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE80220663
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfANJqQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:46:16 -0500
Received: from verein.lst.de ([213.95.11.211]:45609 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfANJqQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 04:46:16 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 7B16B67358; Mon, 14 Jan 2019 10:46:14 +0100 (CET)
Date:   Mon, 14 Jan 2019 10:46:14 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190114094614.GA29604@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com> <20190112183752.GC16457@mellanox.com> <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 12, 2019 at 01:03:05PM -0600, Shiraz Saleem wrote:
> Well I was trying convert the RDMA drivers to use your new iterator variant
> and saw the need for it in locations where we need virtual address of the pages
> contained in the SGEs.

As far as i can tell that pg_arr[i] value is only ever used for
the case where we do an explicit dma coherent allocation,  so you
should not have to fill it out at all.
