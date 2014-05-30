Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:47268 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbaE3VQy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 17:16:54 -0400
From: "Daniel Mayer" <danielmayer@arcor.de>
To: <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
References: 
In-Reply-To: 
Subject: WG: Patch pctv452e.c: Suppress annoying dmesg-SPAM
Date: Fri, 30 May 2014 23:16:52 +0200
Message-ID: <029901cf7c4c$7a4d78d0$6ee86a70$@arcor.de>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_029A_01CF7C5D.3DD6BE00"
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_029A_01CF7C5D.3DD6BE00
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,
attached micro-patch removes the text output of an error-message of the
PCTV452e-driver. The error messages "I2C error: [.]" do not help any user of
the kernel, so whatever causes the error, it does not hamper the function of
my TT-3600 USB receiver.
So: Just remove the entries in the dmesg, for it is quite spam-like. 
Perhaps someone with deeper knowledge could have a look up the background of
this message and fix it?
Thanks,
Daniel

(resent as plain-text; sorry)

------=_NextPart_000_029A_01CF7C5D.3DD6BE00
Content-Type: application/octet-stream;
	name="pctv452e.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="pctv452e.patch"

--- pctv452e.c.orig	2014-05-30 22:16:28.638949289 +0200=0A=
+++ pctv452e.c	2014-05-30 22:16:43.165359598 +0200=0A=
@@ -446,11 +446,11 @@ static int pctv452e_i2c_msg(struct dvb_u=0A=
 	return rcv_len;=0A=
 =0A=
 failed:=0A=
-	err("I2C error %d; %02X %02X  %02X %02X %02X -> "=0A=
+/*	err("I2C error %d; %02X %02X  %02X %02X %02X -> "=0A=
 	     "%02X %02X  %02X %02X %02X.",=0A=
 	     ret, SYNC_BYTE_OUT, id, addr << 1, snd_len, rcv_len,=0A=
 	     buf[0], buf[1], buf[4], buf[5], buf[6]);=0A=
-=0A=
+*/=0A=
 	return ret;=0A=
 }=0A=
 =0A=

------=_NextPart_000_029A_01CF7C5D.3DD6BE00--

