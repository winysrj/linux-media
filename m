Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:45180 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbdKBNOP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 09:14:15 -0400
Date: Thu, 2 Nov 2017 11:14:10 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI-devel <dri-devel@lists.freedesktop.org>,
        Linux Media ML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: Cleanup comments on dma_buf_map_attachment()
Message-ID: <20171102131410.GG4111@jade>
References: <20171101140630.2884-1-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101140630.2884-1-Liviu.Dudau@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Liviu,

2017-11-01 Liviu Dudau <Liviu.Dudau@arm.com>:

> Mappings need to be unmapped by calling dma_buf_unmap_attachment() and
> not by calling again dma_buf_map_attachment(). Also fix some spelling
> mistakes.
> 
> Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
> ---
>  drivers/dma-buf/dma-buf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

queued for 4.16. Thanks for your patch.

Gustavo
