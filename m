Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45177 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab3BALkQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 06:40:16 -0500
Received: by mail-ob0-f169.google.com with SMTP id ta14so4006056obb.14
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 03:40:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <014401ce006f$c7dd1dd0$57975970$%dae@samsung.com>
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
	<CAK9yfHw+aTgiLwGVJt=J9-ie4-2JAaF4Nh3n4tjcHp6w2JHamg@mail.gmail.com>
	<014401ce006f$c7dd1dd0$57975970$%dae@samsung.com>
Date: Fri, 1 Feb 2013 17:10:14 +0530
Message-ID: <CAK9yfHyEdd_nr5eqT9WZ4+J9LHczL4U5VAUEwzzjbH1H0xgjUQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Inki Dae <inki.dae@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 February 2013 17:02, Inki Dae <inki.dae@samsung.com> wrote:
>
> How about using like below?
>         Compatible = ""samsung,exynos4x12-fimg-2d" /* for Exynos4212,
> Exynos4412  */
> It looks odd to use "samsung,exynos4212-fimg-2d" saying that this ip is for
> exynos4212 and exynos4412.

AFAIK, compatible strings are not supposed to have any wildcard characters.
Compatible string should suggest the first SoC that contained this IP.
Hence IMO 4212 is OK.


-- 
With warm regards,
Sachin
