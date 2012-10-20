Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61942 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2JTKBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:01:54 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so362193eaa.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 03:01:53 -0700 (PDT)
Message-ID: <5082768E.2050407@gmail.com>
Date: Sat, 20 Oct 2012 12:01:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [PATCH] [media] exynos-gsc: change driver compatible string
References: <1350398624-20751-1-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1350398624-20751-1-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 10/16/2012 04:43 PM, Shaik Ameer Basha wrote:
> As G-Scaler is going to stay unchanged across all exynos5 series
> SoCs, changing the driver compatible string name to
> "samsung,exynos5-gsc" from "samsung,exynos5250-gsc".
>
> This change is as per the discussion in the devicetree forum.
> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg16448.html

I have added this patch to my tree, together with:

[PATCH] [media] exynos-gsc: fix variable type in gsc_m2m_device_run()
[PATCH] [media] s5p-fimc: fix variable type in fimc_device_run()

Thank you.

--
Regards,
Sylwester
