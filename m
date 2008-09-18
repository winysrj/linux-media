Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KgSGU-0000xd-J9
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 00:46:23 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: wk <handygewinnspiel@gmx.de>
In-Reply-To: <48D28052.5000209@gmx.de>
References: <48D27B52.2010704@anevia.com>  <48D28052.5000209@gmx.de>
Date: Fri, 19 Sep 2008 00:42:18 +0200
Message-Id: <1221777738.4904.40.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] hvr 1300 radio
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Donnerstag, den 18.09.2008, 18:22 +0200 schrieb wk:
> Frederic CAND wrote:
> > Dear all,
> >
> > has anyone got analog FM radio working with an Hauppauge HVR 1300 ?
> > If yes please tell me how ! I got only noise from /dev/dsp* ... :(
> > This is an issue I've had for some time now ...
> > I tried option radio=63 on cx88xx module but it did not change anything 
> > (except writing cx88[0]: TV tuner type 63, Radio tuner type 63 in dmesg 
> > instead of radio tuner type -1 ...)
> >
> > Is radio support just not implemented ?
> >
> >   
> Load cx88_blackbird and open /dev/radioX.
> I haven't tried radio up to now, but i would expect that only radio *or* 
> dvb works, but not both at the same time. Most probably radio is also 
> not feed trough the mpeg encoder.
> 

a fixme still sticks on radio of the HVR1300.

			.audioroute = 2,
		},{
			.type	= CX88_VMUX_SVIDEO,
			.vmux	= 2,
			.gpio0	= 0xe780,
			.audioroute = 2,
		}},
		/* fixme: Add radio support */
		.mpeg           = CX88_MPEG_DVB | CX88_MPEG_BLACKBIRD,
		.radio = {
			.type   = CX88_RADIO,
			.gpio0	= 0xe780,
		},
	},

Guess audio routing and switching is not clear yet.

The FMD1216ME supports radio over tda9887 and tda7040.

On the FM1216ME and FM1236 MK3 we can take the stereo indication bit
from the PLL chip and switch the tda9887 into FM stereo mode
accordingly. Reading this status information also enables auto scanning
for radio broadcasts for the applications. (v4l2 aware like kradio
should be preferred)

This bit does not work on the hybrid FMD1216ME MK3 and you have to
create a station list manually once, but then stereo radio is fine.

On the later FMD1216MEX, which can also be on that board, Steve
mentioned once that the radio might be slightly different.

That one is currently treated like the FMD1216ME, but would need its own
separate tuner type entry in that case.

We also found hints in tuner specs provided by Steve for ivtv, IIRC,
that an AFC narrowing down looping can be used to take this as kind of
signal strength detection on the tda9887 alternatively for the stereo
bit on the pll. Hartmut was aware of it too, but who likes to work on
analog radio these days ...

It is not implemented yet, if it should be related.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
