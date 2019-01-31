Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B0BC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 15:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F6D2085B
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 15:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbfAaPbx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:31:53 -0500
Received: from verein.lst.de ([213.95.11.211]:58163 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfAaPbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 10:31:53 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 1AB7C68C8E; Thu, 31 Jan 2019 16:31:51 +0100 (CET)
Date:   Thu, 31 Jan 2019 16:31:50 +0100
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
Subject: Re: [PATCH 3/3] videobuf2: replace a layering violation with
 dma_map_resource
Message-ID: <20190131153150.GA754@lst.de>
References: <20190111181731.11782-1-hch@lst.de> <CGME20190111181812epcas2p1eeb68a16701631513eaf297073f7299f@epcas2p1.samsung.com> <20190111181731.11782-4-hch@lst.de> <6f8892ac-c2aa-10df-c74f-ba032bf75160@samsung.com> <20190117172152.GA32292@lst.de> <f4222474-0515-c0a2-ef5e-523b56869210@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4222474-0515-c0a2-ef5e-523b56869210@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marek,

can chance you could retest the v2 version?
