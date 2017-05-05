Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:3502 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdEEI2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 04:28:45 -0400
Subject: Re: [RFC 1/3] dt: bindings: Add a binding for flash devices
 associated to a sensor
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493720749-31509-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170504142730.tq4k3paofmyk5jul@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <1e8d0a73-3f3f-410b-ca04-89fa35b1f0b9@linux.intel.com>
Date: Fri, 5 May 2017 11:28:34 +0300
MIME-Version: 1.0
In-Reply-To: <20170504142730.tq4k3paofmyk5jul@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Sebastian Reichel wrote:
> Hi Sakari,
>
> On Tue, May 02, 2017 at 01:25:47PM +0300, Sakari Ailus wrote:
>> Camera flash drivers (and LEDs) are separate from the sensor devices in
>> DT. In order to make an association between the two, provide the
>> association information to the software.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  Documentation/devicetree/bindings/media/video-interfaces.txt | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> index 9cd2a36..d6c62bc 100644
>> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> @@ -67,6 +67,17 @@ are required in a relevant parent node:
>>  		    identifier, should be 1.
>>   - #size-cells    : should be zero.
>>
>> +
>> +Optional properties
>> +-------------------
>> +
>> +- flash: An array of phandles that refer to the flash light sources
>> +  related to an image sensor. These could be e.g. LEDs. In case the LED
>> +  driver drives more than a single LED, then the phandles here refer to
>> +  the child nodes of the LED driver describing individual LEDs. Only
>> +  valid for device nodes that are related to an image sensor.
>
> s/driver/controller/g - DT describes HW. Otherwise

Driver is hardware in this case. :-) The chip that acts as a current 
sink or source for the LED is the driver. E.g. the adp1653 documentation 
describes the chip as "Compact, High Efficiency, High Power, Flash/Torch 
LED Driver with Dual Interface".

It might be still possible to improve the wording. Software oriented 
folks are more likely to misunderstand the meaning of driver here, but 
controller might seem ambiguous for hardware oriented people.

How about:

- flash: An array of phandles that refer to the flash light sources
   related to an image sensor. These could be e.g. LEDs. In case the LED
   driver (current sink or source chip for the LED(s)) drives more than a
   single LED, then the phandles here refer to the child nodes of the LED
   driver describing individual LEDs. Only valid for device nodes that are
   related to an image sensor.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
