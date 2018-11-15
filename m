Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37470 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388088AbeKPDBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 22:01:16 -0500
MIME-Version: 1.0
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com> <20181115145013.3378-8-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-8-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 16 Nov 2018 00:52:28 +0800
Message-ID: <CAGb2v64t6t3Bwf4nc8gQWRDkdv4zGRF1-+Q7snqX6bkEVqirvA@mail.gmail.com>
Subject: Re: [PATCH 07/15] arm64: dts: allwinner: h5: Add system-control node
 with SRAM C1
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2018 at 10:50 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Add the H5-specific system control node description to its device-tree
> with support for the SRAM C1 section, that will be used by the video
> codec node later on.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 22 ++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> index b41dc1aab67d..c2d14b22b8c1 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> @@ -94,6 +94,28 @@
>         };
>
>         soc {
> +               system-control@1c00000 {
> +                       compatible = "allwinner,sun50i-h5-system-control";
> +                       reg = <0x01c00000 0x1000>;
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       ranges;
> +
> +                       sram_c1: sram@1d00000 {
> +                               compatible = "mmio-sram";
> +                               reg = <0x01d00000 0x80000>;

I'll try to check this one tomorrow.

I did find something interesting on the H3: there also seems to be SRAM at
0x01dc0000 to 0x01dcfeff , again mapped by the same bits as SRAM C1.

And on the A33, the SRAM C1 range is 0x01d00000 to 0x01d478ff.

This was found by mapping the SRAM to the CPU, then using devmem to poke
around the register range. If there's SRAM, the first read would typically
return random data, and a subsequent write to it would set some value that
would be read back correctly. If there's no SRAM, a read either returns 0x0
or some random data that can't be overwritten.

You might want to check the other SoCs.

ChenYu

> +                               #address-cells = <1>;
> +                               #size-cells = <1>;
> +                               ranges = <0 0x01d00000 0x80000>;
> +
> +                               ve_sram: sram-section@0 {
> +                                       compatible = "allwinner,sun50i-h5-sram-c1",
> +                                                    "allwinner,sun4i-a10-sram-c1";
> +                                       reg = <0x000000 0x80000>;
> +                               };
> +                       };
> +               };
> +
>                 mali: gpu@1e80000 {
>                         compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
>                         reg = <0x01e80000 0x30000>;
> --
> 2.19.1
>
