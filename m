Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36555 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdFLOFj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 10:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <4d8f40f9-e248-6d90-ab8d-a7a548201866@xs4all.nl>
References: <20170612132620.1024-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170612132620.1024-4-ramesh.shanmugasundaram@bp.renesas.com> <4d8f40f9-e248-6d90-ab8d-a7a548201866@xs4all.nl>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 12 Jun 2017 16:05:36 +0200
Message-ID: <CAMuHMdUDyPQLc8KcZLiVEhes4_k3LHYRekxOm8e_9wvQ=q9mSQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] media: i2c: max2175: Add MAX2175 support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Chris Paterson <chris.paterson2@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 12, 2017 at 3:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 06/12/2017 03:26 PM, Ramesh Shanmugasundaram wrote:
>> This patch adds driver support for the MAX2175 chip. This is Maxim
>> Integrated's RF to Bits tuner front end chip designed for software-defined
>> radio solutions. This driver exposes the tuner as a sub-device instance
>> with standard and custom controls to configure the device.
>>
>> Signed-off-by: Ramesh Shanmugasundaram
>> <ramesh.shanmugasundaram@bp.renesas.com>
>
>
> Sorry, got this sparse warning:
>
> /home/hans/work/build/media-git/drivers/media/i2c/max2175.c: In function
> 'max2175_poll_timeout':
> /home/hans/work/build/media-git/drivers/media/i2c/max2175.c:385:21: warning:
> '*' in boolean context, suggest '&&' instead [-Wint-in-bool-context]
>     1000, timeout_ms * 1000);
>           ~~~~~~~~~~~^~~
>
> The smatch warnings are now gone.
>
> If you can make a v9 for just this patch?

This is not an issue with the max2175 driver, but with the
regmap_read_poll_timeout() macro:

    #define regmap_read_poll_timeout(map, addr, val, cond, sleep_us,
timeout_us) \
    ({ \
            ...
            if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \

For increased safety, and to avoid this warning, "timeout_us" should be
inside parentheses.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
