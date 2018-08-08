Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40632 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeHIBg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 21:36:26 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH] dt-bindings: media: adv748x: Document secondary addresses
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: mchehab@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
References: <20180808173128.6400-1-kieran.bingham@ideasonboard.com>
 <4299631.dFueHHkrC4@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <dfee5f7b-8e42-a130-94f4-d6ffa9034349@ideasonboard.com>
Date: Thu, 9 Aug 2018 00:14:28 +0100
MIME-Version: 1.0
In-Reply-To: <4299631.dFueHHkrC4@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/08/18 23:59, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Wednesday, 8 August 2018 20:31:28 EEST Kieran Bingham wrote:
>> The ADV748x supports configurable slave addresses for its I2C pages.
>> Document the page names, and example for setting each of the pages
>> excplicitly.

s/excplicitly/explicitly/


>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>> ---
>>  .../devicetree/bindings/media/i2c/adv748x.txt          | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
>> 21ffb5ed8183..9515d8ad0e31 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> @@ -18,6 +18,11 @@ Optional Properties:
>>  		     "intrq3". All interrupts are optional. The "intrq3" interrupt
>>  		     is only available on the adv7481
>>    - interrupts: Specify the interrupt lines for the ADV748x
>> +  - reg-names : Names of maps with programmable addresses.
>> +		It can contain any map needed a non-default address.
> 
> s/can contain any map needed/shall contain all maps needing/
> 
>> +		Possible map names are:
>> +		  "main", "dpll", "cp", "hdmi", "edid", "repeater",
>> +		  "infoframe", "cbus", "cec", "sdp", "txa", "txb"
> 
> Should you also update the description of the reg property, possibly with the 
> same text as the adv7604 bindings ?


Ah yes - I had missed this part which should be added:

  - reg: I2C slave addresses

The ADV748xx has up to twelve 256-byte maps that can be accessed via the
main I2C ports. Each map has it own I2C address and acts as a standard
slave device on the I2C bus. The main address is mandatory, others are
optional and revert to defaults if not specified.


>>  The device node must contain one 'port' child node per device input and
>> output port, in accordance with the video interface bindings defined in
>> @@ -47,7 +52,10 @@ Example:
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
