Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33035 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966991AbdADP0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 10:26:19 -0500
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-6-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com> <1483477049-19056-6-git-send-email-steve_longerbeam@mentor.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 4 Jan 2017 13:26:18 -0200
Message-ID: <CAOMZO5CibSU45Cw1d8ZipiGSVfhCQ4uP4XiNuWTGLa5eHmC6Qg@mail.gmail.com>
Subject: Re: [PATCH v2 05/19] ARM: dts: imx6-sabresd: add OV5642 and OV5640
 camera sensors
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 3, 2017 at 6:57 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:

> +       camera: ov5642@3c {
> +               compatible = "ovti,ov5642";
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&pinctrl_ov5642>;
> +               clocks = <&clks IMX6QDL_CLK_CKO>;
> +               clock-names = "xclk";
> +               reg = <0x3c>;
> +               xclk = <24000000>;
> +               DOVDD-supply = <&vgen4_reg>; /* 1.8v */
> +               AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
> +                                               rev B board is VGEN5 */

Please use vgen3 so that by default we have the valid AVDD-supply for
revC boards which is more recent and more the users have access to.

> +       mipi_camera: ov5640@3c {
> +               compatible = "ovti,ov5640_mipi";
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&pinctrl_ov5640>;
> +               reg = <0x3c>;
> +               clocks = <&clks IMX6QDL_CLK_CKO>;
> +               clock-names = "xclk";
> +               xclk = <24000000>;
> +               DOVDD-supply = <&vgen4_reg>; /* 1.8v */
> +               AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
> +                                               rev B board is VGEN5 */

Same here.

> +               pinctrl_ov5640: ov5640grp {
> +                       fsl,pins = <
> +                               MX6QDL_PAD_SD1_DAT2__GPIO1_IO19 0x80000000
> +                               MX6QDL_PAD_SD1_CLK__GPIO1_IO20  0x80000000

Please avoid all the 0x80000000 IOMUX settings and replace them by
their real values.
