Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:38788 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751266Ab2DAQYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 12:24:20 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T Stick [0ccd:0093]
Date: Sun, 1 Apr 2012 18:24:09 +0200
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <201204011642.35087.hfvogt@gmx.net> <20120401165601.17a76a03@milhouse>
In-Reply-To: <20120401165601.17a76a03@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204011824.09876.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sonntag, 1. April 2012 schrieb Michael Büsch:
> On Sun, 1 Apr 2012 16:42:34 +0200
> 
> "Hans-Frieder Vogt" <hfvogt@gmx.net> wrote:
> > > [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)
> > > 
> > > It doesn't run into this check on the other af903x driver.
> > > So I suspect an i2c read issue here.
> > 
> > I would first uncomment the i2c read functionality in Antti's driver!
> 
> I did this.

sorry. I didn't check your patches. However, I found the problem: the buffer 
length needs to be msg[1].len, see below. For my mxl5007t based device it 
worked.

 --- old/af9035.c 2012-04-01 16:41:53.694103691 +0200
+++ new/af9035.c    2012-04-01 18:22:25.026930784 +0200
@@ -209,24 +209,15 @@
                                        msg[1].len);
                } else {
                        /* I2C */
-#if 0
-                       /*
-                        * FIXME: Keep that code. It should work but as it is
-                        * not tested I left it disabled and return -
EOPNOTSUPP
-                        * for the sure.
-                        */
                        u8 buf[4 + msg[0].len];
                        struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
                                        buf, msg[1].len, msg[1].buf };
-                       buf[0] = msg[0].len;
+                       buf[0] = msg[1].len;
                        buf[1] = msg[0].addr << 1;
                        buf[2] = 0x01;
                        buf[3] = 0x00;
                        memcpy(&buf[4], msg[0].buf, msg[0].len);
                        ret = af9035_ctrl_msg(d->udev, &req);
-#endif
-                       pr_debug("%s: I2C operation not supported\n", 
__func__);
-                       ret = -EOPNOTSUPP;
                }
        } else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
                if (msg[0].len > 40) {


> > > Attached: The patches.
> 
> See the patches.

cheers,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
