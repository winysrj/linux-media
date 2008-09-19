Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mxh.seznam.cz ([77.75.72.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.vasicek@email.cz>) id 1KgZOE-00076n-FH
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 08:22:52 +0200
In-Reply-To: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
Date: Fri, 19 Sep 2008 08:22:13 +0200 (CEST)
To: Michael <m72@fenza.com>
From: roman.vasicek@email.cz
Mime-Version: 1.0
Message-Id: <12710.19705-31287-938985421-1221805332@email.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB USB receiver stopped reporting correct USB ID
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,
I do not know whether it is possible to reinitialize it. I've faced the sam=
e issue with Technisat TeleStick T1. I've send it back to the shop and rece=
ived new one.

Regards,
Roman
> ------------ P=F9vodn=ED zpr=E1va ------------
> Od: Michael <m72@fenza.com>
> P=F8edm=ECt: [linux-dvb] DVB USB receiver stopped reporting correct USB ID
> Datum: 19.9.2008 07:29:55
> ----------------------------------------
> Hi,
> =

> I have a Kworld USB DVB-T receiver that used to work on Mythbuntu 8.04. T=
he
> driver loaded the firmware correctly (dvb-usb-adstech-usb2-02.fw) and
> everything worked OK.
> =

> Suddenly, without me having made any config changes, it is not being found
> anymore, presumably because it is now reporting a USB ID of 04b4:8613
> [CY7C68013 EZ-USB FX2 USB 2.0 Development Kit].
> =

> When it worked, it used to report an ID of 06e1:a334 [ADS Technologies,
> Inc]. I confirmed the same behavior is the same on another PC (also
> mythbuntu 8.04)
> =

> I think it is not a linux driver problem - the device actually has a
> CY7C68013 in it, so I'm guessing it has somehow "lost" its factory
> configuration that tells it is should present an ID of 06e1:a334.
> =

> Does this mean it is dead or is there some way to reinitialise it?
> =

> =

> =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
