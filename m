Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s37.bay0.hotmail.com ([65.54.246.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlli@hotmail.com>) id 1KHrPC-0006LZ-Pg
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 04:33:45 +0200
Message-ID: <BAY136-W30EA6F7FD226CED17802E1D2920@phx.gbl>
From: Alistair M <tlli@hotmail.com>
To: Antti Palosaari <crope@iki.fi>
Date: Sun, 13 Jul 2008 12:33:07 +1000
In-Reply-To: <486E878D.4060806@iki.fi>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
	<486B3617.3070702@iki.fi> <BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
	<486CB3D2.3000702@iki.fi> <BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
	<486CCF9E.7070109@iki.fi> <BAY136-W13F407BF8A0BCA5BB251F6D2980@phx.gbl>
	<486CDC62.5060605@iki.fi> <BAY136-W4A1D1267A59B878FF68C7D2980@phx.gbl>
	<486CE911.8090808@iki.fi> <BAY136-W177E19D1A9E2B82C462594D2980@phx.gbl>
	<486D589E.8040003@iki.fi> <BAY136-W10D7872483244330850C1DD29B0@phx.gbl>
	<486E5DC2.8050908@iki.fi> <BAY136-W16A2EDA6CD976613C7CCCBD29B0@phx.gbl>
	<486E878D.4060806@iki.fi>
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
Content-Type: multipart/mixed; boundary="===============1486723292=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1486723292==
Content-Type: multipart/alternative;
	boundary="_28a93aab-5af8-4dac-b412-11ba78bcb5bc_"

--_28a93aab-5af8-4dac-b412-11ba78bcb5bc_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hello Antti=2C

I finally managed to try the driver on another amd machine=2C and the probl=
em does not exist (ie. the number I press on the remote continuously appear=
ing on the screen).
Now when I press a button on the remote it only appears once on a text edit=
 screen=2C or terminal=2C which is good.

I have noticed that when I use the channel up/down button=2C it doesn't wor=
k. Volume up/down does work=2C and the channel numbers work also.=20
Is there anything I can do to map other buttons also if I need?

Thanks Antti.
Alistair.


> Date: Fri=2C 4 Jul 2008 23:26:53 +0300
> From: crope@iki.fi
> To: tlli@hotmail.com
> Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
>=20
> you should put it like this around line 875 (af9015_properties.rc_query=20
> =3D NULL=3B )
>=20
>=20
> 			/* leaves A-Link DTU(m) */
> 			break=3B
> 		}
> 	}
>=20
> 	af9015_properties.rc_query =3D NULL=3B
>=20
> 	/* TS mode - one or two receivers */
> 	req.addr =3D AF9015_EEPROM_TS_MODE=3B
> 	ret =3D af9015_rw_udev(udev=2C &req)=3B
> 	if (ret)
> 		goto exit=3B
>=20
>=20
>=20
>=20
> Alistair M wrote:
> > Hi Antii=2C
> >=20
> > I changed line 1295 of file=20
> > /var/tmp/af9015-new/linux/drivers/media/dvb/dvb-usb/af9015.c to show:
> >=20
> >  .rc_query         =3D NULL=2C
> >=20
> > and i get the following error when i run make:
> >=20
> > /var/tmp/af9015-new/v4l/af9015.c:1295:3: error: invalid preprocessing=20
> > directive #.
> > make[3]: *** [/var/tmp/af9015-new/v4l/af9015.o] Error 1
> > make[2]: *** [_module_/var/tmp/af9015-new/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/var/tmp/af9015-new/v4l'
> > make: *** [all] Error 2
> >=20
> > Have i got the right file?
> > Thanks Antii=2C
> > Alistair
> >=20
> >  > Date: Fri=2C 4 Jul 2008 20:28:34 +0300
> >  > From: crope@iki.fi
> >  > To: tlli@hotmail.com
> >  > Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issu=
es
> >  >
> >  > hello
> >  > It could be due to HID remote implemented by AF9015 chip. Unfortunat=
ely
> >  > there seems to be hardware bug which causes that HID remote is not
> >  > working. Due to that remote is implemented by polling remote events =
by
> >  > the driver. I have one idea more=2C it could be again that you have =
never
> >  > silicon revision and it contains fixed HID remote. And something goe=
s
> >  > wrong now because HID and polling remote are used same time.
> >  > Could you disable polling just changing rc_query =3D NULL in af9015.=
c to
> >  > see if HID is working. Also driver should output hardware chip and R=
OM
> >  > version. Your log is not complete enough that I can see those...
> >  >
> >  > Antti
> >  >
> >  > Alistair M wrote:
> >  > > Hi Antii=2C
> >  > >
> >  > > I didn't get a chance to try the usb stick out on another ubuntu
> >  > > machine. I will try it over the weekend (my 9month old son sleeps =
in
> >  > > that room with the other PC=2C i'm on a laptop).
> >  > > Here is what happens in the messages file when I press the 1 key i=
n=20
> > the
> >  > > remote:
> >  > > root@LinuxLaptop:~# tail -f /var/log/messages
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.074707] af9015_i2c_xfer:
> >  > > UNLOCK pid:6641 38 38
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.074896] input: IR-receive=
r
> >  > > inside an USB DVB receiver as
> >  > > /devices/pci0000:00/0000:00:1d.7/usb5/5-1/input/input13
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.082649] dvb-usb: schedule
> >  > > remote query interval to 150 msecs.
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.082661] dvb-usb: Leadtek
> >  > > WinFast DTV Dongle Gold successfully initialized and connected.
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.082668] af9015_init:
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.082673] af9015_init_endpo=
int:
> >  > > USB speed:3
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.090285]=20
> > af9015_download_ir_table:
> >  > > Jul 4 22:59:04 LinuxLaptop kernel: [ 109.200871] usbcore: register=
ed
> >  > > new interface driver dvb_usb_af9015
> >  > > 1Jul 4 23:05:57 LinuxLaptop kernel: [ 291.487198] af9015_rc_query:=
 00
