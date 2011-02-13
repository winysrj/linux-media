Return-path: <mchehab@pedra>
Received: from web30308.mail.mud.yahoo.com ([209.191.69.70]:43854 "HELO
	web30308.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753382Ab1BMIlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 03:41:07 -0500
Message-ID: <429131.49602.qm@web30308.mail.mud.yahoo.com>
Date: Sun, 13 Feb 2011 00:41:05 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: Re: PCTV USB2 PAL / adds loud hum to correct audio
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andy Walls wrote:
> I find audio at 8 ksps very unusual for a TV capture device.
>
I tried it with pulseaudio at 44100 samples/sec
and with some commercial tuned in...
(no big copyright problem hopefully) :-)

i used this command:
parec --device=alsa_input.hw_1 > blah.raw
resulting raw data: http://www.wgboome.de./blah.raw

> The data set contains no large positive values
> (nothing in the range 0x1000-0x7fff).
>
Now the noise is in the positive range, 2...
I made a new filter program (see appendix),
that produces acceptable but still distorted sound.
filter output: http://www.wgboome.de./blah.ogg

> The valuex 0x10 and 0x80 do remind me of the YUV values for black: Y =
> 0x10, U = 0x80, V = 0x80.  Maybe some video data is getting thrown in
> with the audio?
>
sounds good...
because: the unwanted data changed its range now...

-arne

appendix:
...
    (buf[i]/256>=0x80 && buf[i]/256<0xC0) ||
    (buf[i]/256>=0x40 && buf[i]/256<0x80)) {
...


