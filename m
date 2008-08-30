Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KZFCm-0003Vh-PX
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 03:24:46 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	E966518001A5
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 01:24:07 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1220059447119352"
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>, stev391@email.com,
	'jackden' <jackden@gmail.com>
Date: Sat, 30 Aug 2008 11:24:07 +1000
Message-Id: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
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

--_----------=_1220059447119352
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"


> ----- Original Message -----
> From: "Thomas Goerke" <tom@goeng.com.au>
> To: stev391@email.com, "'jackden'" <jackden@gmail.com>
> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and anal=
og TV/FM capture card
> Date: Thu, 28 Aug 2008 23:12:14 +0800
>
>
>
> > Tom, Jackden,
> >
> > Please find attached a patch that should add support for the DVB side
> > of this card.  Please follow the following to the dot and provide the
> > outputs requested, this will ensure that I capture all possible issues
> > as soon as possible (and yes I do expect at least one issue).
> >
> > 1) Ensure that you have everything installed to build the v4l-dvb tree
> > (usually the kernel headers, build-essentials and patch)
> >
> > 2) Download and extract:
> > http://linuxtv.org/hg/~stoth/cx23885-
> > leadtek/archive/837860b92af5.tar.bz2
> >
> > 3) Download attached patch to the same directory as the above file.
> >
> > 4) Open up a terminal into the directory of the extracted files and
> > apply the patch with this
> > command:
> > patch -p1 < ../Compro_VideoMate_E650.patch
> >
> > 5) Make, install:
> > make;
> > sudo make install
> >
> > 6) Download the firmware (see
> > http://linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_th
> > e_Firmware)
> >
> > 7) Now this is going to sound weird (for linux) but it puts the card in
> > a known state for me to work from:
> > Turn the computer off, count to 10 and turn back on (no a reset will
> > not do what I need). Ensure windows does NOT load, before going into
> > Linux, if it does turn it back off again.
> >
> > 8) Provide the dmesg for the lines after:
> > "Linux video capture interface: v2.00"
> >
> > 9) If no errors try scanning for channels (see
> > http://linuxtv.org/wiki/index.php/Scan if you are unsure how do this).
> > If this outputs tv channels then so far so good.
> >
> > 10) Open up your favourite player (ensure the channels config is the
> > correct directory e.g. for xine ~/.xine/) and try and watch a channel.
> >
> > 11) Provide output of dmesg (only the continuation from the previous
> > dmesg output).
> >
> > Now if at any stage it doesn't work here are a few things that you can
> > try (make sure you let me know which ones you did try):
> > a) Perform a computer restart (soft restart - a restart controlled by
> > the computer, not using any of the buttons on the front), and load
> > windows ensure the card is working by tuning to DVB and then perform a
> > soft restart into linux and resume at step above that caused errors.
> > This is typically going to solve an issue where you cannot get past
> > step 9.
> >
> > b) Turn debugging on for the following modules:
> > tuner_xc2028
> > cx23885
> > zl10353
> > This is usually performed in: /etc/modprobe.d/options (this is what
> > ubuntu has) by setting debug =3D 1. An example line is:
> > options cx23885 debug=3D1
> > Now go back to step 7 and try again when you run into a error message
> > or unable to do the above provide the dmesg output as referred to in
> > Step 11.
> >
> > Thanks
> >
> > Stephen
> >
> Stephen,
>
> Thanks for the latest patch.  FYI, I had previously been experimenting wi=
th
> the Dvico card source so to remove any of the changes I had made I did the
> following:
> 	hg clone http://linuxtv.org/hg/v4l-dvb
> 	cd v4l-dvb
> 	make
> 	sudo make install
> I then followed your instructions and restarted the PC after 10 second
> delay.  Please see below for output.
>
> In terms of debugging I am unable to do a soft restart as I need to swap
> drives over.  I did however enable debugging and you can see the output of
> dmesg at the end of the email.
>
---Snip----
>
> Output from scan:
---Snip---
>
> I then tried to tune to channels using the MythTV backend setup.  I was a=
ble
> to add the card but when I tried to scan all Australian channels none were
> detected.
>
> I then added the debugging option as requested and rebooted with 10 second
> power off on power supply switch ie no power to backplane.
>
> With Debugging On:
> root@quark:/etc/modprobe.d# cat cx23885
> options cx23885 debug=3D1
> root@quark:/etc/modprobe.d# cat zl10353
> options zl10353 debug=3D1
> root@quark:/etc/modprobe.d# cat tuner_xc2028
> options tuner_xc2028 debug=3D1
>
> Output from dmesg:
---Snip---
>
> Again thanks for your help and please let me know if you want me to try
> something else.
>
> Tom

Tom,
(Jackden please try first patch and provide feedback, if that doesn't work =
for your card, then=20
try this and provide feedback)

The second dmesg (with debugging) didn't show me what I was looking for, bu=
t from past=20
experience I will try something else.  I was looking for some dma errors fr=
om the cx23885=20
driver, these usually occured while streaming is being attempted.

