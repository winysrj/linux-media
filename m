Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JP2Mo-0006MI-AV
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 22:08:38 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: Eduard Huguet <eduardhc@gmail.com>
Date: Tue, 12 Feb 2008 22:08:07 +0100
References: <47ADC81B.4050203@gmail.com> <47AECFEF.3010503@gmail.com>
	<47B0134D.90006@gmail.com>
In-Reply-To: <47B0134D.90006@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802122208.07450.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Monday 11 February 2008, you wrote:
> En/na Eduard Huguet ha escrit:
> > En/na Matthias Schwarzott ha escrit:
> >> On Samstag, 9. Februar 2008, Eduard Huguet wrote:
> >>> Hi, Matthias
> >>
> >> Hi Eduard!
> >>
> >>>     I've been performing some tests using your patch for this card.
> >>> Right now neither dvbscan nor kaffeine are able to find any channel on
> >>> Astra (the sat. my dish points to).
> >>>
> >>> However, Kaffeine has been giving me some interesting results: with
> >>> your driver "as is" it's getting me a 13-14% signal level and ~52% SNR
> >>> when scanning. Then, thinking that the problem is related to the low
> >>> signal I have I've changed the gain levels used to program the tuner:
> >>> you were using default values of 0 for all (in
> >>> zl1003x_set_gain_params() function, variables "rfg", "ba" and "bg"),
> >>> and I've changed them top the maximum (according to the documentation:
> >>> rfg=3D1, ba=3Dbg=3D3). With that, I'm getting a 18% signal level, whi=
ch is
> >>> higher but still too low apparently to get a lock.
> >>>
> >>> I've stopped here, because I really don't have the necessary backgrou=
nd
> >>> to keep tweaking the driver. I just wanted to share it with you, as
> >>> maybe you have some idea on how to continue or what else could be don=
e.
> >>
> >> So I can do only this guess:
> >> I changed demod driver to invert the Polarization voltage for a700 car=
d.
> >> This is controlled by member-variable voltage_inverted.
> >>
> >> static struct mt312_config avertv_a700_mt312 =3D {
> >>         .demod_address =3D 0x0e,
> >>         .voltage_inverted =3D 1,
> >> };
> >>
> >> Can you try to comment the voltage_inverted line here (saa7134-dvb.c:
> >> line 865).
> >>
> >> BUT: If this helps we need to find out how to detect which card needs
> >> this enabled/disabled.
> >>
> >> Regards
> >> Matthias
> >
> > Hi,
> >   Nothing :(. Removing (or setting it to 0) the voltage_inverted
> > member doesn't seem to make any difference. I'm starting to suspect
> > that there is something wrong with my antennae setup, so I'll test it
> > later using an standalone STB or by plugging the card into a Windows
> > computer and using the supplied drivers.
> >
> > Regards,
> >   Eduard
>
> By the way (sorry if I'm being molest...): I will leave the card in this
> PC for now, as it's easier fo me to test and develop. As I have also
> Windows here =BFis there any way we could do any reverse enginnering from
> Windows driver, etc...?
>

I already asked you to compare eeprom output in dmesg. But did you also =

compare GPIO messages - like init-values read after startup (to detect =

different wiring)?
This is from my dmesg output: "saa7133[0]: board init: gpio is a600"

Or just attach dmesg output after a cold boot and loading saa7134 driver (w=
ith =

i2c_scan=3D1).

Maybe I create a patch where you can select the other existing zl10313 driv=
er.
So we can compare the logs / functionality.

Matthias

-- =

Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
