Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s33.blu0.hotmail.com ([65.55.116.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <db260179@hotmail.com>) id 1KkcWk-0004zd-AX
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 12:32:22 +0200
Message-ID: <BLU116-W122752EF5297963897FDE5C2430@phx.gbl>
From: dabby bentam <db260179@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 30 Sep 2008 10:31:47 +0000
MIME-Version: 1.0
Subject: [linux-dvb] Adding remote support to Avermedia Super 007 - more
	info needed!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1873095306=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1873095306==
Content-Type: multipart/alternative;
	boundary="_7f5a1b34-8cd8-4bef-8a0d-d6634a7727f5_"

--_7f5a1b34-8cd8-4bef-8a0d-d6634a7727f5_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I'm currently trying to get remote support added to the Avermedia Super 007=
 card.

I've turned the ir_debug on and gpio tracking on and enabled i2c_scan. I've=
 added an entry in the saa7134-cards.c and saa7134-input.c - copying the se=
ttings from other avermedia cards.

The polling setting makes the card print out loads of ir_builder settings=
=2C removing the setting no output! - from this i am assuming that this car=
d has no gpio setting? - possible i2c?

I've used regspy (from dscaler) to determine the GPIO STATUS and MASK value=
. Turning on/off the remote in windows has no value change? - does it chang=
e?

Any guidance on how to determine the ir code? - without the manufacture cod=
e book.

Thanks

David Bentham

_________________________________________________________________
Make a mini you and download it into Windows Live Messenger
http://clk.atdmt.com/UKM/go/111354029/direct/01/=

--_7f5a1b34-8cd8-4bef-8a0d-d6634a7727f5_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'><div style=3D"text-align: left=3B">I'm currently =
trying to get remote support added to the Avermedia Super 007 card.<br><br>=
I've turned the ir_debug on and gpio tracking on and enabled i2c_scan. I've=
 added an entry in the saa7134-cards.c and saa7134-input.c - copying the se=
ttings from other avermedia cards.<br><br>The polling setting makes the car=
d print out loads of ir_builder settings=2C removing the setting no output!=
 - from this i am assuming that this card has no gpio setting? - possible i=
2c?<br><br>I've used regspy (from dscaler) to determine the GPIO STATUS and=
 MASK value. Turning on/off the remote in windows has no value change? - do=
es it change?<br><br>Any guidance on how to determine the ir code? - withou=
t the manufacture code book.<br><br>Thanks<br><br>David Bentham<br></div><b=
r /><hr />Try Facebook in Windows Live Messenger! <a href=3D'http://clk.atd=
mt.com/UKM/go/111354030/direct/01/' target=3D'_new'>Try it Now!</a></body>
</html>=

--_7f5a1b34-8cd8-4bef-8a0d-d6634a7727f5_--


--===============1873095306==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1873095306==--
