Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45561 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbeJLQfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 12:35:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id q5-v6so12573989wrw.12
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2018 02:03:34 -0700 (PDT)
Date: Fri, 12 Oct 2018 10:03:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mfd: ds90ux9xx: add I2C bridge/alias and link
 connection driver
Message-ID: <20181012090329.GX4939@dell>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-6-vz@mleia.com>
 <20181012060455.GV4939@dell>
 <c8f01b88-c14f-867d-d796-7464b2e8ccfb@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8f01b88-c14f-867d-d796-7464b2e8ccfb@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Oct 2018, Vladimir Zapolskiy wrote:
> On 10/12/2018 09:04 AM, Lee Jones wrote:
> > On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:
> > 
> >> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >>
> >> The change adds TI DS90Ux9xx I2C bridge/alias subdevice driver and
> >> FPD Link connection handling mechanism.
> >>
> >> Access to I2C devices connected to a remote de-/serializer is done in
> >> a transparent way, on established link detection event such devices
> >> are registered on an I2C bus, which serves a local de-/serializer IC.
> >>
> >> The development of the driver was a collaborative work, the
> >> contribution done by Balasubramani Vivekanandan includes:
> >> * original simplistic implementation of the driver,
> >> * support of implicitly specified devices in device tree,
> >> * support of multiple FPD links for TI DS90Ux9xx,
> >> * other kind of valuable review comments, clean-ups and fixes.
> >>
> >> Also Steve Longerbeam made the following changes:
> >> * clear address maps after linked device removal,
> >> * disable pass-through in disconnection,
> >> * qualify locked status with non-zero remote address.
> >>
> >> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >> ---
> >>  drivers/mfd/Kconfig                |   8 +
> >>  drivers/mfd/Makefile               |   1 +
> >>  drivers/mfd/ds90ux9xx-i2c-bridge.c | 764 +++++++++++++++++++++++++++++
> >>  3 files changed, 773 insertions(+)
> >>  create mode 100644 drivers/mfd/ds90ux9xx-i2c-bridge.c
> > 
> > Shouldn't this live in drivers/i2c?
> 
> no, the driver is not for an I2C controller of any kind, and the driver does
> not register itself in the I2C subsystem by calling i2c_add_adapter() or
> i2c_add_numbered_adapter() or i2c_mux_add_adapter() etc, this topic was
> discussed with Wolfram also.
> 
> Formally the driver converts the managed IC into a multi-address I2C
> slave device, I understand that it does not sound like a well suited driver
> for MFD, but ds90ux9xx-core.c and ds90ux9xx-i2c-bridge.c drivers are quite
> tightly coupled.

Using MFD as the default dumping ground for anything which does more
than one thing has also been discussed before. :)

You need to figure out what function this device provides and
re-locate it into the subsystem which it best fits.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
