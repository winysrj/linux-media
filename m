Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32703.mail.mud.yahoo.com ([68.142.207.247]:25396 "HELO
	web32703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750781Ab0AHDzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2010 22:55:10 -0500
Message-ID: <489449.99130.qm@web32703.mail.mud.yahoo.com>
Date: Thu, 7 Jan 2010 19:48:28 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Kworld 315U and SAA7113?
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1295603052-1262922508=:99130"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-1295603052-1262922508=:99130
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

After some work I have finally gotten the analog inputs to work with the Kw=
orld 315U device.=A0 I have attached the changes/updates to the em28xx driv=
er. Note: I still don't have analog sound working yet..=0A=0AI am hoping so=
meone can comment on the changes in saa7115.c.=A0 I added a s_power routine=
 to reinitialize the device.=A0 The reason I am reinitializing this device =
is because=0A=0A1. I cannot keep both the LG demod and the SAA powered on a=
t the same time for my device=0A=0A2. The SAA datasheet seems to suggest th=
at after a reset/power-on the chip needs to be reinitialized.=A0 =0A=0A3. R=
einitializing causes the analog inputs to work correctly. =0A=0AHere's what=
 is says in the SAA7113 datasheet.. =0A....=0AStatus after power-on=0Acontr=
ol sequence=0A=0AVPO7 to VPO0, RTCO, RTS0 and RTS1=0Aare held in high-imped=
ance state=0A=0Aafter power-on (reset=0Asequence) a complete=0AI2C-bus tran=
smission is=0Arequired=0A...=0AThe above is really suppose to be arranged h=
orizontally in 3 columns.  Anyways, the last part describes that "a complet=
e I2C bus transmission is required"  This is why I think the chip needs to =
be reinitialized.  =0A=0A=0ALast thing is that the initialization routing u=
ses these defaults:=0A=0A       state->bright =3D 128;=0A       state->cont=
rast =3D 64;=0A       state->hue =3D 0;=0A       state->sat =3D 64;=0A=0AI =
was wondering if we should just read the back the values that were initiali=
zed by the initialization routine and use those values instead.The reason i=
s because it seems like the different SAA's use slightly different values w=
hen initializing.  =0A=0AThanks,=0AFranklin Meng=0A=0A=0A      
--0-1295603052-1262922508=:99130
Content-Type: application/octet-stream; name=mydiff1
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=mydiff1

ZGlmZiAtciBiNmI4MjI1OGNmNWUgbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9lbTI4eHgvZW0yOHh4LWNhcmRzLmMKLS0tIGEvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNhcmRzLmMJVGh1IERlYyAzMSAx
OToxNDo1NCAyMDA5IC0wMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJkcy5jCVR1ZSBKYW4gMDUgMjI6NTY6
MDggMjAxMCAtMDgwMApAQCAtMTIyLDkgKzEyMiwxNSBAQAogfTsKICNlbmRp
ZgogCisvKiBLd29ybGQgMzE1VQorICAgR1BJTzAgLSBFbmFibGUgZGlnaXRh
bCBwb3dlciAobGdkdDMzMDMpIC0gbG93IHRvIGVuYWJsZQorICAgR1BJTzEg
LSBFbmFibGUgYW5hbG9nIHBvd2VyIChzYWE3MTEzL2VtcDIwMikgLSBsb3cg
dG8gZW5hYmxlCisgICBHUElPNyAtIGVuYWJsZXMgdHVuZXI/CisgICBHT1Ay
ICAtID8/IHNvbWUgc29ydCBvZiByZXNldCA/CisgICBHT1AzICAtIGxnZHQz
MzAzIHJlc2V0CisgKi8KIC8qIEJvYXJkIC0gRU0yODgyIEt3b3JsZCAzMTVV
IGRpZ2l0YWwgKi8KIHN0YXRpYyBzdHJ1Y3QgZW0yOHh4X3JlZ19zZXEgZW0y
ODgyX2t3b3JsZF8zMTV1X2RpZ2l0YWxbXSA9IHsKLQl7RU0yOFhYX1IwOF9H
UElPLAkweGZmLAkweGZmLAkJMTB9LAogCXtFTTI4WFhfUjA4X0dQSU8sCTB4
ZmUsCTB4ZmYsCQkxMH0sCiAJe0VNMjg4MF9SMDRfR1BPLAkweDA0LAkweGZm
LAkJMTB9LAogCXtFTTI4ODBfUjA0X0dQTywJMHgwYywJMHhmZiwJCTEwfSwK
QEAgLTEzMiw2ICsxMzgsMTkgQEAKIAl7ICAtMSwJCQktMSwJLTEsCQktMX0s
CiB9OwogCisvKiBCb2FyZCAtIEVNMjg4MiBLd29ybGQgMzE1VSBhbmFsb2cx
IGFuYWxvZyB0diAqLworc3RhdGljIHN0cnVjdCBlbTI4eHhfcmVnX3NlcSBl
bTI4ODJfa3dvcmxkXzMxNXVfYW5hbG9nMVtdID0geworCXtFTTI4WFhfUjA4
X0dQSU8sCTB4ZmQsCTB4ZmYsCQkxMH0sCisJe0VNMjhYWF9SMDhfR1BJTywJ
MHg3ZCwJMHhmZiwJCTEwfSwKKwl7ICAtMSwJCQktMSwJLTEsCQktMX0sCit9
OworCisvKiBCb2FyZCAtIEVNMjg4MiBLd29ybGQgMzE1VSBhbmFsb2cyIGNv
bXBvbmVudC9zdmlkZW8gKi8KK3N0YXRpYyBzdHJ1Y3QgZW0yOHh4X3JlZ19z
ZXEgZW0yODgyX2t3b3JsZF8zMTV1X2FuYWxvZzJbXSA9IHsKKwl7RU0yOFhY
X1IwOF9HUElPLAkweGZkLAkweGZmLAkJMTB9LAorCXsgIC0xLAkJCS0xLAkt
MSwJCS0xfSwKK307CisKIHN0YXRpYyBzdHJ1Y3QgZW0yOHh4X3JlZ19zZXEg
ZW0yODgyX2t3b3JsZF8zMTV1X3R1bmVyX2dwaW9bXSA9IHsKIAl7RU0yODgw
X1IwNF9HUE8sCTB4MDgsCTB4ZmYsCQkxMH0sCiAJe0VNMjg4MF9SMDRfR1BP
LAkweDBjLAkweGZmLAkJMTB9LApAQCAtMTQwLDYgKzE1OSwxNiBAQAogCXsg
IC0xLAkJCS0xLAktMSwJCS0xfSwKIH07CiAKKy8qIEJvYXJkIC0gRU0yODgy
IEt3b3JsZCAzMTVVIHN1c3BlbmQgKi8KK3N0YXRpYyBzdHJ1Y3QgZW0yOHh4
X3JlZ19zZXEgZW0yODgyX2t3b3JsZF8zMTV1X3N1c3BlbmRbXSA9IHsKKwl7
RU0yOFhYX1IwOF9HUElPLAkweDdmLAkweGZmLAkJMTB9LAorCXtFTTI4WFhf
UjA4X0dQSU8sCTB4ZmQsCTB4ZmYsCQkxMH0sCisJe0VNMjhYWF9SMDhfR1BJ
TywJMHhmZiwJMHhmZiwJCTEwfSwKKwl7RU0yODgwX1IwNF9HUE8sCTB4MDgs
CTB4ZmYsCQkxMH0sCisJe0VNMjg4MF9SMDRfR1BPLAkweDBjLAkweGZmLAkJ
MTB9LAorCXsgIC0xLAkJCS0xLAktMSwJCS0xfSwKK307CisKIHN0YXRpYyBz
dHJ1Y3QgZW0yOHh4X3JlZ19zZXEga3dvcmxkXzMzMHVfYW5hbG9nW10gPSB7
CiAJe0VNMjhYWF9SMDhfR1BJTywJMHg2ZCwJfkVNX0dQSU9fNCwJMTB9LAog
CXtFTTI4ODBfUjA0X0dQTywJMHgwMCwJMHhmZiwJCTEwfSwKQEAgLTEzMTQs
MjggKzEzNDMsMjggQEAKIAkJLmRlY29kZXIJPSBFTTI4WFhfU0FBNzExWCwK
IAkJLmhhc19kdmIJPSAxLAogCQkuZHZiX2dwaW8JPSBlbTI4ODJfa3dvcmxk
XzMxNXVfZGlnaXRhbCwKKwkJLnN1c3BlbmRfZ3Bpbwk9IGVtMjg4Ml9rd29y
bGRfMzE1dV9zdXNwZW5kLAogCQkueGNsawkJPSBFTTI4WFhfWENMS19GUkVR
VUVOQ1lfMTJNSFosCiAJCS5pMmNfc3BlZWQJPSBFTTI4WFhfSTJDX0NMS19X
QUlUX0VOQUJMRSwKLQkJLyogQW5hbG9nIG1vZGUgLSBzdGlsbCBub3QgcmVh
ZHkgKi8KLQkJLyouaW5wdXQgICAgICAgID0geyB7CisJCS5pbnB1dCAgICAg
ICAgPSB7IHsKIAkJCS50eXBlID0gRU0yOFhYX1ZNVVhfVEVMRVZJU0lPTiwK
IAkJCS52bXV4ID0gU0FBNzExNV9DT01QT1NJVEUyLAogCQkJLmFtdXggPSBF
TTI4WFhfQU1VWF9WSURFTywKLQkJCS5ncGlvID0gZW0yODgyX2t3b3JsZF8z
MTV1X2FuYWxvZywKKwkJCS5ncGlvID0gZW0yODgyX2t3b3JsZF8zMTV1X2Fu
YWxvZzEsCiAJCQkuYW91dCA9IEVNMjhYWF9BT1VUX1BDTV9JTiB8IEVNMjhY
WF9BT1VUX1BDTV9TVEVSRU8sCiAJCX0sIHsKIAkJCS50eXBlID0gRU0yOFhY
X1ZNVVhfQ09NUE9TSVRFMSwKIAkJCS52bXV4ID0gU0FBNzExNV9DT01QT1NJ
VEUwLAogCQkJLmFtdXggPSBFTTI4WFhfQU1VWF9MSU5FX0lOLAotCQkJLmdw
aW8gPSBlbTI4ODJfa3dvcmxkXzMxNXVfYW5hbG9nMSwKKwkJCS5ncGlvID0g
ZW0yODgyX2t3b3JsZF8zMTV1X2FuYWxvZzIsCiAJCQkuYW91dCA9IEVNMjhY
WF9BT1VUX1BDTV9JTiB8IEVNMjhYWF9BT1VUX1BDTV9TVEVSRU8sCiAJCX0s
IHsKIAkJCS50eXBlID0gRU0yOFhYX1ZNVVhfU1ZJREVPLAogCQkJLnZtdXgg
PSBTQUE3MTE1X1NWSURFTzMsCiAJCQkuYW11eCA9IEVNMjhYWF9BTVVYX0xJ
TkVfSU4sCi0JCQkuZ3BpbyA9IGVtMjg4Ml9rd29ybGRfMzE1dV9hbmFsb2cx
LAorCQkJLmdwaW8gPSBlbTI4ODJfa3dvcmxkXzMxNXVfYW5hbG9nMiwKIAkJ
CS5hb3V0ID0gRU0yOFhYX0FPVVRfUENNX0lOIHwgRU0yOFhYX0FPVVRfUENN
X1NURVJFTywKLQkJfSB9LCAqLworCQl9IH0sIAogCX0sCiAJW0VNMjg4MF9C
T0FSRF9FTVBJUkVfRFVBTF9UVl0gPSB7CiAJCS5uYW1lID0gIkVtcGlyZSBk
dWFsIFRWIiwKZGlmZiAtciBiNmI4MjI1OGNmNWUgbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNvcmUuYwotLS0gYS9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgtY29yZS5jCVRodSBE
ZWMgMzEgMTk6MTQ6NTQgMjAwOSAtMDIwMAorKysgYi9saW51eC9kcml2ZXJz
L21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgtY29yZS5jCVR1ZSBKYW4gMDUg
MjI6NTY6MDggMjAxMCAtMDgwMApAQCAtMTEzMiw2ICsxMTMyLDcgQEAKICAq
Lwogdm9pZCBlbTI4eHhfd2FrZV9pMmMoc3RydWN0IGVtMjh4eCAqZGV2KQog
eworCXY0bDJfZGV2aWNlX2NhbGxfYWxsKCZkZXYtPnY0bDJfZGV2LCAwLCBj
b3JlLCAgc19wb3dlciwgMSk7CiAJdjRsMl9kZXZpY2VfY2FsbF9hbGwoJmRl
di0+djRsMl9kZXYsIDAsIGNvcmUsICByZXNldCwgMCk7CiAJdjRsMl9kZXZp
Y2VfY2FsbF9hbGwoJmRldi0+djRsMl9kZXYsIDAsIHZpZGVvLCBzX3JvdXRp
bmcsCiAJCQlJTlBVVChkZXYtPmN0bF9pbnB1dCktPnZtdXgsIDAsIDApOwpk
aWZmIC1yIGI2YjgyMjU4Y2Y1ZSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L3NhYTcxMTUuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3Nh
YTcxMTUuYwlUaHUgRGVjIDMxIDE5OjE0OjU0IDIwMDkgLTAyMDAKKysrIGIv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTE1LmMJVHVlIEphbiAw
NSAyMjo1NjowOCAyMDEwIC0wODAwCkBAIC0xMzM4LDYgKzEzMzgsNTkgQEAK
IAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGludCBzYWE3MTF4X3NfcG93ZXIo
c3RydWN0IHY0bDJfc3ViZGV2ICpzZCwgaW50IHZhbCkKK3sKKwlzdHJ1Y3Qg
c2FhNzExeF9zdGF0ZSAqc3RhdGUgPSB0b19zdGF0ZShzZCk7CisKKwlpZih2
YWwgPiAxIHx8IHZhbCA8IDApCisJCXJldHVybiAtRUlOVkFMOworCisJLyog
VGhlcmUgcmVhbGx5IGlzbid0IGEgd2F5IHRvIHB1dCB0aGUgY2hpcCBpbnRv
IHBvd2VyIHNhdmluZyAKKwkJb3RoZXIgdGhhbiBieSBwdWxsaW5nIENFIHRv
IGdyb3VuZCBzbyBhbGwgd2UgZG8gaXMgcmV0dXJuCisJCW91dCBvZiB0aGlz
IGZ1bmN0aW9uCisJKi8KKwlpZih2YWwgPT0gMCkKKwkJcmV0dXJuIDA7CisK
KwkvKiBXaGVuIGVuYWJsaW5nIHRoZSBjaGlwIGFnYWluIHdlIG5lZWQgdG8g
cmVpbml0aWFsaXplIHRoZSAKKwkJYWxsIHRoZSB2YWx1ZXMKKwkqLworCXN0
YXRlLT5pbnB1dCA9IC0xOworCXN0YXRlLT5vdXRwdXQgPSBTQUE3MTE1X0lQ
T1JUX09OOworCXN0YXRlLT5lbmFibGUgPSAxOworCXN0YXRlLT5yYWRpbyA9
IDA7CisJc3RhdGUtPmJyaWdodCA9IDEyODsKKwlzdGF0ZS0+Y29udHJhc3Qg
PSA2NDsKKwlzdGF0ZS0+aHVlID0gMDsKKwlzdGF0ZS0+c2F0ID0gNjQ7CisK
KwlzdGF0ZS0+YXVkY2xrX2ZyZXEgPSA0ODAwMDsKKworCXY0bDJfZGJnKDEs
IGRlYnVnLCBzZCwgIndyaXRpbmcgaW5pdCB2YWx1ZXMgc19wb3dlclxuIik7
CisKKwkvKiBpbml0IHRvIDYwaHovNDhraHogKi8KKwlzdGF0ZS0+Y3J5c3Rh
bF9mcmVxID0gU0FBNzExNV9GUkVRXzI0XzU3Nl9NSFo7CisJc3dpdGNoIChz
dGF0ZS0+aWRlbnQpIHsKKwljYXNlIFY0TDJfSURFTlRfU0FBNzExMToKKwkJ
c2FhNzExeF93cml0ZXJlZ3Moc2QsIHNhYTcxMTFfaW5pdCk7CisJCWJyZWFr
OworCWNhc2UgVjRMMl9JREVOVF9TQUE3MTEzOgorCQlzYWE3MTF4X3dyaXRl
cmVncyhzZCwgc2FhNzExM19pbml0KTsKKwkJYnJlYWs7CisJZGVmYXVsdDoK
KwkJc3RhdGUtPmNyeXN0YWxfZnJlcSA9IFNBQTcxMTVfRlJFUV8zMl8xMV9N
SFo7CisJCXNhYTcxMXhfd3JpdGVyZWdzKHNkLCBzYWE3MTE1X2luaXRfYXV0
b19pbnB1dCk7CisJfQorCWlmIChzdGF0ZS0+aWRlbnQgIT0gVjRMMl9JREVO
VF9TQUE3MTExKQorCQlzYWE3MTF4X3dyaXRlcmVncyhzZCwgc2FhNzExNV9p
bml0X21pc2MpOworCXNhYTcxMXhfc2V0X3Y0bHN0ZChzZCwgVjRMMl9TVERf
TlRTQyk7CisKKwl2NGwyX2RiZygxLCBkZWJ1Zywgc2QsICJzdGF0dXM6ICgx
RSkgMHglMDJ4LCAoMUYpIDB4JTAyeFxuIiwKKwkJc2FhNzExeF9yZWFkKHNk
LCBSXzFFX1NUQVRVU19CWVRFXzFfVkRfREVDKSwKKwkJc2FhNzExeF9yZWFk
KHNkLCBSXzFGX1NUQVRVU19CWVRFXzJfVkRfREVDKSk7CisJcmV0dXJuIDA7
Cit9CisKIHN0YXRpYyBpbnQgc2FhNzExeF9yZXNldChzdHJ1Y3QgdjRsMl9z
dWJkZXYgKnNkLCB1MzIgdmFsKQogewogCXY0bDJfZGJnKDEsIGRlYnVnLCBz
ZCwgImRlY29kZXIgUkVTRVRcbiIpOwpAQCAtMTUxMyw2ICsxNTY2LDcgQEAK
IAkuc19zdGQgPSBzYWE3MTF4X3Nfc3RkLAogCS5yZXNldCA9IHNhYTcxMXhf
cmVzZXQsCiAJLnNfZ3BpbyA9IHNhYTcxMXhfc19ncGlvLAorCS5zX3Bvd2Vy
ID0gc2FhNzExeF9zX3Bvd2VyLAogI2lmZGVmIENPTkZJR19WSURFT19BRFZf
REVCVUcKIAkuZ19yZWdpc3RlciA9IHNhYTcxMXhfZ19yZWdpc3RlciwKIAku
c19yZWdpc3RlciA9IHNhYTcxMXhfc19yZWdpc3RlciwK

--0-1295603052-1262922508=:99130--
