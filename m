Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:58518 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3CAJTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 04:19:12 -0500
Received: by mail-ia0-f178.google.com with SMTP id y26so2487012iab.9
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2013 01:19:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362024762-28406-3-git-send-email-vikas.sajjan@linaro.org>
References: <1362024762-28406-1-git-send-email-vikas.sajjan@linaro.org>
	<1362024762-28406-3-git-send-email-vikas.sajjan@linaro.org>
Date: Fri, 1 Mar 2013 10:19:10 +0100
Message-ID: <CACRpkdbW-+Ady4oHWmG+paw48SZwGtmPZmXNnawqJ3w9qXBuBQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] video: drm: exynos: Add pinctrl support to fimd
From: Linus Walleij <linus.walleij@linaro.org>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, jy0922.shim@samsung.com,
	patches@linaro.org, l.krishna@samsung.com, joshi@samsung.com,
	inki.dae@samsung.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 28, 2013 at 5:12 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:

> Adds support for pinctrl to drm fimd
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
(...)
> +               pctrl = devm_pinctrl_get_select_default(dev);

NAK.

The device core will do this for you as of commit
ab78029ecc347debbd737f06688d788bd9d60c1d
"drivers/pinctrl: grab default handles from device core"

Yours,
Linus Walleij
