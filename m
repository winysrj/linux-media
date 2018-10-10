Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:46157 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbeJJQC6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 12:02:58 -0400
Received: by mail-io1-f66.google.com with SMTP id t7-v6so3264005ioj.13
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 01:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20181008211205.2900-1-vz@mleia.com> <20181008211205.2900-2-vz@mleia.com>
In-Reply-To: <20181008211205.2900-2-vz@mleia.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 10 Oct 2018 10:41:38 +0200
Message-ID: <CACRpkdb9Lwshpt+haJur_7ESOD50t=8PE-ct-UO5yJFRfrM6Lw@mail.gmail.com>
Subject: Re: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx ICs
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
        Sandeep_Jain@mentor.com,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 On Mon, Oct 8, 2018 at 11:12 PM Vladimir Zapolskiy <vz@mleia.com> wrote:
> From: Sandeep Jain <Sandeep_Jain@mentor.com>
(...)
> +- ti,pixel-clock-edge : Selects Pixel Clock Edge.
> +       Possible values are "<1>" or "<0>".
> +       If "ti,pixel-clock-edge" is High <1>, output data is strobed on the
> +       Rising edge of the PCLK. If ti,pixel-clock-edge is Low <0>, data is
> +       strobed on the Falling edge of the PCLK.
> +       If "ti,pixel-clock-edge" is not mentioned, the pixel clock edge
> +       value is not touched and given by hardware pin strapping.

Please use the existing binding in
Documentation/devicetree/bindings/display/panel/display-timing.txt
for this: pixelclk-active = [<0>|<1>];

Please reference the above document in your binding.

Yours,
Linus Walleij
