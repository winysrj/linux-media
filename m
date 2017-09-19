Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:38152 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751845AbdISPNC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 11:13:02 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8JF8wUq027500
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 16:13:00 +0100
Received: from mail-pg0-f71.google.com (mail-pg0-f71.google.com [74.125.83.71])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg1mee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 16:13:00 +0100
Received: by mail-pg0-f71.google.com with SMTP id p5so6967479pgn.7
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 08:13:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170919143248.c65slho3l5vnvzku@rob-hp-laptop>
References: <cover.1505314390.git.dave.stevenson@raspberrypi.org>
 <9ad8b23d5c394b64ed02f9a5ebc49209696a5ace.1505314390.git.dave.stevenson@raspberrypi.org>
 <20170919143248.c65slho3l5vnvzku@rob-hp-laptop>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Tue, 19 Sep 2017 16:12:57 +0100
Message-ID: <CAAoAYcMVYRgzVUt4j9gMNmL7jYtS1Mmt5mhQw_Xca=Sq=eTU2A@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
To: Rob Herring <robh@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob.

Thanks for the review.

On 19 September 2017 at 15:32, Rob Herring <robh@kernel.org> wrote:
> On Wed, Sep 13, 2017 at 04:07:47PM +0100, Dave Stevenson wrote:
>> Document the DT bindings for the CSI2/CCP2 receiver peripheral
>> (known as Unicam) on BCM283x SoCs.
>>
>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>> ---
>>  .../devicetree/bindings/media/bcm2835-unicam.txt   | 107 +++++++++++++++++++++
>>  1 file changed, 107 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>> new file mode 100644
>> index 0000000..2ee5af7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>> @@ -0,0 +1,107 @@
>> +Broadcom BCM283x Camera Interface (Unicam)
>> +------------------------------------------
>> +
>> +The Unicam block on BCM283x SoCs is the receiver for either
>> +CSI-2 or CCP2 data from image sensors or similar devices.
>> +
>> +There are two camera drivers in the kernel for BCM283x - this one
>> +and bcm2835-camera (currently in staging).
>
> Linux detail that is n/a for bindings.
>
>> +
>> +This driver is purely the kernel controlling the Unicam peripheral - there
>
> Bindings describe h/w blocks, not drivers.
>
>> +is no involvement with the VideoCore firmware. Unicam receives CSI-2
>> +(or CCP2) data and writes it into SDRAM. There is no additional processing
>> +performed.
>> +It should be possible to connect it to any sensor with a
>> +suitable output interface and V4L2 subdevice driver.
>> +
>> +bcm2835-camera uses the VideoCore firmware to control the sensor,
>> +Unicam, ISP, and various tuner control loops. Fully processed frames are
>> +delivered to the driver by the firmware. It only has sensor drivers
>> +for Omnivision OV5647, and Sony IMX219 sensors, and is closed source.
>> +
>> +The two drivers are mutually exclusive for the same Unicam instance.
>> +The firmware checks the device tree configuration during boot. If
>> +it finds device tree nodes called csi0 or csi1 then it will block the
>> +firmware from accessing the peripheral, and bcm2835-camera will
>> +not be able to stream data.
>
> All interesting, but irrelavent to the binding other than the part about
> node name. Reword to just state the requirements to get the firmware to
> ignore things.

Hans had suggested it was potentially appropriate for DT bindings too
on last review [1] (which I apologise for missing off devicetree folk
from), but I'll remove all mention of Linux/driver detail for v3.
That will leave only a reworded version of the bit about making the
firmware ignore the blocks.

[1] http://www.spinics.net/lists/linux-media/msg117047.html

>> +It should be possible to use bcm2835-camera on one camera interface
>> +and bcm2835-unicam on the other interface if there is a need to.
>
> For upstream, I don't think we care to support that. We don't need 2
> bindings.

I'll remove as irrelevant, but in that case wouldn't you have 2
bindings - one to bcm2835-camera which references the vchi node to the
GPU, and one to bcm2835-unicam that gives the full block config as
being discussed in this doc.
(Currently bcm2835-camera is a platform device so has no binding doc).
This probably isn't the place for such a discussion.

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
>
> _clock is redundant.

So just "lp" as the clock name? Will assume so.

>> +
>> +Unicam supports a single port node. It should contain one 'port' child node
>> +with child 'endpoint' node. Please refer to the bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Within the endpoint node, the following properties are mandatory:
>> +- remote-endpoint    : links to the source device endpoint.
>> +- data-lanes         : An array denoting how many data lanes are physically
>> +                       present for this CSI-2 receiver instance. This can
>> +                       be limited by either the SoC itself, or by the
>> +                       breakout on the platform.
>> +                       Lane reordering is not supported, so lanes must be
>> +                       in order, starting at 1.
>
> Just refer to docs for standard properties. Just add any info on limits
> of values like number of cells.

So again from v1 Sakari had asked for a statement of mandatory
properties for the endpoint [1].
Would you be happy with something like:
"Within the endpoint node the "remote-endpoint" and "data-lanes"
properties are mandatory. Lane reordering is not supported so the
lanes must be in order, starting at 1. The number of data lanes should
represent the number of lanes usable on the platform, which may be
limited by the SoC or the platform breakout."

[1] http://www.spinics.net/lists/linux-media/msg117080.html

>> +
>> +Lane reordering is not supported on the clock lane, so the optional property
>> +"clock-lane" will implicitly be <0>.
>> +Similarly lane inversion is not supported, therefore "lane-polarities" will
>> +implicitly be <0 0 0 0 0>.
>> +Neither of these values will be checked.
>> +
>> +Example:
>> +     csi1: csi@7e801000 {
>
> I thought the node had to be called csi0 or csi1. The label (csi1) will
> be gone from the compiled dtb.

Yes, typo :-(

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
>
> Don't need these with a single endpoint.

OK.

>> +
>> +                     csi1_ep: endpoint {
>> +                             remote-endpoint = <&tc358743_0>;
>> +                             data-lanes = <1 2>;
>> +                     };
>> +             };
>> +     };
>> +
>> +     i2c0: i2c@7e205000 {
>> +
>> +             tc358743: csi-hdmi-bridge@0f {
>> +                     compatible = "toshiba,tc358743";
>> +                     reg = <0x0f>;
>> +                     status = "okay";
>
> Don't show status in examples.

OK.

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
>> +                                     remote-endpoint = <&csi1_ep>;
>> +                                     clock-lanes = <0>;
>> +                                     data-lanes = <1 2>;
>> +                                     clock-noncontinuous;
>> +                                     link-frequencies =
>> +                                             /bits/ 64 <297000000>;
>> +                             };
>> +                     };
>> +             };
>> +     };
>> --
>> 2.7.4
>>

Thanks.
  Dave
