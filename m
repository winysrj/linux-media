Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35075 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbcESIPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 04:15:03 -0400
Received: by mail-wm0-f52.google.com with SMTP id r12so68224693wme.0
        for <linux-media@vger.kernel.org>; Thu, 19 May 2016 01:15:02 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] [media] media: i2c/ov5645: add the device tree
 binding document
To: Rob Herring <robh@kernel.org>
References: <1463572208-8826-1-git-send-email-todor.tomov@linaro.org>
 <1463572208-8826-2-git-send-email-todor.tomov@linaro.org>
 <20160518231637.GA31413@rob-hp-laptop>
Cc: pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, geert@linux-m68k.org, matrandg@cisco.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <573D7601.1090605@linaro.org>
Date: Thu, 19 May 2016 11:14:57 +0300
MIME-Version: 1.0
In-Reply-To: <20160518231637.GA31413@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thank you for your time to review. My responses are below:

On 05/19/2016 02:16 AM, Rob Herring wrote:
> On Wed, May 18, 2016 at 02:50:07PM +0300, Todor Tomov wrote:
>> Add the document for ov5645 device tree binding.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/i2c/ov5645.txt       | 56 ++++++++++++++++++++++
>>  1 file changed, 56 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> new file mode 100644
>> index 0000000..8799000
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> @@ -0,0 +1,56 @@
>> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
>> +
>> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image sensor with
>> +an active array size of 2592H x 1944V. It is programmable through a serial SCCB
> 
> s/SCCB/I2C/ because that is the more common name.
Ok.

> 
>> +interface.
>> +
>> +Required Properties:
>> +- compatible: value should be "ovti,ov5645"
>> +- clocks: reference to the xclk clock
>> +- clock-names: should be "xclk"
>> +- assigned-clocks: reference to the xclk clock
> 
> This should be optional as it only makes sense if there is more than one 
> option.
I have only used assigned-clocks to specify for which clock the
assigned-clock-rates property is. This is the way I understood it.
Isn't this correct? (Also please see below.)

> 
>> +- assigned-clock-rates: should be "23880000"
> 
> Doesn't this depend on the board? Most parts take a range of 
> frequencies. The driver should know what the range is and request a rate 
> within this range.
This is the sensor external clock. Actually the driver depends on this value - 
the sensor mode settings which the driver configures are calculated based on
this value. If you change this clock rate you need to change the sensor mode
settings. However they usually come from the vendor of the sensor so they
usually never change. So this clock rate for this driver is fixed to 23.88MHz
and is not expected to change.

> 
>> +
>> +Optional Properties:
>> +- reset-gpios: Chip reset GPIO
>> +- pwdn-gpios: Chip power down GPIO
> 
> Use enable-gpios as it is more common and would just be the inverse of 
> this.
pwdn is the notation which OV use for this gpio, so I'd personally prefer
to keep the name. Do you think it is still better to change it?

> 
> Both need to specify the polarity.
Ok, I'll add a note for the polarity.

> 
>> +- dovdd-supply: Chip IO regulator
>> +- dvdd-supply: Chip core regulator
>> +- avdd-supply: Chip analog regulator
>> +
>> +The device node must contain one 'port' child node for its digital output
>> +video port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.

-- 
Best regards,
Todor Tomov
