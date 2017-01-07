Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36284 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbdAGAZR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 19:25:17 -0500
Subject: Re: [PATCH v2 05/19] ARM: dts: imx6-sabresd: add OV5642 and OV5640
 camera sensors
To: Fabio Estevam <festevam@gmail.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-6-git-send-email-steve_longerbeam@mentor.com>
 <CAOMZO5CibSU45Cw1d8ZipiGSVfhCQ4uP4XiNuWTGLa5eHmC6Qg@mail.gmail.com>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <e8f3329a-ff01-ae6d-a52d-32cb9bb10b2c@gmail.com>
Date: Fri, 6 Jan 2017 16:25:14 -0800
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CibSU45Cw1d8ZipiGSVfhCQ4uP4XiNuWTGLa5eHmC6Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/04/2017 07:26 AM, Fabio Estevam wrote:
> On Tue, Jan 3, 2017 at 6:57 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>> +       camera: ov5642@3c {
>> +               compatible = "ovti,ov5642";
>> +               pinctrl-names = "default";
>> +               pinctrl-0 = <&pinctrl_ov5642>;
>> +               clocks = <&clks IMX6QDL_CLK_CKO>;
>> +               clock-names = "xclk";
>> +               reg = <0x3c>;
>> +               xclk = <24000000>;
>> +               DOVDD-supply = <&vgen4_reg>; /* 1.8v */
>> +               AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
>> +                                               rev B board is VGEN5 */
> Please use vgen3 so that by default we have the valid AVDD-supply for
> revC boards which is more recent and more the users have access to.

done.

>
>> +       mipi_camera: ov5640@3c {
>> +               compatible = "ovti,ov5640_mipi";
>> +               pinctrl-names = "default";
>> +               pinctrl-0 = <&pinctrl_ov5640>;
>> +               reg = <0x3c>;
>> +               clocks = <&clks IMX6QDL_CLK_CKO>;
>> +               clock-names = "xclk";
>> +               xclk = <24000000>;
>> +               DOVDD-supply = <&vgen4_reg>; /* 1.8v */
>> +               AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
>> +                                               rev B board is VGEN5 */
> Same here.

done.

>
>> +               pinctrl_ov5640: ov5640grp {
>> +                       fsl,pins = <
>> +                               MX6QDL_PAD_SD1_DAT2__GPIO1_IO19 0x80000000
>> +                               MX6QDL_PAD_SD1_CLK__GPIO1_IO20  0x80000000
> Please avoid all the 0x80000000 IOMUX settings and replace them by
> their real values.

yeah, finally got around to this, done!

Steve

