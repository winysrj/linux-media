Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep16.mx.upcmail.net ([62.179.121.36]:55962 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1LaNWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 08:22:19 -0500
Date: Sat, 31 Dec 2011 14:22:18 +0100
From: Dorozel Csaba <mrjuuzer@upcmail.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c / rc-hauppauge / linux-3.x broken
In-Reply-To: <4EFEFCF7.5020106@redhat.com>
References: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net>
	<4EFDF229.8090103@redhat.com>
	<20111231101532.GHMQ11861.viefep20-int.chello.at@edge04.upcmail.net>
	<4EFEECF4.3010709@redhat.com>
	<20111231114717.TBV1347.viefep15-int.chello.at@edge04.upcmail.net>
	<4EFEFCF7.5020106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20111231132217.DZKT1551.viefep16-int.chello.at@edge01.upcmail.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
> Changing the mask to 0x1fff would work, but this may not be the
> right fix.
> 
> the hole idea is that other RC-5 devices could also be used with
> the driver, but if the sub-routine is not doing the right thing, only
> this remote will work.
> 
> Could you please try this patch, instead? It is just a debug patch,
> so it won't fix the issue, but it may help us to identify what's
> happening there.
> 
> Btw, do you have any other remote controllers producing Philips RC-5
> codes? If so, could you also test with them and see what happens?

Haven't got any other remote controllers with Philips RC-5 codes.

With the 0x1fff mask work. If im pushig the buttons to fast or holding donw the output look like
this (don't know is it normal):

ir-keytable -t -d /dev/input/event6
Testing events. Please, press CTRL-C to abort.
1325336612.877133: event MSC: scancode = 1e3d
1325336612.877136: event key down: KEY_POWER2 (0x0164)
1325336612.877137: event sync
1325336612.980130: event MSC: scancode = 1e3d
1325336612.980132: event sync
1325336613.083136: event MSC: scancode = 1e3d
1325336613.083138: event sync
1325336613.186133: event MSC: scancode = 1e3d
1325336613.186134: event sync
1325336613.289133: event MSC: scancode = 1e3d
1325336613.289135: event sync
1325336613.378155: event key down: KEY_POWER2 (0x0164)
1325336613.378156: event sync
1325336613.503153: event key down: KEY_POWER2 (0x0164)
1325336613.503154: event sync
1325336613.539111: event key up: KEY_POWER2 (0x0164)
1325336613.539112: event sync

With the debug patch dmesg is growing this without any remote activity:
[12672.782150] 0x00 0x00 0x00 0x00 0x00
[12672.884991] 0x00 0x00 0x00 0x00 0x00
[12672.987794] 0x00 0x00 0x00 0x00 0x00
[12673.090632] 0x00 0x00 0x00 0x00 0x00
[12673.193465] 0x00 0x00 0x00 0x00 0x00
[12673.296304] 0x00 0x00 0x00 0x00 0x00
...

When pushing fast a button:
[12791.990291] 0x80 0x00 0x00 0xfe 0xf4
[12792.093123] 0x00 0x00 0x00 0x00 0x00
[12792.195971] 0x80 0x00 0x00 0xde 0xf4
[12792.298805] 0x80 0x00 0x00 0xfe 0xf4
[12792.401632] 0x00 0x00 0x00 0x00 0x00
[12792.504472] 0x80 0x00 0x00 0xde 0xf4
[12792.607305] 0x00 0x00 0x00 0x00 0x00
[12792.710145] 0x80 0x00 0x00 0xfe 0xf4
[12792.812977] 0x00 0x00 0x00 0x00 0x00
[12792.915819] 0x00 0x00 0x00 0x00 0x00
[12793.018650] 0x80 0x00 0x00 0xfe 0xf4

When hold down a button:
12892.986456] 0x80 0x00 0x00 0xde 0xf4
[12893.089296] 0x80 0x00 0x00 0xde 0xf4
[12893.192186] 0x80 0x00 0x00 0xde 0xf4
[12893.295031] 0x80 0x00 0x00 0xde 0xf4
[12893.397802] 0x80 0x00 0x00 0xde 0xf4
[12893.500639] 0x80 0x00 0x00 0xde 0xf4
[12893.603474] 0x80 0x00 0x00 0xde 0xf4
[12893.706313] 0x80 0x00 0x00 0xde 0xf4
[12893.809146] 0x00 0x00 0x00 0x00 0x00
[12893.911985] 0x00 0x00 0x00 0x00 0x00
[12894.014822] 0x00 0x00 0x00 0x00 0x00
[12894.118122] 0x80 0x00 0x00 0xde 0xf4
[12894.220492] 0x80 0x00 0x00 0xde 0xf4
[12894.325446] 0x80 0x00 0x00 0xde 0xf4
[12894.428161] 0x80 0x00 0x00 0xde 0xf4
[12894.530999] 0x80 0x00 0x00 0xde 0xf4
[12894.633836] 0x80 0x00 0x00 0xde 0xf4
[12894.736672] 0x80 0x00 0x00 0xde 0xf4
[12894.839506] 0x80 0x00 0x00 0xde 0xf4
[12894.942348] 0x00 0x00 0x00 0x00 0x00
[12895.045178] 0x00 0x00 0x00 0x00 0x00
[12895.148017] 0x00 0x00 0x00 0x00 0x00
[12895.250850] 0x00 0x00 0x00 0x00 0x00

