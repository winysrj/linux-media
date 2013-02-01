Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37472 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3BAIde (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 03:33:34 -0500
Received: by mail-ob0-f171.google.com with SMTP id lz20so3823076obb.16
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 00:33:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
	<1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
	<CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
	<510987B5.6090509@gmail.com>
	<050101cdff52$86df3a70$949daf50$%dae@samsung.com>
	<510B02AB.4080908@gmail.com>
	<0b7501ce0011$3df65180$b9e2f480$@samsung.com>
	<00fd01ce001b$5215a3f0$f640ebd0$%dae@samsung.com>
Date: Fri, 1 Feb 2013 14:03:33 +0530
Message-ID: <CAK9yfHxqqumg-oqH_Ku8Zkf8biWVknF91Su0VkWJJXjvWQ3Jhw@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Inki Dae <inki.dae@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org,
	s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 February 2013 06:57, Inki Dae <inki.dae@samsung.com> wrote:
>
> For example,
> If compatible = "samsung,g2d-3.0" is added to exynos4210.dtsi, it'd be
> reasonable. But what if that compatible string is added to exynos4.dtsi?.
> This case isn't considered for exynos4412 SoC with v4.1.

In case of Exynos4 series the base address of G2D ip is different
across series. Hence we cannot define it in exynos4.dtsi and need to
define the nodes in exynos4xxx.dtsi or specific board files. Thus we
can use the version appended compatible string.

However even the second option suggested by Sylwester is OK with me or
to be even more specific we could go for both SoC as well as version
option something like this.

compatible = "samsung,exynos3110-g2d-3.0" /* for Exynos3110, Exynos4210 */
compatible = "samsung,exynos4212-g2d-4.1" /* for Exynos4212, Exynos4412 */

In any case please let me know the final preferred one so that I can
update the code send the revised patches.

-- 
With warm regards,
Sachin
