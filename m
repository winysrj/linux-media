Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26478 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaGUNKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:10:54 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9200FPOCLYFM10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 14:10:46 +0100 (BST)
Message-id: <53CD1155.106@samsung.com>
Date: Mon, 21 Jul 2014 15:10:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	shaik.samsung@gmail.com, joshi@samsung.com
Subject: Re: [PATCH] [media] exynos-gsc: Remove PM_RUNTIME dependency
References: <1405918488-26142-1-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1405918488-26142-1-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/07/14 06:54, Shaik Ameer Basha wrote:
> 1] Currently Gscaler clock is enabled only inside pm_runtime callbacks.
>    If PM_RUNTIME is disabled, driver hangs. This patch removes the
>    PM_RUNTIME dependency by keeping the clock enable/disable functions
>    in m2m start/stop streaming callbacks.
> 
> 2] For Exynos5420/5800, Gscaler clock has to be Turned ON before powering
>    on/off the Gscaler power domain. This dependency is taken care by
>    this patch at driver level.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Regards,
Sylwester
