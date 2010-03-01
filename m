Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52453 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0CAL3J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Mar 2010 06:29:09 -0500
Subject: Re: [IR RC, REGRESSION] Didn't work IR RC
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>,
	Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Timothy D. Lenz" <tlenz@vorgon.com>
In-Reply-To: <20100301153645.5d529766@glory.loctelecom.ru>
References: <20100301153645.5d529766@glory.loctelecom.ru>
Content-Type: text/plain
Date: Mon, 01 Mar 2010 06:28:39 -0500
Message-Id: <1267442919.3110.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-03-01 at 15:36 +0900, Dmitri Belimov wrote:
> Hi All
> 
> After rework of the IR subsystem, IR RC no more work in our TV cards.
> As I see 
> call saa7134_probe_i2c_ir,
>   configure i2c
>   call i2c_new_device
> 
> New i2c device not registred.
> 
> The module kbd-i2c-ir loaded after i2c_new_device.

Jean,

There was also a problem reported with the cx23885 driver's I2C
connected IR by Timothy Lenz:

http://www.spinics.net/lists/linux-media/msg15122.html

The failure mode sounds similar to Dmitri's, but maybe they are
unrelated.

I worked a bit with Timothy on IRC and the remote device fails to be
detected whether ir-kbd-i2c is loaded before the cx23885 driver or after
the cx23885 driver.  I haven't found time to do any folow-up and I don't
have any of the hardware in question.

Do you have any thoughts or a suggested troubleshooting approach?

Regards,
Andy

> I try to found what happens.
> 
> With my best regards, Dmitry.


