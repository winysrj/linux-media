Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45107 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753831AbeERI2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 04:28:03 -0400
Received: by mail-wr0-f195.google.com with SMTP id w3-v6so566039wrl.12
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 01:28:03 -0700 (PDT)
References: <20180517125033.18050-1-rui.silva@linaro.org> <20180517125033.18050-7-rui.silva@linaro.org> <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v4 06/12] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk>
Date: Fri, 18 May 2018 09:27:58 +0100
Message-ID: <m3tvr5xt9t.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
Thanks for the review.
On Fri 18 May 2018 at 06:58, Sakari Ailus wrote:
> Hi Rui,
>
> On Thu, May 17, 2018 at 01:50:27PM +0100, Rui Miguel Silva 
> wrote:
>> Add bindings documentation for i.MX7 media drivers.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  .../devicetree/bindings/media/imx7.txt        | 145 
>>  ++++++++++++++++++
>>  1 file changed, 145 insertions(+)
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/imx7.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/media/imx7.txt 
>> b/Documentation/devicetree/bindings/media/imx7.txt
>> new file mode 100644
>> index 000000000000..161cff8e6442
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/imx7.txt
>> @@ -0,0 +1,145 @@
>> +Freescale i.MX7 Media Video Device
>> +==================================
>> +
>> +Video Media Controller node
>> +---------------------------
>
> Note that DT bindings document the hardware, they are as such 
> not Linux
> dependent.

This was removed in this series, however I removed it in the wrong 
patch,
If you see patch 11/12 you will see this being removed. I will fix 
this
in v5. Thanks for notice it.

> 
>> +
>> +This is the media controller node for video capture support. 
>> It is a
>> +virtual device that lists the camera serial interface nodes 
>> that the
>> +media device will control.
>
> Ditto.
>
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
>
> What's the purpose of this node, if you only refer to another 
> device? This
> one rather does not look like a real device at all.
>
>> +	compatible = "fsl,imx7-capture-subsystem";
>> +	ports = <&csi>;
>> +};
>> +
>> +
>> +mipi_csi2 node
>> +--------------
>> +
>> +This is the device node for the MIPI CSI-2 receiver core in 
>> i.MX7 SoC. It is
>> +compatible with previous version of Samsung D-phy.
>> +
>> +Required properties:
>> +
>> +- compatible    : "fsl,imx7-mipi-csi2";
>> +- reg           : base address and length of the register set 
>> for the device;
>> +- interrupts    : should contain MIPI CSIS interrupt;
>> +- clocks        : list of clock specifiers, see
>> + 
>> Documentation/devicetree/bindings/clock/clock-bindings.txt for 
>> details;
>> +- clock-names   : must contain "pclk", "wrap" and "phy" 
>> entries, matching
>> +                  entries in the clock property;
>> +- power-domains : a phandle to the power domain, see
>> + 
>> Documentation/devicetree/bindings/power/power_domain.txt for 
>> details.
>> +- reset-names   : should include following entry "mrst";
>> +- resets        : a list of phandle, should contain reset 
>> entry of
>> +                  reset-names;
>> +- phy-supply    : from the generic phy bindings, a phandle to 
>> a regulator that
>> +	          provides power to MIPI CSIS core;
>> +- bus-width     : maximum number of data lanes supported (SoC 
>> specific);
>> +
>> +Optional properties:
>> +
>> +- clock-frequency : The IP's main (system bus) clock frequency 
>> in Hz, default
>> +		    value when this property is not specified is 
>> 166 MHz;
>> +
>> +port node
>> +---------
>> +
>> +- reg		  : (required) can take the values 0 or 1, 
>> where 0 is the
>> +                     related sink port and port 1 should be 
>> the source one;
>> +
>> +endpoint node
>> +-------------
>> +
>> +- data-lanes    : (required) an array specifying active 
>> physical MIPI-CSI2
>> +		    data input lanes and their mapping to logical 
>> lanes; the
>> +		    array's content is unused, only its length is 
>> meaningful;
>> +
>> +- fsl,csis-hs-settle : (optional) differential receiver 
>> (HS-RX) settle time;
>
> Could you calculate this, as other drivers do? It probably 
> changes
> depending on the device runtime configuration.

The only reference to possible values to this parameter is given 
by
table in [0], can you point me out the formula for imx7 in the
documentation?

---
Cheers,
	Rui

[0] https://community.nxp.com/thread/463777
