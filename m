Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Kc9KV-00061I-Op
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 03:44:46 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	CBFD01800AF5
	for <linux-dvb@linuxtv.org>; Sun,  7 Sep 2008 01:44:08 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1220751848159823"
MIME-Version: 1.0
From: stev391@email.com
To: jackden@gmail.com
Date: Sun, 7 Sep 2008 11:44:08 +1000
Message-Id: <20080907014408.A68CD32675A@ws1-8.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
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

--_----------=_1220751848159823
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"


> ----- Original Message -----
> From: jackden@gmail.com
> To: stev391@email.com
> Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and anal=
og TV/FM capture card
> Date: Fri, 5 Sep 2008 23:32:42 +0800
>
>
> 2008/9/5, stev391@email.com <stev391@email.com>:
> >
>   ---Snip---
> >> [  274.439468] xc2028 3-0061: seek_firmware called, want type=3DD2620
> >> DTV6 (28), id 0000000000000000.
> >> [  274.439472] xc2028 3-0061: Can't find firmware for type=3DD2620 DTV6
> >> (28), id 0000000000000000.
> >> [  274.439475] xc2028 3-0061: load_firmware called
> >> [  274.439477] xc2028 3-0061: seek_firmware called, want type=3DD2620
> >> DTV6 (28), id 0000000000000000.
> >> [  274.439481] xc2028 3-0061: Can't find firmware for type=3DD2620 DTV6
> >> (28), id 0000000000000000.
> >>
> >> hmm...
> >> have error message, Can't find firmware for want type=3DD2620 DTV6
> >>
> >> ----=3DJackden in Google=3D----
> >> --=3DJackden@Gmail.com=3D--
> >
> > Jackden,
> >
> > This seems to be an issue in tuner_xc2028 module.  I can reproduce this=
 on
> > my computer and are currently looking into it.
> >
> > The firmware type it should be loading in this situation is D2620 DTV6 =
QAM,
> > as this is the only one available that partially matches the criteria.
> >
> > Can you also look at the IC's on the board, and try and identify the ee=
prom
> > and possibly grab the data off it.
> >
> > Regards,
> > Stephen.
> >
> > --
> > Be Yourself @ mail.com!
> > Choose From 200+ Email Addresses
> > Get a Free Account at www.mail.com
> >
> Stephen,
>    I updated chip's image on the board in wiki.
> (http://linuxtv.org/wiki/index.php/Compro_VideoMate_E650#Other_images)
> I can't look at the IC's on E650 board.
> What can i do,now?
>
> ----=3DJackden in Google=3D----
> --=3DJackden@Gmail.com=3D--

Jackden,

Attached is a patch that you should apply to the v4l-dvb tree that fixes th=
e firmware load=20
issue.  It is a quick fix, and is not the ideal solution (Does not break ot=
her firmwares, but=20
should be automatically found).  I will have to find a better way of achiev=
ing this, but for now=20
it should allow you to test my patches for the Compro VideoMate series.

So apply this patch then one of the previously provided patches for the Com=
pro VideoMate,=20
providing results as requested. (Repeat for each of the 3 previous patches).

Regards,

Stephen


--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1220751848159823
Content-Disposition: attachment; filename="D2620_DTV6_QAM_fix.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="D2620_DTV6_QAM_fix.patch"

ZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9u
L3R1bmVycy90dW5lci14YzIwMjguYyB2NGwtZHZiX3R1bmVyX2Z3X2ZpeC9s
aW51eC9kcml2ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMvdHVuZXIteGMyMDI4
LmMKLS0tIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVu
ZXJzL3R1bmVyLXhjMjAyOC5jCTIwMDgtMDgtMDQgMTg6NDM6MjguMDAwMDAw
MDAwICsxMDAwCisrKyB2NGwtZHZiX3R1bmVyX2Z3X2ZpeC9saW51eC9kcml2
ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMvdHVuZXIteGMyMDI4LmMJMjAwOC0w
OS0wNyAxMTozNDo0NC4wMDAwMDAwMDAgKzEwMDAKQEAgLTQzOCw2ICs0Mzgs
MTAgQEAKIAogCXR5cGUgJj0gdHlwZV9tYXNrOwogCisJLyogTWFudWFsbHkg
b3ZlcnJpZGUgdHlwZSBmb3IgRDI2MjAgRFRWNiB3aXRoIEQyNjIwIERUVjYg
UUFNIGFzIHRoaXMgaXMgdGhlIG9ubHkgc29sdXRpb24gKi8KKwlpZiAodHlw
ZSA9PSAoRDI2MjAgKyBEVFY2KSkKKwkJdHlwZSA9IEQyNjIwICsgRFRWNiAr
IFFBTTsKKwogCWlmICghKHR5cGUgJiBTQ09ERSkpCiAJCXR5cGVfbWFzayA9
IH4wOwogCg==

--_----------=_1220751848159823
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1220751848159823--
