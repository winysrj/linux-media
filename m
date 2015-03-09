Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65532 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbCIMWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 08:22:31 -0400
Message-id: <54FD9074.8050600@samsung.com>
Date: Mon, 09 Mar 2015 13:22:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Add OF support
References: <1425822349-19218-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <54FD7788.2020709@samsung.com> <2320734.ji4C9lV64t@avalon>
In-reply-to: <2320734.ji4C9lV64t@avalon>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/15 12:29, Laurent Pinchart wrote:
> On Monday 09 March 2015 11:35:52 Sylwester Nawrocki wrote:
>> On 08/03/15 14:45, Laurent Pinchart wrote:
>>> +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
>>> @@ -0,0 +1,41 @@
>>> +* Aptina 1/3-Inch WVGA CMOS Digital Image Sensor
>>> +
>>> +The Aptina MT9V032 is a 1/3-inch CMOS active pixel digital image sensor
>>> with
>>> +an active array size of 752H x 480V. It is programmable through a simple
>>> +two-wire serial interface.
>>> +
>>> +Required Properties:
>>> +
>>> +- compatible: value should be either one among the following
>>> +	(a) "aptina,mt9v032" for MT9V032 color sensor
>>> +	(b) "aptina,mt9v032m" for MT9V032 monochrome sensor
>>> +	(c) "aptina,mt9v034" for MT9V034 color sensor
>>> +	(d) "aptina,mt9v034m" for MT9V034 monochrome sensor
>>
>> It can't be determined at runtime whether the sensor is just monochromatic ?
> 
> Unfortunately not. As far as I'm aware the only difference between the 
> monochromatic and color sensors is the colour filter array. The register set 
> is identical.
> 
>> Al in all the color filter array is a physical property of the sensor,
>> still the driver seems to be ignoring the "m" suffix.
> 
> No, the driver relies on the I2C core filling returning the I2C device id 
> instance corresponding to the DT compatible string, and gets sensor model 
> information from id->driver_data.

Sorry, I missed the I2C id part.

>> Hence I suspect the
>> register interfaces for both color and monochromatic versions are
>> compatible. I'm wondering whether using a boolean property to indicate the
>> color filter array type would do as well.
> 
> That's an option as well, yes. I don't have a strong preference at the moment, 
> but it should be noted that the "m" suffix is contained in the chip's part 
> number.
> 
> MT9V032C12STM
> MT9V032C12STC
> MT9V032C12STMD
> MT9V032C12STMH
> MT9V032C12STCD
> MT9V032C12STCH
> 
> Granted, they use "c" for colour sensors, which the DT bindings don't use, and 
> a "C12ST" that we completely ignore.

OK, deriving the compatible strings from current I2C device ids seems less
trouble from the driver's writer POV. However, my feeling is that using same
compatible and additional property to indicate colour/monochrome is cleaner
as far as device tree binding is concerned.
Anyway, I'm not going to object against your current approach, I suppose it's
acceptable as well.

-- 
Regards,
Sylwester
