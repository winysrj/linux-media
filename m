Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20858 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbbIPI6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 04:58:31 -0400
Message-id: <55F92F0C.5000508@samsung.com>
Date: Wed, 16 Sep 2015 10:57:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	y2038@lists.linaro.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] [media] use v4l2_get_timestamp where possible
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
 <1442332148-488079-6-git-send-email-arnd@arndb.de>
In-reply-to: <1442332148-488079-6-git-send-email-arnd@arndb.de>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/09/15 17:49, Arnd Bergmann wrote:
> This is a preparation for a change to the type of v4l2 timestamps.
> v4l2_get_timestamp() is a helper function that reads the monotonic
> time and stores it into a 'struct timeval'. Multiple drivers implement
> the same thing themselves for historic reasons.
> 
> Changing them all to use v4l2_get_timestamp() is more consistent
> and reduces the amount of code duplication, and most importantly
> simplifies the following changes.
> 
> If desired, this patch can easily be split up into one patch per
> driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
For:

  drivers/media/platform/exynos4-is/fimc-lite.c
  drivers/media/platform/s3c-camif/camif-capture.c

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
