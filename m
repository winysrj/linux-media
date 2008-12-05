Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 5 Dec 2008 01:56:15 +0100
From: Tanguy Pruvot <tanguy.pruvot@gmail.com>
Message-ID: <1387916491.20081205015615@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <1228259727.2588.67.camel@pc10.localdom.local>
References: <116652354.20081202092655@gmail.com>
	<1228259727.2588.67.camel@pc10.localdom.local>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com, Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [TUA6030] Infineon TUA6030 driver available... =)
Reply-To: Tanguy Pruvot <tanguy.pruvot@gmail.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <video4linux-list@redhat.com>

Le mercredi 3 d=E9cembre 2008 =E0 00:15:27, vous =E9criviez :

> These tuners have been seen at first on Hauppauge products as
> replacement for the Philips FM1216ME/I H-3 (MK-3) and a member of the
> video4linux-list in the UK had confirmation from Hauppauge's user
> support there, that they are compatible with the prior tuner=3D38.

> This was for a MFPE05-2. (PE =3D PAL/Europe)
> http://tuner.tcl.com/English/html/enewsproopen.asp?proname=3D107&url=3Dpr=
oduct
> I think a MFPE05-3-E was reported on some device too.

> Since then this tuner is mapped to tuner=3D38 in media/video/tveeprom.c
> and is on several Hauppauge devices, but also on others. No complaints
> so far.

> The layout of the tuner PCB of your MFPE05-2-E and the FM1216ME MK3
> seems to be identical. The most visible difference is, that the on your
> tuner just unused tuner pins 7 and 8 are not present at the Philips at
> all. Means 12 against 14 visible tuner pins according to your
> photograph.

> Else only the color of some of the coils differs and instead of TUA 6032
> marked on the pll chip, on the pll used by Philips is only printed B2
> and 230, but both have 38pins connected to the obviously same layout.

> You might even have the same original EPCOS SAW filters, but your tuner
> will not support NTSC, needs different filter equipment.
> NTSC is covered by the MFNM05. (NM =3D NTSC N/M)
> http://tuner.tcl.com/English/html/enewsproopen.asp?proname=3D108&url=3Dpr=
oduct
> This also causes the different bandswitch takeover frequencies.

> On a first look at the main programming table all write and read bytes
> are identical up to every single bit. You can find the datasheet of the
> Philips FM1216ME MK3 we have these days at ivtvdriver.org.
> http://dl.ivtvdriver.org/datasheets/tuners

> If we find details not covered by tuner=3D38, you can get a new tuner
> entry, but the patch must be against recent v4l-dvb. The radio should be
> treated like on the other MK3 tuners in tuner-simple.c I guess.
> IIRC, we have reports for radio working well with port1=3D1, inactive, FM
> high sensitivity.

> We would need a valid signed-off-by line from you as well.

> Thanks, especially for the picture of the opened tuner. We did not have
> any further details previously. Just testing results and the Hauppauge
> hint. =


> Cheers,
> Hermann

Thanks for your help for tuners, i removed NTSC settings...

The default Philips settings doesn't work well, even it's working...

i updated tuner config to best values for TV by disabling AGC,
set to external AGC (0x60) in Init Auxiliary Byte

cf. http://tanguy.ath.cx/index.php?q=3DSAA7130


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
