Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbeKZXmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 18:42:15 -0500
Subject: Re: [PATCH V2] mm: Replace all open encodings for NUMA_NO_NODE
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-media@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-rdma@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-block@vger.kernel.org,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-ia64@vger.kernel.org, linux-alpha@vger.kernel.org,
        akpm@linux-foundation.org, jiangqi903@gmail.com,
        hverkuil@xs4all.nl, vkoul@kernel.org
References: <1543235202-9075-1-git-send-email-anshuman.khandual@arm.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <bcf609de-c60a-d6ad-7acb-6c59c412adbc@redhat.com>
Date: Mon, 26 Nov 2018 13:48:07 +0100
MIME-Version: 1.0
In-Reply-To: <1543235202-9075-1-git-send-email-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.11.18 13:26, Anshuman Khandual wrote:
> At present there are multiple places where invalid node number is encoded
> as -1. Even though implicitly understood it is always better to have macros
> in there. Replace these open encodings for an invalid node number with the
> global macro NUMA_NO_NODE. This helps remove NUMA related assumptions like
> 'invalid node' from various places redirecting them to a common definition.
> 
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in V2:
> 
> - Added inclusion of 'numa.h' header at various places per Andrew
> - Updated 'dev_to_node' to use NUMA_NO_NODE instead per Vinod

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
