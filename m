Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KIk8C-0001YK-2w
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 14:59:49 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Tue, 15 Jul 2008 14:59:04 +0200
References: <646735.31020.qm@web23206.mail.ird.yahoo.com>
	<20080715001416.34c5d564@bk.ru> <1216090536l.1474l.2l@manu-laptop>
In-Reply-To: <1216090536l.1474l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807151459.05223.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : Re : Re : problems with multiproto & dvb-s2
	with high SR, losing parts of stream
Reply-To: ajurik@quick.cz
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

On Tuesday 15 of July 2008, manu wrote:
> Le 14.07.2008 16:14:16, Goga777 a =E9crit=A0:
> > > > > And you could retrieve the stream with no problemn even watch
> >
> > it?
> >
> > > > do you mean H264/ffmpeg decoding problem ? Ah, I can't open these
> > > > encrypted channels
> > >
> > > Is it a card problem? I mean my TT-3200 has problems to tune on
> >
> > some
> >
> > > channels, but when it tunes the CI/CAM works perfectly (here almost
> > > every channel is encrypted). Does HVR-4000 has a good CI?
> >
> > I don't have the card, that's why I can't open these channels. We
> > have
> > spoken about LOCK :)
>
> Hmm OK I understand now ;-)
> I was just trying to see if someone around here has found a good dvb-S2
> card with perfect recpetion and good cam support...
> Thx
> Bye
> Manu

Hi,
I'm still thinking that problem is in driver - under Windows everything see=
ms =

to be ok. So I've tried to capture i2c bus between stb0899 and stb6100 and =

got things like this:

Start of driver - linux
Monitoring completed
      0uS: 63 r 48   =

    339uS: 63 W 01   =

    115uS: 66 W  -nak-  =

     96uS: 51 r 78 01 00   . . =

    279uS: 06 r  -nak-  =

    130uS: 61 W A0 85   . =

    202uS: 43 W 90   =

    607uS: 47 W  -nak-  =

    124uS: 50 W 40 00   . =

    326uS: 44 W 80 01   . =

    204uS: 43 r  -nak-  =

    276uS: 43 r  -nak-  =

    131uS: 52 r 00 00   . =

    329uS: 65 W 05 53   S =

    812uS: 51 r  -nak-  =

    125uS: 50 W 40 00   . =

    353uS: 02 W   =

Done

Start if driver - Windows
Monitoring completed
      0uS: 68 W F0 A0 32   . 2 =

    383uS: 68 W F0 A1 80   . . =

    382uS: 68 W F0 A4 04   . . =

    381uS: 68 W F0 A5 00   . . =

    381uS: 68 W F0 A6 00   . . =

    383uS: 68 W F0 A7 00   . . =

    382uS: 68 W F0 A8 20   .   =

    383uS: 68 W F0 A9 8C   . . =

    381uS: 68 W F0 AA 9A   . . =

    381uS: 68 W F1 01 0B   . . =

    382uS: 68 W F1 10 11   . . =

    382uS: 68 W F1 11 0A   . . =

    383uS: 68 W F1 12 05   . . =

    382uS: 68 W F1 13 00   . . =

    381uS: 68 W F1 14 00   . . =

    384uS: 68 W F1 1C 00   . . =

    382uS: 68 W F1 1D 00   . . =

    382uS: 68 W F1 20 FE     . =

    382uS: 68 W F1 21 80   ! . =

    384uS: 68 W F1 22 BC   " . =

    381uS: 68 W F1 23 F4   # . =

    383uS: 68 W F1 24 F3   $ . =

    381uS: 68 W F1 25 FC   % . =

    384uS: 68 W F1 26 FF   & . =

    381uS: 68 W F1 27 FF   ' . =

    382uS: 68 W F1 28 00   ( . =

    383uS: 68 W F1 29 88   ) . =

    381uS: 68 W F1 2A 5C   * \ =

Done

More captures are available - if somebody is interesting in, I'm ready to p=
ost =

it.

All captures are done within the same hw environment with i2c monitoring =

interface from http://ivtv.writeme.ch/tiki-index.php?page=3DMonitoring+I2C+=
Bus.

BR,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
