Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43381 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbeLCKPT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 05:15:19 -0500
MIME-Version: 1.0
References: <20181203100747.16442-1-jagan@amarulasolutions.com>
In-Reply-To: <20181203100747.16442-1-jagan@amarulasolutions.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 3 Dec 2018 18:14:39 +0800
Message-ID: <CAGb2v64B-afrJ=n1td4HsJgtyrr=oxjF3M=pqjuKtp2AU2V0Gw@mail.gmail.com>
Subject: Re: [PATCH 0/5] media/sun6i: Allwinner A64 CSI support
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 3, 2018 at 6:07 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> This series support CSI on Allwinner A64.
>
> The CSI controller seems similar to that of in H3, so fallback
> compatible is used to load the driver.
>
> Unlike other SoC's A64 has set of GPIO Pin gropus SDA, SCK intead
> of dedicated I2C controller, so this series used i2c-gpio bitbanging.
>
> Right now the camera is able to detect, but capture images shows
> sequence of red, blue line. any suggestion please help.

The CSI controller doesn't seem to work properly at the default
clock rate of 600 MHz. Dropping it down to 300 MHz, the default
rate used by the BSP, fixes things.

The BSP also tries to use different clock rates (multiples of 108 MHz)
according to the captured image size. I've not tried this since the
driver no longer exports sub-device controls, and I currently don't
know how to handle that to change the resolution.

Regards
ChenYu
