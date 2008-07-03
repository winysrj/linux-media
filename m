Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s5.bay0.hotmail.com ([65.54.246.141])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlli@hotmail.com>) id 1KEPLB-00012E-3E
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 15:59:20 +0200
Message-ID: <BAY136-W13F407BF8A0BCA5BB251F6D2980@phx.gbl>
From: Alistair M <tlli@hotmail.com>
To: Antti Palosaari <crope@iki.fi>
Date: Thu, 3 Jul 2008 23:58:42 +1000
In-Reply-To: <486CCF9E.7070109@iki.fi>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
	<486B3617.3070702@iki.fi> <BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
	<486CB3D2.3000702@iki.fi> <BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
	<486CCF9E.7070109@iki.fi>
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
Content-Type: multipart/mixed; boundary="===============1798174180=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1798174180==
Content-Type: multipart/alternative;
	boundary="_9b6a489e-cfdb-49c7-93fe-4d7dae02f135_"

--_9b6a489e-cfdb-49c7-93fe-4d7dae02f135_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable



Hello Antii=2C
I have compiled in your latest build.

What seems to be happening is=2C in the terminal or even a text editor=2C w=
hen i press any button on the remote control=2C that character (eg. 0) will=
 be repeated as text on the terminal or text editor. So if i for instance p=
ress the key 0 on the remote=2C while i have a text editor open=2C it enter=
s the number 0 continuously=2C like this:
000000000000000000000000000000... in the editor=2C or terminal window=2C or=
 any text input field.

Does that make sense...
Its past midnight here in Australia so i have to get to bed as i have to wo=
rk tomorrow=2C i'll email back in the morning.
Thank you Antii.
Alistair.


> Date: Thu=2C 3 Jul 2008 16:09:50 +0300
> From: crope@iki.fi
> To: tlli@hotmail.com
> CC: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
>=20
> Alistair M wrote:
> > Hi Antii=2C
> >=20
> > Thanks for that=2C it worked. When I press the numbers (0-9)=2C it will=
=20
> > repeat on the screen (with the key code appearing in the messages file)=
.=20
> > Is that expected?
> >=20
> > Here are the codes:
> > number 0 =3D af9015_rc_query: 00 00 27 00 00 00 00 00
> > number 1 =3D af9015_rc_query: 00 00 1e 00 00 00 00 00
> > number 2 =3D af9015_rc_query: 00 00 1f 00 00 00 00 00
> > number 3 =3D af9015_rc_query: 00 00 20 00 00 00 00 00
> > number 4 =3D af9015_rc_query: 00 00 21 00 00 00 00 00
> > number 5 =3D af9015_rc_query: 00 00 22 00 00 00 00 00
> > number 6 =3D af9015_rc_query: 00 00 23 00 00 00 00 00
> > number 7 =3D af9015_rc_query: 00 00 24 00 00 00 00 00
> > number 8 =3D af9015_rc_query: 00 00 25 00 00 00 00 00
> > number 9 =3D af9015_rc_query: 00 00 26 00 00 00 00 00
> > channel up =3D af9015_rc_query: 00 00 52 00 00 00 00 00
> > channel down =3D af9015_rc_query: 00 00 51 00 00 00 00 00
> > volume up =3D af9015_rc_query: 00 00 4f 00 00 00 00 00
> > volume down =3D af9015_rc_query: 00 00 50 00 00 00 00 00
> > Enter key =3D af9015_rc_query: 00 00 28 00 00 00 00 00
>=20
> Key codes are now mapped to the key events. Please test.
>=20
> > For some reason the last key i press on the remote will repeat on scree=
n=20
> > after i have pressed it. For example=2C i just hit the enter key on the=
=20
> > remote=2C now in this email if i hit enter it repeats on screen. Strang=
e...
>=20
> Did not understand fully what you mean. All keys are repeating until=20
> next key is pressed?
>=20
> > OK hope this helps.
> > Thanks Antii.
> > Alistair
>=20
> Antti
>=20
> --=20
> http://palosaari.fi/

_________________________________________________________________
Overpaid or Underpaid? Check our comprehensive Salary Centre
http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fcontent%2Emycareer%2Ecom%=
2Eau%2Fsalary%2Dcentre%3Fs%5Fcid%3D595810&_t=3D766724125&_r=3DHotmail_Email=
_Tagline_MyCareer_Oct07&_m=3DEXT=

--_9b6a489e-cfdb-49c7-93fe-4d7dae02f135_
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

