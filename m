Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KbOEi-0003m5-8h
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 01:27:40 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	3468E18001B8
	for <linux-dvb@linuxtv.org>; Thu,  4 Sep 2008 23:26:59 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1220570817310811"
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>, 'jackden' <jackden@gmail.com>
Date: Fri, 5 Sep 2008 09:26:57 +1000
Message-Id: <20080904232657.E73D747808F@ws1-5.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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

This is a multi-part message in MIME format.

--_----------=_1220570817310811
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"


> ----- Original Message -----
> From: "Thomas Goerke" <tom@goeng.com.au>
> To: stev391@email.com, "'jackden'" <jackden@gmail.com>
> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and anal=
og TV/FM capture card
> Date: Sun, 31 Aug 2008 19:22:31 +0800
>
>
> > Tom,
> > (Jackden please try first patch and provide feedback, if that doesn't
> > work for your card, then try this and provide feedback)
> >
> > The second dmesg (with debugging) didn't show me what I was looking
> > for, but from past experience I will try something else.  I was looking
> > for some dma errors from the cx23885 driver, these usually occured
> > while streaming is being attempted.
> >
> > Attached to this email is another patch.  The difference between the
> > first one and the second one is that I load an extra module (cx25840),
> > which normally is not required for DVB as it is part of the analog side
> > of this card.  This does NOT mean analog will be supported.
> >
> > As of today the main v4l-dvb can be used with this patch and this means
> > that the cx23885-leadtek tree will soon disappear. So step 2 above has
> > been modified to: "Check out the latest v4l-dvb source".
> >
> > Other then that step 4 has a different file name for the patch.
> >
> > Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you
> > have completed the missing steps already).
> >
> > If the patch works, please do not stop communicating, as I have to
> > perform one more patch to prove that cx25840 is required and my
> > assumptions are correct. Once this is completed I will send it to
> > Steven Toth for inclusion in his test tree. This will need to be tested
> > by you again, and if all is working well after a week or more it will
> > be included into the main tree.
> >
> > Regards,
> > Stephen
> >
> >
> > --
>
> Stephen,
>
> After following Steven Toth's advice re CPIA, applying your patch and then
> make, make install, I can now report that the Compro E800F card is workin=
g!
> This is very impressive and thanks for your help.
>
> I have added the card to MythTV and all channels were successfully added.=
  I
> am not sure about the comparable signal strength's compared to the Hauppa=
uge
> Nova card I also have installed - this is something I can provide feedback
> on at a later stage.
>
> I have tried from a soft and hard reset and all seems ok.
>
> See below for the o/p from dmesg.  Please let  me know if there is anythi=
ng
> else you would like to try/test.
>
> Tom
>
---Snip---


Tom,

Attached is another patch,  this will break the support for your card, but =
proves that the=20
cx25840 module is required for the DVB-T side of this card.  So before appl=
ying the patch make=20
sure you have a copy of the working patch handy (or even two copies of the =
source tree).

Follow the same steps I had for the v0.1 patch, but use the attached (v0.2)=
 patch.  The symptons will be the same as the original patch, i.e. no error=
s in dmesg, but unable to scam/tune.

Also can you please look at the other IC's on the board and see if you iden=
tify them for me.=20=20
I'm looking for an eeprom or similiar IC, as I will need to distinguish bet=
ween the various=20
different boards.  Also if you can get a dump of what is on the eeprom and =
provide it (or put it=20
on the wiki page, or both).  I'm not sure how to do this safely yet, so if =
you have time google=20
is your friend (i2cdump might to the trick).

Thanks,
Stephen


--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1220570817310811
Content-Disposition: attachment; filename="Compro_VideoMate_E650_V0.2.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="Compro_VideoMate_E650_V0.2.patch"

ZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80
bGludXgvQ0FSRExJU1QuY3gyMzg4NSB2NGwtZHZiX2Rldi9saW51eC9Eb2N1
bWVudGF0aW9uL3ZpZGVvNGxpbnV4L0NBUkRMSVNULmN4MjM4ODUKLS0tIHY0
bC1kdmIvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElT
VC5jeDIzODg1CTIwMDgtMDgtMzEgMDc6NTU6MzIuMDAwMDAwMDAwICsxMDAw
CisrKyB2NGwtZHZiX2Rldi9saW51eC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxp
bnV4L0NBUkRMSVNULmN4MjM4ODUJMjAwOC0wOS0wNSAwODowNzoxOS4wMDAw
MDAwMDAgKzEwMDAKQEAgLTExLDMgKzExLDQgQEAKICAxMCAtPiBEVmlDTyBG
dXNpb25IRFRWNyBEdWFsIEV4cHJlc3MgICAgICAgICAgICAgICAgICAgICAg
WzE4YWM6ZDYxOF0KICAxMSAtPiBEVmlDTyBGdXNpb25IRFRWIERWQi1UIER1
YWwgRXhwcmVzcyAgICAgICAgICAgICAgICAgWzE4YWM6ZGI3OF0KICAxMiAt
PiBMZWFkdGVrIFdpbmZhc3QgUHhEVlIzMjAwIEggICAgICAgICAgICAgICAg
ICAgICAgICAgWzEwN2Q6NjY4MV0KKyAxMyAtPiBDb21wcm8gVmlkZW9NYXRl
IEU2NTAJCQkJICAgWzE4NWI6ZTgwMF0KZGlmZiAtTmF1ciB2NGwtZHZiL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRz
LmMgdjRsLWR2Yl9kZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIz
ODg1L2N4MjM4ODUtY2FyZHMuYwotLS0gdjRsLWR2Yi9saW51eC9kcml2ZXJz
L21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1jYXJkcy5jCTIwMDgtMDgt
MzEgMDc6NTU6MzIuMDAwMDAwMDAwICsxMDAwCisrKyB2NGwtZHZiX2Rldi9s
aW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1jYXJk
cy5jCTIwMDgtMDktMDUgMDg6MDc6MTkuMDAwMDAwMDAwICsxMDAwCkBAIC0x
NTksNiArMTU5LDEwIEBACiAJCS5uYW1lCQk9ICJMZWFkdGVrIFdpbmZhc3Qg
UHhEVlIzMjAwIEgiLAogCQkucG9ydGMJCT0gQ1gyMzg4NV9NUEVHX0RWQiwK
IAl9LAorCVtDWDIzODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1MF0g
PSB7CisJCS5uYW1lCQk9ICJDb21wcm8gVmlkZW9NYXRlIEU2NTAiLAorCQku
cG9ydGMJCT0gQ1gyMzg4NV9NUEVHX0RWQiwKKwl9LAogfTsKIGNvbnN0IHVu
c2lnbmVkIGludCBjeDIzODg1X2Jjb3VudCA9IEFSUkFZX1NJWkUoY3gyMzg4
NV9ib2FyZHMpOwogCkBAIC0yMzgsNiArMjQyLDEwIEBACiAJCS5zdWJ2ZW5k
b3IgPSAweDEwN2QsCiAJCS5zdWJkZXZpY2UgPSAweDY2ODEsCiAJCS5jYXJk
ICAgICAgPSBDWDIzODg1X0JPQVJEX0xFQURURUtfV0lORkFTVF9QWERWUjMy
MDBfSCwKKwl9LCB7CisJCS5zdWJ2ZW5kb3IgPSAweDE4NWIsCisJCS5zdWJk
ZXZpY2UgPSAweGU4MDAsCisJCS5jYXJkICAgICAgPSBDWDIzODg1X0JPQVJE
X0NPTVBST19WSURFT01BVEVfRTY1MCwKIAl9LAogfTsKIGNvbnN0IHVuc2ln
bmVkIGludCBjeDIzODg1X2lkY291bnQgPSBBUlJBWV9TSVpFKGN4MjM4ODVf
c3ViaWRzKTsKQEAgLTM1OCw2ICszNjYsNyBAQAogCWNhc2UgQ1gyMzg4NV9C
T0FSRF9IQVVQUEFVR0VfSFZSMTUwMDoKIAljYXNlIENYMjM4ODVfQk9BUkRf
SEFVUFBBVUdFX0hWUjE1MDBROgogCWNhc2UgQ1gyMzg4NV9CT0FSRF9MRUFE
VEVLX1dJTkZBU1RfUFhEVlIzMjAwX0g6CisJY2FzZSBDWDIzODg1X0JPQVJE
X0NPTVBST19WSURFT01BVEVfRTY1MDoKIAkJLyogVHVuZXIgUmVzZXQgQ29t
bWFuZCAqLwogCQliaXRtYXNrID0gMHgwNDsKIAkJYnJlYWs7CkBAIC01MTAs
NiArNTE5LDE2IEBACiAJCW1kZWxheSgyMCk7CiAJCWN4X3NldChHUDBfSU8s
IDB4MDAwNDAwMDQpOwogCQlicmVhazsKKwljYXNlIENYMjM4ODVfQk9BUkRf
Q09NUFJPX1ZJREVPTUFURV9FNjUwOgorCQkvKiBHUElPLTIgIHhjMzAwOCB0
dW5lciByZXNldCAqLworCisJCS8qIFB1dCB0aGUgcGFydHMgaW50byByZXNl
dCBhbmQgYmFjayAqLworCQljeF9zZXQoR1AwX0lPLCAweDAwMDQwMDAwKTsK
KwkJbWRlbGF5KDIwKTsKKwkJY3hfY2xlYXIoR1AwX0lPLCAweDAwMDAwMDA0
KTsKKwkJbWRlbGF5KDIwKTsKKwkJY3hfc2V0KEdQMF9JTywgMHgwMDA0MDAw
NCk7CisJCWJyZWFrOwogCX0KIH0KIApAQCAtNTk4LDYgKzYxNyw3IEBACiAJ
Y2FzZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNzAwOgogCWNhc2Ug
Q1gyMzg4NV9CT0FSRF9IQVVQUEFVR0VfSFZSMTQwMDoKIAljYXNlIENYMjM4
ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IOgorCWNhc2Ug
Q1gyMzg4NV9CT0FSRF9DT01QUk9fVklERU9NQVRFX0U2NTA6CiAJZGVmYXVs
dDoKIAkJdHMyLT5nZW5fY3RybF92YWwgID0gMHhjOyAvKiBTZXJpYWwgYnVz
ICsgcHVuY3R1cmVkIGNsb2NrICovCiAJCXRzMi0+dHNfY2xrX2VuX3ZhbCA9
IDB4MTsgLyogRW5hYmxlIFRTX0NMSyAqLwpAQCAtNjEyLDYgKzYzMiw3IEBA
CiAJY2FzZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxODAwbHA6CiAJ
Y2FzZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNzAwOgogCWNhc2Ug
Q1gyMzg4NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAwX0g6CisJ
Y2FzZSBDWDIzODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1MDoKIAkJ
cmVxdWVzdF9tb2R1bGUoImN4MjU4NDAiKTsKIAkJYnJlYWs7CiAJfQpkaWZm
IC1OYXVyIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIz
ODg1L2N4MjM4ODUtZHZiLmMgdjRsLWR2Yl9kZXYvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMKLS0tIHY0bC1kdmIv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZi
LmMJMjAwOC0wOC0zMSAwNzo1NTozMi4wMDAwMDAwMDAgKzEwMDAKKysrIHY0
bC1kdmJfZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9j
eDIzODg1LWR2Yi5jCTIwMDgtMDktMDUgMDg6MDc6MTkuMDAwMDAwMDAwICsx
MDAwCkBAIC01MDMsNiArNTAzLDcgQEAKIAkJYnJlYWs7CiAJfQogCWNhc2Ug
Q1gyMzg4NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAwX0g6CisJ
Y2FzZSBDWDIzODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1MDoKIAkJ
aTJjX2J1cyA9ICZkZXYtPmkyY19idXNbMF07CiAKIAkJcG9ydC0+ZHZiLmZy
b250ZW5kID0gZHZiX2F0dGFjaCh6bDEwMzUzX2F0dGFjaCwKZGlmZiAtTmF1
ciB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9j
eDIzODg1LmggdjRsLWR2Yl9kZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9jeDIzODg1L2N4MjM4ODUuaAotLS0gdjRsLWR2Yi9saW51eC9kcml2ZXJz
L21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5oCTIwMDgtMDgtMzEgMDc6
NTU6MzIuMDAwMDAwMDAwICsxMDAwCisrKyB2NGwtZHZiX2Rldi9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5oCTIwMDgtMDkt
MDUgMDg6MDc6MTkuMDAwMDAwMDAwICsxMDAwCkBAIC02Nyw2ICs2Nyw3IEBA
CiAjZGVmaW5lIENYMjM4ODVfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl83X0RV
QUxfRVhQIDEwCiAjZGVmaW5lIENYMjM4ODVfQk9BUkRfRFZJQ09fRlVTSU9O
SERUVl9EVkJfVF9EVUFMX0VYUCAxMQogI2RlZmluZSBDWDIzODg1X0JPQVJE
X0xFQURURUtfV0lORkFTVF9QWERWUjMyMDBfSCAxMgorI2RlZmluZSBDWDIz
ODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1MCAxMwogCiAvKiBDdXJy
ZW50bHkgdW5zdXBwb3J0ZWQgYnkgdGhlIGRyaXZlcjogUEFML0gsIE5UU0Mv
S3IsIFNFQ0FNIEIvRy9IL0xDICovCiAjZGVmaW5lIENYMjM4ODVfTk9STVMg
KFwKZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlk
ZW8vY3gyNTg0MC9jeDI1ODQwLWNvcmUuYyB2NGwtZHZiX2Rldi9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL2N4MjU4NDAvY3gyNTg0MC1jb3JlLmMKLS0t
IHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDI1ODQwL2N4
MjU4NDAtY29yZS5jCTIwMDgtMDgtMzEgMDc6NTU6MzIuMDAwMDAwMDAwICsx
MDAwCisrKyB2NGwtZHZiX2Rldi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4MjU4NDAvY3gyNTg0MC1jb3JlLmMJMjAwOC0wOS0wNSAwODowODowNC4w
MDAwMDAwMDAgKzEwMDAKQEAgLTE0MzgsMTEgKzE0MzgsMTEgQEAKIAlzdGF0
ZS0+aWQgPSBpZDsKIAlzdGF0ZS0+cmV2ID0gZGV2aWNlX2lkOwogCi0JaWYg
KHN0YXRlLT5pc19jeDIzODg1KSB7CisvLwlpZiAoc3RhdGUtPmlzX2N4MjM4
ODUpIHsKIAkJLyogRHJpdmUgR1BJTzIgZGlyZWN0aW9uIGFuZCB2YWx1ZXMg
Ki8KLQkJY3gyNTg0MF93cml0ZShjbGllbnQsIDB4MTYwLCAweDFkKTsKLQkJ
Y3gyNTg0MF93cml0ZShjbGllbnQsIDB4MTY0LCAweDAwKTsKLQl9CisvLwkJ
Y3gyNTg0MF93cml0ZShjbGllbnQsIDB4MTYwLCAweDFkKTsKKy8vCQljeDI1
ODQwX3dyaXRlKGNsaWVudCwgMHgxNjQsIDB4MDApOworLy8JfQogCiAJcmV0
dXJuIDA7CiB9Cg==

--_----------=_1220570817310811
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1220570817310811--
