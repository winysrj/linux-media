Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:38200 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbeK0A47 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 19:56:59 -0500
Subject: Re: [PATCH V2] mm: Replace all open encodings for NUMA_NO_NODE
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
 <bcf609de-c60a-d6ad-7acb-6c59c412adbc@redhat.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <20049f8a-b68f-8af2-c4c7-9410781f37fa@arm.com>
Date: Mon, 26 Nov 2018 19:32:44 +0530
MIME-Version: 1.0
In-Reply-To: <bcf609de-c60a-d6ad-7acb-6c59c412adbc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/26/2018 06:18 PM, David Hildenbrand wrote:
> On 26.11.18 13:26, Anshuman Khandual wrote:
>> At present there are multiple places where invalid node number is encoded
>> as -1. Even though implicitly understood it is always better to have macros
>> in there. Replace these open encodings for an invalid node number with the
>> global macro NUMA_NO_NODE. This helps remove NUMA related assumptions like
>> 'invalid node' from various places redirecting them to a common definition.
>>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Changes in V2:
>>
>> - Added inclusion of 'numa.h' header at various places per Andrew
>> - Updated 'dev_to_node' to use NUMA_NO_NODE instead per Vinod
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>

Thanks David. My bad, forgot to add your review tag from the earlier version.
