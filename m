Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33315 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3BALMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 06:12:37 -0500
Received: by mail-ob0-f172.google.com with SMTP id tb18so3945689obb.17
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 03:12:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510B9EC8.6020102@samsung.com>
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
	<1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
	<CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
	<510987B5.6090509@gmail.com>
	<050101cdff52$86df3a70$949daf50$%dae@samsung.com>
	<510B02AB.4080908@gmail.com>
	<0b7501ce0011$3df65180$b9e2f480$@samsung.com>
	<00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
	<CAK9yfHxqqumg-oqH_Ku8Zkf8biWVknF91Su0VkWJJXjvWQ3Jhw@mail.gmail.com>
	<510B9EC8.6020102@samsung.com>
Date: Fri, 1 Feb 2013 16:42:36 +0530
Message-ID: <CAK9yfHw+aTgiLwGVJt=J9-ie4-2JAaF4Nh3n4tjcHp6w2JHamg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> In any case please let me know the final preferred one so that I can
>> update the code send the revised patches.
>
> The version with SoC name embedded in it seems most reliable and correct
> to me.
>
> compatible = "samsung,exynos3110-fimg-2d" /* for Exynos3110 (S5PC110, S5PV210),
>                                              Exynos4210 */
> compatible = "samsung,exynos4212-fimg-2d" /* for Exynos4212, Exynos4412 */
>
Looks good to me.

Inki, Kukjin, please let us know your opinion so that we can freeze
this. Also please suggest the SoC name for Exynos5 (5250?).

-- 
With warm regards,
Sachin
