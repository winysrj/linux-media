Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:37502 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeLCJqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 04:46:23 -0500
Received: by mail-io1-f66.google.com with SMTP id f14so4418090iol.4
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 01:46:05 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-5-wens@csie.org>
In-Reply-To: <20181130075849.16941-5-wens@csie.org>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Mon, 3 Dec 2018 15:15:54 +0530
Message-ID: <CAMty3ZB6p8Uv7abMC8jDHHYwdAeuBen2GPjOhN=wEL7+=DDt3g@mail.gmail.com>
Subject: Re: [PATCH 4/6] ARM: dts: sunxi: h3-h5: Add pinmux setting for CSI
 MCLK on PE1
To: Chen-Yu Tsai <wens@csie.org>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 30, 2018 at 1:28 PM Chen-Yu Tsai <wens@csie.org> wrote:
>
> Some camera modules have the SoC feeding a master clock to the sensor
> instead of having a standalone crystal. This clock signal is generated
> from the clock control unit and output from the CSI MCLK function of
> pin PE1.
>
> Add a pinmux setting for it for camera sensors to reference.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---

On Fri, Nov 30, 2018 at 1:29 PM Chen-Yu Tsai <wens@csie.org> wrote:
>
> The CSI controller found on the H3 (and H5) is a reduced version of the
> one found on the A31. It only has 1 channel, instead of 4 channels for
> time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
> "fallback" to a compatible that implements more features than it
> supports.
>
> Drop the A31 fallback compatible.
>
> Fixes: f89120b6f554 ("ARM: dts: sun8i: Add the H3/H5 CSI controller")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---

Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