Hello Antii=2C<br>I have compiled in your latest build.<br><br>What seems t=
o be happening is=2C in the terminal or even a text editor=2C when i press =
any button on the remote control=2C that character (eg. 0) will be repeated=
 as text on the terminal or text editor. So if i for instance press the key=
 0 on the remote=2C while i have a text editor open=2C it enters the number=
 0 continuously=2C like this:<br>000000000000000000000000000000... in the e=
ditor=2C or terminal window=2C or any text input field.<br><br>Does that ma=
ke sense...<br>Its past midnight here in Australia so i have to get to bed =
as i have to work tomorrow=2C i'll email back in the morning.<br>Thank you =
Antii.<br>Alistair.<br><br><br>&gt=3B Date: Thu=2C 3 Jul 2008 16:09:50 +030=
0<br>&gt=3B From: crope@iki.fi<br>&gt=3B To: tlli@hotmail.com<br>&gt=3B CC:=
 linux-dvb@linuxtv.org<br>&gt=3B Subject: Re: [linux-dvb] Leadtek WinFast D=
TV Dongle Gold Remote issues<br>&gt=3B <br>&gt=3B Alistair M wrote:<br>&gt=
=3B &gt=3B Hi Antii=2C<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Thanks for that=
=2C it worked. When I press the numbers (0-9)=2C it will <br>&gt=3B &gt=3B =
repeat on the screen (with the key code appearing in the messages file). <b=
r>&gt=3B &gt=3B Is that expected?<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Here a=
re the codes:<br>&gt=3B &gt=3B number 0 =3D af9015_rc_query: 00 00 27 00 00=
 00 00 00<br>&gt=3B &gt=3B number 1 =3D af9015_rc_query: 00 00 1e 00 00 00 =
00 00<br>&gt=3B &gt=3B number 2 =3D af9015_rc_query: 00 00 1f 00 00 00 00 0=
0<br>&gt=3B &gt=3B number 3 =3D af9015_rc_query: 00 00 20 00 00 00 00 00<br=
>&gt=3B &gt=3B number 4 =3D af9015_rc_query: 00 00 21 00 00 00 00 00<br>&gt=
=3B &gt=3B number 5 =3D af9015_rc_query: 00 00 22 00 00 00 00 00<br>&gt=3B =
&gt=3B number 6 =3D af9015_rc_query: 00 00 23 00 00 00 00 00<br>&gt=3B &gt=
=3B number 7 =3D af9015_rc_query: 00 00 24 00 00 00 00 00<br>&gt=3B &gt=3B =
number 8 =3D af9015_rc_query: 00 00 25 00 00 00 00 00<br>&gt=3B &gt=3B numb=
er 9 =3D af9015_rc_query: 00 00 26 00 00 00 00 00<br>&gt=3B &gt=3B channel =
up =3D af9015_rc_query: 00 00 52 00 00 00 00 00<br>&gt=3B &gt=3B channel do=
wn =3D af9015_rc_query: 00 00 51 00 00 00 00 00<br>&gt=3B &gt=3B volume up =
=3D af9015_rc_query: 00 00 4f 00 00 00 00 00<br>&gt=3B &gt=3B volume down =
=3D af9015_rc_query: 00 00 50 00 00 00 00 00<br>&gt=3B &gt=3B Enter key =3D=
 af9015_rc_query: 00 00 28 00 00 00 00 00<br>&gt=3B <br>&gt=3B Key codes ar=
e now mapped to the key events. Please test.<br>&gt=3B <br>&gt=3B &gt=3B Fo=
r some reason the last key i press on the remote will repeat on screen <br>=
&gt=3B &gt=3B after i have pressed it. For example=2C i just hit the enter =
key on the <br>&gt=3B &gt=3B remote=2C now in this email if i hit enter it =
repeats on screen. Strange...<br>&gt=3B <br>&gt=3B Did not understand fully=
 what you mean. All keys are repeating until <br>&gt=3B next key is pressed=
?<br>&gt=3B <br>&gt=3B &gt=3B OK hope this helps.<br>&gt=3B &gt=3B Thanks A=
ntii.<br>&gt=3B &gt=3B Alistair<br>&gt=3B <br>&gt=3B Antti<br>&gt=3B <br>&g=
t=3B -- <br>&gt=3B http://palosaari.fi/<br><br /><hr />Check our comprehens=
ive Salary Centre <a href=3D'http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2=
F%2Fcontent%2Emycareer%2Ecom%2Eau%2Fsalary%2Dcentre%3Fs%5Fcid%3D595810&_t=
=3D766724125&_r=3DHotmail_Email_Tagline_MyCareer_Oct07&_m=3DEXT' target=3D'=
_new'>Overpaid or Underpaid?</a></body>
</html>=

--_9b6a489e-cfdb-49c7-93fe-4d7dae02f135_--


--===============1798174180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1798174180==--
