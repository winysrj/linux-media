Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34553 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752634AbeDRPYO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 11:24:14 -0400
Subject: Re: [PATCH] [media] include/media: fix missing | operator when
 setting cfg
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CGME20180418150622epcas4p4be934b89937c0e50a2f236116c02d7cb@epcas4p4.samsung.com>
 <20180418150617.22489-1-colin.king@canonical.com>
 <ebce8e36-9125-aecb-b0d1-87f068646e67@samsung.com>
 <bafbcf6c-a08d-11ba-af25-655b7cc44e1c@samsung.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <c554a771-e9a9-fe1f-6792-e73f33b08838@canonical.com>
Date: Wed, 18 Apr 2018 16:24:11 +0100
MIME-Version: 1.0
In-Reply-To: <bafbcf6c-a08d-11ba-af25-655b7cc44e1c@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/04/18 16:23, Sylwester Nawrocki wrote:
> On 04/18/2018 05:20 PM, Sylwester Nawrocki wrote:
>> On 04/18/2018 05:06 PM, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> The value from a readl is being masked with ITE_REG_CIOCAN_MASK however
>>> this is not being used and cfg is being re-assigned.  I believe the
>>> assignment operator should actually be instead the |= operator.
>>>
>>> Detected by CoverityScan, CID#1467987 ("Unused value")
>>>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> Thanks for the patch.
>>
>> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> I forgot to mention that the subject should rather looks something
> like:
> 
> "exynos4-is: fimc-lite: : fix missing | operator when setting cfg"
> 
Oops, shall I re-send?
