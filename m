Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2JGNDG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Oct 2012 09:03:06 -0400
Date: Sun, 7 Oct 2012 10:03:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Wolfgang Bail <wolfgang.bail@t-online.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] rc-msi-digivox-ii: Add full scan keycodes - Was: Re: v4l
Message-ID: <20121007100301.3870ef32@redhat.com>
In-Reply-To: <201209300549.26996.wolfgang.bail@t-online.de>
References: <201209300549.26996.wolfgang.bail@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Sep 2012 05:49:26 +0200
Wolfgang Bail <wolfgang.bail@t-online.de> escreveu:

> Hello,
> 
> the ir-rc from my msi DigiVox mini II Version 3 (af9015) will not work since 
> kernel 3.2.x (kubuntu 12.04), same with s2-liplianin or v4l.
> 
> sudo ir-keytable -t shows:
> 
> Testing events. Please, press CTRL-C to abort.
> 1348890734.303273: event MSC: scancode = 317
> 1348890734.303280: event key down: KEY_POWER (0x0074)
> 1348890734.303282: event sync
> 1348890734.553961: event key up: KEY_POWER (0x0074)
> 1348890734.553963: event sync
> 1348890741.303451: event MSC: scancode = 30d
> 1348890741.303457: event key down: KEY_DOWN (0x006c)
> 1348890741.303459: event sync
> ^[[B1348890741.553956: event key up: KEY_DOWN (0x006c)
> 
> So I changed in rc-msi-digivox-ii.c { 0x0002, KEY_2 }, to { 0x0302, KEY_2 }, 
> and so on. And now it works well.
> 
> I hope, my mini patch is standard, the first I made. 

Well, you should have using a subject like:

[PATCH] rc-msi-digivox-ii: Add full scan keycodes

And your signed-off-by. There are some pages at linuxtv.org wiki that points
how to write a patch.

Yet, as this is a really trivial one, I'll accept it without your Signed-off-by.

> I don't know, whether 
> there are different variants of remote controls. But I don't believe it, 
> because it was ok with kernel 2.6.x.

No, this seems just yet-another-regression caused by some patch that changed 
the code that gets IR scancode to report the 16-bit keycode, instead of
just the last 8 bits.

Thanks for it.

> 
> @Mauro, thank you for the reply.
> 

Regards,
Mauro

-

FYI, this is how I applied it.


From: Wolfgang Bail <wolfgang.bail@t-online.de>
Date: Sat, 29 Sep 2012 23:49:26 -0300
Subject: [PATCH] [media] rc-msi-digivox-ii: Add full scan keycodes

The ir-rc from my MSI DigiVox mini II Version 3 (af9015) will not work since
kernel 3.2.x.

sudo ir-keytable -t shows:

	1348890734.303273: event MSC: scancode = 317
	1348890734.303280: event key down: KEY_POWER (0x0074)
	1348890734.303282: event sync
	1348890734.553961: event key up: KEY_POWER (0x0074)
	1348890734.553963: event sync
	1348890741.303451: event MSC: scancode = 30d
	1348890741.303457: event key down: KEY_DOWN (0x006c)
	1348890741.303459: event sync
	1348890741.553956: event key up: KEY_DOWN (0x006c)

So I changed in rc-msi-digivox-ii.c { 0x0002, KEY_2 }, to { 0x0302, KEY_2 },
and so on. And now it works well.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index c64e9e3..2fa71d0 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -22,24 +22,24 @@
 #include <linux/module.h>
 
 static struct rc_map_table msi_digivox_ii[] = {
-	{ 0x0002, KEY_2 },
-	{ 0x0003, KEY_UP },              /* up */
-	{ 0x0004, KEY_3 },
-	{ 0x0005, KEY_CHANNELDOWN },
-	{ 0x0008, KEY_5 },
-	{ 0x0009, KEY_0 },
-	{ 0x000b, KEY_8 },
-	{ 0x000d, KEY_DOWN },            /* down */
-	{ 0x0010, KEY_9 },
-	{ 0x0011, KEY_7 },
-	{ 0x0014, KEY_VOLUMEUP },
-	{ 0x0015, KEY_CHANNELUP },
-	{ 0x0016, KEY_OK },
-	{ 0x0017, KEY_POWER2 },
-	{ 0x001a, KEY_1 },
-	{ 0x001c, KEY_4 },
-	{ 0x001d, KEY_6 },
-	{ 0x001f, KEY_VOLUMEDOWN },
+	{ 0x0302, KEY_2 },
+	{ 0x0303, KEY_UP },              /* up */
+	{ 0x0304, KEY_3 },
+	{ 0x0305, KEY_CHANNELDOWN },
+	{ 0x0308, KEY_5 },
+	{ 0x0309, KEY_0 },
+	{ 0x030b, KEY_8 },
+	{ 0x030d, KEY_DOWN },            /* down */
+	{ 0x0310, KEY_9 },
+	{ 0x0311, KEY_7 },
+	{ 0x0314, KEY_VOLUMEUP },
+	{ 0x0315, KEY_CHANNELUP },
+	{ 0x0316, KEY_OK },
+	{ 0x0317, KEY_POWER2 },
+	{ 0x031a, KEY_1 },
+	{ 0x031c, KEY_4 },
+	{ 0x031d, KEY_6 },
+	{ 0x031f, KEY_VOLUMEDOWN },
 };
 
 static struct rc_map_list msi_digivox_ii_map = {

