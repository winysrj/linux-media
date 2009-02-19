Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s4.bay0.hotmail.com ([65.54.246.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <takispadaz@hotmail.com>) id 1La9Fy-0007uI-BC
	for linux-dvb@linuxtv.org; Thu, 19 Feb 2009 14:48:03 +0100
Message-ID: <BAY111-W30090D901B75228887D50BC5B20@phx.gbl>
From: panagiotis takis_rs <takispadaz@hotmail.com>
To: <linux-media@vger.kernel.org>
Date: Thu, 19 Feb 2009 15:47:26 +0200
In-Reply-To: <499CD588.8030104@rogers.com>
References: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>
	<499CD588.8030104@rogers.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [Bulk]  Problem with TV card's sound (SAA7134)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1727213713=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1727213713==
Content-Type: multipart/alternative;
	boundary="_4a9e8573-7dc0-48a7-bef1-5b57a888868d_"

--_4a9e8573-7dc0-48a7-bef1-5b57a888868d_
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable


> panagiotis takis_rs wrote:
> > Hey!!
> > =20
> > I have a problem with my tv card(pinnacle pctv 310i)
> > I can see image but i have no sound.
> > I have tried both tvtime and kdetv.
> > =20
> > I have found this http://ubuntuforums.org/showthread.php?t=3D568528 . I=
s it related with my problem?
> > =20
> > My tv card give audio output with this way: direct cable connection fro=
m
> > tv card to sound card ( same cable witch connect cdrom and soundcard )
>=20
> I didn't read through the link you provided=2C but it appeared to be in
> regards to getting audio via DMA (using the card's 7134 chip to digitize
> the audio and send it over the PCI bus to the host system).  You=2C on th=
e
> other hand=2C indicate that you are attempting to use the method of
> running a patch cable between your TV card and sound card (meaning that
> the sound card will do the digitizing instead).  Question:  have you
> checked your audio mixer to make sure that any of the inputs are not mute=
d?


Yes i have.

The only way i managed to get sound is these two commands:



 tvtime | arecord -D hw:2=2C0 -r 32000 -c 2 -f S16_LE | aplay -  (out of sy=
nc)



tvtime | sox -r 32000 -t alsa hw:2=2C0 -t alsa hw:0=2C1 | aplay -
_________________________________________________________________
Discover the new Windows Vista
http://search.msn.com/results.aspx?q=3Dwindows+vista&mkt=3Den-US&form=3DQBR=
E=

--_4a9e8573-7dc0-48a7-bef1-5b57a888868d_
Content-Type: text/html; charset="iso-8859-7"
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
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
&gt=3B panagiotis takis_rs wrote:<br>&gt=3B &gt=3B Hey!!<br>&gt=3B &gt=3B  =
<br>&gt=3B &gt=3B I have a problem with my tv card(pinnacle pctv 310i)<br>&=
gt=3B &gt=3B I can see image but i have no sound.<br>&gt=3B &gt=3B I have t=
ried both tvtime and kdetv.<br>&gt=3B &gt=3B  <br>&gt=3B &gt=3B I have foun=
d this http://ubuntuforums.org/showthread.php?t=3D568528 . Is it related wi=
th my problem?<br>&gt=3B &gt=3B  <br>&gt=3B &gt=3B My tv card give audio ou=
tput with this way: direct cable connection from<br>&gt=3B &gt=3B tv card t=
o sound card ( same cable witch connect cdrom and soundcard )<br>&gt=3B <br=
>&gt=3B I didn't read through the link you provided=2C but it appeared to b=
e in<br>&gt=3B regards to getting audio via DMA (using the card's 7134 chip=
 to digitize<br>&gt=3B the audio and send it over the PCI bus to the host s=
ystem).  You=2C on the<br>&gt=3B other hand=2C indicate that you are attemp=
ting to use the method of<br>&gt=3B running a patch cable between your TV c=
ard and sound card (meaning that<br>&gt=3B the sound card will do the digit=
izing instead).  Question:  have you<br>&gt=3B checked your audio mixer to =
make sure that any of the inputs are not muted?<br><br>
Yes i have.<br>
The only way i managed to get sound is these two commands:<br>
<br>
&nbsp=3Btvtime | arecord -D hw:2=2C0 -r 32000 -c 2 -f S16_LE | aplay -&nbsp=
=3B (out of sync)<br>
<br>
tvtime | sox -r 32000 -t alsa hw:2=2C0 -t alsa hw:0=2C1 | aplay -<br /><hr =
/>Discover the new Windows Vista <a href=3D'http://search.msn.com/results.a=
spx?q=3Dwindows+vista&mkt=3Den-US&form=3DQBRE' target=3D'_new'>Learn more!<=
/a></body>
</html>=

--_4a9e8573-7dc0-48a7-bef1-5b57a888868d_--


--===============1727213713==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1727213713==--
