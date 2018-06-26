Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:54766 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeFZGL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 02:11:58 -0400
Received: by mail-it0-f68.google.com with SMTP id 76-v6so554974itx.4
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2018 23:11:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180305100432.15009-1-maxime.ripard@bootlin.com>
References: <20180305100432.15009-1-maxime.ripard@bootlin.com>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Tue, 26 Jun 2018 11:41:56 +0530
Message-ID: <CAMty3ZBQXyvOnzy_9RLDW-QO9qnAC4SR5UJnWYmhiPrP23z_vg@mail.gmail.com>
Subject: Re: [PATCH 0/4] media: sun6i: Add support for the H3 CSI controller
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yong Deng <yong.deng@magewell.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 5, 2018 at 3:34 PM, Maxime Ripard <maxime.ripard@bootlin.com> w=
rote:
> Hi,
>
> The H3 and H5 have a CSI controller based on the one previously found
> in the A31, that is currently supported by the sun6i-csi driver.
>
> Add the compatibles to the device tree bindings and to the driver to
> make it work properly.
>
> This obviously depends on the serie "Initial Allwinner V3s CSI
> Support" by Yong Deng.
>
> Let me know what you think,
> Maxime
>
> Maxime Ripard (2):
>   dt-bindings: media: sun6i: Add A31 and H3 compatibles
>   media: sun6i: Add A31 compatible
>
> Myl=C3=A8ne Josserand (2):
>   ARM: dts: sun8i: Add the H3/H5 CSI controller
>   [DO NOT MERGE] ARM: dts: sun8i: Add CAM500B camera module to the Nano
>     Pi M1+

Just trying to understand what interface has been tested with npi-m1+,
is it DVP (parallel) interface? I've Bananapi 5MP[1] and trying to
test on top, and look like its MIPI CSI2. I guess Yong patch[2]
doesn't support CSI2 yet, am I correct?

[1] https://www.amazon.in/Generic-V3-0-BPI-M3-camera-chipset/dp/B0727N5CD1
[2] https://patchwork.kernel.org/patch/10380067/

Jagan.

--=20
Jagan Teki
Senior Linux Kernel Engineer | Amarula Solutions
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
