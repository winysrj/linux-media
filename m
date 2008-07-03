Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s19.bay0.hotmail.com ([65.54.246.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlli@hotmail.com>) id 1KEPT4-0002G4-78
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 16:07:29 +0200
Message-ID: <BAY136-W4A1D1267A59B878FF68C7D2980@phx.gbl>
From: Alistair M <tlli@hotmail.com>
To: Antti Palosaari <crope@iki.fi>
Date: Fri, 4 Jul 2008 00:06:51 +1000
In-Reply-To: <486CDC62.5060605@iki.fi>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
	<486B3617.3070702@iki.fi> <BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
	<486CB3D2.3000702@iki.fi> <BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
	<486CCF9E.7070109@iki.fi> <BAY136-W13F407BF8A0BCA5BB251F6D2980@phx.gbl>
	<486CDC62.5060605@iki.fi>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0072295029=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0072295029==
Content-Type: multipart/alternative;
	boundary="_f6df5954-c090-42c5-ba31-127073497e7a_"

--_f6df5954-c090-42c5-ba31-127073497e7a_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Ah great news...!=20

> Date: Thu=2C 3 Jul 2008 17:04:18 +0300
> From: crope@iki.fi
> To: tlli@hotmail.com
> CC: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
>=20
> Alistair M wrote:
> > Hello Antii=2C
> > I have compiled in your latest build.
> >=20
> > What seems to be happening is=2C in the terminal or even a text editor=
=2C=20
> > when i press any button on the remote control=2C that character (eg. 0)=
=20
> > will be repeated as text on the terminal or text editor. So if i for=20
> > instance press the key 0 on the remote=2C while i have a text editor op=
en=2C=20
> > it enters the number 0 continuously=2C like this:
> > 000000000000000000000000000000... in the editor=2C or terminal window=
=2C or=20
> > any text input field.
>=20
> hmm=2C I think I know the reason. Actually this is due to hardware bug. I=
=20
> think I have older silicon revision that returns error code when polling=
=20
> remote events and there is no event. You have a newer silicon that does=20
> not return error any more. Current remote polling code in the driver=20
> relies that error code. I will fix that soon=2C it is easy to fix.
>=20
> > Does that make sense...
> > Its past midnight here in Australia so i have to get to bed as i have t=
o=20
> > work tomorrow=2C i'll email back in the morning.
> > Thank you Antii.
> > Alistair.
>=20
> regards
> Antti
> --=20
> http://palosaari.fi/

_________________________________________________________________
It's simple! Sell your car for just $30 at CarPoint.com.au
http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fsecure%2Dau%2Eimrworldwid=
e%2Ecom%2Fcgi%2Dbin%2Fa%2Fci%5F450304%2Fet%5F2%2Fcg%5F801459%2Fpi%5F1004813=
%2Fai%5F859641&_t=3D762955845&_r=3Dtig_OCT07&_m=3DEXT=

--_f6df5954-c090-42c5-ba31-127073497e7a_
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
<body class=3D'hmmessage'>
Ah great news...! <br><br>&gt=3B Date: Thu=2C 3 Jul 2008 17:04:18 +0300<br>=
&gt=3B From: crope@iki.fi<br>&gt=3B To: tlli@hotmail.com<br>&gt=3B CC: linu=
x-dvb@linuxtv.org<br>&gt=3B Subject: Re: [linux-dvb] Leadtek WinFast DTV Do=
ngle Gold Remote issues<br>&gt=3B <br>&gt=3B Alistair M wrote:<br>&gt=3B &g=
t=3B Hello Antii=2C<br>&gt=3B &gt=3B I have compiled in your latest build.<=
br>&gt=3B &gt=3B <br>&gt=3B &gt=3B What seems to be happening is=2C in the =
terminal or even a text editor=2C <br>&gt=3B &gt=3B when i press any button=
 on the remote control=2C that character (eg. 0) <br>&gt=3B &gt=3B will be =
repeated as text on the terminal or text editor. So if i for <br>&gt=3B &gt=
=3B instance press the key 0 on the remote=2C while i have a text editor op=
en=2C <br>&gt=3B &gt=3B it enters the number 0 continuously=2C like this:<b=
r>&gt=3B &gt=3B 000000000000000000000000000000... in the editor=2C or termi=
nal window=2C or <br>&gt=3B &gt=3B any text input field.<br>&gt=3B <br>&gt=
=3B hmm=2C I think I know the reason. Actually this is due to hardware bug.=
 I <br>&gt=3B think I have older silicon revision that returns error code w=
hen polling <br>&gt=3B remote events and there is no event. You have a newe=
r silicon that does <br>&gt=3B not return error any more. Current remote po=
lling code in the driver <br>&gt=3B relies that error code. I will fix that=
 soon=2C it is easy to fix.<br>&gt=3B <br>&gt=3B &gt=3B Does that make sens=
e...<br>&gt=3B &gt=3B Its past midnight here in Australia so i have to get =
to bed as i have to <br>&gt=3B &gt=3B work tomorrow=2C i'll email back in t=
he morning.<br>&gt=3B &gt=3B Thank you Antii.<br>&gt=3B &gt=3B Alistair.<br=
>&gt=3B <br>&gt=3B regards<br>&gt=3B Antti<br>&gt=3B -- <br>&gt=3B http://p=
alosaari.fi/<br><br /><hr />Find a new job on Seek <a href=3D'http://a.nine=
msn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fninemsn%2Eseek%2Ecom%2Eau%2F%3Ftrackin=
g%3Dsk%3Amtl%3Ask%3Anine%3A0%3Ahot%3Atext&_t=3D764565661&_r=3DJAN08_endtext=
_increase&_m=3DEXT' target=3D'_new'>Increase your salary. </a></body>
</html>=

--_f6df5954-c090-42c5-ba31-127073497e7a_--


--===============0072295029==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0072295029==--
