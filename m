Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38848 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753500AbcH2T2X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 15:28:23 -0400
Received: by mail-it0-f46.google.com with SMTP id g62so1519238ith.1
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 12:28:23 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, linus.walleij@linaro.org,
        carlo@caione.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org, b.galvani@gmail.com
Subject: Re: [PATCH v5 0/6] Add Meson 8b / GXBB support to the IR driver
References: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
        <20160820095424.636-1-martin.blumenstingl@googlemail.com>
Date: Mon, 29 Aug 2016 14:28:10 -0500
In-Reply-To: <20160820095424.636-1-martin.blumenstingl@googlemail.com> (Martin
        Blumenstingl's message of "Sat, 20 Aug 2016 11:54:18 +0200")
Message-ID: <m2shtniddh.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Newer Amlogic platforms (Meson 8b and GXBB) use a slightly different
> register layout for their Infrared Remoete Controller. The decoder mode
> is now configured in another register. Without the changes to the
> meson-ir driver we are simply getting incorrect "durations" reported
> from the hardware (because the hardware is not in time measurement aka
> software decode mode).
>
> This problem was also noticed by some people trying to use this on an
> ODROID-C1 and ODROID-C2 - the workaround there (probably because the
> datasheets were not publicy available yet at that time) was to switch
> to ir_raw_event_store_edge (which leaves it up to the kernel to measure
> the duration of a pulse). See [0] and [1] for the corresponding
> patches.
>
> Changes in v5:
> - changed pin function and group names to remote_input_ao so they match
>   with the datasheet
>
> Tested-by: Neil Armstrong <narmstrong@baylibre.com>

Thanks for the respin.  I'll take the driver and DT/bindings through the
arm-soc tree and Linus has taken the pinctrl patch.

Kevin
