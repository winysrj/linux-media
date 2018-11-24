Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbeKYAye (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 19:54:34 -0500
Date: Sat, 24 Nov 2018 19:35:54 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-media@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-rdma@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-block@vger.kernel.org,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-ia64@vger.kernel.org, linux-alpha@vger.kernel.org,
        akpm@linux-foundation.org, jiangqi903@gmail.com, hverkuil@xs4all.nl
Subject: Re: [PATCH] mm: Replace all open encodings for NUMA_NO_NODE
Message-ID: <20181124140554.GG3175@vkoul-mobl.Dlink>
References: <1542966856-12619-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542966856-12619-1-git-send-email-anshuman.khandual@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23-11-18, 15:24, Anshuman Khandual wrote:

> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -386,7 +386,8 @@ EXPORT_SYMBOL(dma_issue_pending_all);
>  static bool dma_chan_is_local(struct dma_chan *chan, int cpu)
>  {
>  	int node = dev_to_node(chan->device->dev);
> -	return node == -1 || cpumask_test_cpu(cpu, cpumask_of_node(node));
> +	return node == NUMA_NO_NODE ||
> +		cpumask_test_cpu(cpu, cpumask_of_node(node));
>  }

I do not see dev_to_node being updated first, that returns -1 so I would
prefer to check for -1 unless it return NUMA_NO_NODE

-- 
~Vinod
