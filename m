Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f207.google.com ([209.85.218.207])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <coyoteuser@gmail.com>) id 1Md8lt-0006x6-6O
	for linux-dvb@linuxtv.org; Mon, 17 Aug 2009 22:25:41 +0200
Received: by bwz3 with SMTP id 3so2421422bwz.26
	for <linux-dvb@linuxtv.org>; Mon, 17 Aug 2009 13:25:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 17 Aug 2009 15:25:03 -0500
Message-ID: <bc18792f0908171325s391d9e36nb0ce20f40017678@mail.gmail.com>
From: Malcolm Lewis <coyoteuser@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] au0828: experimental support for Syntek Teledongle
	[05e1:0400]
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi
I've been using the patches from
http://linuxtv.org/hg/~mkrufky/teledongle/rev/676e2f4475ed
on a Sabrent device in openSuSE and SLED, during testing with the
milestone 5 release of
11.2 and kernel version 2.6.31-rc5-git3-2-desktop there needs to be
some changes to the
au0828-cards.c patch to enable building a kmp module;

--- au0828-cards.c=A0=A0=A0 2009-08-12 18:16:39.435886920 -0500
+++ au0828-cards.c.orig=A0=A0=A0 2009-08-12 18:28:22.176126368 -0500
@@ -116,6 +116,12 @@
=A0=A0=A0=A0 =A0=A0=A0 .tuner_addr =3D ADDR_UNSET,
=A0=A0=A0=A0 =A0=A0=A0 .i2c_clk_divider =3D AU0828_I2C_CLK_250KHZ,
=A0=A0=A0=A0 },
+=A0=A0=A0 [AU0828_BOARD_SYNTEK_TELEDONGLE] =3D {
+=A0=A0=A0 =A0=A0=A0 .name =3D "Syntek Teledongle [EXPERIMENTAL]",
+=A0=A0=A0 =A0=A0=A0=A0 .tuner_type =3D UNSET,
+=A0=A0=A0 =A0=A0=A0 .tuner_addr =3D ADDR_UNSET,
+=A0=A0=A0 =A0=A0=A0 .i2c_clk_divider =3D AU0828_I2C_CLK_250KHZ,
+=A0=A0=A0 },
=A0};

=A0/* Tuner callback function for au0828 boards. Currently only needed
@@ -248,6 +254,7 @@
=A0=A0=A0=A0 case AU0828_BOARD_HAUPPAUGE_HVR950Q:
=A0=A0=A0=A0 case AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL:
=A0=A0=A0=A0 case AU0828_BOARD_HAUPPAUGE_WOODBURY:
+=A0=A0=A0 case AU0828_BOARD_SYNTEK_TELEDONGLE: /* FIXME */
=A0=A0=A0=A0 =A0=A0=A0 /* GPIO's
=A0=A0=A0=A0 =A0=A0=A0 =A0* 4 - CS5340
=A0=A0=A0=A0 =A0=A0=A0 =A0* 5 - AU8522 Demodulator
@@ -325,6 +332,8 @@
=A0=A0=A0=A0 =A0=A0=A0 .driver_info =3D AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL =
},
=A0=A0=A0=A0 { USB_DEVICE(0x2040, 0x8200),
=A0=A0=A0=A0 =A0=A0=A0 .driver_info =3D AU0828_BOARD_HAUPPAUGE_WOODBURY },
+=A0=A0=A0 { USB_DEVICE(0x05e1, 0x0400),
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .driver_info =3D AU0828_BOAR=
D_SYNTEK_TELEDONGLE },
=A0=A0=A0=A0 { },
=A0};


There are two versions I'm building and src for both can be found here;
http://download.opensuse.org/repositories/home:/malcolmlewis/

--
Cheers
Malcolm

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
