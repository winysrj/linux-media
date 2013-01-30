Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38701 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3A3Gv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 01:51:58 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so1284403obc.20
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 22:51:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359527449-5174-1-git-send-email-vikas.sajjan@linaro.org>
References: <1359527449-5174-1-git-send-email-vikas.sajjan@linaro.org>
Date: Wed, 30 Jan 2013 12:21:57 +0530
Message-ID: <CAK9yfHxEUTKDeKLXk_6B13FfD=yPuXykTW_5sGXMsyFS6s2QNA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] Adds display-timing node parsing to exynos drm fimd
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, s.trumtrar@pengutronix.de,
	inki.dae@samsung.com, l.krishna@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

Changelog mentioning differences between v1 and v2 is generally
preferred as it will help the reviewers.

On 30 January 2013 12:00, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> This patch adds display-timing node parsing to drm fimd, this depends on
> the display helper patchset at
> http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html
>
> It also adds pinctrl support for drm fimd.
>
> patch is based on branch "exynos-drm-next" at
> http://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
>
> Is tested on Exynos5250 and Exynos4412 by applying dependent patches available
> at http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html
>
> Vikas Sajjan (1):
>   video: drm: exynos: Adds display-timing node parsing using video
>     helper function
>
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   38 +++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With warm regards,
Sachin
