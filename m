Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail11.syd.optusnet.com.au ([211.29.132.192])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lindsay.mathieson@gmail.com>) id 1LRQCv-0004nA-QY
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 13:04:51 +0100
Received: from blackpaw.dyndns.org (c122-108-213-22.rochd4.qld.optusnet.com.au
	[122.108.213.22]) (authenticated sender lindsay.mathieson)
	by mail11.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	n0QC4evR000722
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 23:04:41 +1100
Received: from lindsay-desktop.localnet (unverified [192.168.0.183])
	by blackpaw.dyndns.org (SurgeMail 4.0a) with ESMTP id 316-1769969
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 22:04:40 +1000
To: linux-dvb@linuxtv.org
From: Lindsay Mathieson <lindsay.mathieson@gmail.com>
Date: Mon, 26 Jan 2009 22:04:42 +1000
MIME-Version: 1.0
Message-Id: <200901262204.42649.lindsay.mathieson@gmail.com>
Subject: [linux-dvb] Dual Tuner Devices and udev rules
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0956029047=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0956029047==
Content-Type: multipart/signed;
  boundary="nextPart2647435.9Ors2znfC4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2647435.9Ors2znfC4
Content-Type: multipart/alternative;
  boundary="Boundary-00=_abafJ+/iZ4As/qA"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-00=_abafJ+/iZ4As/qA
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The problem I have with any dual tuner device is that there is no way to=20
differentiate between tuner 0 and tuner 1 when writing a rule, which=20
consequently makes it impossible to write udev rules for such devices.

Would it be possible for the driver to add an attribute that differentiates=
=20
between the tuners on a device? e.g something like:
  ATTRS(tuner)=3D=3D"0"
  ATTRS(tuner)=3D=3D"1"

=46ailing that, is there something clever about udev rules I'm missing?

Thanks - Lindsay

=2D-=20
Lindsay Mathieson
http://blackpaw.jalbum.net/home



--Boundary-00=_abafJ+/iZ4As/qA
Content-Type: text/html;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-=
html40/strict.dtd"><html><head><meta name=3D"qrichtext" content=3D"1" /><st=
yle type=3D"text/css">p, li { white-space: pre-wrap; }</style></head><body =
style=3D" font-family:'DejaVu Sans'; font-size:10pt; font-weight:400; font-=
style:normal;"><p style=3D" margin-top:0px; margin-bottom:0px; margin-left:=
0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">The problem I =
have with any dual tuner device is that there is no way to </p><p style=3D"=
 margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-=
block-indent:0; text-indent:0px;">differentiate between tuner 0 and tuner 1=
 when writing a rule, which </p><p style=3D" margin-top:0px; margin-bottom:=
0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px=
;">consequently makes it impossible to write udev rules for such devices.</=
p><p style=3D"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; =
margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><b=
r></p><p style=3D" margin-top:0px; margin-bottom:0px; margin-left:0px; marg=
in-right:0px; -qt-block-indent:0; text-indent:0px;">Would it be possible fo=
r the driver to add an attribute that differentiates </p><p style=3D" margi=
n-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-=
indent:0; text-indent:0px;">between the tuners on a device? e.g something l=
ike:</p><p style=3D" margin-top:0px; margin-bottom:0px; margin-left:0px; ma=
rgin-right:0px; -qt-block-indent:0; text-indent:0px;">  ATTRS(tuner)=3D=3D"=
0"</p><p style=3D" margin-top:0px; margin-bottom:0px; margin-left:0px; marg=
in-right:0px; -qt-block-indent:0; text-indent:0px;">  ATTRS(tuner)=3D=3D"1"=
</p><p style=3D"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px=
; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">=
<br></p><p style=3D" margin-top:0px; margin-bottom:0px; margin-left:0px; ma=
rgin-right:0px; -qt-block-indent:0; text-indent:0px;">Failing that, is ther=
e something clever about udev rules I'm missing?</p><p style=3D"-qt-paragra=
ph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-r=
ight:0px; -qt-block-indent:0; text-indent:0px;"><br></p><p style=3D" margin=
=2Dtop:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block=
=2Dindent:0; text-indent:0px;">Thanks - Lindsay</p><p style=3D"-qt-paragrap=
h-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-ri=
ght:0px; -qt-block-indent:0; text-indent:0px;"><br></p><p style=3D" margin-=
top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-in=
dent:0; text-indent:0px;">-- </p><p style=3D" margin-top:0px; margin-bottom=
:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0p=
x;">Lindsay Mathieson</p><p style=3D" margin-top:0px; margin-bottom:0px; ma=
rgin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">http=
://blackpaw.jalbum.net/home</p><p style=3D"-qt-paragraph-type:empty; margin=
=2Dtop:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block=
=2Dindent:0; text-indent:0px;"><br></p><p style=3D"-qt-paragraph-type:empty=
; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt=
=2Dblock-indent:0; text-indent:0px;"><br></p></body></html>
--Boundary-00=_abafJ+/iZ4As/qA--

--nextPart2647435.9Ors2znfC4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl9ptoACgkQNbLM9wS4sYfIggCeLq9g5z/03CjTkKL+N2tJYeG0
/Z4An1YdsGjc/ROM7I1cz2lMrPnf3TeU
=LTmY
-----END PGP SIGNATURE-----

--nextPart2647435.9Ors2znfC4--


--===============0956029047==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0956029047==--
