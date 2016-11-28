Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33434 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755446AbcK1WaD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 17:30:03 -0500
Received: by mail-pg0-f49.google.com with SMTP id 3so61496454pgd.0
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2016 14:30:03 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
Subject: Re: [PATCH v3 4/4] [media] dt-bindings: add TI VPIF documentation
References: <20161122155244.802-1-khilman@baylibre.com>
        <20161122155244.802-5-khilman@baylibre.com>
        <20161128213822.26oeyzkht5jz5gd3@rob-hp-laptop>
Date: Mon, 28 Nov 2016 14:30:01 -0800
In-Reply-To: <20161128213822.26oeyzkht5jz5gd3@rob-hp-laptop> (Rob Herring's
        message of "Mon, 28 Nov 2016 15:38:22 -0600")
Message-ID: <m2shqbs0eu.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Rob Herring <robh@kernel.org> writes:

> On Tue, Nov 22, 2016 at 07:52:44AM -0800, Kevin Hilman wrote:
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
>> index 000000000000..c447ac482c1d
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
>> +		reg = <0x00217000 0x1000>;
>> +		interrupts = <92>;
>> +
>> +		port {
>> +			vpif_ch0: endpoint@0 {
>> +				  reg = <0>;
>> +				  bus-width = <8>;
>> +				  remote-endpoint = <&composite>;
>> +			};
>> +
>> +			vpif_ch1: endpoint@1 {
>
> I think probably channels here should be ports rather than endpoints. 
> AIUI, having multiple endpoints is for cases like a mux or 1 to many 
> connections. There's only one data flow, but multiple sources or sinks.

Looking at this closer... , I used an endpoint because it's bascially a
16-bit parallel bus, that can be configured as (up to) 2 8-bit
"channels.  So, based on the video-interfaces.txt doc, I configured this
as a single port, with (up to) 2 endpoints.  That also allows me to
connect output of the decoder directly, using the remote-endpoint
property.

So I guess I'm not fully understanding your suggestion.

Kevin
