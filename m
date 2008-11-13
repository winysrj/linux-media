Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oldium.pro@seznam.cz>) id 1L0kIm-0004hi-Mx
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 23:04:40 +0100
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 13 Nov 2008 23:03:00 +0100
References: <200811132125.07574.oldium.pro@seznam.cz>
In-Reply-To: <200811132125.07574.oldium.pro@seznam.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UQKHJK0FvvCV0Va"
Message-Id: <200811132303.00457.oldium.pro@seznam.cz>
Subject: Re: [linux-dvb] [PATCH] Fixed typo in sizeof() causing NULL pointer
	OOPS
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_UQKHJK0FvvCV0Va
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, once more to have correct encoding (utf-8).

Regards,
Oldrich.

--Boundary-00=_UQKHJK0FvvCV0Va
Content-Type: text/x-diff;
  charset="utf-8";
  name="saa7134-sizeof-typo.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="saa7134-sizeof-typo.patch"

commit 0d996babd6046b54d5a9194ea94ec7971adb0d17
Author: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@seznam.cz>
Date:   Thu Nov 13 20:50:31 2008 +0100

    Fixed typo in sizeof() causing NULL pointer OOPS
   =20
    Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@seznam.cz>

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/vi=
deo/saa7134/saa7134-cards.c
index ddc5402..8635228 100644
=2D-- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -6048,7 +6048,7 @@ static void saa7134_tuner_setup(struct saa7134_dev *d=
ev)
 		struct v4l2_priv_tun_config  xc2028_cfg;
 		struct xc2028_ctrl           ctl;
=20
=2D		memset(&xc2028_cfg, 0, sizeof(ctl));
+		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
 		memset(&ctl, 0, sizeof(ctl));
=20
 		ctl.fname   =3D XC2028_DEFAULT_FIRMWARE;

--Boundary-00=_UQKHJK0FvvCV0Va
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_UQKHJK0FvvCV0Va--
