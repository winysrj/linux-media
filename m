Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58687 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3DZKZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 06:25:19 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLU0053HY7DTH70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Apr 2013 11:25:17 +0100 (BST)
Message-id: <517A560C.7090403@samsung.com>
Date: Fri, 26 Apr 2013 12:25:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v2] [media] exynos4-is: Fix potential null pointer
 dereference in mipi-csis.c
References: <1366966377-15808-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1366966377-15808-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/26/2013 10:52 AM, Sachin Kamat wrote:
> When 'node' is NULL, the print statement tries to dereference it.
> Hence replace the variable with the one that is accessible.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Changes since v1:
> Used pdev->dev.of_node->full_name for node name.

Patch applied for 3.10-rc2+, thanks.

