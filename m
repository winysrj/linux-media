Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KYff3-0004qe-FI
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 13:27:35 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	A26DA180021D
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 11:26:49 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1219922809245700"
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>, jackden <jackden@gmail.com>
Date: Thu, 28 Aug 2008 21:26:49 +1000
Message-Id: <20080828112649.8DAF511581F@ws1-7.us4.outblaze.com>
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

--_----------=_1219922809245700
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"


> ----- Original Message -----
> From: "Thomas Goerke" <tom@goeng.com.au>
> To: "'Steven Toth'" <stoth@linuxtv.org>
> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and anal=
og TV/FM capture card
> Date: Thu, 28 Aug 2008 08:40:21 +0800
>
>
> >
> > http://steventoth.net/ReverseEngineering/PCI/
> >
> > This was the version I originally added cx23885/7/8 support to.
> >
> > It assumes dscaler is installed.
> >
> > - Steve
> I have updated http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F to
> include the Register dumps. Note that I was unable to get the Compro FM
> Tuner Application to work correctly even after several reboots.  For some
> reason the FM tuner application starts, scans through all the channels and
> then hangs.  I have included the register dump for this state but cannot
> guarantee that the register values are correct.  Analog and Digital TV wo=
rk
> fine.
>
> Let me know if you need anything else.
>
> Thanks
>
> Tom

>

Tom, Jackden,

Please find attached a patch that should add support for the DVB side of th=
is card.  Please=20
follow the following to the dot and provide the outputs requested, this wil=
l ensure that I=20
capture all possible issues as soon as possible (and yes I do expect at lea=
st one issue).

1) Ensure that you have everything installed to build the v4l-dvb tree (usu=
ally the kernel=20
headers, build-essentials and patch)

2) Download and extract:
http://linuxtv.org/hg/~stoth/cx23885-leadtek/archive/837860b92af5.tar.bz2

3) Download attached patch to the same directory as the above file.

4) Open up a terminal into the directory of the extracted files and apply t=
he patch with this=20
command:
patch -p1 < ../Compro_VideoMate_E650.patch

5) Make, install:
make;
sudo make install

6) Download the firmware (see=20
http://linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Fi=
rmware)

7) Now this is going to sound weird (for linux) but it puts the card in a k=
nown state for me to=20
work from:
Turn the computer off, count to 10 and turn back on (no a reset will not do=
 what I need). Ensure=20
windows does NOT load, before going into Linux, if it does turn it back off=
 again.

8) Provide the dmesg for the lines after:
"Linux video capture interface: v2.00"

9) If no errors try scanning for channels (see http://linuxtv.org/wiki/inde=
x.php/Scan if you are=20
unsure how do this). If this outputs tv channels then so far so good.

10) Open up your favourite player (ensure the channels config is the correc=
t directory e.g. for=20
xine ~/.xine/) and try and watch a channel.

11) Provide output of dmesg (only the continuation from the previous dmesg =
output).

Now if at any stage it doesn't work here are a few things that you can try =
(make sure you let me=20
know which ones you did try):
a) Perform a computer restart (soft restart - a restart controlled by the c=
omputer, not using=20
any of the buttons on the front), and load windows ensure the card is worki=
ng by tuning to DVB=20
and then perform a soft restart into linux and resume at step above that ca=
used errors.  This is=20
typically going to solve an issue where you cannot get past step 9.

b) Turn debugging on for the following modules:
tuner_xc2028
cx23885
zl10353
This is usually performed in: /etc/modprobe.d/options (this is what ubuntu =
has) by setting debug=20
=3D 1. An example line is:
options cx23885 debug=3D1
Now go back to step 7 and try again when you run into a error message or un=
able to do the above=20
provide the dmesg output as referred to in Step 11.

Thanks

Stephen


--=20
Nothing says Labor Day like 500hp of American muscle
Visit OnCars.com today.


--_----------=_1219922809245700
Content-Disposition: attachment; filename="Compro_VideoMate_E650.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="Compro_VideoMate_E650.patch"

