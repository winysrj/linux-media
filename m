Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40688 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbeFFJSr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 05:18:47 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [RFC PATCH v1 1/4] media: dt-bindings: max9286: add device tree
 binding
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
 <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
 <05b13a1c-61eb-616d-4726-c326bd496a62@cogentembedded.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <6ec0292c-565c-4259-c56f-c2503f312193@ideasonboard.com>
Date: Wed, 6 Jun 2018 10:18:41 +0100
MIME-Version: 1.0
In-Reply-To: <05b13a1c-61eb-616d-4726-c326bd496a62@cogentembedded.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On 06/06/18 10:14, Sergei Shtylyov wrote:
> On 6/6/2018 2:34 AM, Kieran Bingham wrote:
> 
>> Provide device tree binding documentation for the MAX9286 Quad GMSL
>> deserialiser.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>   .../devicetree/bindings/media/i2c/max9286.txt | 75 +++++++++++++++++++
>>   1 file changed, 75 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/max9286.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/max9286.txt
>> b/Documentation/devicetree/bindings/media/i2c/max9286.txt
>> new file mode 100644
>> index 000000000000..e6e5d2c93245
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
>> @@ -0,0 +1,75 @@
>> +* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
>> +
>> +Required Properties:
>> + - compatible: Shall be "maxim,max9286"
>> +
>> +The following required properties are defined externally in
>> +Documentation/devicetree/bindings/i2c/i2c-mux.txt:
>> + - Standard I2C mux properties.
>> + - I2C child bus nodes.
>> +
>> +A maximum of 4 I2C child nodes can be specified on the MAX9286, to
>> +correspond with a maximum of 4 input devices.
>> +
>> +The device node must contain one 'port' child node per device input and output
>> +port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
>> +are numbered as follows.
>> +
>> +      Port        Type
>> +    ----------------------
>> +       0          sink
>> +       1          sink
>> +       2          sink
>> +       3          sink
>> +       4          source
>> +
>> +Example:
>> +&i2c4 {
>> +    gmsl-deserializer@0 {
> 
>    Not @4c?

Hrm possibly. In our current working DTB (where I obtained this from) we have
gmsl-deserializer@0, and gmsl-deserializer@1.

I suspect you are probably right though, this should likely be the i2c address.

Thanks for the spot.

>> +        compatible = "maxim,max9286";
>> +        reg = <0x4c>;
>> +        poc-supply = <&poc_12v>;
>> +
>> +        #address-cells = <1>;
>> +        #size-cells = <0>;
>> +
> [...]
>> +        i2c@0 {
>> +            #address-cells = <1>;
>> +            #size-cells = <0>;
>> +            reg = <0>;
>> +
>> +            camera@51 {
>> +                compatible = MAXIM_CAMERA0;
> 
>    What, again?

Yup. Same example extract :D - I'll make sure it's fixed.

Regards

Kieran

>> +                reg = <0x51 0x61>;
>> +
>> +                port {
>> +                    rdacm20_out0: endpoint {
>> +                        remote-endpoint = <&max9286_in0>;
>> +                    };
>> +                };
>> +            };
>> +        };
>> +    };
>> +};
> 
> MBR, Sergei
