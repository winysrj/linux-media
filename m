Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:37896 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752097AbdIVQH1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 12:07:27 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8MG4ttY011284
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 17:07:25 +0100
Received: from mail-pf0-f197.google.com (mail-pf0-f197.google.com [209.85.192.197])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg34qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 17:07:25 +0100
Received: by mail-pf0-f197.google.com with SMTP id a7so2605247pfj.3
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 09:07:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1814950930.414004.1506062733728@email.1und1.de>
References: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
 <fae3d29bba67825030c0077dd9c79534b6888512.1505916622.git.dave.stevenson@raspberrypi.org>
 <1814950930.414004.1506062733728@email.1und1.de>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 22 Sep 2017 17:07:22 +0100
Message-ID: <CAAoAYcMFm82vo5k-iCCpARbndyrLDt1UMV_kRUDHiHA0iMzhMg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Eric Anholt <eric@anholt.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-rpi-kernel@lists.infradead.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan

On 22 September 2017 at 07:45, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> Hi Dave,
>
>> Dave Stevenson <dave.stevenson@raspberrypi.org> hat am 20. September 2017 um 18:07 geschrieben:
>>
>>
>> Document the DT bindings for the CSI2/CCP2 receiver peripheral
>> (known as Unicam) on BCM283x SoCs.
>>
>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>> ---
>>
>> Changes since v2
>> - Removed all references to Linux drivers.
>> - Reworded section about disabling the firmware driver.
>> - Renamed clock from "lp_clock" to "lp" in description and example.
>> - Referred to video-interfaces.txt and stated requirements on remote-endpoint
>>   and data-lanes.
>> - Corrected typo in example from csi to csi1.
>> - Removed unnecessary #address-cells and #size-cells in example.
>> - Removed setting of status from the example.
>>
>>  .../devicetree/bindings/media/bcm2835-unicam.txt   | 85 ++++++++++++++++++++++
>>  1 file changed, 85 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>> new file mode 100644
>> index 0000000..7714fb3
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>> @@ -0,0 +1,85 @@
>> +Broadcom BCM283x Camera Interface (Unicam)
>> +------------------------------------------
>> +
>> +The Unicam block on BCM283x SoCs is the receiver for either
>> +CSI-2 or CCP2 data from image sensors or similar devices.
>> +
>> +The main platform using this SoC is the Raspberry Pi family of boards.
>> +On the Pi the VideoCore firmware can also control this hardware block,
>> +and driving it from two different processors will cause issues.
>> +To avoid this, the firmware checks the device tree configuration
>> +during boot. If it finds device tree nodes called csi0 or csi1 then
>> +it will stop the firmware accessing the block, and it can then
>> +safely be used via the device tree binding.
>> +
>> +Required properties:
>> +===================
>> +- compatible : must be "brcm,bcm2835-unicam".
>> +- reg                : physical base address and length of the register sets for the
>> +               device.
>> +- interrupts : should contain the IRQ line for this Unicam instance.
>> +- clocks     : list of clock specifiers, corresponding to entries in
>> +               clock-names property.
>> +- clock-names        : must contain an "lp" entry, matching entries in the
>> +               clocks property.
>> +
>> +Unicam supports a single port node. It should contain one 'port' child node
>> +with child 'endpoint' node. Please refer to the bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Within the endpoint node the "remote-endpoint" and "data-lanes" properties
>> +are mandatory.
>> +Data lane reordering is not supported so the data lanes must be in order,
>> +starting at 1. The number of data lanes should represent the number of
>> +usable lanes for the hardware block. That may be limited by either the SoC or
>> +how the platform presents the interface, and the lower value must be used.
>> +
>> +Lane reordering is not supported on the clock lane either, so the optional
>> +property "clock-lane" will implicitly be <0>.
>> +Similarly lane inversion is not supported, therefore "lane-polarities" will
>> +implicitly be <0 0 0 0 0>.
>> +Neither of these values will be checked.
>> +
>> +Example:
>> +     csi1: csi1@7e801000 {
>> +             compatible = "brcm,bcm2835-unicam";
>> +             reg = <0x7e801000 0x800>,
>> +                   <0x7e802004 0x4>;
>
> sorry, i didn't noticed this before. I'm afraid this is using a small range of the CMI. Are there possible other users of this range? Does it make sense to handle this by a separate clock driver?

CMI (Clock Manager Image) consists of a total of 4 registers.
0x7e802000 is CMI_CAM0, with only bits 0-5 used for gating and
inversion of the clock and data lanes (2 data lanes available on
CAM0).
0x7e802004 is CMI_CAM1, with only bits 0-9 used for gating and
inversion of the clock and data lanes (4 data lanes available on
CAM1).
0x7e802008 is CMI_CAMTEST which I have no documentation or drivers for.
0x7e802010 is CMI_USBCTL. Only bit 6 is documented and is a reset. The
default value is the required value. Nothing touches it that I can
find.

The range listed only covers the one register associated with that
Unicam instance, so no other users. The other two aren't touched.
Do 16 active register bits solely for camera clock gating really
warrant a full clock driver?

  Dave
