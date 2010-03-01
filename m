Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0CANiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 08:38:07 -0500
Message-ID: <4B8BC332.6060303@infradead.org>
Date: Mon, 01 Mar 2010 10:37:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Jean Delvare <khali@linux-fr.org>,
	Dmitri Belimov <d.belimov@gmail.com>,
	linux-media@vger.kernel.org, "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: [IR RC, REGRESSION] Didn't work IR RC
References: <20100301153645.5d529766@glory.loctelecom.ru> <1267442919.3110.20.camel@palomino.walls.org>
In-Reply-To: <1267442919.3110.20.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Mon, 2010-03-01 at 15:36 +0900, Dmitri Belimov wrote:
>> Hi All
>>
>> After rework of the IR subsystem, IR RC no more work in our TV cards.
>> As I see 
>> call saa7134_probe_i2c_ir,
>>   configure i2c
>>   call i2c_new_device
>>
>> New i2c device not registred.
>>
>> The module kbd-i2c-ir loaded after i2c_new_device.
> 
> Jean,
> 
> There was also a problem reported with the cx23885 driver's I2C
> connected IR by Timothy Lenz:
> 
> http://www.spinics.net/lists/linux-media/msg15122.html
> 
> The failure mode sounds similar to Dmitri's, but maybe they are
> unrelated.
> 
> I worked a bit with Timothy on IRC and the remote device fails to be
> detected whether ir-kbd-i2c is loaded before the cx23885 driver or after
> the cx23885 driver.  I haven't found time to do any folow-up and I don't
> have any of the hardware in question.
> 
> Do you have any thoughts or a suggested troubleshooting approach?

Andy/Dmitri,

With the current i2c approach, the bridge driver is responsible for binding
an i2c device into the i2c adapter. In other words, the bridge driver should
have some logic to know what devices use ir-kbd-i2c, loading it at the right
i2c address(es). Manually loading IR shouldn't make any difference.

>From Andy's comment, I suspect that such logic is missing at cx23885 for the board
you're referring. Not sure if this is the same case of the boards Dmitri is
concerned about.

It should be noticed that the i2c redesign happened on 2.6.31 or 2.6.32, so,
if this is the case, a patch should be sent also to -stable.

In the case of saa7134, Jean worked on a fix for some boards:
	http://patchwork.kernel.org/patch/75883/

He is currently waiting for someone with the affected boards to test it and
give some return.

-- 

Cheers,
Mauro
