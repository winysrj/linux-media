Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50317 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2KHVa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 16:30:29 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1827162eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 13:30:28 -0800 (PST)
Message-ID: <1352410221.17913.23.camel@Route3278>
Subject: [PATCH] it913x: [BUG] fix correct endpoint size when pid filter on.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Antti Palosaari <crope@iki.fi>
Date: Thu, 08 Nov 2012 21:30:21 +0000
In-Reply-To: <509C138F.1000402@iki.fi>
References: <509AF219.6030907@iki.fi> <1352396904.3036.0.camel@Route3278>
	 <509C138F.1000402@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-11-08 at 22:18 +0200, Antti Palosaari wrote:
> On 11/08/2012 07:48 PM, Malcolm Priestley wrote:
> >
> > On 07/11/12 23:43, Antti Palosaari wrote:
> >> Malcolm,
> >> Have you newer tested it with USB1.1 port? Stream is totally broken.
> >>
> > Hi Antti
> >
> > Hmm, yes it is a bit choppy on dvb-usb-v2.
> >
> > I will have a look at it.
> 
> Fedora's stock 3.6.5-1.fc17.x86_64 is even more worse - no picture at 
> all when using vlc. Clearly visible difference is pid filter count. 
> dvb-usb says 5 filters whilst dvb-usb-v2 says 32 pid filters.
> 
> dvb_usb_v2: will use the device's hardware PID filter (table count: 32)
> dvb-usb: will use the device's hardware PID filter (table count: 5).
> 
> 
I kept the count as the hardware default with dvb-usb-v2, with 5, users
can still run in to trouble with Video PIDs.

I have traced it to an incorrect endpoint size when the PID filter
is enabled. It also affected USB 2.0 with the filter on.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/it913x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 695f910..29300e3 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -643,7 +643,8 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 	struct it913x_state *st = d->priv;
 	int ret = 0;
 	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
-	u16 ep_size = adap->stream.buf_size / 4;
+	u16 ep_size = (adap->pid_filtering) ? TS_BUFFER_SIZE_PID / 4 :
+		TS_BUFFER_SIZE_MAX / 4;
 	u8 pkt_size = 0x80;
 
 	if (d->udev->speed != USB_SPEED_HIGH)
-- 
1.7.10.4



