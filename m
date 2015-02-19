Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:60953 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbbBSLyD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 06:54:03 -0500
Message-ID: <54E5CED2.3010701@southpole.se>
Date: Thu, 19 Feb 2015 12:53:54 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] mn88472: reduce firmware download chunk size
References: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>	<54E5B028.5080900@southpole.se> <CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
In-Reply-To: <CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010904060907070700030906"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010904060907070700030906
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2015-02-19 11:21, Antti Seppälä wrote:
> On 19 February 2015 at 11:43, Benjamin Larsson <benjamin@southpole.se> wrote:
>> On 2015-02-19 10:13, Antti Seppälä wrote:
>>>
>>> It seems that currently the firmware download on the mn88472 is
>>> somehow wrong for my Astrometa HD-901T2.
>>>
>>> Reducing the download chunk size (mn88472_config.i2c_wr_max) to 2
>>> makes the firmware download consistently succeed.
>>>
>>
>>
>> Hi, try adding the workaround patch I sent for this.
>>
>> [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
>>
>> I now see that it hasn't been merged. But I have been running with this
>> patch for a few months now without any major issues.
>>
>
> The patch really did improve firmware loading. Weird...
>
> Even with it I still get occasional i2c errors from r820t:
>
> [   15.874402] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=0a len=1: da
> [   81.455517] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
> len=4: 69 74 e6 df
> [   99.949702] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
> len=4: 69 74 e6 df
>
> These errors seem to appear more often if I'm reading the signal
> strength values using e.g. femon.
>
> Br,
> -Antti
>

This patch implements a retry logic. If a transfer fails it will convert 
it to 1 byte transfers. This will not work when loading the nm88472 
firmware as everything is loaded through the 0xf6 register.

I think we might need something like this to get the Astrometa working 
reliably.

Based on usb logs from the windows driver one can see that they only 
send 1 byte at a time so they can retry all transfers. So this issue 
seems to be related to the rtl2832p bridge chip and how much i2c traffic 
is generated.

MvH
Benjamin Larsson

--------------010904060907070700030906
Content-Type: text/x-patch;
 name="0001-rtl28xxu-implement-i2c-transfer-retry-logic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-rtl28xxu-implement-i2c-transfer-retry-logic.patch"

>From 5962cf8fafdfe98138fd69beb4d0b5d2a7af5732 Mon Sep 17 00:00:00 2001
From: Benjamin Larsson <benjamin@southpole.se>
Date: Thu, 20 Nov 2014 00:50:02 +0100
Subject: [PATCH] rtl28xxu: implement i2c transfer retry logic
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>

This is needed for Astrometa hardware. Retry counts up to 6 has been
observered before the i2c transfer succeded.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 4af8a61..4d321ae 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -185,6 +185,8 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct rtl28xxu_priv *priv = d->priv;
 	struct rtl28xxu_req req;
+	u8 rb_buf[2];
+	int i, retry_cnt;
 
 	/*
 	 * It is not known which are real I2C bus xfer limits, but testing
@@ -273,6 +275,33 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			req.size = msg[0].len-1;
 			req.data = &msg[0].buf[1];
 			ret = rtl28xxu_ctrl_msg(d, &req);
+
+			/* Astrometa hardware needs a retry for some failed transfers.
+			 * Just send one byte at the time.
+			 * Retry max 10 times for each transfer.
+			 */
+			if (ret) {
+				req.size = 1;
+				req.data = rb_buf;
+
+				dev_dbg(&d->udev->dev, "%s: transfer of %d bytes failed\n", __func__, msg[0].len-1);
+				rb_buf[0] = msg[0].buf[0];
+
+				for (i=0 ; i<msg[0].len-1 ; i++) {
+					retry_cnt = 0;
+					req.value = ((msg[0].buf[0]+i) << 8) | (msg[0].addr << 1);
+					rb_buf[0] = msg[0].buf[i+1];
+
+					do {
+						dev_dbg(&d->udev->dev, "%s: byte: %d retry: %d\n", __func__, i, retry_cnt);
+						ret = rtl28xxu_ctrl_msg(d, &req);
+						retry_cnt++;
+						if (retry_cnt > 10)
+							goto err_mutex_unlock;
+
+					} while (ret);
+				}
+			}
 		} else {
 			/* method 3 - new I2C */
 			req.value = (msg[0].addr << 1);
-- 
1.9.1


--------------010904060907070700030906--
