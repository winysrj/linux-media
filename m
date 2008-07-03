Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s23.bay0.hotmail.com ([65.54.246.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlli@hotmail.com>) id 1KEO83-0005e3-77
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 14:41:42 +0200
Message-ID: <BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
From: Alistair M <tlli@hotmail.com>
To: Antti Palosaari <crope@iki.fi>
Date: Thu, 3 Jul 2008 22:41:04 +1000
In-Reply-To: <486CB3D2.3000702@iki.fi>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
	<486B3617.3070702@iki.fi> <BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
	<486CB3D2.3000702@iki.fi>
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
Content-Type: multipart/mixed; boundary="===============0459762310=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0459762310==
Content-Type: multipart/alternative;
	boundary="_b0731674-c091-4839-b0fd-6780ce70c288_"

--_b0731674-c091-4839-b0fd-6780ce70c288_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable





Hi Antii=2C

Thanks for that=2C it worked. When I press the numbers (0-9)=2C it will rep=
eat on the screen (with the key code appearing in the messages file). Is th=
at expected?

Here are the codes:
number 0 =3D af9015_rc_query: 00 00 27 00 00 00 00 00
number 1 =3D af9015_rc_query: 00 00 1e 00 00 00 00 00
number 2 =3D af9015_rc_query: 00 00 1f 00 00 00 00 00
number 3 =3D af9015_rc_query: 00 00 20 00 00 00 00 00
number 4 =3D af9015_rc_query: 00 00 21 00 00 00 00 00
number 5 =3D af9015_rc_query: 00 00 22 00 00 00 00 00
number 6 =3D af9015_rc_query: 00 00 23 00 00 00 00 00
number 7 =3D af9015_rc_query: 00 00 24 00 00 00 00 00
number 8 =3D af9015_rc_query: 00 00 25 00 00 00 00 00
number 9 =3D af9015_rc_query: 00 00 26 00 00 00 00 00
channel up =3D af9015_rc_query: 00 00 52 00 00 00 00 00
channel down =3D af9015_rc_query: 00 00 51 00 00 00 00 00
volume up =3D af9015_rc_query: 00 00 4f 00 00 00 00 00
volume down =3D af9015_rc_query: 00 00 50 00 00 00 00 00
Enter key =3D af9015_rc_query: 00 00 28 00 00 00 00 00

For some reason the last key i press on the remote will repeat on screen af=
ter i have pressed it. For example=2C i just hit the enter key on the remot=
e=2C now in this email if i hit enter it repeats on screen. Strange...

OK hope this helps.
Thanks Antii.
Alistair

> Date: Thu=2C 3 Jul 2008 14:11:14 +0300
> From: crope@iki.fi
> To: tlli@hotmail.com
> CC: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
>=20
> Alistair M wrote:
> > Hello Antii=2C
> >=20
> > I've attached the usb snoop. I hope I did it correctly.
>=20
> It was correct :)
>=20
> I added IR-code table to the driver. Now we should find correct keys for=
=20
> those codes.
> 1) install driver from http://linuxtv.org/hg/~anttip/af9015-new/ (make &=
=20
> make install=3B make rmmod=3B tail -100f /var/log/messages)
> 2) it should print remote codes to the message log when you press remote=
=20
> keys. Write down which key gives which code.
>=20
> Here is example what it should output to the message-log when key is=20
> pressed=3B
> af9015_rc_query: 00 00 1e 00 00 00 00 00
> af9015_rc_query: 00 00 1f 00 00 00 00 00
> af9015_rc_query: 00 00 20 00 00 00 00 00
> af9015_rc_query: 00 00 21 00 00 00 00 00
>=20
> report like:
> number 1 =3D af9015_rc_query: 00 00 1f 00 00 00 00 00
> channel up =3D af9015_rc_query: 00 00 1f 00 00 00 00 00
> volume down =3D af9015_rc_query: 00 00 20 00 00 00 00 00
>=20
> > Thank you so much for this.
> >=20
> > Regards=2C
> > Alistair.
>=20
> regards
> Antti
>=20
> --=20
> http://palosaari.fi/

_________________________________________________________________
Overpaid or Underpaid? Check our comprehensive Salary Centre
http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fcontent%2Emycareer%2Ecom%=
2Eau%2Fsalary%2Dcentre%3Fs%5Fcid%3D595810&_t=3D766724125&_r=3DHotmail_Email=
_Tagline_MyCareer_Oct07&_m=3DEXT=

--_b0731674-c091-4839-b0fd-6780ce70c288_
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



