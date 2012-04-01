Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:58709 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752266Ab2DASLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 14:11:37 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: [PATCH][GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 i2c read fix
Date: Sun, 1 Apr 2012 20:11:29 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <201204011915.47265.hfvogt@gmx.net> <4F788F49.202@iki.fi>
In-Reply-To: <4F788F49.202@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204012011.29830.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

attached is the i2c read fix (necessary e.g. for mxl5007t tuner, because it 
sends a 2 bytes for a read request, thus msg[0].len != msg[1].len).
 
Am Sonntag, 1. April 2012 schrieb Antti Palosaari:
> On 01.04.2012 20:15, Hans-Frieder Vogt wrote:
> > Support of AVerMedia AVerTV HD Volar, with tuner MxL5007t (needs the i2c
> > read bug fixed patch send earlier).
> 
> Could you sent separate patch for I2C read fix?
> 
> The only functional comment I has is about ADC frequency. There is
> Xtal/ADC lookup table already in af9033_priv.h. You could use it instead
> of adding new configuration parameter. Demodulator driver generally
> needs only Xtal frequency as a parameter, other can be usually
> discovered by driver.
> 
> But if you would not like to fix it, I will apply that as it is. It is
> not so important issue after all.
> 
> regards
> Antti

Enable i2c read requests.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb/dvb-usb/af9035.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -Nupr a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-
usb/af9035.c
--- a/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 16:41:53.694103691 +0200
+++ b/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 18:22:25.026930784 +0200
@@ -209,24 +209,15 @@ static int af9035_i2c_master_xfer(struct
 					msg[1].len);
 		} else {
 			/* I2C */
-#if 0
-			/*
-			 * FIXME: Keep that code. It should work but as it is
-			 * not tested I left it disabled and return -EOPNOTSUPP
-			 * for the sure.
-			 */
 			u8 buf[4 + msg[0].len];
 			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
 					buf, msg[1].len, msg[1].buf };
-			buf[0] = msg[0].len;
+			buf[0] = msg[1].len;
 			buf[1] = msg[0].addr << 1;
 			buf[2] = 0x01;
 			buf[3] = 0x00;
 			memcpy(&buf[4], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d->udev, &req);
-#endif
-			pr_debug("%s: I2C operation not supported\n", __func__);
-			ret = -EOPNOTSUPP;
 		}
 	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
 		if (msg[0].len > 40) {


Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
