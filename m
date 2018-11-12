Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:58384 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbeKLOF5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 09:05:57 -0500
Subject: Re: [RFC] mm: Replace all open encodings for NUMA_NO_NODE
To: Joseph Qi <jiangqi903@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-rdma@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-block@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-ia64@vger.kernel.org,
        linux-alpha@vger.kernel.org
References: <1541990515-11670-1-git-send-email-anshuman.khandual@arm.com>
 <1e9393c5-ff43-8ec7-dd6c-a662f09ef7c1@gmail.com>
 <b92e3275-7a04-a148-bb5b-38658c270583@arm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <926057f3-f31d-9fe0-e2a8-d76bc3d97049@arm.com>
Date: Mon, 12 Nov 2018 09:44:32 +0530
MIME-Version: 1.0
In-Reply-To: <b92e3275-7a04-a148-bb5b-38658c270583@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/12/2018 09:40 AM, Anshuman Khandual wrote:
> 
> 
> On 11/12/2018 09:27 AM, Joseph Qi wrote:
>> For ocfs2 part, node means host in the cluster, not NUMA node.
>>
> 
> Does not -1 indicate an invalid node which can never be present ?
> 

My bad, got it wrong. Seems like this is nothing to do with NUMA node
at all. Will drop the changes from ocfs2.
