Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65366 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3CAJbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 04:31:50 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so3189426wib.15
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2013 01:31:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACRpkdbW-+Ady4oHWmG+paw48SZwGtmPZmXNnawqJ3w9qXBuBQ@mail.gmail.com>
References: <1362024762-28406-1-git-send-email-vikas.sajjan@linaro.org>
	<1362024762-28406-3-git-send-email-vikas.sajjan@linaro.org>
	<CACRpkdbW-+Ady4oHWmG+paw48SZwGtmPZmXNnawqJ3w9qXBuBQ@mail.gmail.com>
Date: Fri, 1 Mar 2013 15:01:49 +0530
Message-ID: <CAGm_ybh88tF2s607ow3_O5eD31vR_=hQGwOiqY21xAWTk1AQNA@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] video: drm: exynos: Add pinctrl support to fimd
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	l.krishna@samsung.com, joshi@samsung.com,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

On Fri, Mar 1, 2013 at 2:49 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Feb 28, 2013 at 5:12 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
>
>> Adds support for pinctrl to drm fimd
>>
>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> (...)
>> +               pctrl = devm_pinctrl_get_select_default(dev);
>
> NAK.
>
> The device core will do this for you as of commit
> ab78029ecc347debbd737f06688d788bd9d60c1d
> "drivers/pinctrl: grab default handles from device core"
>
OK. Will abandon the patch.

> Yours,
> Linus Walleij
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
