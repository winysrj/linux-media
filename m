Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail01.syd.optusnet.com.au ([211.29.132.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lindsay.mathieson@gmail.com>) id 1LU5YL-0007hd-16
	for linux-dvb@linuxtv.org; Mon, 02 Feb 2009 21:37:58 +0100
Received: from blackpaw.dyndns.org (c122-108-213-22.rochd4.qld.optusnet.com.au
	[122.108.213.22]) (authenticated sender lindsay.mathieson)
	by mail01.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	n12KblEC026731
	for <linux-dvb@linuxtv.org>; Tue, 3 Feb 2009 07:37:47 +1100
From: Lindsay Mathieson <lindsay.mathieson@gmail.com>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Date: Tue, 3 Feb 2009 06:37:39 +1000
References: <546B4176F0487A4CBA62FC16EFC1D9D6026FC2@EXCHANGE.joratech.com>
	<4987568A.6060504@iki.fi>
In-Reply-To: <4987568A.6060504@iki.fi>
MIME-Version: 1.0
Message-Id: <200902030637.40168.lindsay.mathieson@gmail.com>
Cc: Andrew Williams <andrew.williams@joratech.com>
Subject: Re: [linux-dvb]
 =?iso-8859-1?q?KWorld_PlusTV_Dual_DVB-T_Stick_=28DVB-?=
 =?iso-8859-1?q?T_399U=29_/_AF9015_-=09Dual_tuner_enabled_by_default_=3DBa?=
 =?iso-8859-1?q?d_signal_reception?=
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1500838139=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1500838139==
Content-Type: multipart/signed;
  boundary="nextPart1972300.WJWavdUU2r";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1972300.WJWavdUU2r
Content-Type: multipart/alternative;
  boundary="Boundary-00=_Um1hJ+I3XZb5P0l"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-00=_Um1hJ+I3XZb5P0l
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Feb 2009 06:24:42 am Antti Palosaari wrote:
> Yes, it really looks like there is some sensitivity drop when both
> tuners are enabled. However in my understanding tuner #1 in dual mode
> have almost same performance than tuner #0 in single mode. Also current
> MXL5005S tuner driver has not best performance...

Yes, I'd noticed that. My TT works fine for most channels with both tuners=
=20
except for one (SBS) which has less signal strength, both tuners fail on it=
 -=20
my single tuners don't.

Another dual tuner (Lifeview TV Walker) has similar problems.

All my tuners are feed off a powered splitter so I presume the problem with=
 the=20
dual tuners are they split the signal internally.

I'll give the alternative driver you posted a go.

=2D-=20
Lindsay Mathieson
http://blackpaw.jalbum.net/home

--Boundary-00=_Um1hJ+I3XZb5P0l
Content-Type: text/html;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd"><html><head><meta name="qrichtext" content="1" /><style type="text/css">p, li { white-space: pre-wrap; }</style></head><body style=" font-family:'DejaVu Sans'; font-size:10pt; font-weight:400; font-style:normal;">On Tue, 3 Feb 2009 06:24:42 am Antti Palosaari wrote:<br>
&gt; Yes, it really looks like there is some sensitivity drop when both<br>
&gt; tuners are enabled. However in my understanding tuner #1 in dual mode<br>
&gt; have almost same performance than tuner #0 in single mode. Also current<br>
&gt; MXL5005S tuner driver has not best performance...<br>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><br></p>Yes, I'd noticed that. My TT works fine for most channels with both tuners except for one (SBS) which has less signal strength, both tuners fail on it - my single tuners don't.<br>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><br></p>Another dual tuner (Lifeview TV Walker) has similar problems.<br>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><br></p>All my tuners are feed off a powered splitter so I presume the problem with the dual tuners are they split the signal internally.<br>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><br></p>I'll give the alternative driver you posted a go.<br>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><br></p>-- <br>
Lindsay Mathieson<br>
http://blackpaw.jalbum.net/home</p></body></html>
--Boundary-00=_Um1hJ+I3XZb5P0l--

--nextPart1972300.WJWavdUU2r
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmHWZQACgkQNbLM9wS4sYdDXgCgg8kM9F0ChdDD2ge0a7gHCJ1L
ubUAniJ51NZ0TgsIZVcXR9Ae1vaIUOoZ
=5ssl
-----END PGP SIGNATURE-----

--nextPart1972300.WJWavdUU2r--


--===============1500838139==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1500838139==--
