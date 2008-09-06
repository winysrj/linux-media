Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.247])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1Kc3Yu-0001kJ-UB
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 21:35:13 +0200
Received: by an-out-0708.google.com with SMTP id c18so153832anc.125
	for <linux-dvb@linuxtv.org>; Sat, 06 Sep 2008 12:35:08 -0700 (PDT)
Message-ID: <ea4209750809061235mf068166h36ff1f979eeb6589@mail.gmail.com>
Date: Sat, 6 Sep 2008 21:35:07 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>, "Patrick Boettcher" <pb@linuxtv.org>
In-Reply-To: <ea4209750808160758y53777c02kb4c881b57d232233@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_53567_21330172.1220729708067"
References: <ea4209750808160758y53777c02kb4c881b57d232233@mail.gmail.com>
Subject: [linux-dvb] [PATCH] Added support for Asus My Cinema U3000H dvb-t
	(dibcom based device)
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

------=_Part_53567_21330172.1220729708067
Content-Type: multipart/alternative;
	boundary="----=_Part_53568_24046673.1220729708067"

------=_Part_53568_24046673.1220729708067
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all, since I think it was not added I send again a patch adding the
Asus-U3000H device for dvb-t.

---------- Forwarded message ----------
From: Albert Comerma <albert.comerma@gmail.com>
Date: 2008/8/16
Subject: [PATCH] Added support for Asus My Cinema U3000H dvb-t (dibcom based
device)
To: linux-dvb <linux-dvb@linuxtv.org>, Patrick Boettcher <
patrick.boettcher@desy.de>, zePh7r <zeph7r@gmail.com>


Hi all, this patch add support for the Asus My Cinema U3000H, tested by Rui.
I copy the header of the patch;

#This patch introduces support for dvb-t for the following dibcom based
cards:
#       Asus My Cinema U3000 Hybrid (USB-ID: 0b05:1736)
#               Signed-off-by: Rui <zeph7r@gmail.com>
#               Signed-off-by: Albert Comerma <albert.comerma@gmail.com>

Albert

------=_Part_53568_24046673.1220729708067
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi all, since I think it was not added I send again a patch adding the Asus-U3000H device for dvb-t.<br><br><div class="gmail_quote">---------- Forwarded message ----------<br>From: <b class="gmail_sendername">Albert Comerma</b> <span dir="ltr">&lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;</span><br>
Date: 2008/8/16<br>Subject: [PATCH] Added support for Asus My Cinema U3000H dvb-t (dibcom based device)<br>To: linux-dvb &lt;<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>&gt;, Patrick Boettcher &lt;<a href="mailto:patrick.boettcher@desy.de">patrick.boettcher@desy.de</a>&gt;, zePh7r &lt;<a href="mailto:zeph7r@gmail.com">zeph7r@gmail.com</a>&gt;<br>
<br><br><div dir="ltr">Hi all, this patch add support for the Asus My Cinema U3000H, tested by Rui.<br>I copy the header of the patch;<br><br>#This patch introduces support for dvb-t for the following dibcom based cards:<br>
#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Asus My Cinema U3000 Hybrid (USB-ID: 0b05:1736)<br>
#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Signed-off-by: Rui &lt;<a href="mailto:zeph7r@gmail.com" target="_blank">zeph7r@gmail.com</a>&gt;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Signed-off-by: Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank">albert.comerma@gmail.com</a>&gt;<br>

<br>Albert<br></div>
</div><br></div>

------=_Part_53568_24046673.1220729708067--

------=_Part_53567_21330172.1220729708067
Content-Type: text/x-diff; name=U3000H.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjycseuk0
Content-Disposition: attachment; filename=U3000H.patch

