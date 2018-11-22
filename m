Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46318 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbeKWGrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 01:47:14 -0500
Date: Thu, 22 Nov 2018 18:06:11 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: stakanov <stakanov@eclipso.eu>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181122180611.2e7f1123@coco.lan>
In-Reply-To: <2836654.gWKGMNFOG2@roadrunner.suse>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de>
        <20181120140855.29f5dc3f@coco.lan>
        <20181122141908.1ef2bcae@coco.lan>
        <2836654.gWKGMNFOG2@roadrunner.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 Nov 2018 19:58:19 +0100
stakanov <stakanov@eclipso.eu> escreveu:

> Hi Mauro!
>=20
> In data gioved=C3=AC 22 novembre 2018 17:19:08 CET, Mauro Carvalho Chehab=
 ha=20
> scritto:
> > Stakanov,
> >=20
> > Em Tue, 20 Nov 2018 14:08:55 -0200
> >=20
> > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu: =20
> > > Em Tue, 20 Nov 2018 14:20:01 +0100
> > >=20
> > > stakanov <stakanov@eclipso.eu> escreveu: =20
> > > > In data marted=C3=AC 20 novembre 2018 13:42:17 CET, Mauro Carvalho =
Chehab ha
> > > >=20
> > > > scritto: =20
> > > > > Em Tue, 20 Nov 2018 13:11:58 +0100
> > > > >=20
> > > > > "Stakanov Schufter" <stakanov@eclipso.eu> escreveu: =20
> > > > > > Sorry for the delay. Apparently my smtp exits are blocking me (=
for
> > > > > > whatever reason). I am trying now via web mailer.
> > > > > >=20
> > > > > >=20
> > > > > > In short, no it does not work. Only EPG, no pic no sound.
> > > > > > But the error message in dmesg is gone I think.
> > > > > >=20
> > > > > > uname -a
> > > > > > Linux silversurfer 4.20.0-rc3-2.gfe5d771-default #1 SMP PREEMPT=
 Tue
