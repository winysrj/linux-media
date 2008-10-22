Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate05.web.de ([217.72.192.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SebastianMarskamp@web.de>) id 1KshDv-0002EB-MB
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 19:10:20 +0200
Date: Wed, 22 Oct 2008 19:09:46 +0200
Message-Id: <1551757801@web.de>
MIME-Version: 1.0
From: Sebastian Marskamp <SebastianMarskamp@web.de>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> -----Urspr=FCngliche Nachricht-----
> Von: "Antti Palosaari" <crope@iki.fi>
> Gesendet: 22.10.08 11:38:58
> An: Darron Broad <darron@kewl.org>
> CC: linux-dvb@linuxtv.org
> Betreff: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working


> Darron Broad kirjoitti:
> > In message <48FE6351.2000805@podzimek.org>, Andrej Podzimek wrote:
> >> One more little note about the firmware:
> >>
> >> 	[andrej@xandrej firmware]$ sha1sum dvb-usb-af9015.fw
> >> 	6a0edcc65f490d69534d4f071915fc73f5461560  dvb-usb-af9015.fw
> >>
> >> That file can be found here: http://www.otit.fi/~crope/v4l-dvb/af9015/=
af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
> >>
> >> Is it the right one? Shell I try something else?
> > =

> > Lo
> > =

> > try this patch (WARNING, although I have one of these devices
> > and this looked to fix it, I have no idea what this actually means).
> =

> Your patch means it does not reconnect stick on USB-bus after firmware =

> download. Anyhow, it should reconnect, there is reconnect command in =

> af9015 driver after firmware download. I have no idea why functionality =

> seems to be changed (stick does not reconnect anymore).
> =

> Is that problem coming from after new Kernel?
> =

> regards
> Antti
> -- =

> http://palosaari.fi/
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> =


Yes its related to Kernel 2.6.27.1   .....i test it with diffrent kernels a=
nd only this one  and newer are affected =


_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! =

Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=3D021114


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
