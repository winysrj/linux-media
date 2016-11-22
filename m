Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33665 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756122AbcKVPuJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 10:50:09 -0500
Received: by mail-pf0-f179.google.com with SMTP id d2so4836284pfd.0
        for <linux-media@vger.kernel.org>; Tue, 22 Nov 2016 07:50:08 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 4/4] [media] dt-bindings: add TI VPIF documentation
References: <20161122014408.22388-1-khilman@baylibre.com>
        <20161122014408.22388-5-khilman@baylibre.com>
        <6699f003-a125-1e1b-e161-e9453dad7bdc@xs4all.nl>
Date: Tue, 22 Nov 2016 07:50:06 -0800
In-Reply-To: <6699f003-a125-1e1b-e161-e9453dad7bdc@xs4all.nl> (Hans Verkuil's
        message of "Tue, 22 Nov 2016 13:47:20 +0100")
Message-ID: <m2wpfvzf81.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 22/11/16 02:44, Kevin Hilman wrote:
>> Cc: Rob Herring <robh@kernel.org>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> ---
>>  .../bindings/media/ti,da850-vpif-capture.txt       | 65 ++++++++++++++++++++++
>>  .../devicetree/bindings/media/ti,da850-vpif.txt    |  8 +++
>>  2 files changed, 73 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
>>  create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
>> new file mode 100644
>> index 000000000000..bdd93267301f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
>> @@ -0,0 +1,65 @@
>> +Texas Instruments VPIF Capture
>> +------------------------------
>> +
>> +The TI Video Port InterFace (VPIF) capture component is the primary
>> +component for video capture on the DA850 family of TI DaVinci SoCs.
>> +
>> +TI Document number reference: SPRUH82C
>> +
>> +Required properties:
>> +- compatible: must be "ti,da850-vpif-capture"
>> +- reg: physical base address and length of the registers set for the device;
>> +- interrupts: should contain IRQ line for the VPIF
>> +
>> +VPIF capture has a 16-bit parallel bus input, supporting 2 8-bit
>> +channels or a single 16-bit channel.  It should contain at least one
>> +port child node with child 'endpoint' node. Please refer to the
>> +bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example using 2 8-bit input channels, one of which is connected to an
>> +I2C-connected TVP5147 decoder:
>> +
>> +	vpif_capture: video-capture@0x00217000 {
>> +		compatible = "ti,vpif-capture";
>
> Did you forget to update the compatible string to ti,da850-vpif-capture?
>

Ugh, yup.   v3 coming right up.

Kevin


