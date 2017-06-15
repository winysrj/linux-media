Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:44434 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752441AbdFOMgK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 08:36:10 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5FCa3ac014393
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 13:36:03 +0100
Received: from mail-pf0-f198.google.com (mail-pf0-f198.google.com [209.85.192.198])
        by mx07-00252a01.pphosted.com with ESMTP id 2b065ythpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 13:36:03 +0100
Received: by mail-pf0-f198.google.com with SMTP id q78so10849239pfj.9
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 05:36:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9b335139-d558-d15b-52fa-ce9ea06040a3@i2se.com>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <888a28269a8a7c22feb2a126db699b1259d1b457.1497452006.git.dave.stevenson@raspberrypi.org>
 <9b335139-d558-d15b-52fa-ce9ea06040a3@i2se.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Thu, 15 Jun 2017 13:35:59 +0100
Message-ID: <CAAoAYcN0C+_K14EaM60Hch4eqs-cp4g5AZSMfJ+ig4SzZ_ZzSA@mail.gmail.com>
Subject: Re: [RFC 1/2] [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan.
Thanks for taking the time to review this.

On 15 June 2017 at 07:34, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> Hi Dave,
>
> Am 14.06.2017 um 17:15 schrieb Dave Stevenson:
>> Document the DT bindings for the CSI2/CCP2 receiver peripheral
>> (known as Unicam) on BCM283x SoCs.
>>
>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>
> please add the devicetree guys in CC for the binding.

Will do for V2.

>> ---
>>  .../devicetree/bindings/media/bcm2835-unicam.txt   | 76 ++++++++++++++++++++++
>>  1 file changed, 76 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>> new file mode 100644
>> index 0000000..cc5a451
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>> @@ -0,0 +1,76 @@
>> +Broadcom BCM283x Camera Interface (Unicam)
>> +------------------------------------------
>> +
>> +The Unicam block on BCM283x SoCs is the receiver for either
>> +CSI-2 or CCP2 data from image sensors or similar devices.
>
> It would be nice to add some of your explanations to Hans in this
> document or into the driver.

Will do.

>> +
>> +Required properties:
>> +===================
>> +- compatible : must be "brcm,bcm2835-unicam".
>> +- reg                : physical base address and length of the register sets for the
>> +               device.
>> +- interrupts : should contain the IRQ line for this Unicam instance.
>> +- clocks     : list of clock specifiers, corresponding to entries in
>> +               clock-names property.
>> +- clock-names        : must contain an "lp_clock" entry, matching entries
>> +               in the clocks property.
>> +
>> +Optional properties
>> +===================
>> +- max-data-lanes: the hardware can support varying numbers of clock lanes.
>> +               This value is the maximum number supported by this instance.
>> +               Known values of 2 or 4. Default is 2.
>
> AFAIK, this isn't a common property yet. So possibly a vendor prefix
> must be added.

I think yoiu are correct that it isn't a common property. I was
wanting to cover the situation on the majority of the Pi boards where
Unicam1 has been used which can handle 4 lanes, but only 2 have been
broken out to the camera connector.
Happy to add a vendor prefix in V2.

>> +
>> +
>> +Unicam supports a single port node. It should contain one 'port' child node
>> +with child 'endpoint' node. Please refer to the bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +     csi1: csi@7e801000 {
>> +             compatible = "brcm,bcm2835-unicam";
>> +             reg = <0x7e801000 0x800>,
>> +                   <0x7e802004 0x4>;
>> +             interrupts = <2 7>;
>> +             clocks = <&clocks BCM2835_CLOCK_CAM1>;
>> +             clock-names = "lp_clock";
>> +
>> +             port {
>> +                     #address-cells = <1>;
>> +                     #size-cells = <0>;
>> +
>> +                     endpoint {
>> +                             remote-endpoint = <&tc358743_0>;
>> +
>> +                     };
>> +             };
>> +     };
>> +
>> +     i2c0: i2c@7e205000 {
>> +
>> +             tc358743: tc358743@0f {
>
> Usually the node name should describe the function of the node for example:
>
> tc358743: csi-hdmi-bridge@0f

Will do.

> Best regards
> Stefan
>
>> +                     compatible = "toshiba,tc358743";
>> +                     reg = <0x0f>;
>> +                     status = "okay";
>> +
>> +                     clocks = <&tc358743_clk>;
>> +                     clock-names = "refclk";
>> +
>> +                     tc358743_clk: bridge-clk {
>> +                             compatible = "fixed-clock";
>> +                             #clock-cells = <0>;
>> +                             clock-frequency = <27000000>;
>> +                     };
>> +
>> +                     port {
>> +                             tc358743_0: endpoint {
>> +                                     remote-endpoint = <&csi1>;
>> +                                     clock-lanes = <0>;
>> +                                     data-lanes = <1 2 3 4>;
>> +                                     clock-noncontinuous;
>> +                                     link-frequencies =
>> +                                             /bits/ 64 <297000000>;
>> +                             };
>> +                     };
>> +             };
>> +     };

Thanks
  Dave
