Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA82C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 23:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F09208E3
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 23:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EikjmN81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfAJXmW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 18:42:22 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43331 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfAJXmV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 18:42:21 -0500
Received: by mail-pg1-f193.google.com with SMTP id v28so5480249pgk.10
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 15:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CGbGciDXDaOFaw7tyoURQCK72kHq4YbWapdOxjk8N70=;
        b=EikjmN81xd0nQYwSQaGSTWnffwVY5+AHktdBEvhGsIF2HmmPw/R/OlTfhTMwj10EZE
         5KPxZCr+qIRKeMKeUufebHuguv/APZnaE8YNW1a6fPptcbADcT6ov5wIFeo5l018BId+
         PBpYWzJNXx3PrQ/wfhZ4ckh/y23Q5nCEZ4lXJT6VBG2wOg/C9rNY1uxrWYE0W88RxiYU
         o5HPbrjaa+bGJJtqcApZsGIpECsGFb34+3CetwTLDGWlU4w4/Y9fcU7p36zuYk3nMbGk
         hWSh+iY8RsUnHeH+y8HrtUCWJFinAhL/bvEEZX8azURWciKjfISAovS3zmjWOX3KjfiC
         0ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CGbGciDXDaOFaw7tyoURQCK72kHq4YbWapdOxjk8N70=;
        b=oU4WlVtNLZzVhx1diNw7tEnUNxp2nCt6UBIvYMOqf4tVSU1wUw5xqTBQwEBpFhI1QS
         1cIV/XsA70tScfBFsjEpoXygG2Mil1aKd4iWcj9u8+MXAhx6QeS6IakvCST0GifizSrl
         9+o07ojlCeuCBCpKxEoU/isOP3C/9i6bTuR089Uz7LnW4/vVs1LH2YmIxuBXWDLEa+iD
         56q0BiTIyjEuG+M0Bh9xWaTOQg7vmVvJAGO75fPsmKfjdCybo8J3rOKk0xddQ428OLTC
         o1SHLnoq6P7jKl6lu0UQtkh3f55RHIxgp8KdRi4+7pySl6LG2L3oOhXnyTCf+u+kFzC2
         pYvg==
X-Gm-Message-State: AJcUukdR4Wi04TkNtf4c7mkOBVXPbgKEQ/+0U3BZjG8d+1+PJj8iwCMx
        0zxg67Q78/EPxAa00B7OugPsd1ueJE4=
X-Google-Smtp-Source: ALg8bN5SXc4iJ5BAvsiJqXD2w/ws9lN8qJtQrb0k65OAYwjp7JB00yYTR5zTzooaN8TbPtjGhKMqzQ==
X-Received: by 2002:a63:4948:: with SMTP id y8mr11205161pgk.32.1547163740837;
        Thu, 10 Jan 2019 15:42:20 -0800 (PST)
Received: from ziepe.ca (S010614cc2056d97f.ed.shawcable.net. [174.3.196.123])
        by smtp.gmail.com with ESMTPSA id v12sm105948442pgg.41.2019.01.10.15.42.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jan 2019 15:42:19 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ghjxq-0001Fq-Ic; Thu, 10 Jan 2019 16:42:18 -0700
Date:   Thu, 10 Jan 2019 16:42:18 -0700
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
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
Message-ID: <20190110234218.GM6890@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104223531.GA1705@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 04, 2019 at 03:35:31PM -0700, Jason Gunthorpe wrote:
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
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        | 26 ++++++++++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_mob.c        | 26 +++++++-----
>  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c | 42 +++++++++++++------
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
>  include/linux/scatterlist.h                | 49 ++++++++++++++++++----
>  lib/scatterlist.c                          | 26 ++++++++++++
>  6 files changed, 134 insertions(+), 39 deletions(-)
> 
> I'd like to run this patch through the RDMA tree as we have another
> series in the works that wants to use the for_each_sg_dma_page() API.
> 
> The changes to vmwgfx make me nervous, it would be great if someone
> could test and ack them?
> 
> Changes since the RFC:
> - Rework vmwgfx too [CH]
> - Use a distinct type for the DMA page iterator [CH]
> - Do not have a #ifdef [CH]

ChristophH: Will you ack?

Are you still OK with the vmwgfx reworking, or should we go back to
the original version that didn't have the type safety so this driver
can be left broken?

Thanks,
Jason
