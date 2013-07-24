Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36799 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3GXP4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:56:13 -0400
Received: by mail-oa0-f48.google.com with SMTP id f4so1418856oah.35
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 08:56:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130724154536.GE12281@valkosipuli.retiisi.org.uk>
References: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130724154536.GE12281@valkosipuli.retiisi.org.uk>
Date: Wed, 24 Jul 2013 18:49:24 +0300
Message-ID: <CAHp75Vdp43x=SMYwpxWLoS0f7ku+qmZoAhW8Pao1p7DDGXcCPg@mail.gmail.com>
Subject: Re: [PATCH] smiapp: re-use clamp_t instead of min(..., max(...))
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 24, 2013 at 6:45 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

[]

>> +     max_m = clamp_t(u32, max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
>> +                     sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
>
> Do you need clamp_t()? Wouldn't plain clamp() do?

The *_t variants are preferred due to they are faster (no type checking).

> I can change it if you're ok with that.

I don't know why you may choose clamp instead of clamp_t here. Are you
going to change variable types?

--
With Best Regards,
Andy Shevchenko
