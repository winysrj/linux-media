Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40751 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2JTJzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:55:14 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so449077eek.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:55:13 -0700 (PDT)
Message-ID: <508274FE.7040004@gmail.com>
Date: Sat, 20 Oct 2012 11:55:10 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 6/8] [media] exynos-gsc: Fix compilation warning
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-6-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Used type casting to avoid the following compilation warning:
>
> drivers/media/platform/exynos-gsc/gsc-core.c:983:37: warning:
> incorrect type in assignment (different modifiers)
> drivers/media/platform/exynos-gsc/gsc-core.c:983:37:
> expected struct gsc_driverdata *driver_data
> drivers/media/platform/exynos-gsc/gsc-core.c:983:37:
> got void const *data

Applied to my tree, thanks.
