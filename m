Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458D1C282DA
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 09:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F0C020869
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 09:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfBAJH6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 04:07:58 -0500
Received: from verein.lst.de ([213.95.11.211]:33828 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfBAJH6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 04:07:58 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0349368CEC; Fri,  1 Feb 2019 10:07:56 +0100 (CET)
Date:   Fri, 1 Feb 2019 10:07:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: fix a layering violation in videobuf2 and improve
 dma_map_resource v2
Message-ID: <20190201090755.GA16464@lst.de>
References: <CGME20190118113751epcas2p2d7d678dcf247806a119316aabb4dde21@epcas2p2.samsung.com> <20190118113727.3270-1-hch@lst.de> <774dc557-b690-203f-898f-38755b099068@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <774dc557-b690-203f-898f-38755b099068@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 01, 2019 at 08:05:21AM +0100, Marek Szyprowski wrote:
> Works fine on older Exynos based boards with IOMMU and CMA disabled.
> 
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks.  I've merged the ѕeries into the dma-mapping tree, and I've
also made a stable branch available at:

    git://git.infradead.org/users/hch/dma-mapping.git videobuf-map-resource

in case it needs to be pulled into the media tree.
