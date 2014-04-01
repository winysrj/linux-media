Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20950 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDAO2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 10:28:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3C00AR4W7WZF90@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 01 Apr 2014 15:28:45 +0100 (BST)
Content-transfer-encoding: 8BIT
Message-id: <533ACD16.4070600@samsung.com>
Date: Tue, 01 Apr 2014 16:28:38 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] s5p-fimc: Misc fixes
References: <1395780301.11851.14.camel@nicolas-tpx230>
 <1396361586.18172.0.camel@nicolas-tpx230>
In-reply-to: <1396361586.18172.0.camel@nicolas-tpx230>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 01/04/14 16:13, Nicolas Dufresne wrote:
> Any comment/input ?

My apologies for the delay. The patches look good to me, I'm going
to apply them to my tree for 3.16, as the media tree is already closed
for 3.15. Thanks a lot for these fixes!

> Le mardi 25 mars 2014 à 16:45 -0400, Nicolas Dufresne a écrit :
>> This patch series fixes several bugs found in the s5p-fimc driver. These
>> bugs relate to bad parameters in the formats definition and short size
>> of image buffers.
>>
>> Nicolas Dufresne (5):
>>   s5p-fimc: Reuse calculated sizes
>>   s5p-fimc: Iterate for each memory plane
>>   s5p-fimc: Align imagesize to row size for tiled formats
>>   s5p-fimc: Fix YUV422P depth
>>   s5p-fimc: Changed RGB32 to BGR32
>>
>>  drivers/media/platform/exynos4-is/fimc-core.c | 21 +++++++++++++++------
>>  drivers/media/platform/exynos4-is/fimc-m2m.c  |  6 +++---
>>  2 files changed, 18 insertions(+), 9 deletions(-)


Regards,
Sylwester
