Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60453 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbdJPMs7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 08:48:59 -0400
Subject: Re: [PATCH 0/2] fix lockdep warnings in s5p_mfc and exynos-gsc vb2
 drivers
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@kernel.org,
        hansverk@cisco.com, kgene@kernel.org, krzk@kernel.org,
        s.nawrocki@samsung.com, shailendra.v@samsung.com, shuah@kernel.org,
        Julia.Lawall@lip6.fr, kyungmin.park@samsung.com, kamil@wypas.org,
        jtp.park@samsung.com, a.hajda@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <c2dae5ff-a35c-bdd1-910b-75db6c9c16b2@samsung.com>
Date: Mon, 16 Oct 2017 14:48:54 +0200
MIME-version: 1.0
In-reply-to: <cover.1507935819.git.shuahkh@osg.samsung.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20171013231531epcas5p2f009317ed58f5177e7a0768b69a62b6c@epcas5p2.samsung.com>
        <cover.1507935819.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On 2017-10-14 01:13, Shuah Khan wrote:
> Driver mmap functions shouldn't hold lock when calling vb2_mmap(). The
> vb2_mmap() function has its own lock that it uses to protect the critical
> section.
>
> Reference: commit log for f035eb4e976ef5a059e30bc91cfd310ff030a7d3

It would make sense to add the information about the reference commit to 
each
commit message and also point to commit 
e752577ed7bf55c81e10343fced8b378cda2b63b,
as it is exactly the same case here. Anyway:

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

I wonder if makes sense to send those patches also to stable@vget.kernel.org
(maybe v4.3+, like the mentioned above commit, if they really apply?).

> Shuah Khan (2):
>    media: exynos-gsc: fix lockdep warning
>    media: s5p-mfc: fix lockdep warning
>
>   drivers/media/platform/exynos-gsc/gsc-m2m.c | 5 -----
>   drivers/media/platform/s5p-mfc/s5p_mfc.c    | 3 ---
>   2 files changed, 8 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
