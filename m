Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s37.bay0.hotmail.com ([65.54.246.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlli@hotmail.com>) id 1KEWhl-00028J-Jk
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 23:51:11 +0200
Message-ID: <BAY136-W177E19D1A9E2B82C462594D2980@phx.gbl>
From: Alistair M <tlli@hotmail.com>
To: Antti Palosaari <crope@iki.fi>
Date: Fri, 4 Jul 2008 07:50:31 +1000
In-Reply-To: <486CE911.8090808@iki.fi>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
	<486B3617.3070702@iki.fi> <BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
	<486CB3D2.3000702@iki.fi> <BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
	<486CCF9E.7070109@iki.fi> <BAY136-W13F407BF8A0BCA5BB251F6D2980@phx.gbl>
	<486CDC62.5060605@iki.fi> <BAY136-W4A1D1267A59B878FF68C7D2980@phx.gbl>
	<486CE911.8090808@iki.fi>
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
Content-Type: multipart/mixed; boundary="===============0761163264=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0761163264==
Content-Type: multipart/alternative;
	boundary="_0f1353db-9e0d-42a9-9952-ef669423de93_"

--_0f1353db-9e0d-42a9-9952-ef669423de93_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable



Hi Antii=2C

I'm sorry=2C its still doing it. I'm doing the following:
# hg clone http://linuxtv.org/hg/~anttip/af9015-new
# cd af9015-new
# make
# make install
reboot

I then open terminal=2C with the usb stick plugged in=2C i hit the number 5=
 on the remote=2C then 5 gets printed on the terminal screen=2C and is repe=
ated continuously=2C eg. 5555555555555555555555555555.... until i hit anoth=
er key. If i use the number 5 from the keyboard when i type something=2C it=
 will do the same again=2C 55555555555555555555555555555555.....

This happens for what ever number i press on the remote=2C it will then do =
on my laptop keyboard=2C etc.

Thanks Antii=2C
Alistair


> Date: Thu=2C 3 Jul 2008 17:58:25 +0300
> From: crope@iki.fi
> To: tlli@hotmail.com
> CC: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
>=20
> should be fixed now!
>=20
> regards
> Antti
>=20
> Alistair M wrote:
> > Ah great news...!
> >=20
> >  > Date: Thu=2C 3 Jul 2008 17:04:18 +0300
> >  > From: crope@iki.fi
> >  > To: tlli@hotmail.com
> >  > CC: linux-dvb@linuxtv.org
> >  > Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issu=
es
> >  >
> >  > Alistair M wrote:
> >  > > Hello Antii=2C
> >  > > I have compiled in your latest build.
> >  > >
> >  > > What seems to be happening is=2C in the terminal or even a text ed=
itor=2C
> >  > > when i press any button on the remote control=2C that character (e=
g. 0)
> >  > > will be repeated as text on the terminal or text editor. So if i f=
or
> >  > > instance press the key 0 on the remote=2C while i have a text edit=
or=20
> > open=2C
> >  > > it enters the number 0 continuously=2C like this:
> >  > > 000000000000000000000000000000... in the editor=2C or terminal=20
> > window=2C or
> >  > > any text input field.
> >  >
> >  > hmm=2C I think I know the reason. Actually this is due to hardware b=
ug. I
> >  > think I have older silicon revision that returns error code when pol=
ling
> >  > remote events and there is no event. You have a newer silicon that d=
oes
> >  > not return error any more. Current remote polling code in the driver
> >  > relies that error code. I will fix that soon=2C it is easy to fix.
> >  >
> >  > > Does that make sense...
> >  > > Its past midnight here in Australia so i have to get to bed as i=20
> > have to
> >  > > work tomorrow=2C i'll email back in the morning.
> >  > > Thank you Antii.
> >  > > Alistair.
> >  >
> >  > regards
> >  > Antti
> >  > --
> >  > http://palosaari.fi/
> >=20
> > -----------------------------------------------------------------------=
-
> > Find a new job on Seek Increase your salary.=20
> > <http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fninemsn%2Eseek%2Ecom=
%2Eau%2F%3Ftracking%3Dsk%3Amtl%3Ask%3Anine%3A0%3Ahot%3Atext&_t=3D764565661&=
_r=3DJAN08_endtext_increase&_m=3DEXT>
> >=20
> >=20
> > -----------------------------------------------------------------------=
-
> >=20
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>=20
>=20
> --=20
> http://palosaari.fi/

_________________________________________________________________
What are you waiting for? Join Lavalife FREE
http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Flavalife9%2Eninemsn%2Ecom=
%2Eau%2Fclickthru%2Fclickthru%2Eact%3Fid%3Dninemsn%26context%3Dan99%26local=
e%3Den%5FAU%26a%3D30288&_t=3D764581033&_r=3Demail_taglines_Join_free_OCT07&=
_m=3DEXT=

--_0f1353db-9e0d-42a9-9952-ef669423de93_
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

Hi Antii=2C<br><br>I'm sorry=2C its still doing it. I'm doing the following=
:<br># hg clone http://linuxtv.org/hg/~anttip/af9015-new<br># cd af9015-new=
<br># make<br># make install<br>reboot<br><br>I then open terminal=2C with =
the usb stick plugged in=2C i hit the number 5 on the remote=2C then 5 gets=
 printed on the terminal screen=2C and is repeated continuously=2C eg. 5555=
555555555555555555555555.... until i hit another key. If i use the number 5=
 from the keyboard when i type something=2C it will do the same again=2C 55=
555555555555555555555555555555.....<br><br>This happens for what ever numbe=
r i press on the remote=2C it will then do on my laptop keyboard=2C etc.<br=
><br>Thanks Antii=2C<br>Alistair<br><br><br>&gt=3B Date: Thu=2C 3 Jul 2008 =
17:58:25 +0300<br>&gt=3B From: crope@iki.fi<br>&gt=3B To: tlli@hotmail.com<=
br>&gt=3B CC: linux-dvb@linuxtv.org<br>&gt=3B Subject: Re: [linux-dvb] Lead=
tek WinFast DTV Dongle Gold Remote issues<br>&gt=3B <br>&gt=3B should be fi=
xed now!<br>&gt=3B <br>&gt=3B regards<br>&gt=3B Antti<br>&gt=3B <br>&gt=3B =
Alistair M wrote:<br>&gt=3B &gt=3B Ah great news...!<br>&gt=3B &gt=3B <br>&=
gt=3B &gt=3B  &gt=3B Date: Thu=2C 3 Jul 2008 17:04:18 +0300<br>&gt=3B &gt=
=3B  &gt=3B From: crope@iki.fi<br>&gt=3B &gt=3B  &gt=3B To: tlli@hotmail.co=
m<br>&gt=3B &gt=3B  &gt=3B CC: linux-dvb@linuxtv.org<br>&gt=3B &gt=3B  &gt=
=3B Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues<=
br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &gt=3B Alistair M wrote:<br>&gt=
=3B &gt=3B  &gt=3B &gt=3B Hello Antii=2C<br>&gt=3B &gt=3B  &gt=3B &gt=3B I =
have compiled in your latest build.<br>&gt=3B &gt=3B  &gt=3B &gt=3B<br>&gt=
=3B &gt=3B  &gt=3B &gt=3B What seems to be happening is=2C in the terminal =
or even a text editor=2C<br>&gt=3B &gt=3B  &gt=3B &gt=3B when i press any b=
utton on the remote control=2C that character (eg. 0)<br>&gt=3B &gt=3B  &gt=
=3B &gt=3B will be repeated as text on the terminal or text editor. So if i=
 for<br>&gt=3B &gt=3B  &gt=3B &gt=3B instance press the key 0 on the remote=
=2C while i have a text editor <br>&gt=3B &gt=3B open=2C<br>&gt=3B &gt=3B  =
&gt=3B &gt=3B it enters the number 0 continuously=2C like this:<br>&gt=3B &=
gt=3B  &gt=3B &gt=3B 000000000000000000000000000000... in the editor=2C or =
terminal <br>&gt=3B &gt=3B window=2C or<br>&gt=3B &gt=3B  &gt=3B &gt=3B any=
 text input field.<br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &gt=3B hmm=2C=
 I think I know the reason. Actually this is due to hardware bug. I<br>&gt=
=3B &gt=3B  &gt=3B think I have older silicon revision that returns error c=
ode when polling<br>&gt=3B &gt=3B  &gt=3B remote events and there is no eve=
nt. You have a newer silicon that does<br>&gt=3B &gt=3B  &gt=3B not return =
error any more. Current remote polling code in the driver<br>&gt=3B &gt=3B =
 &gt=3B relies that error code. I will fix that soon=2C it is easy to fix.<=
br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B Does that make sen=
se...<br>&gt=3B &gt=3B  &gt=3B &gt=3B Its past midnight here in Australia s=
o i have to get to bed as i <br>&gt=3B &gt=3B have to<br>&gt=3B &gt=3B  &gt=
=3B &gt=3B work tomorrow=2C i'll email back in the morning.<br>&gt=3B &gt=
=3B  &gt=3B &gt=3B Thank you Antii.<br>&gt=3B &gt=3B  &gt=3B &gt=3B Alistai=
r.<br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &gt=3B regards<br>&gt=3B &gt=
=3B  &gt=3B Antti<br>&gt=3B &gt=3B  &gt=3B --<br>&gt=3B &gt=3B  &gt=3B http=
://palosaari.fi/<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B -----------------------=
-------------------------------------------------<br>&gt=3B &gt=3B Find a n=
ew job on Seek Increase your salary. <br>&gt=3B &gt=3B &lt=3Bhttp://a.ninem=
sn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fninemsn%2Eseek%2Ecom%2Eau%2F%3Ftracking=
%3Dsk%3Amtl%3Ask%3Anine%3A0%3Ahot%3Atext&amp=3B_t=3D764565661&amp=3B_r=3DJA=
N08_endtext_increase&amp=3B_m=3DEXT&gt=3B<br>&gt=3B &gt=3B <br>&gt=3B &gt=
=3B <br>&gt=3B &gt=3B -----------------------------------------------------=
-------------------<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B ____________________=
___________________________<br>&gt=3B &gt=3B linux-dvb mailing list<br>&gt=
=3B &gt=3B linux-dvb@linuxtv.org<br>&gt=3B &gt=3B http://www.linuxtv.org/cg=
i-bin/mailman/listinfo/linux-dvb<br>&gt=3B <br>&gt=3B <br>&gt=3B -- <br>&gt=
=3B http://palosaari.fi/<br><br /><hr />Click here <a href=3D'http://a.nine=
msn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Flavalife9%2Eninemsn%2Ecom%2Eau%2Fclick=
thru%2Fclickthru%2Eact%3Fid%3Dninemsn%26context%3Dan99%26locale%3Den%5FAU%2=
6a%3D30290&_t=3D764581033&_r=3Demail_taglines_Search_OCT07&_m=3DEXT' target=
=3D'_new'>Search for local singles online @ Lavalife.</a></body>
</html>=

--_0f1353db-9e0d-42a9-9952-ef669423de93_--


--===============0761163264==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0761163264==--
