Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46914 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbeJLUo1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 16:44:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, wsa@the-dreams.de
Subject: Re: [PATCH 5/7] mfd: ds90ux9xx: add I2C bridge/alias and link connection driver
Date: Fri, 12 Oct 2018 16:12:04 +0300
Message-ID: <1584081.CVFmJobd6K@avalon>
In-Reply-To: <c8f01b88-c14f-867d-d796-7464b2e8ccfb@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com> <20181012060455.GV4939@dell> <c8f01b88-c14f-867d-d796-7464b2e8ccfb@mentor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

(CC'ing Wolfram)

On Friday, 12 October 2018 10:32:32 EEST Vladimir Zapolskiy wrote:
> On 10/12/2018 09:04 AM, Lee Jones wrote:
> > On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:
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
> >> 
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

(Who is now on CC)

> Formally the driver converts the managed IC into a multi-address I2C
> slave device, I understand that it does not sound like a well suited driver
> for MFD, but ds90ux9xx-core.c and ds90ux9xx-i2c-bridge.c drivers are quite
> tightly coupled.

As mentioned in other e-mails in this thread I don't think this should be 
split out to a separate driver, I would move the functionality to the 
ds90ux9xx driver. You may want to register an I2C mux, but as you have a 
single port, that could be overkill. I haven't studied in details how to best 
support this chip using the existing I2C subsystems APIs (which we may want to 
extend if it needed), but I believe that (in your use cases) the deserializer 
should be a child of the serializer, and modeled as an I2C device.

-- 
Regards,

Laurent Pinchart