> >  > > 00 1e 00 00 00 00 00
> >  > > 11111111111111111111111111111111111111111<I hit Ctrl-c here>
> >  > > root@LinuxLaptop:~#
> >  > >
> >  > > Antii do you think it has something to do with this:
> >  > > root@LinuxLaptop:~# dmesg |grep -i keyboard
> >  > > [ 15.966361] input: AT Translated Set 2 keyboard as
> >  > > /devices/platform/i8042/serio0/input/input1
> >  > > [ 108.339466] input=2Chidraw0: USB HID v1.01 Keyboard [Leadtek Win=
Fast
> >  > > DTV Dongle Gold] on usb-0000:00:1d.7-1
> >  > > [ 108.537436] input=2Chidraw0: USB HID v1.01 Keyboard [Leadtek Win=
Fast
> >  > > DTV Dongle Gold] on usb-0000:00:1d.7-1
> >  > > root@LinuxLaptop:~#
> >  > >
> >  > > I think the USB dongle is being recognised as something related to=
 a
> >  > > keyboard. Is that supposed to happen?
> >  > >
> >  > > Thanks Antii=2C
> >  > > Alistair.
> >  > >
> >  > >
> >  > >
> >  > > > Date: Fri=2C 4 Jul 2008 01:54:22 +0300
> >  > > > From: crope@iki.fi
> >  > > > To: tlli@hotmail.com
> >  > > > Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote=
=20
> > issues
> >  > > >
> >  > > > Alistair M wrote:
> >  > > > > Hi Antii=2C
> >  > > > >
> >  > > > > I'm sorry=2C its still doing it. I'm doing the following:
> >  > > > > # hg clone http://linuxtv.org/hg/~anttip/af9015-new
> >  > > > > # cd af9015-new
> >  > > > > # make
> >  > > > > # make install
> >  > > > > reboot
> >  > > > >
> >  > > > > I then open terminal=2C with the usb stick plugged in=2C i hit=
 the
> >  > > number 5
> >  > > > > on the remote=2C then 5 gets printed on the terminal screen=2C=
 and is
