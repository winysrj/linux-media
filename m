Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54692 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbeHIK5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 06:57:12 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2] dt-bindings: media: adv748x: Document re-mappable
 addresses
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: mchehab@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
References: <20180808232941.10582-1-kieran.bingham@ideasonboard.com>
 <3968377.CNlSUayrWh@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <22e60e95-be35-76c4-af4e-7595025128d1@ideasonboard.com>
Date: Thu, 9 Aug 2018 09:33:21 +0100
MIME-Version: 1.0
In-Reply-To: <3968377.CNlSUayrWh@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/08/18 09:22, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Thursday, 9 August 2018 02:29:41 EEST Kieran Bingham wrote:
>> The ADV748x supports configurable slave addresses for its I2C pages.
>> Document the page names, and provide an example for setting each of the
>> pages explicitly.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>> ---
>> v2:
>>  - Fix commit message
>>  - Extend documentation for the "required property" reg:
>>
>>
>>  .../devicetree/bindings/media/i2c/adv748x.txt    | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
>> 21ffb5ed8183..f7fbe221c15e 100644
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
>> +    optional and revert to defaults if not specified.
> 
> Maybe "revert" has a meaning I'm not aware of, but don't you mean "default" > instead ? "default to defaults" probably needs to be rephrased though.

"Revert to defaults" makes perfect sense in my head :D ... but perhaps
   "remains at default values"
would be better?

> 
>>  Optional Properties:
>>
>> @@ -18,6 +22,11 @@ Optional Properties:
>>  		     "intrq3". All interrupts are optional. The "intrq3" interrupt
>>  		     is only available on the adv7481
>>    - interrupts: Specify the interrupt lines for the ADV748x
>> +  - reg-names : Names of maps with programmable addresses.
>> +		It can contain any map needed a non-default address.
> 
> I think you missed my comment to v1:
> 
> s/can contain any map needed/shall contain all maps needing/

Ugh ... yes I did.

/me shouldn't try to do easy patches at 12.30am.


>> +		Possible map names are:
>> +		  "main", "dpll", "cp", "hdmi", "edid", "repeater",
>> +		  "infoframe", "cbus", "cec", "sdp", "txa", "txb"
>>
>>  The device node must contain one 'port' child node per device input and
>> output port, in accordance with the video interface bindings defined in
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
> 

-- 
Regards
--
Kieran
