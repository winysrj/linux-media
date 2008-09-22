Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp27.orange.fr ([80.12.242.95])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Khrtf-0001JX-9q
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 22:20:40 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Mon, 22 Sep 2008 22:20:03 +0200
References: <mailman.1.1222077601.9177.linux-dvb@linuxtv.org>
	<200809222118.38528.md001@gmx.de>
In-Reply-To: <200809222118.38528.md001@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809222220.03566.hftom@free.fr>
Cc: Martin Dauskardt <md001@gmx.de>
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
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
List-ID: <linux-dvb@linuxtv.org>

Le Monday 22 September 2008 21:18:38 Martin Dauskardt, vous avez =E9crit=A0:
> >This driver has been working in
> > my own use quite well, especially after upgrading the bios to the latest
> > available version from TerraTec.
> >
> > Regards,
> > Tomi Orava
>
> what "bios" do you mean? the firmware?
>
> > Could you check what is the firmware version in your device ?
> > Check for the "bcdDevice" keyword with lsusb -v -s <busid>:<devnum> I h=
ad
> > way too many problems with 1.06 firmware version, but the
> > newer 1.08 seems to be a little bit better in stability.
>
> I was not aware that this device uses a firmware. Do I have to flash it
> into the box? Is this possible with Linux? Where do I find the firmware?

See this message:
http://linuxtv.org/pipermail/linux-dvb/2008-September/028939.html



-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
