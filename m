Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:54739 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751752AbdFOPk1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 11:40:27 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5FFd2Sh014203
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 16:40:25 +0100
Received: from mail-pg0-f69.google.com (mail-pg0-f69.google.com [74.125.83.69])
        by mx08-00252a01.pphosted.com with ESMTP id 2b058etpwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 16:40:25 +0100
Received: by mail-pg0-f69.google.com with SMTP id e187so15757904pgc.7
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 08:40:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2de5b0c1-2408-2a12-8c4c-fa91658e0c0b@i2se.com>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
 <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl> <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
 <2de5b0c1-2408-2a12-8c4c-fa91658e0c0b@i2se.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Thu, 15 Jun 2017 16:40:22 +0100
Message-ID: <CAAoAYcO_6BmqMBm_o1B7R5RUBDbCFmLQwULHvs029SpK0zwN2A@mail.gmail.com>
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan.

On 15 June 2017 at 15:49, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> Hi Dave,
>
> Am 15.06.2017 um 15:38 schrieb Dave Stevenson:
>> Hi Hans.
>>
>> "On 15 June 2017 at 08:12, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> Hi Dave,
>>>
>>> Here is a quick review of this driver. Once a v2 is posted I'll do a more
>>> thorough
>>> check.
>> Thank you. I wasn't expecting such a quick response.
>>
>>> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>>>> ...
>>>>
>>>> +
>>>> +struct bayer_fmt {
>>>> +       u32 fourcc;
>>>> +       u8 depth;
>>>> +};
>>>> +
>>>> +const struct bayer_fmt all_bayer_bggr[] = {
>>>> +       {V4L2_PIX_FMT_SBGGR8,   8},
>>>> +       {V4L2_PIX_FMT_SBGGR10P, 10},
>>>> +       {V4L2_PIX_FMT_SBGGR12,  12},
>>>> +       {V4L2_PIX_FMT_SBGGR16,  16},
>>>> +       {0,                     0}
>>>> +};
>>>> +
>>>> +const struct bayer_fmt all_bayer_rggb[] = {
>>>> +       {V4L2_PIX_FMT_SRGGB8,   8},
>>>> +       {V4L2_PIX_FMT_SRGGB10P, 10},
>>>> +       {V4L2_PIX_FMT_SRGGB12,  12},
>>>> +       /* V4L2_PIX_FMT_SRGGB16,        16},*/
>>>
>>> Why is this commented out? Either uncomment, add a proper comment explaining
>>> why
>>> or remove it.
>> I was developing this against the Pi specific tree, and that is still
>> on 4.9 which didn't have several of the 16 bit Bayer formats. I see
>> that Sakari has added them (thank you Sakari), so I can uncomment
>> them.
>
> does this series work with Linux Mainline (incl. bcm283x dts files)?
>
> In case not, please tell what is missing?

I switched about a week or so back onto mainline, partly to pick up
and use the recent fwnode parsing changes within V4L2.
This driver is working with Mainline and bcm283x.dts once the relevant
DT sections are added.

The DT changes aren't in a state to post as a patch set as yet. The
main stumbiling block is that the camera I2C is BSC0 but typically on
GPIOs 28&29 instead of 0&1 (44&45 on Pi3). Swapping to 28&29 would be
a significant change in behaviour so wouldn't be acceptable.
If it can be knocked in to shape then the i2c-mux-pinctrl driver
appears to do what is required to make 0&1 and 28&29 appear as 2
independent I2C buses, but I haven't had the time as yet to finesse
that. It needs some care as 44&45 (needed for the camera on Pi3) are
used for the SMSC9514 clock and audio on Pi2, so the configuration
needs to be sorted per platform. (switching off the 9514 clock results
in no ethernet or USB, so generally means time for a swift reboot -
been there, done that).

The DT diffs I have for running on a Pi2 are:
diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi
b/arch/arm/boot/dts/bcm2835-rpi.dtsi
index a7b5ce1..1f24219 100644
--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -46,7 +46,7 @@

 &i2c0 {
        pinctrl-names = "default";
-       pinctrl-0 = <&i2c0_gpio0>;
+       pinctrl-0 = <&i2c0_gpio28>;
        status = "okay";
        clock-frequency = <100000>;
 };
@@ -106,3 +106,11 @@
 &dsi1 {
        power-domains = <&power RPI_POWER_DOMAIN_DSI1>;
 };
+
+&csi0 {
+       power-domains = <&power RPI_POWER_DOMAIN_UNICAM0>;
+};
+
+&csi1 {
+       power-domains = <&power RPI_POWER_DOMAIN_UNICAM1>;
+};
diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 561f27d..4c575e4 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -512,6 +512,34 @@
                        status = "disabled";
                };

