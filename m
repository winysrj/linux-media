Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35063 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbcLGR2v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 12:28:51 -0500
Received: by mail-pf0-f173.google.com with SMTP id i88so78017372pfk.2
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 09:28:50 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 4/5] [media] dt-bindings: add TI VPIF documentation
References: <20161207050826.23174-1-khilman@baylibre.com>
        <20161207050826.23174-5-khilman@baylibre.com>
        <7493249.S63p6GTauu@avalon>
Date: Wed, 07 Dec 2016 09:28:49 -0800
In-Reply-To: <7493249.S63p6GTauu@avalon> (Laurent Pinchart's message of "Wed,
        07 Dec 2016 17:17:45 +0200")
Message-ID: <m260mvejhq.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:

> Hi Kevin,
>
> Thank you for the patch.
>
> On Tuesday 06 Dec 2016 21:08:25 Kevin Hilman wrote:
>> Acked-by: Rob Herring <robh@kernel.org>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> ---
>> .../devicetree/bindings/media/ti,da850-vpif.txt    | 67 +++++++++++++++++++
>> 1 file changed, 67 insertions(+)
>> create mode 100644
>> Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt new file mode
>> 100644
>> index 000000000000..fa06dfdb6898
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> @@ -0,0 +1,67 @@
>> +Texas Instruments VPIF
>> +----------------------
>> +
>> +The TI Video Port InterFace (VPIF) is the primary component for video
>> +capture and display on the DA850/AM18x family of TI DaVinci/Sitara
>> +SoCs.
>> +
>> +TI Document reference: SPRUH82C, Chapter 35
>> +http://www.ti.com/lit/pdf/spruh82
>> +
>> +Required properties:
>> +- compatible: must be "ti,da850-vpif"
>> +- reg: physical base address and length of the registers set for the
>> device;
>> +- interrupts: should contain IRQ line for the VPIF
>> +
>> +Video Capture:
>> +
>> +VPIF has a 16-bit parallel bus input, supporting 2 8-bit channels or a
>> +single 16-bit channel.  It should contain at least one port child node
>> +with child 'endpoint' node. Please refer to the bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>
> You might want to clarify how endpoints are use in the two cases. Apart from 
> that,

OK, I'll add another example for the 16-bit case.  Something like...

>> +Example using 2 8-bit input channels, one of which is connected to an
>> +I2C-connected TVP5147 decoder:
>> +
>> +	vpif: vpif@217000 {
>> +		compatible = "ti,da850-vpif";
>> +		reg = <0x217000 0x1000>;
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
>> +				  reg = <1>;
>> +				  bus-width = <8>;
>> +				  data-shift = <8>;
>> +			};
>> +		};
>> +	};
>> +
>> +[ ... ]
>> +
>> +&i2c0 {
>> +
>> +	tvp5147@5d {
>> +		compatible = "ti,tvp5147";
>> +		reg = <0x5d>;
>> +		status = "okay";
>> +
>> +		port {
>> +			composite: endpoint {
>> +				hsync-active = <1>;
>> +				vsync-active = <1>;
>> +				pclk-sample = <0>;
>> +
>> +				/* VPIF channel 0 (lower 8-bits) */
>> +				remote-endpoint = <&vpif_ch0>;
>> +				bus-width = <8>;
>> +			};
>> +		};
>> +	};
>> +};

...this, at the end of the binding doc:

Alternatively, an example when the bus is configured as a single
16-bit input (e.g. for raw-capture mode):

	vpif: vpif@217000 {
		compatible = "ti,da850-vpif";
		reg = <0x217000 0x1000>;
		interrupts = <92>;

		port {
			vpif_ch0: endpoint {
				  bus-width = <16>;
			};
		};
	};


Thanks for the review,

Kevin
