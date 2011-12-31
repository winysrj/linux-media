Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab1LaMP6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:15:58 -0500
Message-ID: <4EFEFCF7.5020106@redhat.com>
Date: Sat, 31 Dec 2011 10:15:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dorozel Csaba <mrjuuzer@upcmail.hu>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c / rc-hauppauge / linux-3.x broken
References: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net> <4EFDF229.8090103@redhat.com> <20111231101532.GHMQ11861.viefep20-int.chello.at@edge04.upcmail.net> <4EFEECF4.3010709@redhat.com> <20111231114717.TBV1347.viefep15-int.chello.at@edge04.upcmail.net>
In-Reply-To: <20111231114717.TBV1347.viefep15-int.chello.at@edge04.upcmail.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31-12-2011 09:47, Dorozel Csaba wrote:
> 
>> An RC-5 code is just 14 bits. I found some Hauppauge decoders returning
>> just 12 bits on some places. It seems that all it needs is to do a
>> code3 | 0x3f, in order to discard the two most significant bits (MSB).
>>
>> So, the enclosed patch should fix the issues. Please test.
> 
> Half way .. something still wrong.
> 
> user juuzer # ir-keytable -t -d /dev/input/event6
> Testing events. Please, press CTRL-C to abort.
> 1325331995.343188: event MSC: scancode = 3e3d
> 1325331995.343190: event sync
> 1325331995.446127: event MSC: scancode = 3e3d
> 1325331995.446129: event sync
> 1325331997.504133: event MSC: scancode = 1e3d
> 1325331997.504135: event key down: KEY_POWER2 (0x0164)
> 1325331997.504136: event sync
> 1325331997.607137: event MSC: scancode = 1e3d
> 1325331997.607138: event sync
> 1325331997.857161: event key up: KEY_POWER2 (0x0164)
> 1325331997.857163: event sync
> 1325331999.973135: event MSC: scancode = 3e3d
> 1325331999.973136: event sync
> 1325332000.075130: event MSC: scancode = 3e3d
> 1325332000.075131: event sync

Changing the mask to 0x1fff would work, but this may not be the
right fix.

the hole idea is that other RC-5 devices could also be used with
the driver, but if the sub-routine is not doing the right thing, only
this remote will work.

Could you please try this patch, instead? It is just a debug patch,
so it won't fix the issue, but it may help us to identify what's
happening there.

Btw, do you have any other remote controllers producing Philips RC-5
codes? If so, could you also test with them and see what happens?

Regards,
Mauro

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index d4ee24b..783d44c 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -241,6 +241,9 @@ static int get_key_hvr1110(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	if (5 != i2c_master_recv(ir->c, buf, 5))
 		return -EIO;
 
+	printk("0x%02x 0x%02x 0x%02x 0x%02x 0x%02x",
+		buf[0], buf[1],buf[2],buf[3],buf[4]);
+
 	cod4	= buf[4];
 	code4	= (cod4 >> 2);
 	code3	= buf[3];

