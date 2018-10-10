Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:51686 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbeJJQHE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 12:07:04 -0400
Received: by mail-it1-f194.google.com with SMTP id 74-v6so6870504itw.1
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 01:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20181008211205.2900-1-vz@mleia.com> <20181008211205.2900-4-vz@mleia.com>
In-Reply-To: <20181008211205.2900-4-vz@mleia.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 10 Oct 2018 10:45:43 +0200
Message-ID: <CACRpkdZJMPYWHBUXohjxo12XZpLdz7OzcWRBrrkcB8YLLd5StA@mail.gmail.com>
Subject: Re: [PATCH 3/7] dt-bindings: pinctrl: ds90ux9xx: add description of
 TI DS90Ux9xx pinmux
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

thanks for your patch!

Can we change the subject to something like "add DT bindings" rather than
"add description" as it is more specific and makes it easier for me as
maintainer.

On Mon, Oct 8, 2018 at 11:12 PM Vladimir Zapolskiy <vz@mleia.com> wrote:

> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>
> TI DS90Ux9xx de-/serializers have a capability to multiplex pin functions,
> in particular a pin may have selectable functions of GPIO, GPIO line
> transmitter, one of I2S lines, one of RGB24 video signal lines and so on.
>
> The change adds a description of DS90Ux9xx pin multiplexers and GPIO
> controllers.
>
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
(...)
> +- gpio-ranges: Mapping to pin controller pins (as described in
> +       Documentation/devicetree/bindings/gpio/gpio.txt)
> +
> +Optional properties:
> +- ti,video-depth-18bit: Sets video bridge pins to RGB 18-bit mode.
> +
> +Available pins, groups and functions (reference to device datasheets):

Please reference the generic binding you're using here:
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

Apart from these small nitpicks it looks very standard and good.

Yours,
Linus Walleij
