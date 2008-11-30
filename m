Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gszathmari@gmail.com>) id 1L6izW-0003cE-3e
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 10:53:27 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1429010fga.25
	for <linux-dvb@linuxtv.org>; Sun, 30 Nov 2008 01:53:22 -0800 (PST)
Message-ID: <4df9b1830811300153j38a1173dxeaadf8373db80c2f@mail.gmail.com>
Date: Sun, 30 Nov 2008 10:53:22 +0100
From: "=?ISO-8859-1?Q?Szathm=E1ri_G=E1bor?=" <gszathmari@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: Re: [linux-dvb] Winfast TV2000XP Global sound problem (white noise)
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

Some additional information:

dmesg:
http://pastebin.com/f2d1ff20b

lsmod:
http://pastebin.com/f54073851

Thanks



> Dear all,
>
> Recently I bought a 'Winfast TV2000XP Global' tuner card.
> Almost everything works with the latest kernel:
> the picture is brilliant, I can tune all of the stations, but I have
> white noise (like an untuned channel) instead of proper sound.
>
> I use the the cx88xx module with these options:
> options cx88xx card=3D61 tuner=3D71
> I created the xc3028-v27.fw firmware and copied into /lib/firmware also.
>
> I live in Hungary, and the TV system here is PAL-BG
>
> Thank you in advance.


--
Szathm=E1ri G=E1bor
gszathmari@gmail.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
