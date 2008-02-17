Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JQpOF-0007JV-Ni
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 20:41:31 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: Eduard Huguet <eduardhc@gmail.com>
Date: Sun, 17 Feb 2008 20:40:57 +0100
References: <47ADC81B.4050203@gmail.com> <200802131651.17260.zzam@gentoo.org>
	<47B314B8.7060403@gmail.com>
In-Reply-To: <47B314B8.7060403@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802172040.57892.zzam@gentoo.org>
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mittwoch, 13. Februar 2008, Eduard Huguet wrote:
>
> OK, I don't know exactly what you mean, but I'll try to measure the
> output voltage of the input connector. I think you mean this, don't you?
>
> BTW, =BFwhere is the set_voltage app? I have media-tv/linuxtv-dvb-apps
> package installed and there is nothing with that name...
>

Another thing you can try is:
Boot windows and look at the GPIO values. (See v4l wiki for how to do this =

using regspy).

Use my latest diff, and try loading saa7134 with use_frontend=3D1 to use th=
e =

alternative zl10313 driver.

Regards
Matthias

-- =

Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