> > > > > > Nov 20
> > > > > > 09:35:04 UTC 2018 (fe5d771) x86_64 x86_64 x86_64 GNU
> > > > > >=20
> > > > > > dmesg:
> > > > > >=20
> > > > > > [    6.412792] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
> > > > > > receiver
> > > > > > chip loaded successfully
> > > > > > [    6.416645] flexcop-pci: will use the HW PID filter.
> > > > > > [    6.416648] flexcop-pci: card revision 2
> > > > > > [    6.423749] scsi host10: usb-storage 9-3.1:1.0
> > > > > > [    6.423842] usbcore: registered new interface driver usb-sto=
rage
> > > > > > [    6.426029] usbcore: registered new interface driver uas
> > > > > > [    6.439251] dvbdev: DVB: registering new adapter (FlexCop Di=
gital
> > > > > > TV
> > > > > > device)
> > > > > > [    6.440845] b2c2-flexcop: MAC address =3D 00:d0:d7:11:8b:58
> > > > > >=20
> > > > > > [    6.694999] dvb_pll_attach: delsys: 0, frequency range:
> > > > > > 950000000..2150000000
> > > > > > [    6.695001] b2c2-flexcop: found 'ST STV0299 DVB-S' .
> > > > > > [    6.695004] b2c2_flexcop_pci 0000:06:06.0: DVB: registering
> > > > > > adapter 0
> > > > > > frontend 0 (ST STV0299 DVB-S)...
> > > > > > [    6.695050] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2
> > > > > > DVB-S rev
> > > > > > 2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete =20
> > > > >=20
> > > > > Well, the Kernel bug is probably gone. I don't see any other rece=
nt
> > > > > changes that would be affecting the b2c2 flexcop driver.
> > > > >=20
> > > > > If you're successfully getting EPG data from the transponders, th=
en it
> > > > > should also be receiving audio and video channels too, as, for the
> > > > > Kernel,
> > > > > there's no difference if a given program ID (PID) contains EPG, a=
udio
> > > > > or
> > > > > video.
> > > > >=20
> > > > > At the BZ, you're saying that you're using Kaffeine, right?
> > > > >=20
> > > > > There are a few reasons why you can't watch audio/video, but you'=
re
> > > > >=20
> > > > > able to get EPG tables:
> > > > > 	- the audio/video PID had changed;
> > > > > 	- the audio/video is now encrypted;
> > > > > 	- too weak signal (or bad cabling).
> > > > >=20
> > > > > The EPG data comes several times per second on well known PIDs, v=
ia a
> > > > > low
> > > > > bandwidth PID and it is not encrypted. So, it is usually trivial =
to
> > > > > get
> > > > > it.
> > > > >=20
> > > > > I suggest you to re-scan your channels on Kaffeine, in order to f=
orce
> > > > > it to get the new PIDs. Also, please check that the channels you'=
re
> > > > > trying to use are Free to the Air (FTA).
> > > > >=20
> > > > > You can also use libdvbv5 tools in order to check if you're not
> > > > > losing data due to weak signal/bad cabling. The newer versions
> > > > > of dvbv5-zap have a logic with detects and report data loses, when
> > > > > started on monitor mode (-m command line option). It also prints
> > > > > the transponder bandwidth, and check what PIDs are received.
> > > > >=20
> > > > > It is very useful to debug problems.
> > > > >=20
> > > > > Thanks,
> > > > > Mauro =20
> > > >=20
> > > > I checked again and:
> > > > [sudo] password di root:
> > > > [    6.412792] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
> > > > receiver chip loaded successfully
> > > > [    6.440845] b2c2-flexcop: MAC address =3D 00:d0:d7:11:8b:58
> > > > [    6.695001] b2c2-flexcop: found 'ST STV0299 DVB-S' .
> > > > [    6.695004] b2c2_flexcop_pci 0000:06:06.0: DVB: registering adap=
ter 0
> > > > frontend 0 (ST STV0299 DVB-S)...
> > > > [    6.695050] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DV=
B-S
> > > > rev
> > > > 2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> > > > [ 6265.403360] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 10719000 out of range (950000..2150000)
> > > > [ 6265.405702] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 10723000 out of range (950000..2150000)
> > > > [ 6265.407120] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 10757000 out of range (950000..2150000)
> > > > [ 6265.408556] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 10775000 out of range (950000..2150000)
> > > > [ 6265.409754] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 10795000 out of range (950000..2150000)
> > > > [ 6399.837806] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 12713000 out of range (950000..2150000)
> > > > [ 6399.839144] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 fronte=
nd 0
> > > > frequency 12731000 out of range (950000..2150000) =20
> > >=20
> > > Ok. Now, min/max frequencies are at the same scale. For DVB-S,
> > > dvb_frontend_get_frequency_limits() returns both in kHz, so the frequ=
ency
> > > range is now OK.
> > >=20
> > > The tuning frequency is wrong through. 10,719,000 kHz - e. g. 10,719 =
MHz
> > > seems to be the transponder frequency you're trying to tune, and not =
the
> > > intermediate frequency used at the DVB-S board.
> > >=20
> > > That sounds to me either a wrong LNBf setting or a bug at libdvbv5 or
> > > at Kaffeine's side. What happens is that the typical European LNBFs a=
re:
> > >=20
> > > 1) the "old" universal one:
> > >=20
> > > UNIVERSAL
> > >=20
> > > 	Universal, Europe
> > > 	Freqs     : 10800 to 11800 MHz, LO: 9750 MHz
> > > 	Freqs     : 11600 to 12700 MHz, LO: 10600 MHz
> > >=20
> > > 2) the "new" universal one, with seems to be used by most modern
> > > satellite dishes in Europe nowadays:
> > >=20
> > > EXTENDED
> > >=20
> > > 	Astra 1E, European Universal Ku (extended)
> > > 	Freqs     : 10700 to 11700 MHz, LO: 9750 MHz
> > > 	Freqs     : 11700 to 12750 MHz, LO: 10600 MHz
> > >=20
> > > Assuming that your satellite dish is equipped with an Astra-1E compat=
ible
> > > LNBf, as you're trying to tune 10,719 MHz, you need to setup Kaffeine
> > > to use the EXTENDED LNBf, with covers the extended frequency range.
> > >=20
> > > Kaffeine/libdvbv5 will subtract this value from the LO frequency:
> > > 	10719 MHz - 9750 MHz =3D 969 MHz
> > >=20
> > > And pass the 969 MHz frequency for the Kernel to tune. As this
> > > is between the 950MHz..2150MHz limit, it won't produce any Kernel
> > > messages.
> > >=20
> > > Please notice that there were some bugs at v4l-utils and DVB-S/S2,
> > > so be sure to check the v4l-utils version you're using. The last
> > > one is 1.14.2 (released on Feb, 10 2018). I recommend you to have
> > > at least version 1.12.4 (released on May, 6 2017). =20
> >=20
> > Did it work after using the EXTENDED LNBf on Kaffeine?
> >=20
> >=20
> > Thanks,
> > Mauro =20
>=20
>=20
>=20
> I am not sure to tell the truth.
> I am using Italian language on my machines. So the only setting I have is=
=20
> LNBf "alta tensione". Now this is like "high tension LNBf if this does te=
ll=20
> you something.
> There are three settings (that are not well documented to tell the truth.=
=20
> First is:
> selection square empty
> then=20
> half empty
> then=20
> full
>=20
> Now, I did not find an explanation on the web for the third position.=20
> One=20
> should use no reinforcement of the signal. One should offer support by=20
> reinforcing the signal (via low tension on the antenna cable?). The middl=
e=20
> position I do not know. Maybe it is the degree of reinforcement?
> Now, I tried all three in a sequence. I did not encounter any change.=20

This setting controls an special ioctl that it is not available on all
devices. Except if you have a problem, and your device supports it, you
should let it at the "half empty" state, meaning that Kaffeine won't use
the ioctl.=20

Anyway, this not where you set the LNBf. Look at the Kaffeine's handbook:
it should have some pictures showing where the LNBf setting is done, but
it is on a separate popup window[1]:

	https://git.linuxtv.org/mchehab/kaffeine.git/plain/doc/kaffeine_configure_=
tv_lnbf.png

There, you can select the EXTENDED LNBf item (it is the third one: Astra 1E=
).

[1] this picture is there at the Kaffeine's handbook, with can be activated
    on Kaffeine by using the F1 key). You can also see the full Kaffeine's
    manual at:
	https://docs.kde.org/trunk5/en/extragear-multimedia/kaffeine/index.html

    There's even an Italian translation for it (although it is outdated):

	https://docs.kde.org/trunk5/it/extragear-multimedia/kaffeine/index.html