> >  > > > > repeated continuously=2C eg. 5555555555555555555555555555....=
=20
> > until i
> >  > > hit
> >  > > > > another key. If i use the number 5 from the keyboard when i ty=
pe
> >  > > > > something=2C it will do the same again=2C
> >  > > 55555555555555555555555555555555.....
> >  > > > >
> >  > > > > This happens for what ever number i press on the remote=2C it =
will
> >  > > then do
> >  > > > > on my laptop keyboard=2C etc.
> >  > > >
> >  > > > What does the message.log output in this case? This is a little =
bit
> >  > > > strange situation in all choices I have in my mind..
> >  > > >
> >  > > >
> >  > > > --
> >  > > > http://palosaari.fi/
> >  > >
> >  > >=20
> > -----------------------------------------------------------------------=
-
> >  > > Find out: SEEK Salary Centre Are you paid what you're worth?
> >  > >=20
> > <http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fninemsn%2Eseek%2Ecom=
%2Eau%2Fcareer%2Dresources%2Fsalary%2Dcentre%2F%3Ftracking%3Dsk%3Ahet%3Asc%=
3Anine%3A0%3Ahot%3Atext&_t=3D764565661&_r=3DOCT07_endtext_salary&_m=3DEXT>
> >  >
> >  >
> >  > --
> >  > http://palosaari.fi/
> >=20
> > -----------------------------------------------------------------------=
-
> > Try ninemsn dating now! Meet singles near you.=20
> > <http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fdating%2Eninemsn%2Ec=
om%2Eau%2Fchannel%2Findex%2Easpx%3Ftrackingid%3D1046247&_t=3D773166080&_r=
=3DWL_TAGLINE&_m=3DEXT>
>=20
>=20
> --=20
> http://palosaari.fi/

_________________________________________________________________
Want to help Windows Live Messenger plant more Aussie trees?
http://livelife.ninemsn.com.au/article.aspx?id=3D443698=

--_28a93aab-5af8-4dac-b412-11ba78bcb5bc_
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
Hello Antti=2C<br><br>I finally managed to try the driver on another amd ma=
chine=2C and the problem does not exist (ie. the number I press on the remo=
te continuously appearing on the screen).<br>Now when I press a button on t=
he remote it only appears once on a text edit screen=2C or terminal=2C whic=
h is good.<br><br>I have noticed that when I use the channel up/down button=
=2C it doesn't work. Volume up/down does work=2C and the channel numbers wo=
rk also. <br>Is there anything I can do to map other buttons also if I need=
?<br><br>Thanks Antti.<br>Alistair.<br><br><br>&gt=3B Date: Fri=2C 4 Jul 20=
08 23:26:53 +0300<br>&gt=3B From: crope@iki.fi<br>&gt=3B To: tlli@hotmail.c=
om<br>&gt=3B Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remot=
e issues<br>&gt=3B <br>&gt=3B you should put it like this around line 875 (=
af9015_properties.rc_query <br>&gt=3B =3D NULL=3B )<br>&gt=3B <br>&gt=3B <b=
r>&gt=3B 			/* leaves A-Link DTU(m) */<br>&gt=3B 			break=3B<br>&gt=3B 		}<=
br>&gt=3B 	}<br>&gt=3B <br>&gt=3B 	af9015_properties.rc_query =3D NULL=3B<b=
r>&gt=3B <br>&gt=3B 	/* TS mode - one or two receivers */<br>&gt=3B 	req.ad=
dr =3D AF9015_EEPROM_TS_MODE=3B<br>&gt=3B 	ret =3D af9015_rw_udev(udev=2C &=
amp=3Breq)=3B<br>&gt=3B 	if (ret)<br>&gt=3B 		goto exit=3B<br>&gt=3B <br>&g=
t=3B <br>&gt=3B <br>&gt=3B <br>&gt=3B Alistair M wrote:<br>&gt=3B &gt=3B Hi=
 Antii=2C<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B I changed line 1295 of file <b=
r>&gt=3B &gt=3B /var/tmp/af9015-new/linux/drivers/media/dvb/dvb-usb/af9015.=
c to show:<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B  .rc_query         =3D NULL=
=2C<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B and i get the following error when i=
 run make:<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B /var/tmp/af9015-new/v4l/af901=
