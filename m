Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:43832 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372Ab1FAKxM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 06:53:12 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter() from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>
Date: Wed, 01 Jun 2011 12:53:06 +0200
In-Reply-To: <4DE60B36.9040507@iki.fi> (Antti Palosaari's message of "Wed, 01
	Jun 2011 12:49:42 +0300")
Message-ID: <87mxi1n7ql.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Another possible solution...  This is my last one, I promise :-)

I looked at dvb_attach() and realized that you can ab^H^Hreuse it.  This
makes the patch tiny, and allow you to continue hiding=20
struct cxd2820r_priv.


Bj=C3=B8rn



--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
 filename=0001-em28xx-dvb-Use-dvb_attach-to-call-cxd2820r_get_tuner.patch
Content-Transfer-Encoding: quoted-printable

>From b570bbad12c1d164ed92c6711a1775db29c4c0a7 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Bj=3DC3=3DB8rn=3D20Mork?=3D <bjorn@mork.no>
Date: Wed, 1 Jun 2011 12:48:25 +0200
Subject: [PATCH] em28xx-dvb: Use dvb_attach to call cxd2820r_get_tuner_i2c_=
adapter()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

This avoids a hard module dependency on cxd2820r.  Even though we
don't really attach anything in this call, we can stil reuse
dvb_attach since the called function is expected to return a
pointer.

Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 drivers/media/video/em28xx/em28xx-dvb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/=
em28xx/em28xx-dvb.c
index 7904ca4..d994592 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -669,7 +669,8 @@ static int dvb_init(struct em28xx *dev)
 			&em28xx_cxd2820r_config, &dev->i2c_adap, NULL);
 		if (dvb->fe[0]) {
 			struct i2c_adapter *i2c_tuner;
-			i2c_tuner =3D cxd2820r_get_tuner_i2c_adapter(dvb->fe[0]);
+			/* we don't really attach i2c_tuner.  Just reusing the symbol logic */
+			i2c_tuner =3D dvb_attach(cxd2820r_get_tuner_i2c_adapter, dvb->fe[0]);
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
 				i2c_tuner, &em28xx_cxd2820r_tda18271_config)) {
--=20
1.7.2.5


--=-=-=--
