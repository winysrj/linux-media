Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:40251 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZFKOxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 10:53:23 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KL2008U5XD1TU20@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 11 Jun 2009 10:53:25 -0400 (EDT)
Date: Thu, 11 Jun 2009 10:53:24 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
In-reply-to: <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
To: Roger <rogerx@sdf.lonestar.org>
Cc: Mike Isely <isely@isely.net>, linux-media@vger.kernel.org
Message-id: <4A311A64.4080008@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1244446830.3797.6.camel@localhost2.local>
 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mike Isely wrote:
> On Sun, 7 Jun 2009, Roger wrote:
> 
>> >From looking at "linux/drivers/media/dvb/frontends/s5h1411.c",  The
>> s5h1411_readreg wants to see "2" but is getting "-5" from the i2c bus.
>>
>> --- Snip ---
>>
>> s5h1411_readreg: readreg error (ret == -5)
>> pvrusb2: unregistering DVB devices
>> device: 'dvb0.net0': device_unregister
>>
>> --- Snip ---
>>
>> What exactly does this mean?
> 
> Roger:
> 
> It means that the module attempted an I2C transfer and the transfer 
> failed.  The I2C adapter within the pvrusb2 driver will return either 
> the number of bytes that it transferred or a failure code.  The failure 
> code, as is normal convention in the kernel, will be a negated errno 
> value.  Thus the expected value of 2 would be the fact that it probably 
> tried a 2 byte transfer, while the actual value returned of -5 indicate 
> an EIO error, which is what the pvrusb2 driver will return when the 
> underlying I2C transaction has failed.
> 
> Of course the real question is not that it failed but why it failed.  
> And for that I unfortunately do not have an answer.  It's possible that 
> the s5h1411 driver did something that the chip didn't like and the chip 
> responded by going deaf on the I2C bus.  More than a few I2C-driven 
> parts can behave this way.  It's also possible that the part might have 
> been busy and unable to respond - but usually in that case the driver 
> for such a part will be written with this in mind and will know how / 
> when to communicate with the hardware.

Roger:

Another possibility, although I don't know the PVRUSB2 driver too well, the 
s5h1411 is being held in reset when the driver unloads _AFTER_ the last active 
use was analog video (assuming the s5h1411 is floated in reset as the FX2 input 
port might be shared with the analog encoder)

I don't have all the details so your failure case could be complete different.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
