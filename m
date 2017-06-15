Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:46275 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750793AbdFOQPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:15:09 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5FGD977007084
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 17:15:08 +0100
Received: from mail-pf0-f200.google.com (mail-pf0-f200.google.com [209.85.192.200])
        by mx07-00252a01.pphosted.com with ESMTP id 2b065ytm99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 17:15:08 +0100
Received: by mail-pf0-f200.google.com with SMTP id h21so15049883pfk.13
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:15:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170615125958.GE12407@valkosipuli.retiisi.org.uk>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <888a28269a8a7c22feb2a126db699b1259d1b457.1497452006.git.dave.stevenson@raspberrypi.org>
 <20170615125958.GE12407@valkosipuli.retiisi.org.uk>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Thu, 15 Jun 2017 17:15:04 +0100
Message-ID: <CAAoAYcOKD=Bd8_yDuoT8g+g1JYJO1fEoY83YWjPY38sru8Cvdw@mail.gmail.com>
Subject: Re: [RFC 1/2] [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari.

Thanks for the review.

On 15 June 2017 at 13:59, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Dave,
>
> Thanks for the set!
>
> On Wed, Jun 14, 2017 at 04:15:46PM +0100, Dave Stevenson wrote:
>> Document the DT bindings for the CSI2/CCP2 receiver peripheral
>> (known as Unicam) on BCM283x SoCs.
>>
>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
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
> Please use "data-lanes" endpoint property instead. This is the number of
> connected physical lanes and specific to the hardware.

I'll rethink/test, but to explain what I was intending to achieve:

Registers UNICAM_DAT2 and UNICAM_DAT3 are not valid for instances of
the hardware that only have two lanes instantiated in silicon.
In the case of the whole BCM283x family, Unicam0 ony has 2 lanes
instantiated, whilst Unicam1 has the maximum 4 lanes. (Lower
resolution front cameras would connect to Unicam0, whilst the higher
resolution back cameras would go to Unicam1).

To further confuse matters, on the Pi platforms (other than the
Compute Module), it is Unicam1 that is brought out to the camera
connector but with only 2 lanes wired up.

I was intending to make it possible for the driver to avoid writing to
invalid registers, and also describe the platform limitations to allow
sanity checking.
I haven't tested against Unicam0 as yet to see what actually happens
if we try to write UNICAM_DAT2 or UNICAM_DAT3. If the hardware
silently swallows it then that requirement is null and void. I'll do
some testing tomorrow.
The second bit comes down to how friendly an error you want should
someone write an invalid DT with 'data-lanes' greater than can be
supported by the platform.

> Could you also document which endpoint properties are mandatory and which
> ones optional?

Will do, although I'm not sure there are any required properties.

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
>
> Extra newline. Don't you need any other properties here?

Newline done.
As above, I don't believe there are any other properties required, but
will double check. What extras were you expecting to see there?

>> +                     };
>> +             };
>> +     };
>> +
>> +     i2c0: i2c@7e205000 {
>> +
>> +             tc358743: tc358743@0f {
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
>
> This one needs to refer to the endpoint, just as the one in the CSI-2
> receiver does.

OK.
(I'm suspecting very few drivers actually follow that link, but I'll correct).

>> +                                     clock-lanes = <0>;
>> +                                     data-lanes = <1 2 3 4>;

Oops, DT author beware! That should only have 2 lanes defined (not
that the TC358743 driver looks at it beyond checking it is non-zero).

>> +                                     clock-noncontinuous;
>> +                                     link-frequencies =
>> +                                             /bits/ 64 <297000000>;
>> +                             };
>> +                     };
>> +             };
>> +     };
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
