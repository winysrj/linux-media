Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44213 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab3HGQxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 12:53:51 -0400
Message-id: <52027B9C.7020704@samsung.com>
Date: Wed, 07 Aug 2013 18:53:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, prathyush.k@samsung.com,
	arun.m@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH] [media] exynos-gsc: fix s2r functionality
References: <1375879984-19052-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1375879984-19052-1-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/2013 02:53 PM, Arun Kumar K wrote:
> From: Prathyush K <prathyush.k@samsung.com>
> 
> When gsc is in runtime suspended state, there is no need to call
> m2m_suspend during suspend and similarily, there is no need to call

s/similarily/similarly. I'll fix that typo when applying.

> m2m_resume during resume if already in runtime suspended state. This
> patch adds the necessary conditions to achieve this.
> 
> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
> Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>

Thanks, that looks good. I'll queue it for 3.12. We actually have
similar patch for the exynos4-is fimc-is-i2c driver.

However this is sort of things that IMO should ideally be handled
in the PM core.

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
