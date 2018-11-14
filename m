Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40268 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbeKNN02 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 08:26:28 -0500
MIME-Version: 1.0
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 14 Nov 2018 11:24:48 +0800
Message-ID: <CAGb2v66ygbcomUMkcv8qMCAs_qviFMPzpxj-F4=YBrpuLrdSUw@mail.gmail.com>
Subject: Re: [PATCH 0/5] media: Allwinner A10 CSI support
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2018 at 4:24 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi,
>
> Here is a series introducing the support for the A10 (and SoCs of the same
> generation) CMOS Sensor Interface (called CSI, not to be confused with
> MIPI-CSI, which isn't support by that IP).
>
> That interface is pretty straightforward, but the driver has a few issues
> that I wanted to bring up:
>
>   * The only board I've been testing this with has an ov5640 sensor
>     attached, which doesn't work with the upstream driver. Copying the
>     Allwinner init sequence works though, and this is how it has been
>     tested. Testing with a second sensor would allow to see if it's an
>     issue on the CSI side or the sensor side.
>   * When starting a capture, the last buffer to capture will fail due to
>     double buffering being used, and we don't have a next buffer for the
>     last frame. I'm not sure how to deal with that though. It seems like
>     some drivers use a scratch buffer in such a case, some don't care, so
>     I'm not sure which solution should be preferred.
>   * We don't have support for the ISP at the moment, but this can be added
>     eventually.
>
>   * How to model the CSI module clock isn't really clear to me. It looks
>     like it goes through the CSI controller and then is muxed to one of the
>     CSI pin so that it can clock the sensor. I'm not quite sure how to
>     model it, if it should be a clock, the CSI driver being a clock
>     provider, or if the sensor should just use the module clock directly.

Which clock are you talking about? MCLK? This seems to be fed directly from
the CCU, as there doesn't seem to be controls for it within the CSI hardware
block, and the diagram doesn't list it either. IMO you don't have to model it.
The camera sensor device node would just take a reference to it directly. You
would probably enable the (separate) pinmux setting in the CSI controller node.


ChenYu
