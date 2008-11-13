Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L0QXR-0005nq-Nf
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 01:58:26 +0100
Date: Thu, 13 Nov 2008 01:57:52 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0811121131k2a6f35dfm9da8de305dfd199b@mail.gmail.com>
Message-ID: <20081113005752.36210@gmx.net>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
	<b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
	<c74595dc0810281320r9ef1a1cw172a36738c8a4e8@mail.gmail.com>
	<c74595dc0810301510t5ae3df6fg28c6a62e999aed83@mail.gmail.com>
	<c74595dc0811121131k2a6f35dfm9da8de305dfd199b@mail.gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Some more updates for scan-s2:
> - Fixed skip count specified by "-k" option (skipped one message less than
> specified).
> - Removed dumping (null) provider name.
> - Fixed DVB-T tuning. Thanks to Hans Werner.
> - Fixed some network ID output problems. Thanks to Oleg Roitburd.
> - Added options to specify "S1" and "S2" entries in frequency file that
> will
> use DVB-S and DVB-S2 scan modes respectively.
> - Added "-D" option to disable scanning of some modes. "-D S1" will
> disable
> DVB-S scan, "-D S2" will disable DVB-S2 scan.
> - Added 3/5 and 9/10 FEC options. Thanks to Michael Verbraak.
> =

> In my TODO list so far:
> - Revise and add diseqc motor support patch from Hans Werner.

Thanks.

> - Revise and add few more patches sent by different people.
> - Revise NIT message parsing to figure out why it doesn't add transponders
> with correct delivery system.

Does this fix it?

diff -r 40368fdba59a scan.c
--- a/scan.c
+++ b/scan.c
@@ -403,7 +403,7 @@ static void parse_satellite_delivery_sys
                return;
        }

-       if(((buf[8] >> 1) & 0x01) =3D=3D 0) {
+       if(((buf[8] >> 2) & 0x01) =3D=3D 0) {
                t->delivery_system =3D SYS_DVBS;
        }
        else {

In the first patch I sent yesterday I used an equivalent switch statement i=
nstead:
       switch ( getBits(buf,69,1) ) {

> - Add UTF-8 channels encoding support.
> =

> Please test the latest version of scan-s2 from:
> http://mercurial.intuxication.org/hg/scan-s2/
> =

> Let me know if something doesn't work as it should.
> =

> Thanks.
> Alex.
> =


-- =

Release early, release often.

Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! =

Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
