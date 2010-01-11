Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:46753 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab0AKIJR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 03:09:17 -0500
Date: Mon, 11 Jan 2010 09:10:30 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	=?UTF-8?B?U3Q=?= =?UTF-8?B?w6lwaGFuZQ==?= Marguet
	<smarguet@gmail.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_pac7302: sporatdic problem when plugging the device
Message-ID: <20100111091030.298cedd7@tele>
In-Reply-To: <4B4A386D.3080106@freemail.hu>
References: <4B4A0752.6030306@freemail.hu>
 <20100110204844.770f8fd7@tele>
 <4B4A386D.3080106@freemail.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/BXIeQsYfFZOUYv3kCHgOY8N"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/BXIeQsYfFZOUYv3kCHgOY8N
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Sorry, I forgot to attach the patch.

> In some usbsnoop files I have, the index 0x48 is not loaded. May you
> try the attached patch (skip the index 0x48 and remove the delay).
>=20
> (St=C3=A9phane, est-ce que tu peux voir aussi ce que =C3=A7a donne chez t=
oi?)

Regards.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/BXIeQsYfFZOUYv3kCHgOY8N
Content-Type: application/octet-stream; name=pac7302.pat
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=pac7302.pat

ZGlmZiAtciA4YzExYmU0ZWRmMzMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9wYWM3
MzAyLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9wYWM3MzAyLmMJU3Vu
IEphbiAxMCAyMDozNjo1MyAyMDEwICswMTAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlk
ZW8vZ3NwY2EvcGFjNzMwMi5jCU1vbiBKYW4gMTEgMDk6MDE6MjQgMjAxMCArMDEwMApAQCAtMzg4
LDcgKzM4OCw3IEBACiAJMHhhNCwgMHhiOCwgMHhlMCwgMHgyYSwgMHhmNiwgMHgwMCwgMHgwMCwg
MHgwMCwKIAkweDAwLCAweDFlLCAweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLAog
CTB4MDAsIDB4ZmMsIDB4MDAsIDB4ZjIsIDB4MWYsIDB4MDQsIDB4MDAsIDB4MDAsCi0JMHgwMCwg
MHgwMCwgMHgwMCwgMHhjMCwgMHhjMCwgMHgxMCwgMHgwMCwgMHgwMCwKKwlTS0lQLCAweDAwLCAw
eDAwLCAweGMwLCAweGMwLCAweDEwLCAweDAwLCAweDAwLAogCTB4MDAsIDB4NDAsIDB4MDAsIDB4
MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsCiAJMHgwMCwgMHg0MCwgMHhmZiwgMHgwMywgMHgx
OSwgMHgwMCwgMHgwMCwgMHgwMCwKIAkweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAw
LCAweDAwLCAweDAwLApAQCAtNDE5LDcgKzQxOSw2IEBACiAJCVBERUJVRyhEX0VSUiwgInJlZ193
X2J1ZigpOiAiCiAJCSJGYWlsZWQgdG8gd3JpdGUgcmVnaXN0ZXJzIHRvIGluZGV4IDB4JXgsIGVy
cm9yICVpIiwKIAkJaW5kZXgsIHJldCk7Ci0JbXNsZWVwKDQpOwkJLyogZG9uJ3QgZ28gdG9vIHF1
aWNrbHkgKi8KIAlyZXR1cm4gcmV0OwogfQogCg==

--MP_/BXIeQsYfFZOUYv3kCHgOY8N--