> I have however a doubt that I am going to verify today. I am thinking tha=
t up=20
> to 4.18.15-1 for some reasons you did not use the firmware that Linux TV =
org=20
> does advice for the card. While it could be that it is needed now, I am g=
oing=20
> to download and verify today. The only rational explanation that I could =
have=20
> is that before it did inadvertently another firmware that comes with TW (=
there=20
> are several) or that TW did take out the firmware but I would have been a=
sked=20
> before removal...=20
> Anyway, that is the last experiment at least if you do not tell me that u=
p to=20
> now I did not do the right thing (in that case be very verbose to be sure=
 I do=20
> understand well were to change settings).=20
> BTW the only other choice is between "disecq and rotor" and as we do not =
have=20
> a rotor on the roof....
>=20
> Comparison: I have in the machine in parallel a Hauppauge Card 5525 HD an=
d so=20
> I can confirm the signal is good. However this card too stayed black only=
 EPG,=20
> so I did download the firmware to /lib/firmware. I did reboot and it work=
s now=20
> perfectly. I will try the same with the Technisat. But the question remai=
ns=20
> why it did work without firmware with the previous kernel. I am puzzled.=
=20

Are you sure that the difference is just the Kernel version? Perhaps you
also updated some other package.

> I will update you tomorrow. Be patient if you should have found out that =
I did=20
> not check for the right thing. I really appreciate your help given and=20
> ignorance is, so to say, never intentional. ;-)=20
>=20
> Thank you,=20
> Stak.=20
>=20
>=20
>=20
> _________________________________________________________________
> ________________________________________________________
> Ihre E-Mail-Postf=C3=A4cher sicher & zentral an einem Ort. Jetzt wechseln=
 und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
>=20
>=20



Thanks,
Mauro
