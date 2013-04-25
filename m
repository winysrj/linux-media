Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33632 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3DYKHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 06:07:16 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT006MP2QO4Y50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 11:07:13 +0100 (BST)
Message-id: <51790050.9040903@samsung.com>
Date: Thu, 25 Apr 2013 12:07:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/7] Add copy time stamp handling to mem2mem drivers
References: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
In-reply-to: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/25/2013 11:49 AM, Kamil Debski wrote:
> Hi,
> 
> This set of patches adds support for copy time stamp handling in the following
> mem2mem drivers:
> * CODA video codec
> * Exynos GScaler
> * m2m-deinterlace
> * mx2_emmaprp
> * Exynos G2D
> * Exynos Jpeg
> In addition there is a slight optimisation for the Exynos MFC driver.

The series looks good to me, but would be nice to have the commit message
not empty, so it is more clear why this change is needed.

Thanks,
Sylwester
