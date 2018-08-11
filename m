Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua1-f67.google.com ([209.85.222.67]:45204 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbeHKMRm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Aug 2018 08:17:42 -0400
MIME-Version: 1.0
In-Reply-To: <3a9ece34-baad-a19d-c3bd-96aa458ea70b@gmail.com>
References: <20180506080250.GA24114@amd> <20180716090814.GA4505@amd> <3a9ece34-baad-a19d-c3bd-96aa458ea70b@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 11 Aug 2018 12:44:02 +0300
Message-ID: <CAHp75Vf4PZW8A+uj8V5uL2LkTSzSogQDcR8JTqVh4jzVecgtRQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: i2c: lm3560: use conservative defaults
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>, nekit1000@gmail.com,
        mpartap@gmx.net, merlijn@wizzup.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 11, 2018 at 9:10 AM, Daniel Jeong <gshark.jeong@gmail.com> wrote:
> Hi Pavel,
>
> I think if there is not exist pdata, it should be set to the value of power
> on reset (POR) to sync with the chip.
>
> According to the LM3560 datasheet, Flash Timeout is 512ms, Flash current is
> 875mA and Torch Current is 93.75mA.

Can't we simple read back?

-- 
With Best Regards,
Andy Shevchenko
