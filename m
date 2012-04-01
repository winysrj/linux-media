Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42918 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2DAUd5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 16:33:57 -0400
Date: Sun, 1 Apr 2012 22:33:48 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] af9035: Add USB read checksumming
Message-ID: <20120401223348.5f163b5d@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A0dY8p4HeVCSDR8r6KeRwI_"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/A0dY8p4HeVCSDR8r6KeRwI_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This adds USB message read checksumming to protect against
device and bus errors.
It also adds a read length check to avoid returning garbage from
the buffer, if the device truncated the message.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/dvb/dvb-usb/af9035.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 21:44:27.76700=
0731 +0200
+++ linux/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 22:26:46.020185359 =
+0200
@@ -37,6 +37,22 @@
 	}
 };
=20
+static u16 af9035_checksum(const u8 *buf, size_t len)
+{
+	size_t i;
+	u16 checksum =3D 0;
+
+	for (i =3D 1; i < len; i++) {
+		if (i % 2)
+			checksum +=3D buf[i] << 8;
+		else
+			checksum +=3D buf[i];
+	}
+	checksum =3D ~checksum;
+
+	return checksum;
+}
+
 static int af9035_ctrl_msg(struct usb_device *udev, struct usb_req *req)
 {
 #define BUF_LEN 63
@@ -45,11 +61,11 @@
 #define CHECKSUM_LEN 2
 #define USB_TIMEOUT 2000
=20
-	int ret, i, act_len;
+	int ret, act_len;
 	u8 buf[BUF_LEN];
 	u32 msg_len;
 	static u8 seq; /* packet sequence number */
-	u16 checksum =3D 0;
+	u16 checksum, tmpsum;
=20
 	/* buffer overflow check */
 	if (req->wlen > (BUF_LEN - REQ_HDR_LEN - CHECKSUM_LEN) ||
@@ -70,14 +86,7 @@
 		memcpy(&buf[4], req->wbuf, req->wlen);
=20
 	/* calc and add checksum */
-	for (i =3D 1; i < buf[0]-1; i++) {
-		if (i % 2)
-			checksum +=3D buf[i] << 8;
-		else
-			checksum +=3D buf[i];
-	}
-	checksum =3D ~checksum;
-
+	checksum =3D af9035_checksum(buf, buf[0] - 1);
 	buf[buf[0]-1] =3D (checksum >> 8);
 	buf[buf[0]-0] =3D (checksum & 0xff);
=20
@@ -107,7 +116,23 @@
 		ret =3D -EIO;
 		goto err_mutex_unlock;
 	}
+	if (act_len !=3D msg_len) {
+		err("recv bulk message truncated (%d !=3D %u)\n",
+		    act_len, (unsigned int)msg_len);
+		ret =3D -EIO;
+		goto err_mutex_unlock;
+	}
=20
+	/* verify checksum */
+	checksum =3D af9035_checksum(buf, act_len - 2);
+	tmpsum =3D (buf[act_len - 2] << 8) | buf[act_len - 1];
+	if (tmpsum !=3D checksum) {
+		err("%s: command=3D%02X checksum mismatch (%04X !=3D %04X)\n",
+		    __func__, req->cmd,
+		    (unsigned int)tmpsum, (unsigned int)checksum);
+		ret =3D -EIO;
+		goto err_mutex_unlock;
+	}
 	/* check status */
 	if (buf[2]) {
 		pr_debug("%s: command=3D%02x failed fw error=3D%d\n", __func__,


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/A0dY8p4HeVCSDR8r6KeRwI_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeLusAAoJEPUyvh2QjYsOEv4P/j7hqDWqtzy+Ut5X/dTXs66M
ouR4V0ceVnrDhwT8EOyG7/uB2ElkwzHw/qwbLmyZiCmwzMgsjTk3HR5nNYUB9K8i
eY5qge/AgB0sP5k3M872UZN1piwa0ChUzM3UAUATWoUMC2Udvg25ly2Lt+vP8wcP
p8aHZ+JaSaFsNWyectCevlW1qgLStyi/0PG04vBo5eEJwoKk00bL1rP/VcsPVwof
FAjimqX4Uf8ixwopIIu5a1VrGCDIFJP3MGKeTKmkBJUip8IKxCw6CJWKZb3Up0Pw
3ngdRqGFikBBXVAROfC7j234FS0i0zDCG3ihSELCOKglmvbKWO25LUv6o6Kp17uD
XGWCW0qcHPMWj6xN8Z6/qjSt1+M6KnvN/CMYLjokBhqXiHjBDmv/rQVOtGZGDiXq
pl6wdrxVbFd0D5K12D5K6EPYjKvRujORSkZvnxBiWUqGdPaF8hWWOhgKrK532D2x
9u4JTmKq7AtZ5hVtNOJE37fUmYED8kINbRNGe+bYaWi6Wjj9s+nZtPUNozIX1scn
odFuueu7daLSk6gjRvmiXw5F17FiOAw3h9DJMe/XVt+rWC4bdWJxpL/Nv6s7tR7a
AVFNqCtltVd7y7e/Dsvg6intliSBfA1/cgQ5c81mBPIH9jsldWY5pouFgonr7Cq3
ZJ/atPTQmPqX9u4KyLUz
=RqKE
-----END PGP SIGNATURE-----

--Sig_/A0dY8p4HeVCSDR8r6KeRwI_--
