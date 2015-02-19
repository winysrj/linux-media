Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55977 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbBSI01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 03:26:27 -0500
Message-id: <54E59E2F.5050805@samsung.com>
Date: Thu, 19 Feb 2015 09:26:23 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd>
In-reply-to: <20150218224747.GA3999@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2015 11:47 PM, Pavel Machek wrote:
>
> On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
>> Add a documentation of LED Flash class specific sysfs attributes.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>
> NAK-ed-by: Pavel Machek
>
>> +What:		/sys/class/leds/<led>/available_sync_leds
>> +Date:		February 2015
>> +KernelVersion:	3.20
>> +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
>> +Description:	read/write

Here it should be 'read only', to be fixed.

>> +		Space separated list of LEDs available for flash strobe
>> +		synchronization, displayed in the format:
>> +
>> +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
>
> Multiple values per file, with all the problems we had in /proc. I
> assume led_id is an integer?

Yes.

> What prevents space or dot in led name?

Space can be forbidden by defining naming convention. The name comes
from the DT binding 'label' property and I don't see any problem in
forbidding space in it.

A dot in the name does not introduce parsing problems - simply the first
dot after digits separates led id from led name.

-- 
Best Regards,
Jacek Anaszewski