Hi Antii=2C<br><br>Thanks for that=2C it worked. When I press the numbers (=
0-9)=2C it will repeat on the screen (with the key code appearing in the me=
ssages file). Is that expected?<br><br>Here are the codes:<br>number 0 =3D =
af9015_rc_query: 00 00 27 00 00 00 00 00<br>number 1 =3D af9015_rc_query: 0=
0 00 1e 00 00 00 00 00<br>number 2 =3D af9015_rc_query: 00 00 1f 00 00 00 0=
0 00<br>number 3 =3D af9015_rc_query: 00 00 20 00 00 00 00 00<br>number 4 =
=3D af9015_rc_query: 00 00 21 00 00 00 00 00<br>number 5 =3D af9015_rc_quer=
y: 00 00 22 00 00 00 00 00<br>number 6 =3D af9015_rc_query: 00 00 23 00 00 =
00 00 00<br>number 7 =3D af9015_rc_query: 00 00 24 00 00 00 00 00<br>number=
 8 =3D af9015_rc_query: 00 00 25 00 00 00 00 00<br>number 9 =3D af9015_rc_q=
uery: 00 00 26 00 00 00 00 00<br>channel up =3D af9015_rc_query: 00 00 52 0=
0 00 00 00 00<br>channel down =3D af9015_rc_query: 00 00 51 00 00 00 00 00<=
br>volume up =3D af9015_rc_query: 00 00 4f 00 00 00 00 00<br>volume down =
=3D af9015_rc_query: 00 00 50 00 00 00 00 00<br>Enter key =3D af9015_rc_que=
ry: 00 00 28 00 00 00 00 00<br><br>For some reason the last key i press on =
the remote will repeat on screen after i have pressed it. For example=2C i =
just hit the enter key on the remote=2C now in this email if i hit enter it=
 repeats on screen. Strange...<br><br>OK hope this helps.<br>Thanks Antii.<=
br>Alistair<br><br>&gt=3B Date: Thu=2C 3 Jul 2008 14:11:14 +0300<br>&gt=3B =
From: crope@iki.fi<br>&gt=3B To: tlli@hotmail.com<br>&gt=3B CC: linux-dvb@l=
inuxtv.org<br>&gt=3B Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Go=
ld Remote issues<br>&gt=3B <br>&gt=3B Alistair M wrote:<br>&gt=3B &gt=3B He=
llo Antii=2C<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B I've attached the usb snoop=
. I hope I did it correctly.<br>&gt=3B <br>&gt=3B It was correct :)<br>&gt=
=3B <br>&gt=3B I added IR-code table to the driver. Now we should find corr=
ect keys for <br>&gt=3B those codes.<br>&gt=3B 1) install driver from http:=
//linuxtv.org/hg/~anttip/af9015-new/ (make &amp=3B <br>&gt=3B make install=
=3B make rmmod=3B tail -100f /var/log/messages)<br>&gt=3B 2) it should prin=
t remote codes to the message log when you press remote <br>&gt=3B keys. Wr=
ite down which key gives which code.<br>&gt=3B <br>&gt=3B Here is example w=
hat it should output to the message-log when key is <br>&gt=3B pressed=3B<b=
r>&gt=3B af9015_rc_query: 00 00 1e 00 00 00 00 00<br>&gt=3B af9015_rc_query=
: 00 00 1f 00 00 00 00 00<br>&gt=3B af9015_rc_query: 00 00 20 00 00 00 00 0=
0<br>&gt=3B af9015_rc_query: 00 00 21 00 00 00 00 00<br>&gt=3B <br>&gt=3B r=
eport like:<br>&gt=3B number 1 =3D af9015_rc_query: 00 00 1f 00 00 00 00 00=
<br>&gt=3B channel up =3D af9015_rc_query: 00 00 1f 00 00 00 00 00<br>&gt=
=3B volume down =3D af9015_rc_query: 00 00 20 00 00 00 00 00<br>&gt=3B <br>=
&gt=3B &gt=3B Thank you so much for this.<br>&gt=3B &gt=3B <br>&gt=3B &gt=
=3B Regards=2C<br>&gt=3B &gt=3B Alistair.<br>&gt=3B <br>&gt=3B regards<br>&=
gt=3B Antti<br>&gt=3B <br>&gt=3B -- <br>&gt=3B http://palosaari.fi/<br><br =
/><hr />Check our comprehensive Salary Centre <a href=3D'http://a.ninemsn.c=
om.au/b.aspx?URL=3Dhttp%3A%2F%2Fcontent%2Emycareer%2Ecom%2Eau%2Fsalary%2Dce=
ntre%3Fs%5Fcid%3D595810&_t=3D766724125&_r=3DHotmail_Email_Tagline_MyCareer_=
Oct07&_m=3DEXT' target=3D'_new'>Overpaid or Underpaid?</a></body>
</html>=

--_b0731674-c091-4839-b0fd-6780ce70c288_--


--===============0459762310==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0459762310==--