+               csi0: csi0@7e800000 {
+                       compatible = "brcm,bcm2835-unicam";
+                       reg = <0x7e800000 0x800>,
+                             <0x7e802000 0x4>;
+                       interrupts = <2 6>;
+                       clocks = <&clocks BCM2835_CLOCK_CAM0>;
+                       clock-names = "lp_clock";
+                       #address-cells = <1>;
+                       #size-cells = <0>;
+                       #clock-cells = <1>;
+
+                       status = "disabled";
+               };
+
+               csi1: csi1@7e801000 {
+                       compatible = "brcm,bcm2835-unicam";
+                       reg = <0x7e801000 0x800>,
+                             <0x7e802004 0x4>;
+                       interrupts = <2 7>;
+                       clocks = <&clocks BCM2835_CLOCK_CAM1>;
+                       clock-names = "lp_clock";
+                       #address-cells = <1>;
+                       #size-cells = <0>;
+                       #clock-cells = <1>;
+
+                       status = "disabled";
+               };
+
                i2c1: i2c@7e804000 {
                        compatible = "brcm,bcm2835-i2c";
                        reg = <0x7e804000 0x1000>;

and then an overlay to add the TC358743
diff --git a/arch/arm/boot/dts/overlays/tc358743-overlay.dts
b/arch/arm/boot/dts/overlays/tc358743-overlay.dts
new file mode 100644
index 0000000..b205ca1
--- /dev/null
+++ b/arch/arm/boot/dts/overlays/tc358743-overlay.dts
@@ -0,0 +1,72 @@
+// Definitions for Toshiba TC358743 HDMI to CSI2 bridge on VC I2C bus
+/dts-v1/;
+/plugin/;
+
+/{
+       compatible = "brcm,bcm2708";
+
+       fragment@0 {
+               target = <&i2c_vc>;
+               __overlay__ {
+                       #address-cells = <1>;
+                       #size-cells = <0>;
+                       status = "okay";
+
+                       tc358743@0f {
+                               compatible = "toshiba,tc358743";
+                               reg = <0x0f>;
+                               status = "okay";
+
+                               clocks = <&tc358743_clk>;
+                               clock-names = "refclk";
+
+                               tc358743_clk: bridge-clk {
+                                       compatible = "fixed-clock";
+                                       #clock-cells = <0>;
+                                       clock-frequency = <27000000>;
+                               };
+
+                               port {
+                                       tc358743: endpoint {
+                                               remote-endpoint = <&csi1>;
+                                               clock-lanes = <0>;
+                                               data-lanes = <1 2>;
+                                               clock-noncontinuous;
+                                               link-frequencies =
/bits/ 64 <297000000>;
+                                       };
+                               };
+                       };
+               };
+       };
+
+       fragment@1 {
+               target = <&csi1>;
+               __overlay__ {
+                       #address-cells = <1>;
+                       #size-cells = <0>;
+                       status = "okay";
+
+                       port {
+                               #address-cells = <1>;
+                               #size-cells = <0>;
+
+                               endpoint {
+                                       remote-endpoint = <&tc358743>;
+                               };
+                       };
+               };
+       };
+};

Apologies for the formatting - it'll obviously be cleaned up before
submitting as a patch.

  Dave
