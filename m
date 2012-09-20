Return-path: <linux-media-owner@vger.kernel.org>
Received: from rekin10.go2.pl ([193.17.41.30]:51666 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753074Ab2ITHwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 03:52:17 -0400
Received: from moh2-ve3.go2.pl (unknown [10.0.0.117])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 00A17A6A069
	for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 09:52:07 +0200 (CEST)
Received: from o2.pl (unknown [10.0.0.7])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 09:52:06 +0200 (CEST)
Subject: =?UTF-8?Q?[PATCH]_[1/5]_dvb-apps_-_update_scan?=
	=?UTF-8?Q?_file_DVB-S_5E?=
From: =?UTF-8?Q?VoJcEK?= <vojcek@tlen.pl>
To: linux-media@vger.kernel.org
Mime-Version: 1.0
Message-ID: <568f2f8.213d8232.505acb26.eb03a@tlen.pl>
Date: Thu, 20 Sep 2012 09:52:06 +0200
Content-Type: multipart/mixed;
	boundary="==o2.pl-WebMail-f36118a.506e0412.eb040=="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--==o2.pl-WebMail-f36118a.506e0412.eb040==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I=20have=20created=20few=20more=20patches=20for=20DVB-APPS.=20I=20believe=
=20that=20even=20now=20in=20the=20age=20of=20blidscans=20it=20is=20better=
=20to=20just=20have=20somewhat=20up=20to=20date=20list=20to=20have=20curr=
ent=20directories=20scanned=20quickly.=20My=20first=20patch=20for=20Hotbi=
rd=20went=20missing=20so=20far=20as=20some=20filter=20have=20that=20retur=
ned=20probably=20because=20of=20the=20links=20to=20the=20Kingofsat=20I=20=
wrote=20to=20the=20postmaster=20and=20it=20should=20return=20in=20a=20bit=
=20if=20not=20I'll=20send=20it=20again=20in=20few=20days.

In=20the=20meantime=20here=20are=20patches=20for=20few=20more=20sattelite=
s.=20I=20would=20like=20to=20prepare=20next=20listing=20for=20Astra=2028E=
=20but=20I=20must=20ask=20what=20do=20You=20guys=20think=20about=20having=
=20it=20split=20into=202=20separate=20listings=20its=20own=20for=20Astra=20=
1N=20and=202A,B.

The=20plus=20of=20that=20is=20that=20people=20that=20are=20(just=20like=20=
me)=20out=20of=20range=20of=20Astra=201N=20as=20it=20is=20directed=20with=
=20spot=20beam=20at=20UK=20only=20would=20not=20waste=20time=20at=20scann=
ing=20frequencies=20they=20would=20not=20be=20able=20to=20reach=20unless=20=
they=20have=201.8m=20dish=20or=20larger=20and=20just=20to=20a=20scan=20of=
=20Astra=202A=20and=202B=20which=20is=20available=20in=20wider=20area

The=20minus=20is=20that=20if=20one=20is=20living=20in=20the=20UK=20or=20a=
re=20able=20to=20reach=20those=20frequencies=20with=20larger=20dish=20now=
=20would=20have=20to=20do=20a=20scan=20twice=20for=20the=20same=20satteli=
te=20posission.=20
Anyways=20it=20is=20similar=20problem=20to=20the=20one=20with=20Turksat=20=
42E=20where=20programs=20are=20send=20East,=20West=20and=20European=20spo=
ts

Regards,
Wojciech=20Myrda
--==o2.pl-WebMail-f36118a.506e0412.eb040==
Content-Type: text/x-patch;
	name="=?UTF-8?Q?dvb-apps=5Fscan=5F5E.patch?="
Content-Disposition: attachment;
	filename="=?UTF-8?Q?dvb-apps=5Fscan=5F5E.patch?="
Content-Transfer-Encoding: quoted-printable

---=20util/scan/dvb-s/Sirius-5.0E.old=092012-09-20=2008:18:48.548053688=20=
+0200
+++=20util/scan/dvb-s/Sirius-5.0E=092012-09-20=2008:27:49.279133255=20+02=
00
@@=20-1,9=20+1,6=20@@
=20#=20Sirius=205.0E
=20#=20freq=20pol=20sr=20fec
-S=2011215000=20V=206666000=201/2
-S=2011227000=20H=2023145000=203/4
-S=2011247000=20V=2023145000=203/4
-S=2011420000=20H=2023145000=203/4
+S2=2011264000=20V=2030000000=203/4=20AUTO=208PSK
=20S=2011727000=20H=2027500000=205/6
=20S=2011747000=20V=2027500000=203/4
=20S=2011766000=20H=2027500000=203/4
@@=20-27,36=20+24,29=20@@
=20S=2012111000=20H=2027500000=205/6
=20S=2012130000=20V=2027500000=203/4
=20S=2012149000=20H=2027500000=203/4
-S=2012169000=20V=2027500000=203/4
-S=2012188000=20H=2027500000=207/8
-S=2012207000=20V=2027500000=203/4
+S2=2012169000=20V=2027500000=203/4=20AUTO=208PSK
+S2=2012188000=20H=2027500000=203/4=20AUTO=208PSK
+S2=2012207000=20V=2030000000=203/4=20AUTO=208PSK
=20S=2012226000=20H=2025540000=207/8
=20S=2012245000=20V=2027500000=203/4
=20S=2012265000=20H=2027500000=203/4
=20S=2012284000=20V=2027500000=203/4
=20S=2012303000=20H=2025547000=207/8
-S=2012322000=20V=2027500000=203/4
-S=2012341000=20H=2027500000=203/4
-S=2012360000=20V=2027500000=207/8
+S=2012322000=20V=2027500000=207/8
+S2=2012341000=20H=2027500000=203/4=20AUTO=208PSK
+S=2012360000=20V=2027500000=203/4
=20S=2012379000=20H=2027500000=203/4
-S=2012399000=20V=2027500000=202/3
+S2=2012399000=20V=2027500000=203/4=20AUTO=208PSK
=20S=2012418000=20H=2027500000=203/4
-S=2012437000=20V=2027500000=202/3
-S=2012456000=20H=2027500000=203/4
+S2=2012437000=20V=2027500000=203/4=20AUTO=208PSK
+S2=2012456000=20H=2027500000=203/4=20AUTO=208PSK
=20S=2012476000=20V=2027500000=203/4
=20S=2012608000=20H=2027500000=203/4
=20S=2012637000=20H=2014465000=203/4
-S=2012668000=20V=206666000=201/2
=20S=2012672000=20H=203300000=203/4
-S=2012674000=20V=2010000000=203/4
-S=2012678000=20V=2013333000=205/6
-S=2012680000=20H=209404000=203/4
-S=2012685000=20V=204444000=203/4
-S=2012690000=20H=203330000=203/4
+S2=2012682000=20V=201111000=202/3=20AUTO=208PSK
+S=2012687000=20V=206667000=205/6
=20S=2012693000=20V=203333000=205/6
-S=2012701000=20H=206111000=203/4
-S=2012715000=20H=203330000=203/4
-S=2012718000=20V=2023500000=203/4
-S=2012724000=20H=201772000=203/4
-S=2012728000=20V=2019720000=203/4
-S=2012737000=20V=206150000=203/4
+S=2012703000=20V=202963000=203/4
+S=2012718000=20V=202960000=207/8
+S2=2012728000=20V=201480000=209/10=20AUTO=208PSK

--==o2.pl-WebMail-f36118a.506e0412.eb040==--

