Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EE7C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516C820656
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfANLMP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:12:15 -0500
Received: from verein.lst.de ([213.95.11.211]:46117 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfANLMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 06:12:15 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 5640968D93; Mon, 14 Jan 2019 12:12:13 +0100 (CET)
Date:   Mon, 14 Jan 2019 12:12:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Russell King <linux@armlinux.org.uk>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] videobuf2: replace a layering violation with
 dma_map_resource
Message-ID: <20190114111213.GA31455@lst.de>
References: <20190111181731.11782-1-hch@lst.de> <20190111181731.11782-4-hch@lst.de> <20190111175416.7d291e25@coco.lan> <20190114103139.GA31005@lst.de> <20190114090456.03071201@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190114090456.03071201@coco.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 14, 2019 at 09:04:56AM -0200, Mauro Carvalho Chehab wrote:
> It would be good if you could later send us a stable branch where
> you merged, in order to allow us to run some tests with the new
> DMA mapping patchset and be sure that it won't cause regressions
> to videobuf2.

I can do that, but the series as sent should be testable, results
welcome!
