Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32703.mail.mud.yahoo.com ([68.142.207.247]:40648 "HELO
	web32703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448Ab0AIIaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2010 03:30:10 -0500
Message-ID: <772427.81188.qm@web32703.mail.mud.yahoo.com>
Date: Sat, 9 Jan 2010 00:30:08 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U and SAA7113?
To: linux-media@vger.kernel.org
Cc: Douglas Schilling <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-738195257-1263025808=:81188"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-738195257-1263025808=:81188
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Attached is an updated diff for the Kworld 315U TV.  I believe all the bugs=
 have been worked out.  I haven't figured out the remote control stuff and =
hopefully I will be able to get around to it some time. =0A=0AThe sound iss=
ue was because I didn't have the right mplayer config so that is fixed as w=
ell.  =0A=0AOther than that, the LED light on the front of the box doesn't =
shut off after I start and stop the stream.  It's probably a GPIO setting t=
hat I need to tweak.  =0A=0AAnd I wanted to say thank you to Douglas and De=
vin for the tips they provided me.  =0A=0AThanks,=0AFranklin Meng=0A=0A--- =
On Thu, 1/7/10, Franklin Meng <fmeng2002@yahoo.com> wrote:=0A=0A> From: Fra=
nklin Meng <fmeng2002@yahoo.com>=0A> Subject: Kworld 315U and SAA7113?=0A> =
To: linux-media@vger.kernel.org=0A> Date: Thursday, January 7, 2010, 7:48 P=
M=0A> After some work I have finally gotten=0A> the analog inputs to work w=
ith the Kworld 315U device.=A0 I=0A> have attached the changes/updates to t=
he em28xx driver.=0A> Note: I still don't have analog sound working yet..=
=0A> =0A> I am hoping someone can comment on the changes in=0A> saa7115.c.=
=A0 I added a s_power routine to reinitialize the=0A> device.=A0 The reason=
 I am reinitializing this device is=0A> because=0A> =0A> 1. I cannot keep b=
oth the LG demod and the SAA powered on=0A> at the same time for my device=
=0A> =0A> 2. The SAA datasheet seems to suggest that after a=0A> reset/powe=
r-on the chip needs to be reinitialized.=A0 =0A> =0A> 3. Reinitializing cau=
ses the analog inputs to work=0A> correctly. =0A> =0A> Here's what is says =
in the SAA7113 datasheet.. =0A> ....=0A> Status after power-on=0A> control =
sequence=0A> =0A> VPO7 to VPO0, RTCO, RTS0 and RTS1=0A> are held in high-im=
pedance state=0A> =0A> after power-on (reset=0A> sequence) a complete=0A> I=
2C-bus transmission is=0A> required=0A> ...=0A> The above is really suppose=
 to be arranged horizontally in=0A> 3 columns.=A0 Anyways, the last part de=
scribes that "a=0A> complete I2C bus transmission is required"=A0 This is w=
hy=0A> I think the chip needs to be reinitialized.=A0 =0A> =0A> =0A> Last t=
hing is that the initialization routing uses these=0A> defaults:=0A> =0A> =
=A0 =A0 =A0=A0=A0state->bright =3D 128;=0A> =A0 =A0 =A0=A0=A0state->contras=
t =3D 64;=0A> =A0 =A0 =A0=A0=A0state->hue =3D 0;=0A> =A0 =A0 =A0=A0=A0state=
->sat =3D 64;=0A> =0A> I was wondering if we should just read the back the =
values=0A> that were initialized by the initialization routine and use=0A> =
those values instead.The reason is because it seems like the=0A> different =
SAA's use slightly different values when=0A> initializing.=A0 =0A> =0A> Tha=
nks,=0A> Franklin Meng=0A> =0A> =0A> =A0 =A0 =A0=0A=0A=0A      
--0-738195257-1263025808=:81188
Content-Type: text/x-diff; name="curdiff.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="curdiff.diff"

ZGlmZiAtciBiNmI4MjI1OGNmNWUgbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9lbTI4eHgvZW0yOHh4LWNhcmRzLmMKLS0tIGEvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNhcmRzLmMJVGh1IERlYyAzMSAx
OToxNDo1NCAyMDA5IC0wMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJkcy5jCVNhdCBKYW4gMDkgMDA6MjE6
MzkgMjAxMCAtMDgwMApAQCAtMTIyLDEzICsxMjIsMzEgQEAKIH07CiAjZW5k
aWYKIAorLyogS3dvcmxkIDMxNVUKKyAgIEdQSU8wIC0gRW5hYmxlIGRpZ2l0
YWwgcG93ZXIgKGxnZHQzMzAzKSAtIGxvdyB0byBlbmFibGUKKyAgIEdQSU8x
IC0gRW5hYmxlIGFuYWxvZyBwb3dlciAoc2FhNzExMy9lbXAyMDIpIC0gbG93
IHRvIGVuYWJsZQorICAgR1BJTzcgLSBlbmFibGVzIHNvbWV0aGluZyA/Cisg
ICBHT1AyICAtID8/IHNvbWUgc29ydCBvZiByZXNldCA/CisgICBHT1AzICAt
IGxnZHQzMzAzIHJlc2V0CisgKi8KIC8qIEJvYXJkIC0gRU0yODgyIEt3b3Js
ZCAzMTVVIGRpZ2l0YWwgKi8KIHN0YXRpYyBzdHJ1Y3QgZW0yOHh4X3JlZ19z
ZXEgZW0yODgyX2t3b3JsZF8zMTV1X2RpZ2l0YWxbXSA9IHsKLQl7RU0yOFhY
X1IwOF9HUElPLAkweGZmLAkweGZmLAkJMTB9LAogCXtFTTI4WFhfUjA4X0dQ
SU8sCTB4ZmUsCTB4ZmYsCQkxMH0sCiAJe0VNMjg4MF9SMDRfR1BPLAkweDA0
LAkweGZmLAkJMTB9LAogCXtFTTI4ODBfUjA0X0dQTywJMHgwYywJMHhmZiwJ
CTEwfSwKLQl7RU0yOFhYX1IwOF9HUElPLAkweDdlLAkweGZmLAkJMTB9LAor
CXsgIC0xLAkJCS0xLAktMSwJCS0xfSwKK307CisKKy8qIEJvYXJkIC0gRU0y
ODgyIEt3b3JsZCAzMTVVIGFuYWxvZzEgYW5hbG9nIHR2ICovCitzdGF0aWMg
c3RydWN0IGVtMjh4eF9yZWdfc2VxIGVtMjg4Ml9rd29ybGRfMzE1dV9hbmFs
b2cxW10gPSB7CisJe0VNMjhYWF9SMDhfR1BJTywJMHhmZCwJMHhmZiwJCTEw
fSwKKwl7RU0yOFhYX1IwOF9HUElPLAkweDdkLAkweGZmLAkJMTB9LAorCXsg
IC0xLAkJCS0xLAktMSwJCS0xfSwKK307CisKKy8qIEJvYXJkIC0gRU0yODgy
IEt3b3JsZCAzMTVVIGFuYWxvZzIgY29tcG9uZW50L3N2aWRlbyAqLworc3Rh
dGljIHN0cnVjdCBlbTI4eHhfcmVnX3NlcSBlbTI4ODJfa3dvcmxkXzMxNXVf
YW5hbG9nMltdID0geworCXtFTTI4WFhfUjA4X0dQSU8sCTB4ZmQsCTB4ZmYs
CQkxMH0sCiAJeyAgLTEsCQkJLTEsCS0xLAkJLTF9LAogfTsKIApAQCAtMTQw
LDYgKzE1OCwxMiBAQAogCXsgIC0xLAkJCS0xLAktMSwJCS0xfSwKIH07CiAK
Ky8qIEJvYXJkIC0gRU0yODgyIEt3b3JsZCAzMTVVIHN1c3BlbmQgKi8KK3N0
YXRpYyBzdHJ1Y3QgZW0yOHh4X3JlZ19zZXEgZW0yODgyX2t3b3JsZF8zMTV1
X3N1c3BlbmRbXSA9IHsKKwl7RU0yOFhYX1IwOF9HUElPLAkweGZmLAkweGZm
LAkJMTB9LAorCXsgIC0xLAkJCS0xLAktMSwJCS0xfSwKK307CisKIHN0YXRp
YyBzdHJ1Y3QgZW0yOHh4X3JlZ19zZXEga3dvcmxkXzMzMHVfYW5hbG9nW10g
PSB7CiAJe0VNMjhYWF9SMDhfR1BJTywJMHg2ZCwJfkVNX0dQSU9fNCwJMTB9
LAogCXtFTTI4ODBfUjA0X0dQTywJMHgwMCwJMHhmZiwJCTEwfSwKQEAgLTEz
MTQsMjggKzEzMzgsMjggQEAKIAkJLmRlY29kZXIJPSBFTTI4WFhfU0FBNzEx
WCwKIAkJLmhhc19kdmIJPSAxLAogCQkuZHZiX2dwaW8JPSBlbTI4ODJfa3dv
cmxkXzMxNXVfZGlnaXRhbCwKKwkJLnN1c3BlbmRfZ3Bpbwk9IGVtMjg4Ml9r
d29ybGRfMzE1dV9zdXNwZW5kLAogCQkueGNsawkJPSBFTTI4WFhfWENMS19G
UkVRVUVOQ1lfMTJNSFosCiAJCS5pMmNfc3BlZWQJPSBFTTI4WFhfSTJDX0NM
S19XQUlUX0VOQUJMRSwKLQkJLyogQW5hbG9nIG1vZGUgLSBzdGlsbCBub3Qg
cmVhZHkgKi8KLQkJLyouaW5wdXQgICAgICAgID0geyB7CisJCS5pbnB1dCAg
ICAgICAgPSB7IHsKIAkJCS50eXBlID0gRU0yOFhYX1ZNVVhfVEVMRVZJU0lP
TiwKIAkJCS52bXV4ID0gU0FBNzExNV9DT01QT1NJVEUyLAogCQkJLmFtdXgg
PSBFTTI4WFhfQU1VWF9WSURFTywKLQkJCS5ncGlvID0gZW0yODgyX2t3b3Js
ZF8zMTV1X2FuYWxvZywKKwkJCS5ncGlvID0gZW0yODgyX2t3b3JsZF8zMTV1
X2FuYWxvZzEsCiAJCQkuYW91dCA9IEVNMjhYWF9BT1VUX1BDTV9JTiB8IEVN
MjhYWF9BT1VUX1BDTV9TVEVSRU8sCiAJCX0sIHsKIAkJCS50eXBlID0gRU0y
OFhYX1ZNVVhfQ09NUE9TSVRFMSwKIAkJCS52bXV4ID0gU0FBNzExNV9DT01Q
T1NJVEUwLAogCQkJLmFtdXggPSBFTTI4WFhfQU1VWF9MSU5FX0lOLAotCQkJ
LmdwaW8gPSBlbTI4ODJfa3dvcmxkXzMxNXVfYW5hbG9nMSwKKwkJCS5ncGlv
ID0gZW0yODgyX2t3b3JsZF8zMTV1X2FuYWxvZzIsCiAJCQkuYW91dCA9IEVN
MjhYWF9BT1VUX1BDTV9JTiB8IEVNMjhYWF9BT1VUX1BDTV9TVEVSRU8sCiAJ
CX0sIHsKIAkJCS50eXBlID0gRU0yOFhYX1ZNVVhfU1ZJREVPLAogCQkJLnZt
dXggPSBTQUE3MTE1X1NWSURFTzMsCiAJCQkuYW11eCA9IEVNMjhYWF9BTVVY
X0xJTkVfSU4sCi0JCQkuZ3BpbyA9IGVtMjg4Ml9rd29ybGRfMzE1dV9hbmFs
b2cxLAorCQkJLmdwaW8gPSBlbTI4ODJfa3dvcmxkXzMxNXVfYW5hbG9nMiwK
IAkJCS5hb3V0ID0gRU0yOFhYX0FPVVRfUENNX0lOIHwgRU0yOFhYX0FPVVRf
UENNX1NURVJFTywKLQkJfSB9LCAqLworCQl9IH0sIAogCX0sCiAJW0VNMjg4
MF9CT0FSRF9FTVBJUkVfRFVBTF9UVl0gPSB7CiAJCS5uYW1lID0gIkVtcGly
ZSBkdWFsIFRWIiwKZGlmZiAtciBiNmI4MjI1OGNmNWUgbGludXgvZHJpdmVy
cy9tZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNvcmUuYwotLS0gYS9saW51
eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgtY29yZS5jCVRo
dSBEZWMgMzEgMTk6MTQ6NTQgMjAwOSAtMDIwMAorKysgYi9saW51eC9kcml2
ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgtY29yZS5jCVNhdCBKYW4g
MDkgMDA6MjE6MzkgMjAxMCAtMDgwMApAQCAtMTEzMiw2ICsxMTMyLDcgQEAK
ICAqLwogdm9pZCBlbTI4eHhfd2FrZV9pMmMoc3RydWN0IGVtMjh4eCAqZGV2
KQogeworCXY0bDJfZGV2aWNlX2NhbGxfYWxsKCZkZXYtPnY0bDJfZGV2LCAw
LCBjb3JlLCAgc19wb3dlciwgMSk7CiAJdjRsMl9kZXZpY2VfY2FsbF9hbGwo
JmRldi0+djRsMl9kZXYsIDAsIGNvcmUsICByZXNldCwgMCk7CiAJdjRsMl9k
ZXZpY2VfY2FsbF9hbGwoJmRldi0+djRsMl9kZXYsIDAsIHZpZGVvLCBzX3Jv
dXRpbmcsCiAJCQlJTlBVVChkZXYtPmN0bF9pbnB1dCktPnZtdXgsIDAsIDAp
OwpkaWZmIC1yIGI2YjgyMjU4Y2Y1ZSBsaW51eC9kcml2ZXJzL21lZGlhL3Zp
ZGVvL3NhYTcxMTUuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L3NhYTcxMTUuYwlUaHUgRGVjIDMxIDE5OjE0OjU0IDIwMDkgLTAyMDAKKysr
IGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTE1LmMJU2F0IEph
biAwOSAwMDoyMTozOSAyMDEwIC0wODAwCkBAIC0xMzM4LDYgKzEzMzgsNTkg
QEAKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGludCBzYWE3MTF4X3NfcG93
ZXIoc3RydWN0IHY0bDJfc3ViZGV2ICpzZCwgaW50IHZhbCkKK3sKKwlzdHJ1
Y3Qgc2FhNzExeF9zdGF0ZSAqc3RhdGUgPSB0b19zdGF0ZShzZCk7CisKKwlp
Zih2YWwgPiAxIHx8IHZhbCA8IDApCisJCXJldHVybiAtRUlOVkFMOworCisJ
LyogVGhlcmUgcmVhbGx5IGlzbid0IGEgd2F5IHRvIHB1dCB0aGUgY2hpcCBp
bnRvIHBvd2VyIHNhdmluZyAKKwkJb3RoZXIgdGhhbiBieSBwdWxsaW5nIENF
IHRvIGdyb3VuZCBzbyBhbGwgd2UgZG8gaXMgcmV0dXJuCisJCW91dCBvZiB0
aGlzIGZ1bmN0aW9uCisJKi8KKwlpZih2YWwgPT0gMCkKKwkJcmV0dXJuIDA7
CisKKwkvKiBXaGVuIGVuYWJsaW5nIHRoZSBjaGlwIGFnYWluIHdlIG5lZWQg
dG8gcmVpbml0aWFsaXplIHRoZSAKKwkJYWxsIHRoZSB2YWx1ZXMKKwkqLwor
CXN0YXRlLT5pbnB1dCA9IC0xOworCXN0YXRlLT5vdXRwdXQgPSBTQUE3MTE1
X0lQT1JUX09OOworCXN0YXRlLT5lbmFibGUgPSAxOworCXN0YXRlLT5yYWRp
byA9IDA7CisJc3RhdGUtPmJyaWdodCA9IDEyODsKKwlzdGF0ZS0+Y29udHJh
c3QgPSA2NDsKKwlzdGF0ZS0+aHVlID0gMDsKKwlzdGF0ZS0+c2F0ID0gNjQ7
CisKKwlzdGF0ZS0+YXVkY2xrX2ZyZXEgPSA0ODAwMDsKKworCXY0bDJfZGJn
KDEsIGRlYnVnLCBzZCwgIndyaXRpbmcgaW5pdCB2YWx1ZXMgc19wb3dlclxu
Iik7CisKKwkvKiBpbml0IHRvIDYwaHovNDhraHogKi8KKwlzdGF0ZS0+Y3J5
c3RhbF9mcmVxID0gU0FBNzExNV9GUkVRXzI0XzU3Nl9NSFo7CisJc3dpdGNo
IChzdGF0ZS0+aWRlbnQpIHsKKwljYXNlIFY0TDJfSURFTlRfU0FBNzExMToK
KwkJc2FhNzExeF93cml0ZXJlZ3Moc2QsIHNhYTcxMTFfaW5pdCk7CisJCWJy
ZWFrOworCWNhc2UgVjRMMl9JREVOVF9TQUE3MTEzOgorCQlzYWE3MTF4X3dy
aXRlcmVncyhzZCwgc2FhNzExM19pbml0KTsKKwkJYnJlYWs7CisJZGVmYXVs
dDoKKwkJc3RhdGUtPmNyeXN0YWxfZnJlcSA9IFNBQTcxMTVfRlJFUV8zMl8x
MV9NSFo7CisJCXNhYTcxMXhfd3JpdGVyZWdzKHNkLCBzYWE3MTE1X2luaXRf
YXV0b19pbnB1dCk7CisJfQorCWlmIChzdGF0ZS0+aWRlbnQgIT0gVjRMMl9J
REVOVF9TQUE3MTExKQorCQlzYWE3MTF4X3dyaXRlcmVncyhzZCwgc2FhNzEx
NV9pbml0X21pc2MpOworCXNhYTcxMXhfc2V0X3Y0bHN0ZChzZCwgVjRMMl9T
VERfTlRTQyk7CisKKwl2NGwyX2RiZygxLCBkZWJ1Zywgc2QsICJzdGF0dXM6
ICgxRSkgMHglMDJ4LCAoMUYpIDB4JTAyeFxuIiwKKwkJc2FhNzExeF9yZWFk
KHNkLCBSXzFFX1NUQVRVU19CWVRFXzFfVkRfREVDKSwKKwkJc2FhNzExeF9y
ZWFkKHNkLCBSXzFGX1NUQVRVU19CWVRFXzJfVkRfREVDKSk7CisJcmV0dXJu
IDA7Cit9CisKIHN0YXRpYyBpbnQgc2FhNzExeF9yZXNldChzdHJ1Y3QgdjRs
Ml9zdWJkZXYgKnNkLCB1MzIgdmFsKQogewogCXY0bDJfZGJnKDEsIGRlYnVn
LCBzZCwgImRlY29kZXIgUkVTRVRcbiIpOwpAQCAtMTUxMyw2ICsxNTY2LDcg
QEAKIAkuc19zdGQgPSBzYWE3MTF4X3Nfc3RkLAogCS5yZXNldCA9IHNhYTcx
MXhfcmVzZXQsCiAJLnNfZ3BpbyA9IHNhYTcxMXhfc19ncGlvLAorCS5zX3Bv
d2VyID0gc2FhNzExeF9zX3Bvd2VyLAogI2lmZGVmIENPTkZJR19WSURFT19B
RFZfREVCVUcKIAkuZ19yZWdpc3RlciA9IHNhYTcxMXhfZ19yZWdpc3RlciwK
IAkuc19yZWdpc3RlciA9IHNhYTcxMXhfc19yZWdpc3RlciwK

--0-738195257-1263025808=:81188--