5.c:1295:3: error: invalid preprocessing <br>&gt=3B &gt=3B directive #.<br>=
&gt=3B &gt=3B make[3]: *** [/var/tmp/af9015-new/v4l/af9015.o] Error 1<br>&g=
t=3B &gt=3B make[2]: *** [_module_/var/tmp/af9015-new/v4l] Error 2<br>&gt=
=3B &gt=3B make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-gen=
eric'<br>&gt=3B &gt=3B make[1]: *** [default] Error 2<br>&gt=3B &gt=3B make=
[1]: Leaving directory `/var/tmp/af9015-new/v4l'<br>&gt=3B &gt=3B make: ***=
 [all] Error 2<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Have i got the right file=
?<br>&gt=3B &gt=3B Thanks Antii=2C<br>&gt=3B &gt=3B Alistair<br>&gt=3B &gt=
=3B <br>&gt=3B &gt=3B  &gt=3B Date: Fri=2C 4 Jul 2008 20:28:34 +0300<br>&gt=
=3B &gt=3B  &gt=3B From: crope@iki.fi<br>&gt=3B &gt=3B  &gt=3B To: tlli@hot=
mail.com<br>&gt=3B &gt=3B  &gt=3B Subject: Re: [linux-dvb] Leadtek WinFast =
DTV Dongle Gold Remote issues<br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &g=
t=3B hello<br>&gt=3B &gt=3B  &gt=3B It could be due to HID remote implement=
ed by AF9015 chip. Unfortunately<br>&gt=3B &gt=3B  &gt=3B there seems to be=
 hardware bug which causes that HID remote is not<br>&gt=3B &gt=3B  &gt=3B =
working. Due to that remote is implemented by polling remote events by<br>&=
gt=3B &gt=3B  &gt=3B the driver. I have one idea more=2C it could be again =
that you have never<br>&gt=3B &gt=3B  &gt=3B silicon revision and it contai=
ns fixed HID remote. And something goes<br>&gt=3B &gt=3B  &gt=3B wrong now =
because HID and polling remote are used same time.<br>&gt=3B &gt=3B  &gt=3B=
 Could you disable polling just changing rc_query =3D NULL in af9015.c to<b=
r>&gt=3B &gt=3B  &gt=3B see if HID is working. Also driver should output ha=
rdware chip and ROM<br>&gt=3B &gt=3B  &gt=3B version. Your log is not compl=
ete enough that I can see those...<br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=
=3B  &gt=3B Antti<br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &gt=3B Alistai=
r M wrote:<br>&gt=3B &gt=3B  &gt=3B &gt=3B Hi Antii=2C<br>&gt=3B &gt=3B  &g=
t=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B I didn't get a chance to try th=
e usb stick out on another ubuntu<br>&gt=3B &gt=3B  &gt=3B &gt=3B machine. =
I will try it over the weekend (my 9month old son sleeps in<br>&gt=3B &gt=
=3B  &gt=3B &gt=3B that room with the other PC=2C i'm on a laptop).<br>&gt=
=3B &gt=3B  &gt=3B &gt=3B Here is what happens in the messages file when I =
press the 1 key in <br>&gt=3B &gt=3B the<br>&gt=3B &gt=3B  &gt=3B &gt=3B re=
mote:<br>&gt=3B &gt=3B  &gt=3B &gt=3B root@LinuxLaptop:~# tail -f /var/log/=
messages<br>&gt=3B &gt=3B  &gt=3B &gt=3B Jul 4 22:59:04 LinuxLaptop kernel:=
 [ 109.074707] af9015_i2c_xfer:<br>&gt=3B &gt=3B  &gt=3B &gt=3B UNLOCK pid:=
6641 38 38<br>&gt=3B &gt=3B  &gt=3B &gt=3B Jul 4 22:59:04 LinuxLaptop kerne=
l: [ 109.074896] input: IR-receiver<br>&gt=3B &gt=3B  &gt=3B &gt=3B inside =
an USB DVB receiver as<br>&gt=3B &gt=3B  &gt=3B &gt=3B /devices/pci0000:00/=
0000:00:1d.7/usb5/5-1/input/input13<br>&gt=3B &gt=3B  &gt=3B &gt=3B Jul 4 2=
2:59:04 LinuxLaptop kernel: [ 109.082649] dvb-usb: schedule<br>&gt=3B &gt=
=3B  &gt=3B &gt=3B remote query interval to 150 msecs.<br>&gt=3B &gt=3B  &g=
t=3B &gt=3B Jul 4 22:59:04 LinuxLaptop kernel: [ 109.082661] dvb-usb: Leadt=
ek<br>&gt=3B &gt=3B  &gt=3B &gt=3B WinFast DTV Dongle Gold successfully ini=
tialized and connected.<br>&gt=3B &gt=3B  &gt=3B &gt=3B Jul 4 22:59:04 Linu=
xLaptop kernel: [ 109.082668] af9015_init:<br>&gt=3B &gt=3B  &gt=3B &gt=3B =
Jul 4 22:59:04 LinuxLaptop kernel: [ 109.082673] af9015_init_endpoint:<br>&=
gt=3B &gt=3B  &gt=3B &gt=3B USB speed:3<br>&gt=3B &gt=3B  &gt=3B &gt=3B Jul=
 4 22:59:04 LinuxLaptop kernel: [ 109.090285] <br>&gt=3B &gt=3B af9015_down=
load_ir_table:<br>&gt=3B &gt=3B  &gt=3B &gt=3B Jul 4 22:59:04 LinuxLaptop k=
ernel: [ 109.200871] usbcore: registered<br>&gt=3B &gt=3B  &gt=3B &gt=3B ne=
w interface driver dvb_usb_af9015<br>&gt=3B &gt=3B  &gt=3B &gt=3B 1Jul 4 23=
:05:57 LinuxLaptop kernel: [ 291.487198] af9015_rc_query: 00<br>&gt=3B &gt=
=3B  &gt=3B &gt=3B 00 1e 00 00 00 00 00<br>&gt=3B &gt=3B  &gt=3B &gt=3B 111=
11111111111111111111111111111111111111&lt=3BI hit Ctrl-c here&gt=3B<br>&gt=
=3B &gt=3B  &gt=3B &gt=3B root@LinuxLaptop:~#<br>&gt=3B &gt=3B  &gt=3B &gt=
=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B Antii do you think it has something to =
do with this:<br>&gt=3B &gt=3B  &gt=3B &gt=3B root@LinuxLaptop:~# dmesg |gr=
ep -i keyboard<br>&gt=3B &gt=3B  &gt=3B &gt=3B [ 15.966361] input: AT Trans=
lated Set 2 keyboard as<br>&gt=3B &gt=3B  &gt=3B &gt=3B /devices/platform/i=
8042/serio0/input/input1<br>&gt=3B &gt=3B  &gt=3B &gt=3B [ 108.339466] inpu=
t=2Chidraw0: USB HID v1.01 Keyboard [Leadtek WinFast<br>&gt=3B &gt=3B  &gt=
=3B &gt=3B DTV Dongle Gold] on usb-0000:00:1d.7-1<br>&gt=3B &gt=3B  &gt=3B =
&gt=3B [ 108.537436] input=2Chidraw0: USB HID v1.01 Keyboard [Leadtek WinFa=
st<br>&gt=3B &gt=3B  &gt=3B &gt=3B DTV Dongle Gold] on usb-0000:00:1d.7-1<b=
r>&gt=3B &gt=3B  &gt=3B &gt=3B root@LinuxLaptop:~#<br>&gt=3B &gt=3B  &gt=3B=
 &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B I think the USB dongle is being rec=
ognised as something related to a<br>&gt=3B &gt=3B  &gt=3B &gt=3B keyboard.=
 Is that supposed to happen?<br>&gt=3B &gt=3B  &gt=3B &gt=3B<br>&gt=3B &gt=
=3B  &gt=3B &gt=3B Thanks Antii=2C<br>&gt=3B &gt=3B  &gt=3B &gt=3B Alistair=
.<br>&gt=3B &gt=3B  &gt=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B<br>&gt=3B=
 &gt=3B  &gt=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B Date: Fri=2C =
4 Jul 2008 01:54:22 +0300<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B From: crop=
e@iki.fi<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B To: tlli@hotmail.com<br>&gt=
=3B &gt=3B  &gt=3B &gt=3B &gt=3B Subject: Re: [linux-dvb] Leadtek WinFast D=
TV Dongle Gold Remote <br>&gt=3B &gt=3B issues<br>&gt=3B &gt=3B  &gt=3B &gt=
=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B Alistair M wrote:<br>&gt=
=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B Hi Antii=2C<br>&gt=3B &gt=3B  &gt=
=3B &gt=3B &gt=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B I'm =
sorry=2C its still doing it. I'm doing the following:<br>&gt=3B &gt=3B  &gt=
=3B &gt=3B &gt=3B &gt=3B # hg clone http://linuxtv.org/hg/~anttip/af9015-ne=
w<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B # cd af9015-new<br>&gt=3B &=
gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B # make<br>&gt=3B &gt=3B  &gt=3B &gt=3B &=
gt=3B &gt=3B # make install<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B r=
eboot<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B<br>&gt=3B &gt=3B  &gt=
=3B &gt=3B &gt=3B &gt=3B I then open terminal=2C with the usb stick plugged=
 in=2C i hit the<br>&gt=3B &gt=3B  &gt=3B &gt=3B number 5<br>&gt=3B &gt=3B =
 &gt=3B &gt=3B &gt=3B &gt=3B on the remote=2C then 5 gets printed on the te=
rminal screen=2C and is<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B repea=
ted continuously=2C eg. 5555555555555555555555555555.... <br>&gt=3B &gt=3B =
until i<br>&gt=3B &gt=3B  &gt=3B &gt=3B hit<br>&gt=3B &gt=3B  &gt=3B &gt=3B=
 &gt=3B &gt=3B another key. If i use the number 5 from the keyboard when i =
type<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B something=2C it will do =
the same again=2C<br>&gt=3B &gt=3B  &gt=3B &gt=3B 5555555555555555555555555=
5555555.....<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B &gt=3B<br>&gt=3B &gt=3B=
  &gt=3B &gt=3B &gt=3B &gt=3B This happens for what ever number i press on =
the remote=2C it will<br>&gt=3B &gt=3B  &gt=3B &gt=3B then do<br>&gt=3B &gt=
=3B  &gt=3B &gt=3B &gt=3B &gt=3B on my laptop keyboard=2C etc.<br>&gt=3B &g=
t=3B  &gt=3B &gt=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B What does=
 the message.log output in this case? This is a little bit<br>&gt=3B &gt=3B=
  &gt=3B &gt=3B &gt=3B strange situation in all choices I have in my mind..=
<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=
=3B<br>&gt=3B &gt=3B  &gt=3B &gt=3B &gt=3B --<br>&gt=3B &gt=3B  &gt=3B &gt=
=3B &gt=3B http://palosaari.fi/<br>&gt=3B &gt=3B  &gt=3B &gt=3B<br>&gt=3B &=
gt=3B  &gt=3B &gt=3B <br>&gt=3B &gt=3B ------------------------------------=
------------------------------------<br>&gt=3B &gt=3B  &gt=3B &gt=3B Find o=
ut: SEEK Salary Centre Are you paid what you're worth?<br>&gt=3B &gt=3B  &g=
t=3B &gt=3B <br>&gt=3B &gt=3B &lt=3Bhttp://a.ninemsn.com.au/b.aspx?URL=3Dht=
tp%3A%2F%2Fninemsn%2Eseek%2Ecom%2Eau%2Fcareer%2Dresources%2Fsalary%2Dcentre=
%2F%3Ftracking%3Dsk%3Ahet%3Asc%3Anine%3A0%3Ahot%3Atext&amp=3B_t=3D764565661=
&amp=3B_r=3DOCT07_endtext_salary&amp=3B_m=3DEXT&gt=3B<br>&gt=3B &gt=3B  &gt=
=3B<br>&gt=3B &gt=3B  &gt=3B<br>&gt=3B &gt=3B  &gt=3B --<br>&gt=3B &gt=3B  =
&gt=3B http://palosaari.fi/<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B ------------=
------------------------------------------------------------<br>&gt=3B &gt=
=3B Try ninemsn dating now! Meet singles near you. <br>&gt=3B &gt=3B &lt=3B=
http://a.ninemsn.com.au/b.aspx?URL=3Dhttp%3A%2F%2Fdating%2Eninemsn%2Ecom%2E=
au%2Fchannel%2Findex%2Easpx%3Ftrackingid%3D1046247&amp=3B_t=3D773166080&amp=
=3B_r=3DWL_TAGLINE&amp=3B_m=3DEXT&gt=3B<br>&gt=3B <br>&gt=3B <br>&gt=3B -- =
<br>&gt=3B http://palosaari.fi/<br><br /><hr />Click here. <a href=3D'http:=
//livelife.ninemsn.com.au/article.aspx?id=3D443698' target=3D'_new'>Want to=
 help Windows Live Messenger plant more Aussie trees?</a></body>
</html>=

--_28a93aab-5af8-4dac-b412-11ba78bcb5bc_--


--===============1486723292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1486723292==--
