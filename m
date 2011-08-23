Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47157 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWVnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 17:43:43 -0400
Received: by wwf5 with SMTP id 5so556648wwf.1
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2011 14:43:42 -0700 (PDT)
Subject: [PATCH] Re: Afatech AF9013 [TEST ONLY] AF9015 stream buffer size
 aligned with max packet size.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <CAATJ+ftemL4NYTQLxLw4vmXpD+nFfxrUVjmapUt9EzYJNqH6FQ@mail.gmail.com>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
	 <CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
	 <1313949634.2874.13.camel@localhost>
	 <CAATJ+fv6x6p5kimJs4unWGQ_PU36hp29Rafu8BDCcRAABtAfgQ@mail.gmail.com>
	 <CAL9G6WUFddsFM2V46xXCDWEfhfCR0n5G-8S4JSYwLLkmZnYu7g@mail.gmail.com>
	 <CAATJ+fsUWPjh5aq38triZOu0-DmU=nCbd77qUzxUn5kiDiaR+w@mail.gmail.com>
	 <CAATJ+ftemL4NYTQLxLw4vmXpD+nFfxrUVjmapUt9EzYJNqH6FQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 22:43:36 +0100
Message-ID: <1314135816.2140.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-08-23 at 11:47 +1000, Jason Hecker wrote:
> Damn, this patch didn't help so maybe forget this patch.  Tuner A is
> still messed up.
Try this patch, applied to the latest media_build. it aligns buffer size to the max packet
size instead of TS packet size.

I think what might happening is that TS packets are getting chopped, as device seems to want
to align to max packet size.

Afatech seem to want create rather large buffers at considerable delay. The size of the buffer
has also been considerably reduced. If you want to increase it change TS_USB20_PACKET_COUNT
in multiplies of 2 (56 ... 112).

---
 drivers/media/dvb/dvb-usb/af9015.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index d7ad05f..eaf0800 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -404,21 +404,22 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 	   We use smaller - about 1/4 from the original, 5 and 87. */
 #define TS_PACKET_SIZE            188
 
-#define TS_USB20_PACKET_COUNT      87
-#define TS_USB20_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB20_PACKET_COUNT)
-
 #define TS_USB11_PACKET_COUNT       5
 #define TS_USB11_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB11_PACKET_COUNT)
 
-#define TS_USB20_MAX_PACKET_SIZE  512
+#define TS_USB20_MAX_PACKET_SIZE  128
 #define TS_USB11_MAX_PACKET_SIZE   64
 
+#define TS_USB20_PACKET_COUNT      28
+#define TS_USB20_FRAME_SIZE       (TS_USB20_MAX_PACKET_SIZE\
+					*TS_USB20_PACKET_COUNT)
+
 	if (d->udev->speed == USB_SPEED_FULL) {
 		frame_size = TS_USB11_FRAME_SIZE/4;
 		packet_size = TS_USB11_MAX_PACKET_SIZE/4;
 	} else {
-		frame_size = TS_USB20_FRAME_SIZE/4;
-		packet_size = TS_USB20_MAX_PACKET_SIZE/4;
+		frame_size = TS_USB20_FRAME_SIZE;
+		packet_size = TS_USB20_MAX_PACKET_SIZE;
 	}
 
 	ret = af9015_set_reg_bit(d, 0xd507, 2); /* assert EP4 reset */
-- 
1.7.4.1