ZGlmZiAtTmF1ciBjeDIzODg1LWxlYWR0ZWsvbGludXgvRG9jdW1lbnRhdGlv
bi92aWRlbzRsaW51eC9DQVJETElTVC5jeDIzODg1IGN4MjM4ODUtbGVhZHRl
a19kZXYvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElT
VC5jeDIzODg1Ci0tLSBjeDIzODg1LWxlYWR0ZWsvbGludXgvRG9jdW1lbnRh
dGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5jeDIzODg1CTIwMDgtMDgtMjcg
MTY6NDA6MTQuMDAwMDAwMDAwICsxMDAwCisrKyBjeDIzODg1LWxlYWR0ZWtf
ZGV2L2xpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80bGludXgvQ0FSRExJU1Qu
Y3gyMzg4NQkyMDA4LTA4LTI3IDE2OjUyOjU2LjAwMDAwMDAwMCArMTAwMApA
QCAtMTEsMyArMTEsNCBAQAogIDEwIC0+IERWaUNPIEZ1c2lvbkhEVFY3IER1
YWwgRXhwcmVzcyAgICAgICAgICAgICAgICAgICAgICBbMThhYzpkNjE4XQog
IDExIC0+IERWaUNPIEZ1c2lvbkhEVFYgRFZCLVQgRHVhbCBFeHByZXNzICAg
ICAgICAgICAgICAgICBbMThhYzpkYjc4XQogIDEyIC0+IExlYWR0ZWsgV2lu
ZmFzdCBQeERWUjMyMDAgSCAgICAgICAgICAgICAgICAgICAgICAgICBbMTA3
ZDo2NjgxXQorIDEzIC0+IENvbXBybyBWaWRlb01hdGUgRTY1MAkJCQkgICBb
MTg1YjplODAwXQpkaWZmIC1OYXVyIGN4MjM4ODUtbGVhZHRlay9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1jYXJkcy5jIGN4
MjM4ODUtbGVhZHRla19kZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9j
eDIzODg1L2N4MjM4ODUtY2FyZHMuYwotLS0gY3gyMzg4NS1sZWFkdGVrL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRz
LmMJMjAwOC0wOC0yNyAxNjo0MDoxNS4wMDAwMDAwMDAgKzEwMDAKKysrIGN4
MjM4ODUtbGVhZHRla19kZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9j
eDIzODg1L2N4MjM4ODUtY2FyZHMuYwkyMDA4LTA4LTI3IDE2OjUyOjU0LjAw
MDAwMDAwMCArMTAwMApAQCAtMTU5LDYgKzE1OSwxMCBAQAogCQkubmFtZQkJ
PSAiTGVhZHRlayBXaW5mYXN0IFB4RFZSMzIwMCBIIiwKIAkJLnBvcnRjCQk9
IENYMjM4ODVfTVBFR19EVkIsCiAJfSwKKwlbQ1gyMzg4NV9CT0FSRF9DT01Q
Uk9fVklERU9NQVRFX0U2NTBdID0geworCQkubmFtZQkJPSAiQ29tcHJvIFZp
ZGVvTWF0ZSBFNjUwIiwKKwkJLnBvcnRjCQk9IENYMjM4ODVfTVBFR19EVkIs
CisJfSwKIH07CiBjb25zdCB1bnNpZ25lZCBpbnQgY3gyMzg4NV9iY291bnQg
PSBBUlJBWV9TSVpFKGN4MjM4ODVfYm9hcmRzKTsKIApAQCAtMjM4LDYgKzI0
MiwxMCBAQAogCQkuc3VidmVuZG9yID0gMHgxMDdkLAogCQkuc3ViZGV2aWNl
ID0gMHg2NjgxLAogCQkuY2FyZCAgICAgID0gQ1gyMzg4NV9CT0FSRF9MRUFE
VEVLX1dJTkZBU1RfUFhEVlIzMjAwX0gsCisJfSwgeworCQkuc3VidmVuZG9y
ID0gMHgxODViLAorCQkuc3ViZGV2aWNlID0gMHhlODAwLAorCQkuY2FyZCAg
ICAgID0gQ1gyMzg4NV9CT0FSRF9DT01QUk9fVklERU9NQVRFX0U2NTAsCiAJ
fSwKIH07CiBjb25zdCB1bnNpZ25lZCBpbnQgY3gyMzg4NV9pZGNvdW50ID0g
QVJSQVlfU0laRShjeDIzODg1X3N1Ymlkcyk7CkBAIC0zNTgsNiArMzY2LDcg
QEAKIAljYXNlIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hWUjE1MDA6CiAJ
Y2FzZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNTAwUToKIAljYXNl
IENYMjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IOgor
CWNhc2UgQ1gyMzg4NV9CT0FSRF9DT01QUk9fVklERU9NQVRFX0U2NTA6CiAJ
CS8qIFR1bmVyIFJlc2V0IENvbW1hbmQgKi8KIAkJYml0bWFzayA9IDB4MDQ7
CiAJCWJyZWFrOwpAQCAtNTEwLDYgKzUxOSwxNiBAQAogCQltZGVsYXkoMjAp
OwogCQljeF9zZXQoR1AwX0lPLCAweDAwMDQwMDA0KTsKIAkJYnJlYWs7CisJ
Y2FzZSBDWDIzODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1MDoKKwkJ
LyogR1BJTy0yICB4YzMwMDggdHVuZXIgcmVzZXQgKi8KKworCQkvKiBQdXQg
dGhlIHBhcnRzIGludG8gcmVzZXQgYW5kIGJhY2sgKi8KKwkJY3hfc2V0KEdQ
MF9JTywgMHgwMDA0MDAwMCk7CisJCW1kZWxheSgyMCk7CisJCWN4X2NsZWFy
KEdQMF9JTywgMHgwMDAwMDAwNCk7CisJCW1kZWxheSgyMCk7CisJCWN4X3Nl
dChHUDBfSU8sIDB4MDAwNDAwMDQpOworCQlicmVhazsKIAl9CiB9CiAKQEAg
LTU5OCw2ICs2MTcsNyBAQAogCWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQUEFV
R0VfSFZSMTcwMDoKIAljYXNlIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hW
UjE0MDA6CiAJY2FzZSBDWDIzODg1X0JPQVJEX0xFQURURUtfV0lORkFTVF9Q
WERWUjMyMDBfSDoKKwljYXNlIENYMjM4ODVfQk9BUkRfQ09NUFJPX1ZJREVP
TUFURV9FNjUwOgogCWRlZmF1bHQ6CiAJCXRzMi0+Z2VuX2N0cmxfdmFsICA9
IDB4YzsgLyogU2VyaWFsIGJ1cyArIHB1bmN0dXJlZCBjbG9jayAqLwogCQl0
czItPnRzX2Nsa19lbl92YWwgPSAweDE7IC8qIEVuYWJsZSBUU19DTEsgKi8K
ZGlmZiAtTmF1ciBjeDIzODg1LWxlYWR0ZWsvbGludXgvZHJpdmVycy9tZWRp
YS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMgY3gyMzg4NS1sZWFkdGVr
X2Rldi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4
NS1kdmIuYwotLS0gY3gyMzg4NS1sZWFkdGVrL2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWR2Yi5jCTIwMDgtMDgtMjcgMTY6
NDA6MTUuMDAwMDAwMDAwICsxMDAwCisrKyBjeDIzODg1LWxlYWR0ZWtfZGV2
L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWR2
Yi5jCTIwMDgtMDgtMjcgMTY6NTE6MzkuMDAwMDAwMDAwICsxMDAwCkBAIC01
MDMsNiArNTAzLDcgQEAKIAkJYnJlYWs7CiAJfQogCWNhc2UgQ1gyMzg4NV9C
T0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAwX0g6CisJY2FzZSBDWDIz
ODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1MDoKIAkJaTJjX2J1cyA9
ICZkZXYtPmkyY19idXNbMF07CiAKIAkJcG9ydC0+ZHZiLmZyb250ZW5kID0g
ZHZiX2F0dGFjaCh6bDEwMzUzX2F0dGFjaCwKZGlmZiAtTmF1ciBjeDIzODg1
LWxlYWR0ZWsvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4
MjM4ODUuaCBjeDIzODg1LWxlYWR0ZWtfZGV2L2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LmgKLS0tIGN4MjM4ODUtbGVhZHRl
ay9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5o
CTIwMDgtMDgtMjcgMTY6NDA6MTUuMDAwMDAwMDAwICsxMDAwCisrKyBjeDIz
ODg1LWxlYWR0ZWtfZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gy
Mzg4NS9jeDIzODg1LmgJMjAwOC0wOC0yNyAxNjo0MjowNi4wMDAwMDAwMDAg
KzEwMDAKQEAgLTY3LDYgKzY3LDcgQEAKICNkZWZpbmUgQ1gyMzg4NV9CT0FS
RF9EVklDT19GVVNJT05IRFRWXzdfRFVBTF9FWFAgMTAKICNkZWZpbmUgQ1gy
Mzg4NV9CT0FSRF9EVklDT19GVVNJT05IRFRWX0RWQl9UX0RVQUxfRVhQIDEx
CiAjZGVmaW5lIENYMjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZS
MzIwMF9IIDEyCisjZGVmaW5lIENYMjM4ODVfQk9BUkRfQ09NUFJPX1ZJREVP
TUFURV9FNjUwIDEzCiAKIC8qIEN1cnJlbnRseSB1bnN1cHBvcnRlZCBieSB0
aGUgZHJpdmVyOiBQQUwvSCwgTlRTQy9LciwgU0VDQU0gQi9HL0gvTEMgKi8K
ICNkZWZpbmUgQ1gyMzg4NV9OT1JNUyAoXAo=

--_----------=_1219922809245700
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1219922809245700--
