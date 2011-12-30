Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1L3RRj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 12:17:39 -0500
Message-ID: <4EFDF229.8090103@redhat.com>
Date: Fri, 30 Dec 2011 15:17:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dorozel Csaba <mrjuuzer@upcmail.hu>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c / rc-hauppauge / linux-3.x broken
References: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net>
In-Reply-To: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-12-2011 10:06, Dorozel Csaba wrote:
> Hi!
> 
> After kernel upgrade from 2.6.38 to any of the 3.x.x series my remote is partly broken (Hauppauge
> WinTV-HVR1110 DVB-T/Hybrid with gray remote (A415-HPG-WE-A)).

(c/c linux-media ML)

> user juuzer # ir-keytable 
> Found /sys/class/rc/rc0/ (/dev/input/event6) with:
>         Driver ir-kbd-i2c, table rc-hauppauge
>         Supported protocols: RC-5 
>         Enabled protocols: RC-5 
>         Repeat delay = 500 ms, repeat period = 125 ms
> user juuzer # ir-keytable -t
> Testing events. Please, press CTRL-C to abort.
> 1325171356.344341: event MSC: scancode = 3b
> 1325171356.344343: event sync
> 1325171356.447358: event MSC: scancode = 3b
> 1325171356.447359: event sync
> 1325171357.786360: event MSC: scancode = 3d
> 1325171357.786362: event sync
> 1325171357.889359: event MSC: scancode = 3d
> 1325171357.889360: event sync
> 1325171363.039366: event MSC: scancode = 01
> 1325171363.039369: event key down: KEY_1 (0x0002)
> 1325171363.039370: event sync
> 11325171363.289389: event key up: KEY_1 (0x0002)
> 1325171363.289390: event sync
> 1325171364.584360: event MSC: scancode = 02
> 1325171364.584364: event key down: KEY_2 (0x0003)
> 1325171364.584365: event sync
> 21325171364.687351: event MSC: scancode = 02
> 1325171364.687353: event sync
> 1325171364.937382: event key up: KEY_2 (0x0003)
> 1325171364.937383: event sync
> 
> So i made some changes in rc-hauppauge.c file. Add/rename/replace some keycodes started with 0x00
> address which keep the compatibility with old black remote and work with my gray one.
> 
> ser juuzer # ir-keytable   
> Found /sys/class/rc/rc0/ (/dev/input/event6) with:
>         Driver ir-kbd-i2c, table rc-hauppauge
>         Supported protocols: RC-5 
>         Enabled protocols: RC-5 
>         Repeat delay = 500 ms, repeat period = 125 ms
> user juuzer # ir-keytable -t
> Testing events. Please, press CTRL-C to abort.
> 1325171718.396566: event MSC: scancode = 3b
> 1325171718.396569: event key down: KEY_SELECT (0x0161)
> 1325171718.396570: event sync
> 1325171718.499571: event MSC: scancode = 3b
> 1325171718.499572: event sync
> 1325171718.749585: event key up: KEY_SELECT (0x0161)
> 1325171718.749586: event sync
> 1325171721.180564: event MSC: scancode = 3d
> 1325171721.180567: event key down: KEY_POWER2 (0x0164)
> 1325171721.180568: event sync
> 1325171721.283562: event MSC: scancode = 3d
> 1325171721.283563: event sync
> 1325171721.533585: event key up: KEY_POWER2 (0x0164)
> 1325171721.533586: event sync
> 1325171731.070564: event MSC: scancode = 01
> 1325171731.070567: event key down: KEY_1 (0x0002)
> 1325171731.070569: event sync
> 11325171731.173562: event MSC: scancode = 01
> 1325171731.173563: event sync
> 1325171731.423587: event key up: KEY_1 (0x0002)
> 1325171731.423588: event sync
> 1325171732.203561: event MSC: scancode = 02
> 1325171732.203565: event key down: KEY_2 (0x0003)
> 1325171732.203566: event sync
> 21325171732.306567: event MSC: scancode = 02
> 1325171732.306569: event sync
> 1325171732.556586: event key up: KEY_2 (0x0003)
> 1325171732.556587: event sync
> 
> Some of  the keycodes have different function on black and gray:
> 
> 0x001f  KEY_TV on black - KEY_EXIT on gray
> 0x002e  KEY_ZOOM on black - KEY_GREEN on gray
> 0x000d  KEY_MUTE on black – KEY_MENU on gray
> 0x001e  KEY_RED on black – KEY_NEXTSONG on gray

Sorry, but your fix is at the wrong place ;) The bug is not inside
the ir-hauppage.c table.

Basically, the bridge driver is not sending the complete RC-5
keycode to the IR core, but just the 8 least siginificant bits.
So, it is loosing the 0x1e00 code for the Hauppauge grey remote.

The fix should be at saa7134-input. It should be something like
the enclosed patch (I'm just guessing there that code3 contains
the MSB bits - you may need to adjust it to match the IR decoder
there):

saa7134-input: Fix get_key_hvr1110() handling

Instead of returning just 8 bits, return the full RC-5 code

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index d4ee24b..29c8efd 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -249,8 +249,8 @@ static int get_key_hvr1110(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		return 0;
 
 	/* return key */
-	*ir_key = code4;
-	*ir_raw = code4;
+	*ir_key = code4 | code3 << 8;
+	*ir_raw = *ir_key;
 	return 1;
 }
 
