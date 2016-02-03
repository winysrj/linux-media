Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53517 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbcBCOmZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2016 09:42:25 -0500
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Wolfram Sang <wsa@the-dreams.de>
References: <56B204CB.60602@osg.samsung.com>
 <20160203142323.GA8620@tetsubishi>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <56B211CB.7060900@osg.samsung.com>
Date: Wed, 3 Feb 2016 11:42:19 -0300
MIME-Version: 1.0
In-Reply-To: <20160203142323.GA8620@tetsubishi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Wolfram,

On 02/03/2016 11:23 AM, Wolfram Sang wrote:
> Hi,
>
> thanks for reporting the issue!
>

Thanks for the quick response.
  
>> Not filling the OMAP I2C driver's runtime PM callbacks does not help either.
>>
>> Any hints about the proper way to fix this issue?
>
> Can the I2C device be en-/disabled in some way? Which board is this
> happening with? Any specs for it publicly available?
>

Yes, the device has a PDN (Power-Down) pin that puts the device in stand by
mode but it is not used by the driver. The only thing that the driver does
is to toggle the PDN and RESET pins to put the device in normal operation.

In fact, the behavior after commit 9f924169c035 is the same as when the power
sequence does not happen. That confused me at the beginning and I was chasing
a red herring by looking at the OMAP GPIO driver and GPIO core.

The datasheet of the tvp5151 is public in case you need more info [0].

This is happening on an OMAP3 DM3730 IGEPv2 board [1] using an expansion
board [2] that has the tvp5151 video decoder among other peripherals.

I don't think the schematics for these boards are public but I've them in
case you need me to look at something.
  
> Regards,
>
>     Wolfram
>

[0]: http://www.ti.com/lit/ds/symlink/tvp5151.pdf
[1]: https://isee.biz/products/igep-processor-boards/igepv2-dm3730
[2]: https://isee.biz/products/igep-expansion-boards/igepv2-expansion

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
