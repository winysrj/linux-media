Return-path: <linux-media-owner@vger.kernel.org>
Received: from imgrunds.de ([176.28.17.15]:36179 "EHLO imgrunds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbbHaLwm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:52:42 -0400
Received: from ip-91-214-9-55.4msp.de ([91.214.9.55] helo=[192.168.188.21])
	by imgrunds.de with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <max@imgrunds.de>)
	id 1ZWN7y-0004hH-J6
	for linux-media@vger.kernel.org; Mon, 31 Aug 2015 13:19:54 +0200
Message-ID: <55E43855.3060409@imgrunds.de>
Date: Mon, 31 Aug 2015 13:19:49 +0200
From: Maximilian Imgrund <max@imgrunds.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: New Terratec Cinergy S2 Box usb-id
References: <201508311109.t7VB9utm008834@higgs.fritz.box>
In-Reply-To: <201508311109.t7VB9utm008834@higgs.fritz.box>
Content-Type: multipart/mixed;
 boundary="------------090008000206060300020309"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090008000206060300020309
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Dear all,

I am currently figuring out how to get the Terratec Cinergy S2 USB Box
up and running. I already modified a patch to  previous version (see
attachment) to include the new ID in the device driver, module is also
loading with the ds3000 firmware. However, when using w_scan, the
reported frequency range is .95GHz ... 2.15Ghz which is roughly a
factor of 10 lower than I expected (Astra is 12.515Ghz e.g.). Since
the tuner seems to tune in correctly but in the wrong frequency range,
I feel that is the reason for me not getting in any channels.

Can you help me with what to change in the driver to get this working
? I feel like an additional .frequency_div should do the job, however
I am unable to find further informaion on that...

Best
Maximilian Imgrund
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlXkOFIACgkQR/X5cR0fI/6sfAD+OVauTyLw0oWSMr8ONzmrguF+
Ci/vg4uO9mxZwzjgGXkA/ipgQ/IuX+8n2CSScHg6CFjt9tIBbFOAVzStuUrOpwx2
=AAXS
-----END PGP SIGNATURE-----

--------------090008000206060300020309
Content-Type: text/plain; charset=UTF-8;
 name="7655778-dw2102-k4.1.1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="7655778-dw2102-k4.1.1.patch"

--- a/drivers/media/usb/dvb-usb/dw2102.c=09
+++ b/drivers/media/usb/dvb-usb/dw2102.c=09
@@ -1657,6 +1657,7 @@
 	GOTVIEW_SAT_HD,
 	GENIATECH_T220,
 	TECHNOTREND_S2_4600,
+	TERRATEC_CINERGY_S2_R3,
 };
=20
 static struct usb_device_id dw2102_table[] =3D {
@@ -1682,6 +1683,7 @@
 	[GENIATECH_T220] =3D {USB_DEVICE(0x1f4d, 0xD220)},
 	[TECHNOTREND_S2_4600] =3D {USB_DEVICE(USB_VID_TECHNOTREND,
 		USB_PID_TECHNOTREND_CONNECT_S2_4600)},
+	[TERRATEC_CINERGY_S2_R3] =3D {USB_DEVICE(USB_VID_TERRATEC, 0x0105)},
 	{ }
 };
=20
@@ -2085,7 +2087,7 @@
 		}},
 		}
 	},
-	.num_device_descs =3D 5,
+	.num_device_descs =3D 6,
 	.devices =3D {
 		{ "SU3000HD DVB-S USB2.0",
 			{ &dw2102_table[GENIATECH_SU3000], NULL },
@@ -2107,6 +2109,10 @@
 			{ &dw2102_table[GOTVIEW_SAT_HD], NULL },
 			{ NULL },
 		},
+		{ "Terratec Cinergy S2 USB HD Rev.3",
+			{ &dw2102_table[TERRATEC_CINERGY_S2_R3], NULL },
+			{ NULL },
+		},
 	}
 };
=20


--------------090008000206060300020309--