Attached to this email is another patch.  The difference between the first =
one and the second=20
one is that I load an extra module (cx25840), which normally is not require=
d for DVB as it is=20
part of the analog side of this card.  This does NOT mean analog will be su=
pported.

As of today the main v4l-dvb can be used with this patch and this means tha=
t the cx23885-leadtek=20
tree will soon disappear. So step 2 above has been modified to: "Check out =
the latest v4l-dvb=20
source".

Other then that step 4 has a different file name for the patch.

Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you hav=
e completed the=20
missing steps already).

If the patch works, please do not stop communicating, as I have to perform =
one more patch to=20
prove that cx25840 is required and my assumptions are correct. Once this is=
 completed I will=20
send it to Steven Toth for inclusion in his test tree. This will need to be=
 tested by you again,=20
and if all is working well after a week or more it will be included into th=
e main tree.

Regards,
Stephen


--=20
Nothing says Labor Day like 500hp of American muscle
Visit OnCars.com today.


--_----------=_1220059447119352
Content-Disposition: attachment; filename="Compro_VideoMate_E650_V0.1.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="Compro_VideoMate_E650_V0.1.patch"

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
eDIzODg1L2N4MjM4ODUtY2FyZHMuYwkyMDA4LTA4LTMwIDEwOjQxOjI1LjAw
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
QEAgLTYxMiw2ICs2MzIsNyBAQAogCWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQ
UEFVR0VfSFZSMTgwMGxwOgogCWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQUEFV
R0VfSFZSMTcwMDoKIAljYXNlIENYMjM4ODVfQk9BUkRfTEVBRFRFS19XSU5G
QVNUX1BYRFZSMzIwMF9IOgorCWNhc2UgQ1gyMzg4NV9CT0FSRF9DT01QUk9f
VklERU9NQVRFX0U2NTA6CiAJCXJlcXVlc3RfbW9kdWxlKCJjeDI1ODQwIik7
CiAJCWJyZWFrOwogCX0KZGlmZiAtTmF1ciBjeDIzODg1LWxlYWR0ZWsvbGlu
dXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMg
Y3gyMzg4NS1sZWFkdGVrX2Rldi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4MjM4ODUvY3gyMzg4NS1kdmIuYwotLS0gY3gyMzg4NS1sZWFkdGVrL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWR2Yi5j
CTIwMDgtMDgtMjcgMTY6NDA6MTUuMDAwMDAwMDAwICsxMDAwCisrKyBjeDIz
ODg1LWxlYWR0ZWtfZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gy
Mzg4NS9jeDIzODg1LWR2Yi5jCTIwMDgtMDgtMjcgMTY6NTE6MzkuMDAwMDAw
MDAwICsxMDAwCkBAIC01MDMsNiArNTAzLDcgQEAKIAkJYnJlYWs7CiAJfQog
CWNhc2UgQ1gyMzg4NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAw
X0g6CisJY2FzZSBDWDIzODg1X0JPQVJEX0NPTVBST19WSURFT01BVEVfRTY1
MDoKIAkJaTJjX2J1cyA9ICZkZXYtPmkyY19idXNbMF07CiAKIAkJcG9ydC0+
ZHZiLmZyb250ZW5kID0gZHZiX2F0dGFjaCh6bDEwMzUzX2F0dGFjaCwKZGlm
ZiAtTmF1ciBjeDIzODg1LWxlYWR0ZWsvbGludXgvZHJpdmVycy9tZWRpYS92
aWRlby9jeDIzODg1L2N4MjM4ODUuaCBjeDIzODg1LWxlYWR0ZWtfZGV2L2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LmgKLS0t
IGN4MjM4ODUtbGVhZHRlay9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4
MjM4ODUvY3gyMzg4NS5oCTIwMDgtMDgtMjcgMTY6NDA6MTUuMDAwMDAwMDAw
ICsxMDAwCisrKyBjeDIzODg1LWxlYWR0ZWtfZGV2L2xpbnV4L2RyaXZlcnMv
bWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LmgJMjAwOC0wOC0yNyAxNjo0
MjowNi4wMDAwMDAwMDAgKzEwMDAKQEAgLTY3LDYgKzY3LDcgQEAKICNkZWZp
bmUgQ1gyMzg4NV9CT0FSRF9EVklDT19GVVNJT05IRFRWXzdfRFVBTF9FWFAg
MTAKICNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9EVklDT19GVVNJT05IRFRWX0RW
Ql9UX0RVQUxfRVhQIDExCiAjZGVmaW5lIENYMjM4ODVfQk9BUkRfTEVBRFRF
S19XSU5GQVNUX1BYRFZSMzIwMF9IIDEyCisjZGVmaW5lIENYMjM4ODVfQk9B
UkRfQ09NUFJPX1ZJREVPTUFURV9FNjUwIDEzCiAKIC8qIEN1cnJlbnRseSB1
bnN1cHBvcnRlZCBieSB0aGUgZHJpdmVyOiBQQUwvSCwgTlRTQy9LciwgU0VD
QU0gQi9HL0gvTEMgKi8KICNkZWZpbmUgQ1gyMzg4NV9OT1JNUyAoXAo=

--_----------=_1220059447119352
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1220059447119352--