I1RoaXMgcGF0Y2ggaW50cm9kdWNlcyBzdXBwb3J0IGZvciBkdmItdCBmb3IgdGhlIGZvbGxvd2lu
ZyBkaWJjb20gYmFzZWQgY2FyZHM6CiMgICAgICAgQXN1cyBNeSBDaW5lbWEgVTMwMDAgSHlicmlk
IChVU0ItSUQ6IDBiMDU6MTczNikKIyAgICAgICAgICAgICAgIFNpZ25lZC1vZmYtYnk6IFJ1aSA8
emVwaDdyQGdtYWlsLmNvbT4KIwkJU2lnbmVkLW9mZi1ieTogQWxiZXJ0IENvbWVybWEgPGFsYmVy
dC5jb21lcm1hQGdtYWlsLmNvbT4KZGlmZiAtciBjYzYyNGJmNzQ4OWMgbGludXgvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1ZSBBdWcgMDUgMjE6MDA6MTEgMjAw
OCArMDMwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2
aWNlcy5jCVNhdCBBdWcgMTYgMTY6NDg6MTIgMjAwOCArMDIwMApAQCAtMTExNyw3ICsxMTE3LDgg
QEAgc3RydWN0IHVzYl9kZXZpY2VfaWQgZGliMDcwMF91c2JfaWRfdGFibAogCXsgVVNCX0RFVklD
RShVU0JfVklEX1RFUlJBVEVDLAlVU0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfSFRfRVhQUkVTUykg
fSwKIAl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9URVJSQVRFQywJVVNCX1BJRF9URVJSQVRFQ19DSU5F
UkdZX1RfWFhTKSB9LAogCXsgVVNCX0RFVklDRShVU0JfVklEX0xFQURURUssICAgVVNCX1BJRF9X
SU5GQVNUX0RUVl9ET05HTEVfU1RLNzcwMFBfMikgfSwKLQl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9I
QVVQUEFVR0UsIFVTQl9QSURfSEFVUFBBVUdFX05PVkFfVERfU1RJQ0tfNTIwMDkpIH0sCisvKiAz
NSAqL3sgVVNCX0RFVklDRShVU0JfVklEX0hBVVBQQVVHRSwgVVNCX1BJRF9IQVVQUEFVR0VfTk9W
QV9URF9TVElDS181MjAwOSkgfSwKKwl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9BU1VTLCBVU0JfUElE
X0FTVVNfVTMwMDBIKSB9LAogCXsgMCB9CQkvKiBUZXJtaW5hdGluZyBlbnRyeSAqLwogfTsKIE1P
RFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBkaWIwNzAwX3VzYl9pZF90YWJsZSk7CkBAIC0xNDAzLDcg
KzE0MDQsNyBAQCBzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWIwNzAwCiAJCQl9
LAogCQl9LAogCi0JCS5udW1fZGV2aWNlX2Rlc2NzID0gMywKKwkJLm51bV9kZXZpY2VfZGVzY3Mg
PSA0LAogCQkuZGV2aWNlcyA9IHsKIAkJCXsgICAiVGVycmF0ZWMgQ2luZXJneSBIVCBVU0IgWEUi
LAogCQkJCXsgJmRpYjA3MDBfdXNiX2lkX3RhYmxlWzI3XSwgTlVMTCB9LApAQCAtMTQxNyw2ICsx
NDE4LDEwIEBAIHN0cnVjdCBkdmJfdXNiX2RldmljZV9wcm9wZXJ0aWVzIGRpYjA3MDAKIAkJCQl7
ICZkaWIwNzAwX3VzYl9pZF90YWJsZVszMl0sIE5VTEwgfSwKIAkJCQl7IE5VTEwgfSwKIAkJCX0s
CisJCQl7ICAgIkFzdXMgTXkgQ2luZW1hLVUzMDAwSHlicmlkIiwKKwkJCQl7ICZkaWIwNzAwX3Vz
Yl9pZF90YWJsZVszNl0sIE5VTEwgfSwKKwkJCQl7IE5VTEwgfSwKKwkJCX0sCiAJCX0sCiAJCS5y
Y19pbnRlcnZhbCAgICAgID0gREVGQVVMVF9SQ19JTlRFUlZBTCwKIAkJLnJjX2tleV9tYXAgICAg
ICAgPSBkaWIwNzAwX3JjX2tleXMsCmRpZmYgLXIgY2M2MjRiZjc0ODljIGxpbnV4L2RyaXZlcnMv
bWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAotLS0gYS9saW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgJVHVlIEF1ZyAwNSAyMTowMDoxMSAyMDA4ICswMzAw
CisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAlTYXQg
QXVnIDE2IDE2OjQ4OjEyIDIwMDggKzAyMDAKQEAgLTIwNSw2ICsyMDUsNyBAQAogI2RlZmluZSBV
U0JfUElEX0xJRkVWSUVXX1RWX1dBTEtFUl9UV0lOX1dBUk0JCTB4MDUxMwogI2RlZmluZSBVU0Jf
UElEX0dJR0FCWVRFX1U3MDAwCQkJCTB4NzAwMQogI2RlZmluZSBVU0JfUElEX0FTVVNfVTMwMDAJ
CQkJMHgxNzFmCisjZGVmaW5lIFVTQl9QSURfQVNVU19VMzAwMEgJCQkJMHgxNzM2CiAjZGVmaW5l
IFVTQl9QSURfQVNVU19VMzEwMAkJCQkweDE3M2YKICNkZWZpbmUgVVNCX1BJRF9ZVUFOX0VDMzcy
UwkJCQkweDFlZGMKICNkZWZpbmUgVVNCX1BJRF9EVzIxMDIJCQkJCTB4MjEwMgo=
------=_Part_53567_21330172.1220729708067
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_53567_21330172.1220729708067--
