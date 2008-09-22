Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48D75FA5.90106@anevia.com>
Date: Mon, 22 Sep 2008 11:04:37 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <48D27B52.2010704@anevia.com> <48D28052.5000209@gmx.de>
	<1221777738.4904.40.camel@pc10.localdom.local>
In-Reply-To: <1221777738.4904.40.camel@pc10.localdom.local>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] hvr 1300 radio
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

hermann pitton a =E9crit :
> Hi,
> =

> Am Donnerstag, den 18.09.2008, 18:22 +0200 schrieb wk:
>> Frederic CAND wrote:
>>> Dear all,
>>>
>>> has anyone got analog FM radio working with an Hauppauge HVR 1300 ?
>>> If yes please tell me how ! I got only noise from /dev/dsp* ... :(
>>> This is an issue I've had for some time now ...
>>> I tried option radio=3D63 on cx88xx module but it did not change anythi=
ng =

>>> (except writing cx88[0]: TV tuner type 63, Radio tuner type 63 in dmesg =

>>> instead of radio tuner type -1 ...)
>>>
>>> Is radio support just not implemented ?
>>>
>>>   =

>> Load cx88_blackbird and open /dev/radioX.
>> I haven't tried radio up to now, but i would expect that only radio *or* =

>> dvb works, but not both at the same time. Most probably radio is also =

>> not feed trough the mpeg encoder.
>>
> =

> a fixme still sticks on radio of the HVR1300.
> =

> 			.audioroute =3D 2,
> 		},{
> 			.type	=3D CX88_VMUX_SVIDEO,
> 			.vmux	=3D 2,
> 			.gpio0	=3D 0xe780,
> 			.audioroute =3D 2,
> 		}},
> 		/* fixme: Add radio support */
> 		.mpeg           =3D CX88_MPEG_DVB | CX88_MPEG_BLACKBIRD,
> 		.radio =3D {
> 			.type   =3D CX88_RADIO,
> 			.gpio0	=3D 0xe780,
> 		},
> 	},
> =

> Guess audio routing and switching is not clear yet.
> =

> The FMD1216ME supports radio over tda9887 and tda7040.
> =

> On the FM1216ME and FM1236 MK3 we can take the stereo indication bit
> from the PLL chip and switch the tda9887 into FM stereo mode
> accordingly. Reading this status information also enables auto scanning
> for radio broadcasts for the applications. (v4l2 aware like kradio
> should be preferred)
> =

> This bit does not work on the hybrid FMD1216ME MK3 and you have to
> create a station list manually once, but then stereo radio is fine.
> =

> On the later FMD1216MEX, which can also be on that board, Steve
> mentioned once that the radio might be slightly different.
> =

> That one is currently treated like the FMD1216ME, but would need its own
> separate tuner type entry in that case.
> =

> We also found hints in tuner specs provided by Steve for ivtv, IIRC,
> that an AFC narrowing down looping can be used to take this as kind of
> signal strength detection on the tda9887 alternatively for the stereo
> bit on the pll. Hartmut was aware of it too, but who likes to work on
> analog radio these days ...

I do. As we embedd these cards on our servers we'd like to add this =

feature to our products (analog to digital streaming servers).
Anyway, this is a feature of the card which is lacking under Linux so =

the question of who is interested in analog radio is not a good =

question. The question of why not going as far as possible when =

supporting a card is a good question.
So yes I am not afraid of saying I'm interested in analgo radio :)

> =

> It is not implemented yet, if it should be related.
> =

> Cheers,
> Hermann
> =

> =

> =


Ok so if I get it right, what you're saying is that stereo radio isn't =

working on HVR 1300 with FMD1216MEX but mono radio is working ? If yes =

I'd like to know how ... shouldn't I just set frequency to /dev/radio, =

then get it from /dev/dsp ??? This for me isn't working and providing =

only noise.

Now if you tell me this is just not implemented yet, then how could I =

help you to implement it ? If it's not scheduled to be implemented one =

day then I might be able to work on it at my office (maybe not me =

directly but one of my coworkers).

Btw I tried on my KNC TV Station DVR (FM1216ME MK3, saa7134, saa6752hs) =

with no success : if I tune to an analog TV station through /dev/video, =

I will get sound from /dev/dsp. Then I tune to a radio through =

/dev/radio ... but I still get the TV sound from /dev/dsp ...

-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
