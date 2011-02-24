Return-path: <mchehab@pedra>
Received: from fallback7.mail.ru ([94.100.176.135]:58430 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755010Ab1BXKq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 05:46:58 -0500
Received: from smtp5.mail.ru (smtp5.mail.ru [94.100.176.132])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id DC7051DA7CAA
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 13:42:19 +0300 (MSK)
Received: from [77.35.201.86] (port=50156 helo=ua0lnjhome)
	by smtp5.mail.ru with asmtp
	id 1PsYdR-0000f1-00
	for linux-media@vger.kernel.org; Thu, 24 Feb 2011 13:41:26 +0300
From: =?koi8-r?B?8NLJxNfP0s/XIOHOxNLFyiAoUHJpZHZvcm92IEFuZHJleSk=?=
	<ua0lnj@bk.ru>
To: <linux-media@vger.kernel.org>
References: <201101110921.36394.hverkuil@xs4all.nl> <201102241050.27236.hverkuil@xs4all.nl>
Subject: [PATCH] NTSC443 for cx2584x
Date: Thu, 24 Feb 2011 20:41:22 +1000
Message-ID: <B748B6E5C4314B15A47C4E472F9C15FE@ua0lnjhome>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0000_01CBD463.339F4D80"
In-Reply-To: <201102241050.27236.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.

------=_NextPart_000_0000_01CBD463.339F4D80
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit

Hi.

This patch adds support for ntsc 443, 525/60. I tested it with pvr 150 MCE
card + vdr + pvrinput.

Without this patch, I had a b/w picture.

Regards.


------=_NextPart_000_0000_01CBD463.339F4D80
Content-Type: application/octet-stream;
	name="ntsc443.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ntsc443.diff"

--- cx25840-core.c	2011-02-06 11:08:07.000000000 +1000=0A=
+++ cx25840-core-new.c	2010-11-01 13:43:10.000000000 +1000=0A=
@@ -586,6 +586,13 @@ void cx25840_std_setup(struct i2c_client=0A=
 			burst =3D 0x61;=0A=
 			comb =3D 0x20;=0A=
 			sc =3D 555452;=0A=
+		} else if (std =3D=3D V4L2_STD_NTSC_443) {=0A=
+			vblank =3D 26;=0A=
+			vblank656 =3D 26;=0A=
+			burst =3D 0x5b;=0A=
+			luma_lpf =3D 2;=0A=
+			comb =3D 0x20;=0A=
+			sc =3D 688739;=0A=
 		} else {=0A=
 			vblank =3D 26;=0A=
 			vblank656 =3D 26;=0A=

------=_NextPart_000_0000_01CBD463.339F4D80--

