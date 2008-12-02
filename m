Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp3-g19.free.fr ([212.27.42.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <djamil@djamil.net>) id 1L7OlQ-00014R-8l
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 07:29:40 +0100
From: djamil <djamil@djamil.net>
To: Jeff DeFouw <jeffd@i2k.com>
In-Reply-To: <20081122195252.GA26727@blorp.plorb.com>
References: <20081122195252.GA26727@blorp.plorb.com>
Date: Tue, 02 Dec 2008 07:29:34 +0100
Message-Id: <1228199374.7788.2.camel@toptop>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] notes and code for HVR-1800 S-Video
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1617749832=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1617749832==
Content-Type: multipart/alternative; boundary="=-ZJYMvUWRSuwqwTTL2qBz"


--=-ZJYMvUWRSuwqwTTL2qBz
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi=20
I am trying to do the same thing on my HVR 1400, can you give me clues
on how i can hack it up

I want to get analog working for svideo/composite inputs ...

Any tools under windows to spy on it ...


best regards

Le samedi 22 novembre 2008 =E0 14:52 -0500, Jeff DeFouw a =E9crit :

> I compared the registers in different modes with the Windows driver for=
=20
> my WinTV-HVR-1800 (CX23887 based, PCI-E).  Setting the AFE control=20
> registers fixes bad and flickering colors in S-Video mode.  The same=20
> register values are used for Composite.
>=20
> /* Set AFE control for Composite/S-Video input */
> cx25840_write4(client, 0x104, 0x071cdc00);
>=20
> In analog tuner mode, the values are the chip defaults (0x0704dd80), bu=
t=20
> I've left the regs set for S-Video and didn't notice anything.
>=20
> To get the external audio input working (for Composite and S-Video=20
> modes), the input needs to be set to AC97, unmuted, and the=20
> microcontroller must be disabled (so it doesn't mute it).  The=20
> microcontroller was always being enabled for some reason no matter the=20
> audio source.
>=20
> /* Set Path1 to AC97 and unmute */
> cx25840_write4(client, 0x8d0, 0x00063073);
>=20
> With those two changes I am able to record S-Video and external audio=20
> through the MPEG encoder.  I managed to hack the code up enough to get=20
> all modes working based on the input setting.  It's not clear in the=20
> existing cx23885-cx25840 framework how the audio input is supposed to b=
e=20
> configured.
>=20
> Other issues:
>=20
> The MPEG encoder video device randomly fails to start streaming, times=20
> out, and returns an I/O error.  It's like something isn't being reset o=
r=20
> waited on properly during the setup.  The next attempt usually works,=20
> but I can try 5 times and not succeed.
>=20
> The MPEG encoder video device rejects attempts to set the input and=20
> other settings as the raw video device does.  The raw video device must=
=20
> be used for configuration, so any application would have to do somethin=
g=20
> special with both devices to be fully functional.  Is there a reason fo=
r=20
> that?
>=20
> Viewing the analog tuner over the raw video device and then using the=20
> MPEG video device often causes the tuner video on both devices to be=20
> scrambled.  Reloading the modules fixes it.  This only happens the firs=
t=20
> time after boot.
>=20
> The cx23885-audio branch screws up the operation of my card. =20
> Specifically the patch to cx23885_initialize that disables the write to=
=20
> register 0x2 affects my board and scrambles the video and audio rate. =20
> It even screws up the MCU firmware download.
>=20

--=-ZJYMvUWRSuwqwTTL2qBz
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.24.1.1">
</HEAD>
<BODY>
Hi <BR>
I am trying to do the same thing on my HVR 1400, can you give me clues on how i can hack it up<BR>
<BR>
I want to get analog working for svideo/composite inputs ...<BR>
<BR>
Any tools under windows to spy on it ...<BR>
<BR>
<BR>
best regards<BR>
<BR>
Le samedi 22 novembre 2008 &#224; 14:52 -0500, Jeff DeFouw a &#233;crit :
<BLOCKQUOTE TYPE=CITE>
<PRE>
I compared the registers in different modes with the Windows driver for 
my WinTV-HVR-1800 (CX23887 based, PCI-E).  Setting the AFE control 
registers fixes bad and flickering colors in S-Video mode.  The same 
register values are used for Composite.

/* Set AFE control for Composite/S-Video input */
cx25840_write4(client, 0x104, 0x071cdc00);

In analog tuner mode, the values are the chip defaults (0x0704dd80), but 
I've left the regs set for S-Video and didn't notice anything.

To get the external audio input working (for Composite and S-Video 
modes), the input needs to be set to AC97, unmuted, and the 
microcontroller must be disabled (so it doesn't mute it).  The 
microcontroller was always being enabled for some reason no matter the 
audio source.

/* Set Path1 to AC97 and unmute */
cx25840_write4(client, 0x8d0, 0x00063073);

With those two changes I am able to record S-Video and external audio 
through the MPEG encoder.  I managed to hack the code up enough to get 
all modes working based on the input setting.  It's not clear in the 
existing cx23885-cx25840 framework how the audio input is supposed to be 
configured.

Other issues:

The MPEG encoder video device randomly fails to start streaming, times 
out, and returns an I/O error.  It's like something isn't being reset or 
waited on properly during the setup.  The next attempt usually works, 
but I can try 5 times and not succeed.

The MPEG encoder video device rejects attempts to set the input and 
other settings as the raw video device does.  The raw video device must 
be used for configuration, so any application would have to do something 
special with both devices to be fully functional.  Is there a reason for 
that?

Viewing the analog tuner over the raw video device and then using the 
MPEG video device often causes the tuner video on both devices to be 
scrambled.  Reloading the modules fixes it.  This only happens the first 
time after boot.

The cx23885-audio branch screws up the operation of my card.  
Specifically the patch to cx23885_initialize that disables the write to 
register 0x2 affects my board and scrambles the video and audio rate.  
It even screws up the MCU firmware download.

</PRE>
</BLOCKQUOTE>
</BODY>
</HTML>

--=-ZJYMvUWRSuwqwTTL2qBz--



--===============1617749832==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1617749832==--
