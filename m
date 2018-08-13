Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43018 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730301AbeHMWBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 18:01:20 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3] dt-bindings: media: adv748x: Document re-mappable
 addresses
To: Rob Herring <robh@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180809192944.7371-1-kieran.bingham@ideasonboard.com>
 <20180813174544.GA11379@rob-hp-laptop>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <dedade62-91ed-2c92-dac7-fe4a8f9d9452@ideasonboard.com>
Date: Mon, 13 Aug 2018 20:17:42 +0100
MIME-Version: 1.0
In-Reply-To: <20180813174544.GA11379@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 13/08/18 18:45, Rob Herring wrote:
> On Thu, Aug 09, 2018 at 08:29:44PM +0100, Kieran Bingham wrote:
>> The ADV748x supports configurable slave addresses for its I2C pages.
>> Document the page names, and provide an example for setting each of the
>> pages explicitly.
> 
> It would be good to say why you need this. 

In fact - I should probably have added a fixes tag here, which would
have added more context:

Fixes: 67537fe960e5 ("media: i2c: adv748x: Add support for
i2c_new_secondary_device")

Should I repost with this fixes tag?
Or can it be collected with the RB tag?


> The only use I can think of 
> is if there are other devices on the bus and you need to make sure the 
> addresses don't conflict.

Yes, precisely. This driver has 'slave pages' which are created and
mapped by the driver. The device has default addresses which are used by
the driver - but it's very easy for these to conflict with other devices
on the same I2C bus.

Because the mappings are simply a software construct, we have a means to
specify the desired mappings through DT at the board level - which
allows the boards to ensure that conflicts do not appear.


> Arguably, that information could be figured out without this in DT.

How so ?

Scanning the bus is error prone, and dependant upon driver state (and
presence), and we have no means currently of requesting 'free/unused'
addresses from the I2C core framework.

> Regardless,
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Thank you.

--
Regards

Kieran



> 
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>
>> ---
>> v2:
>>  - Fix commit message
>>  - Extend documentation for the "required property" reg:
>>
>> v3
>>  - Fix missing comment from Laurent.
>>  - correct the reg descrption
>> ---
>>  .../devicetree/bindings/media/i2c/adv748x.txt    | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> index 21ffb5ed8183..25a02496f4ba 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> @@ -10,7 +10,11 @@ Required Properties:
>>      - "adi,adv7481" for the ADV7481
>>      - "adi,adv7482" for the ADV7482
>>  
>> -  - reg: I2C slave address
>> +  - reg: I2C slave addresses
>> +    The ADV748x has up to twelve 256-byte maps that can be accessed via the
>> +    main I2C ports. Each map has it own I2C address and acts as a standard
>> +    slave device on the I2C bus. The main address is mandatory, others are
>> +    optional and remain at default values if not specified.
>>  
>>  Optional Properties:
>>  
>> @@ -18,6 +22,11 @@ Optional Properties:
>>  		     "intrq3". All interrupts are optional. The "intrq3" interrupt
>>  		     is only available on the adv7481
>>    - interrupts: Specify the interrupt lines for the ADV748x
>> +  - reg-names : Names of maps with programmable addresses.
>> +		It shall contain all maps needing a non-default address.
>> +		Possible map names are:
>> +		  "main", "dpll", "cp", "hdmi", "edid", "repeater",
>> +		  "infoframe", "cbus", "cec", "sdp", "txa", "txb"
>>  
>>  The device node must contain one 'port' child node per device input and output
>>  port, in accordance with the video interface bindings defined in
>> @@ -47,7 +56,10 @@ Example:
>>  
>>  	video-receiver@70 {
>>  		compatible = "adi,adv7482";
>> -		reg = <0x70>;
>> +		reg = <0x70 0x71 0x72 0x73 0x74 0x75
>> +		       0x60 0x61 0x62 0x63 0x64 0x65>;
>> +		reg-names = "main", "dpll", "cp", "hdmi", "edid", "repeater",
>> +			    "infoframe", "cbus", "cec", "sdp", "txa", "txb";
>>  
>>  		#address-cells = <1>;
>>  		#size-cells = <0>;
>> -- 
>> 2.17.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards
--
Kieran
