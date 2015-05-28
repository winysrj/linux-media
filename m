Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64975 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbE1Kuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 06:50:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NP2000MV3GOA780@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 May 2015 11:50:48 +0100 (BST)
Message-id: <5566F307.6040600@samsung.com>
Date: Thu, 28 May 2015 12:50:47 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <kamil@wypas.org>
Subject: Re: s5p-mfc: sparse warnings
References: <555F356A.9030000@xs4all.nl>
In-reply-to: <555F356A.9030000@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-05-22 15:55, Hans Verkuil wrote:
> Hi Marek, Kamil,
>
> Can someone look at these sparse warnings?
>
> s5p-mfc/s5p_mfc_opr_v5.c:266:23: warning: incorrect type in argument 2 (different address spaces)
> s5p-mfc/s5p_mfc_opr_v5.c:274:23: warning: incorrect type in argument 1 (different address spaces)
> s5p-mfc/s5p_mfc_opr_v6.c:1855:23: warning: incorrect type in argument 2 (different address spaces)
> s5p-mfc/s5p_mfc_opr_v6.c:1865:22: warning: incorrect type in argument 1 (different address spaces)
>
> It all depends on whether this is supposed to be __iomem memory or not.
>
> If it is supposed to be __iomem, then sparse will fail elsewhere (I saw at
> least one memset).

Well, this really looks messy. I will send a fix for it.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

