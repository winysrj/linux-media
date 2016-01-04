Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55071 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbcADQQ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 11:16:28 -0500
Subject: Re: [PATCH 07/10] [media] tvp5150: Add device tree binding document
To: Rob Herring <robh@kernel.org>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
 <1451910332-23385-8-git-send-email-javier@osg.samsung.com>
 <20160104140748.GA10797@rob-hp-laptop>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <568A9AD2.2010702@osg.samsung.com>
Date: Mon, 4 Jan 2016 13:16:18 -0300
MIME-Version: 1.0
In-Reply-To: <20160104140748.GA10797@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Rob,

Thanks a lot for your feedback.

On 01/04/2016 11:07 AM, Rob Herring wrote:
> On Mon, Jan 04, 2016 at 09:25:29AM -0300, Javier Martinez Canillas wrote:
>> Add a Device Tree binding document for the TVP5150 video decoder.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>
>>  .../devicetree/bindings/media/i2c/tvp5150.txt      | 35 ++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp5150.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
>> new file mode 100644
>> index 000000000000..bf0b3f3128ce
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
>> @@ -0,0 +1,35 @@
>> +* Texas Instruments TVP5150 and TVP5151 video decoders
>> +
>> +The TVP5150 and TVP5151 are video decoders that convert baseband NTSC and PAL
>> +(and also SECAM in the TVP5151 case) video signals to either 8-bit 4:2:2 YUV
>> +with discrete syncs or 8-bit ITU-R BT.656 with embedded syncs output formats.
>> +
>> +Required Properties:
>> +- compatible: value must be "ti,tvp5150"
> 
> What about the 5151? The driver never needs to know if SECAM is 
> supported or not?
>

The device ID can be detected at runtime by reading the TVP5150_MSB_DEV_ID
and TVP5150_LSB_DEV_ID registers in both tvp5150 and tvp5151 (see patch #2
in this series). So I thought there was no need to have another compatible
string for "ti,tvp5151".
 
>> +- reg: I2C slave address
>> +
>> +Optional Properties:
>> +- powerdown-gpios: phandle for the GPIO connected to the PDN pin, if any.
>> +- reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
>> +
>> +The device node must contain one 'port' child node for its digital output
>> +video port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +&i2c2 {
>> +	...
>> +	tvp5150@5c {
>> +			compatible = "ti,tvp5150";
> 
> Too much indentation here.
>

Right, I copied the example from a DTS that had another level of indentation
but it seems that I forgot to fix all lines, sorry about that. I will in v2.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
