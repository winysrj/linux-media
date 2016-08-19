Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34491 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754127AbcHSW22 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 18:28:28 -0400
Received: by mail-pa0-f50.google.com with SMTP id fi15so19727658pac.1
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2016 15:28:27 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, carlo@caione.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        mchehab@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 4/6] media: rc: meson-ir: Add support for newer versions of the IR decoder
References: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
        <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
        <20160819215547.20063-5-martin.blumenstingl@googlemail.com>
Date: Fri, 19 Aug 2016 15:28:22 -0700
In-Reply-To: <20160819215547.20063-5-martin.blumenstingl@googlemail.com>
        (Martin Blumenstingl's message of "Fri, 19 Aug 2016 23:55:45 +0200")
Message-ID: <7hy43s5r7d.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> From: Neil Armstrong <narmstrong@baylibre.com>
>
> Newer SoCs (Meson 8b and GXBB) are using REG2 (offset 0x20) instead of
> REG1 to configure the decoder mode. This makes it necessary to
> introduce new bindings so the driver knows which register has to be
> used.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Kevin Hilman <khilman@baylibre.com>

Mauro, are you the one to pick up new media/rc drivers?  Or if you
prefer, with your ack, I'll take this along with the DT and submit via
arm-soc.

Thanks,

Kevin
