Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53312 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3B1X45 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 18:56:57 -0500
Received: by mail-ia0-f174.google.com with SMTP id u20so2115144iag.33
        for <linux-media@vger.kernel.org>; Thu, 28 Feb 2013 15:56:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512EB830.5030808@samsung.com>
References: <1360910587-25548-1-git-send-email-vikas.sajjan@linaro.org>
	<1360910587-25548-2-git-send-email-vikas.sajjan@linaro.org>
	<5125C4D4.5040804@samsung.com>
	<CAD025yR8u79VHg0oACTWTFQxiEBzzw6hHA6c=+CA9VP__fRJuA@mail.gmail.com>
	<5125CA44.10506@samsung.com>
	<512EB830.5030808@samsung.com>
Date: Fri, 1 Mar 2013 00:56:56 +0100
Message-ID: <CACRpkdbxM1pnOAKnnkjAdCcLHRnapf+OCW1iUE4h7s2_KJfTyw@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] video: drm: exynos: Add display-timing node
 parsing using video helper function
From: Linus Walleij <linus.walleij@linaro.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>, kgene.kim@samsung.com,
	patches@linaro.org, l.krishna@samsung.com,
	sunil joshi <joshi@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 28, 2013 at 2:51 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:

> My mistake. If CONFIG_PINCTRL is disabled, devm_pinctrl_get_select_default
> can return NULL.

Yes, and that is perfectly legal and *NOT* an error.

> devm_pinctrl_get_select() and pinctrl_get_select() also need IS_ERR_OR_NULL
> instead of IS_ERR?

No.

In fact, IS_ERR_OR_NULL() shall not be used at all.

Check the LKML mailinglist for Russells recent struggle to
purge it from the kernel.

> And many drivers using above functions don't check NULL, right?

No, and they should not. Stub pinctrl handles, just like stub
clocks and stub regulators, are perfectly legal, just that they have
no effect.

Yours,
Linus Walleij
