Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34408 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbeEILGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 07:06:52 -0400
Received: by mail-wr0-f193.google.com with SMTP id p18-v6so35305943wrm.1
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 04:06:52 -0700 (PDT)
References: <20180507162152.2545-1-rui.silva@linaro.org> <20180507162152.2545-8-rui.silva@linaro.org> <1525789823.18091.11.camel@pengutronix.de>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v3 07/14] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <1525789823.18091.11.camel@pengutronix.de>
Date: Wed, 09 May 2018 12:06:49 +0100
Message-ID: <m3d0y59jg6.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
Thanks for the review.

On Tue 08 May 2018 at 14:30, Philipp Zabel wrote:
> On Mon, 2018-05-07 at 17:21 +0100, Rui Miguel Silva wrote:
>> Add bindings documentation for i.MX7 media drivers.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  .../devicetree/bindings/media/imx7.txt        | 152 
>>  ++++++++++++++++++
>>  1 file changed, 152 insertions(+)
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/imx7.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/media/imx7.txt 
>> b/Documentation/devicetree/bindings/media/imx7.txt
>> new file mode 100644
>> index 000000000000..06d723d6354d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/imx7.txt
>> @@ -0,0 +1,152 @@
>> +Freescale i.MX7 Media Video Device
>> +==================================
>> +
>> +Video Media Controller node
>> +---------------------------
>> +
>> +This is the media controller node for video capture support. 
>> It is a
>> +virtual device that lists the camera serial interface nodes 
>> that the
>> +media device will control.
>> +
>> +Required properties:
>> +- compatible : "fsl,imx7-capture-subsystem";
>> +- ports      : Should contain a list of phandles pointing to 
>> camera
>> +		sensor interface port of CSI
>> +
>> +example:
>> +
>> +capture-subsystem {
>> +	compatible = "fsl,imx7-capture-subsystem";
>> +	ports = <&csi>;
>> +};
>
> Purely from a device tree perspective, I think this node is 
> unnecessary
> on i.MX7. The reason we have it for i.MX6 is that there are two
> identical IPUs on some of them, which makes it impossible to 
> reasonably
> bind the subsystem driver to one or the other of the ipu nodes. 
> On i.MX7
> the csi node is unique.
>
> The relevant imx-media-dev.c code in imx_media_probe could be 
> refactored
> into a utility function that could be called from the probe 
> function of
> the csi driver as well.

I think is a good idea, I will do something like this in v4
>
> [...]
>> +csi node
>> +--------
>> +
>> +This is device node for the CMOS Sensor Interface (CSI) which 
>> enables the chip
>> +to connect directly to external CMOS image sensors.
>> +
>> +Required properties:
>> +
>> +- compatible    : "fsl,imx7-csi";
>> +- reg           : base address and length of the register set 
>> for the device;
>> +- interrupts    : should contain CSI interrupt;
>> +- clocks        : list of clock specifiers, see
>> + 
>> Documentation/devicetree/bindings/clock/clock-bindings.txt for 
>> details;
>> +- clock-names   : must contain "axi", "mclk" and "dcic" 
>> entries, matching
>> +                 entries in the clock property;
>> +
>> +port node
>> +---------
>> +
>> +- reg		  : (required) should be 0 for the sink 
>> port;
>
> Not necessary, see below.
>
>> +
>> +example:
>> +
>> +                csi: csi@30710000 {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>> +
>> +                        compatible = "fsl,imx7-csi";
>> +                        reg = <0x30710000 0x10000>;
>> +                        interrupts = <GIC_SPI 7 
>> IRQ_TYPE_LEVEL_HIGH>;
>> +                        clocks = <&clks IMX7D_CLK_DUMMY>,
>> +                                        <&clks 
>> IMX7D_CSI_MCLK_ROOT_CLK>,
>> +                                        <&clks 
>> IMX7D_CLK_DUMMY>;
>> +                        clock-names = "axi", "mclk", "dcic";
>> +
>> +                        port@0 {
>> +                                reg = <0>;
>
> Since there is only one port, it does not need to be numbered.

Yes, ack.

---
Cheers,
	Rui
