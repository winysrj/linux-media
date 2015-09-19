Return-path: <linux-media-owner@vger.kernel.org>
Received: from kronos.mailus.de ([217.172.179.146]:44833 "EHLO
	kronos.mailus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbbISRaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2015 13:30:35 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by kronos.mailus.de (Postfix) with ESMTP id 279B22C1F1
	for <linux-media@vger.kernel.org>; Sat, 19 Sep 2015 19:30:33 +0200 (CEST)
Received: from kronos.mailus.de ([127.0.0.1])
	by localhost (kronos.mailus.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id uWyvNVhjs7ut for <linux-media@vger.kernel.org>;
	Sat, 19 Sep 2015 19:30:32 +0200 (CEST)
Received: from [192.168.36.2] (x55b1605f.dyn.telefonica.de [85.177.96.95])
	by kronos.mailus.de (Postfix) with ESMTPSA id E71082C140
	for <linux-media@vger.kernel.org>; Sat, 19 Sep 2015 19:30:31 +0200 (CEST)
Message-ID: <55FD9BB6.9050401@vontaene.de>
Date: Sat, 19 Sep 2015 19:30:30 +0200
From: Erik Andresen <erik@vontaene.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Add Terratec H7 Revision 4 to DVBSky driver
References: <55F2ED67.3030306@vontaene.de>
In-Reply-To: <55F2ED67.3030306@vontaene.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SlgAJ2Je5eFGAejqID98MfmW3oPtbnFss"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SlgAJ2Je5eFGAejqID98MfmW3oPtbnFss
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Adds Terratec H7 Rev. 4 with USB id 0ccd:10a5 to DVBSky driver.

Signed-off-by: Erik Andresen <erik@vontaene.de>
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-cor=
e/dvb-usb-ids.h
index c117fb3..0a46580 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -257,6 +257,7 @@
 #define USB_PID_TERRATEC_CINERGY_T_XXS_2		0x00ab
 #define USB_PID_TERRATEC_H7				0x10b4
 #define USB_PID_TERRATEC_H7_2				0x10a3
+#define USB_PID_TERRATEC_H7_3				0x10a5
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_NOXON_DAB_STICK				0x00b3
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dv=
b-usb-v2/dvbsky.c
index cdf59bc..8f526a4 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -841,6 +841,10 @@ static const struct usb_device_id dvbsky_id_table[] =
=3D {
 		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI,
 		&dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI",
 		RC_MAP_TT_1500) },
+        { DVB_USB_DEVICE(USB_VID_TERRATEC,
+                USB_PID_TERRATEC_H7_3,
+                &dvbsky_t680c_props, "Terratec H7 Rev.4",
+                RC_MAP_TT_1500) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
--=20
2.5.0




--SlgAJ2Je5eFGAejqID98MfmW3oPtbnFss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlX9m7YACgkQ8NqlQQxmej7JtQCfZsSFLV0dpBd8IWiUOx61sVnn
pg4AoLZpYg0y64o51rET70Z2QMddF8At
=e78a
-----END PGP SIGNATURE-----

--SlgAJ2Je5eFGAejqID98MfmW3oPtbnFss--
