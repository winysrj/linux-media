Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAN1gvpC025688
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 20:42:58 -0500
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.223.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAN1giOV011782
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 20:42:44 -0500
Received: by iwn4 with SMTP id 4so268623iwn.23
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 17:42:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6ab2c27e0911221723v5479a179kbe42a67ebb53a797@mail.gmail.com>
References: <19415111.1258842824951.JavaMail.ngmail@webmail09.arcor-online.net>
	<6ab2c27e0911220451y1777caaelc54dd9e70b974bac@mail.gmail.com>
	<1258929022.7524.6.camel@pc07.localdom.local>
	<6ab2c27e0911221723v5479a179kbe42a67ebb53a797@mail.gmail.com>
Date: Mon, 23 Nov 2009 09:42:43 +0800
Message-ID: <6ab2c27e0911221742g739380d1m10b517d25f451898@mail.gmail.com>
From: Terry Wu <terrywu2009@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Content-Type: multipart/mixed; boundary=00151774155a18674b0478fff1ad
Cc: video4linux-list@redhat.com
Subject: Re: Re: Leadtek Winfast TV2100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--00151774155a18674b0478fff1ad
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

    Please refer to the attached JPEG file for the GPIO settings of
TV2100 with FM (PCB:B).

    Let me know if you need the information of TV2100 without FM
(PCB:A, TVF8533-BDF).

Terry Wu

2009/11/23 Terry Wu <terrywu2009@gmail.com>:
> Hi,
>
> =A0 =A0The TVF88T5-BDFF data sheet is attached.
>
> Terry Wu
>
> 11/17/2003 =A006:39 PM =A0 =A0 =A0 =A0 =A0 =A072,010 TVF5531-MF.pdf
> 03/12/2008 =A011:37 AM =A0 =A0 =A0 =A0 =A0 555,285 TVF5533-MF-.pdf
> 02/24/2004 =A002:19 PM =A0 =A0 =A0 =A0 =A0 120,727 TVF5533-MF.pdf
> 12/30/2003 =A006:59 PM =A0 =A0 =A0 =A0 =A0 =A091,577 TVF5831-MFF.pdf
> 09/26/2005 =A010:20 AM =A0 =A0 =A0 =A0 =A0 156,853 TVF78P3-MFF.pdf
> 11/17/2003 =A006:39 PM =A0 =A0 =A0 =A0 =A0 =A067,947 TVF8531-BDF.pdf
> 11/17/2003 =A006:39 PM =A0 =A0 =A0 =A0 =A0 =A067,715 TVF8531-DIF.pdf
> 03/12/2008 =A011:37 AM =A0 =A0 =A0 =A0 =A0 509,340 TVF8533-BDF.pdf
> 03/12/2008 =A011:37 AM =A0 =A0 =A0 =A0 =A0 507,295 TVF8533-DIF.pdf
> 12/30/2003 =A006:59 PM =A0 =A0 =A0 =A0 =A0 =A087,921 TVF8831-BDFF.pdf
> 12/30/2003 =A006:59 PM =A0 =A0 =A0 =A0 =A0 =A087,624 TVF8831-DIFF.pdf
> 09/26/2005 =A010:20 AM =A0 =A0 =A0 =A0 =A0 176,525 TVF88P3-CFF.pdf
> 03/24/2006 =A010:48 AM =A0 =A0 =A0 =A0 =A0 460,941 TVF88T5-BDFF.pdf
> 02/24/2004 =A002:19 PM =A0 =A0 =A0 =A0 =A0 132,304 TVF9533-BDF.pdf
> 02/24/2004 =A002:19 PM =A0 =A0 =A0 =A0 =A0 120,940 TVF9533-DIF.pdf
> 03/12/2008 =A011:37 AM =A0 =A0 =A0 =A0 =A0 458,967 TVF99T5-BDFF.pdf
>
>
> 2009/11/23 hermann pitton <hermann-pitton@arcor.de>:
>> Hi,
>>
>> Am Sonntag, den 22.11.2009, 20:51 +0800 schrieb Terry Wu:
>>> Hi,
>>>
>>> =A0 =A0 I will give you the tuner data sheet and schematic of GPIO tomo=
rrow.
>>> =A0 =A0 Stay tuned.
>>>
>>> Terry
>>
>> that is of course very welcome.
>>
>> We know that the PLL chip is TI sn761677, datasheet is publicly
>> available, radio switch is 0x11 and inside is a TENA tuner PCB also
>> known from other tuners.
>>
>> For the gpio configuration hopefully my assumptions should not be that
>> wrong.
>>
>> Pavle, are you able to test such yourself or should I provide some
>> patches?
>>
>> Cheers,
>> Hermann
>>
>>> 2009/11/22 =A0<hermann-pitton@arcor.de>:
>>> > Hi,
>>> >
>>> > sorry, posting from a webmail interface.
>>> >
>>> > Might get bounced from the list.
>>> >
>>> > ----- Original Nachricht ----
>>> > Von: =A0 =A0 Pavle Predic <pavle.predic@yahoo.co.uk>
>>> > An: =A0 =A0 =A0Terry Wu <terrywu2009@gmail.com>, hermann pitton <herm=
ann-pitton@arcor.de>
>>> > Datum: =A0 21.11.2009 20:53
>>> > Betreff: Re: Leadtek Winfast TV2100
>>> >
>>> >> Hey Terry,
>>> >>
>>> >> Thanks for your input. Yes it would seem that my tuner is not suppor=
ted
>>> >> (it's a YMEC Tvision TVF88T5-B/DFF), and neither is my board. But I =
was
>>> >> hoping that an existing board/tuner combination might do the job.
>>> >>
>>> >> @Hermann - I tried card IDs 1-150 with tuner=3D69 and - alas - didn'=
t get
>>> >> sound. Interestingly enough, almost all card ids produce a picture w=
ith this
>>> >> tuner. Also, I noticed that with some board IDs I'm getting clicks w=
hen
>>> >> muting/unmuting or switching channels, but no broadcast sound
>>> >> whatsoever...:(
>>> >
>>> > Tuner=3D69 covers a lot of tuners with TexasInstruments pll chip, NTS=
C and PAL.
>>> > I looked up this tuner from your previous mail and 69 is correct. You=
 will note this when it comes to radio, UHF frequencies and takeover freque=
ncies.
>>> >
>>> >> I also tried running regspy.exe (after booting to Windows) and perfo=
rmed the
>>> >> test as described on dscaler site. But the results are way to crypti=
c for
>>> >> me...I have no clue how to use this. So I'll paste it here, and mayb=
e
>>> >> someone will be able to draw a conclusion:
>>> >>
>>> > Ah, good.
>>> >
>>> >> SAA7130 Card [0]:
>>> >>
>>> >> Vendor ID: =A0 =A0 =A0 =A0 =A0 0x1131
>>> >> Device ID: =A0 =A0 =A0 =A0 =A0 0x7130
>>> >> Subsystem ID: =A0 =A0 =A0 =A00x6f3a107d
>>> >>
>>> >>
>>> >> 7 states dumped
>>> >>
>>> >> --------------------------------------------------------------------=
--------
>>> >> ------
>>> >>
>>> >> SAA7130 Card - State 0:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 80000009 * (10000000 00=
000000 00000000
>>> >> 00001001)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 0606200c * (00000110 0000=
0110 00100000
>>> >> 00001100)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c1 =A0 =A0 =A0 =A0 (1100000=
1)
>>> >>
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A03b * =A0 =A0 =A0 (00111011)
>>> >>
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >>
>>> >> Changes: State 0 -> State 1:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 80000009 -> 8000000d =
=A0(-------- --------
>>> >> -------- -----0--)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 0606200c -> 00062000 =A0(=
-----11- --------
>>> >> -------- ----11--)
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A03b =A0 =A0 =A0 -> 00 =A0 =
=A0 =A0 =A0(--111-11)
>>> >>
>>> >>
>>> >> 3 changes
>>> >>
>>> >>
>>> >> --------------------------------------------------------------------=
--------
>>> >> ------
>>> >>
>>> >> SAA7130 Card - State 1:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 8000000d =A0 (10000000 =
00000000 00000000
>>> >> 00001101) =A0(was: 80000009)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 00062000 * (00000000 0000=
0110 00100000
>>> >> 00000000) =A0(was: 0606200c)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c1 * =A0 =A0 =A0 (11000001)
>>> >>
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A000 * =A0 =A0 =A0 (00000000)
>>> >> =A0 =A0 =A0 (was: 3b)
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >>
>>> >> Changes: State 1 -> State 2:
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 00062000 -> 00062008 =A0(=
-------- --------
>>> >> -------- ----0---)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c1 =A0 =A0 =A0 -> 83 =A0 =
=A0 =A0 =A0(-1----0-)
>>> >>
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A000 =A0 =A0 =A0 -> 09 =A0 =
=A0 =A0 =A0(----0--0)
>>> >>
>>> >>
>>> >> 3 changes
>>> >>
>>> >>
>>> >> --------------------------------------------------------------------=
--------
>>> >> ------
>>> >>
>>> >> SAA7130 Card - State 2:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 8000000d =A0 (10000000 =
00000000 00000000
>>> >> 00001101)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 00062008 =A0 (00000000 00=
000110 00100000
>>> >> 00001000) =A0(was: 00062000)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 83 * =A0 =A0 =A0 (10000011)
>>> >> =A0 =A0 =A0 (was: c1)
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A009 =A0 =A0 =A0 =A0 (0000100=
1)
>>> >> =A0 =A0 =A0 (was: 00)
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >>
>>> >> Changes: State 2 -> State 3:
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 83 =A0 =A0 =A0 -> c8 =A0 =
=A0 =A0 =A0(-0--0-11)
>>> >>
>>> >>
>>> >> 1 changes
>>> >>
>>> >>
>>> >> --------------------------------------------------------------------=
--------
>>> >> ------
>>> >>
>>> >> SAA7130 Card - State 3:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 8000000d =A0 (10000000 =
00000000 00000000
>>> >> 00001101)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 00062008 * (00000000 0000=
0110 00100000
>>> >> 00001000)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c8 * =A0 =A0 =A0 (11001000)
>>> >> =A0 =A0 =A0 (was: 83)
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A009 * =A0 =A0 =A0 (00001001)
>>> >>
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >>
>>> >> Changes: State 3 -> State 4:
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 00062008 -> 04062004 =A0(=
-----0-- --------
>>> >> -------- ----10--)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c8 =A0 =A0 =A0 -> c1 =A0 =
=A0 =A0 =A0(----1--0)
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(same as 0, 1)
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A009 =A0 =A0 =A0 -> 00 =A0 =
=A0 =A0 =A0(----1--1)
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(same as 1)
>>> >>
>>> >> 3 changes
>>> >>
>>> >>
>>> >> --------------------------------------------------------------------=
--------
>>> >> ------
>>> >>
>>> >> SAA7130 Card - State 4:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 8000000d =A0 (10000000 =
00000000 00000000
>>> >> 00001101)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 04062004 * (00000100 0000=
0110 00100000
>>> >> 00000100) =A0(was: 00062008)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c1 =A0 =A0 =A0 =A0 (1100000=
1)
>>> >> =A0 =A0 =A0 (was: c8)
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >> =A0 =A0 =A0 (was: 09)
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >>
>>> >> Changes: State 4 -> State 5:
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 04062004 -> 02062000 =A0(=
-----10- --------
>>> >> -------- -----1--)
>>> >>
>>> >> 1 changes
>>> >>
>>> >>
>>> >> --------------------------------------------------------------------=
--------
>>> >> ------
>>> >>
>>> >> SAA7130 Card - State 5:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 8000000d =A0 (10000000 =
00000000 00000000
>>> >> 00001101)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 02062000 * (00000010 0000=
0110 00100000
>>> >> 00000000) =A0(was: 04062004)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c1 =A0 =A0 =A0 =A0 (1100000=
1)
>>> >>
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A000 * =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >>
>>> >> Changes: State 5 -> Register Dump:
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 02062000 -> 06062008 =A0(=
-----0-- --------
>>> >> -------- ----0---)
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A000 =A0 =A0 =A0 -> 02 =A0 =
=A0 =A0 =A0(------0-)
>>> >>
>>> >>
>>> >> 2 changes
>>> >>
>>> >>
>>> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>> >> =3D=3D=3D=3D=3D
>>> >>
>>> >> SAA7130 Card - Register Dump:
>>> >> SAA7134_GPIO_GPMODE: =A0 =A0 =A0 =A0 =A0 =A0 8000000d =A0 (10000000 =
00000000 00000000
>>> >> 00001101)
>>> >> SAA7134_GPIO_GPSTATUS: =A0 =A0 =A0 =A0 =A0 06062008 =A0 (00000110 00=
000110 00100000
>>> >> 00001000) =A0(was: 02062000)
>>> >> SAA7134_ANALOG_IN_CTRL1: =A0 =A0 =A0 =A0 c1 =A0 =A0 =A0 =A0 (1100000=
1)
>>> >>
>>> >> SAA7134_ANALOG_IO_SELECT: =A0 =A0 =A0 =A002 =A0 =A0 =A0 =A0 (0000001=
0)
>>> >> =A0 =A0 =A0 (was: 00)
>>> >> SAA7134_VIDEO_PORT_CTRL0: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL4: =A0 =A0 =A0 =A000000000 =A0 (00000000 0000=
0000 00000000
>>> >> 00000000)
>>> >> SAA7134_VIDEO_PORT_CTRL8: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_SELECT: =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_FORMAT: =A0 =A0 =A0 01 =A0 =A0 =A0 =A0 (00000001)
>>> >>
>>> >> SAA7134_I2S_OUTPUT_LEVEL: =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0000000=
0)
>>> >>
>>> >> SAA7134_I2S_AUDIO_OUTPUT: =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (0000000=
1)
>>> >>
>>> >> SAA7134_TS_PARALLEL: =A0 =A0 =A0 =A0 =A0 =A0 04 =A0 =A0 =A0 =A0 (000=
00100)
>>> >>
>>> >> SAA7134_TS_PARALLEL_SERIAL: =A0 =A0 =A000 =A0 =A0 =A0 =A0 (00000000)
>>> >>
>>> >> SAA7134_TS_SERIAL0: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_SERIAL1: =A0 =A0 =A0 =A0 =A0 =A0 =A000 =A0 =A0 =A0 =A0 (0=
0000000)
>>> >>
>>> >> SAA7134_TS_DMA0: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA1: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_TS_DMA2: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 00 =A0 =A0 =A0 =A0 =
(00000000)
>>> >>
>>> >> SAA7134_SPECIAL_MODE: =A0 =A0 =A0 =A0 =A0 =A001 =A0 =A0 =A0 =A0 (000=
00001)
>>> >>
>>> >>
>>> >> end of dump
>>> >>
>>> >> Here is the order in which I performed the test:State 6
>>> >> State 0 - viewing software off
>>> >> State 1 - tuner mode
>>> >> State 2 - composite mode
>>> >> State 3 - s video mode
>>> >> State 4 - radio mode
>>> >> State 5 - tuner mode (again)
>>> >> Final dump - viewing software off (again)
>>> >>
>>> >> Thanks to everyone for your help.
>>> >>
>>> >> Pavle.
>>> >>
>>> >
>>> > Better don't top post. Becomes hard to read after a while.
>>> >
>>> > You would try wsith a gpio_mask =3D 0x0d.
>>> >
>>> > .gpio for TV is 0x00000000 (default, don't even need to set it).
>>> >
>>> > For s-video and composite 0x08.
>>> >
>>> > For radio 0x04.
>>> >
>>> > On saa7130 chips mono audio from tuner in most cases is connected to =
LINE2.
>>> >
>>> > Then also radio is on LINE2 and s-video and composite on LINE1.
>>> >
>>> > For .mute it seems to switch to s-video/composite LINE input and keep=
s that input open with .gpio 0x08.
>>> >
>>> > Maybe Terry knows better.
>>> >
>>> > Good luck for testing.
>>> >
>>> > Cheers,
>>> > Hermann
>>> >
>>> >>
>>> >> ________________________________
>>> >> From: Terry Wu <terrywu2009@gmail.com>
>>> >> To: hermann pitton <hermann-pitton@arcor.de>
>>> >> Cc: Pavle Predic <pavle.predic@yahoo.co.uk>; video4linux-list@redhat=
.com
>>> >> Sent: Sat, 21 November, 2009 10:07:05
>>> >> Subject: Re: Leadtek Winfast TV2100
>>> >>
>>> >> Hi,
>>> >>
>>> >> =A0 =A0 There are many models of TV2100.
>>> >> =A0 =A0 Different model uses different TV tuner.
>>> >>
>>> >> =A0 =A0 The tuner 69 is TUNER_TNF_5335MF.
>>> >> =A0 =A0 Make sure the tuner in your TV2100 card is the TNF_5335MF.
>>> >>
>>> >> =A0 =A0 Maybe the tuner in your TV2100 card is not supported by curr=
ent
>>> >> v4l-dvb driver yet (linux\include\media\tuner.h).
>>> >>
>>> >>
>>> >> Terry
>>> >>
>>> >> 2009/11/21 hermann pitton <hermann-pitton@arcor.de>:
>>> >> > Hi Pavle,
>>> >> >
>>> >> > Am Freitag, den 20.11.2009, 14:11 +0000 schrieb Pavle Predic:
>>> >> >> Hi Hermann,
>>> >> >>
>>> >> >> Thank you so much for your help. I didn't really get most of what=
 you
>>> >> >> said (way to technical for me), but at least I know now which tun=
er I
>>> >> >> should use, so I'll keep testing with tuner 69 and see if I get
>>> >> >> results.
>>> >> >
>>> >> > that one should be right, especially for analog radio.
>>> >> >
>>> >> >> BTW, I'm not from UK - I'm from Serbia and I'm trying to make the=
 card
>>> >> >> work for my cable tv which uses PAL BG (at least so they say).
>>> >> >
>>> >> > Lots of people are on the move these days, therefore it is importa=
nt to
>>> >> > know too, what they might carry with them. That tuner should be fi=
ne
>>> >> > then.
>>> >> >
>>> >> >> I'll report back after testing on tuner 69 (I'll simply try all c=
ard
>>> >> >> ids with this tuner id). In the meantime here's some more info:
>>> >> >
>>> >> > Better is to follow the advice how you can narrow down such stuff.
>>> >> >
>>> >> > As far I know, we have not destroyed a single device yet on the sa=
a7134
>>> >> > driver, but to go over all possibilities, concerning voltage and g=
pios,
>>> >> > has some risks and is not the shortest way to come closer.
>>> >> >
>>> >> > Thanks for your input.
>>> >> >
>>> >> > Cheers,
>>> >> > Hermann
>>> >> >
>>> >> >> dmesg:
>>> >> >>
>>> >> >> [ =A0 =A09.829338] saa7130/34: v4l2 driver version 0.2.15 loaded
>>> >> >> [ =A0 =A09.829408] saa7134 0000:00:08.0: PCI INT A -> GSI 17 (lev=
el, low)
>>> >> >> -> IRQ 17
>>> >> >> [ =A0 =A09.829419] saa7130[0]: found at 0000:00:08.0, rev: 1, irq=
: 17,
>>> >> >> latency: 64, mmio: 0xfdffe000
>>> >> >> [ =A0 =A09.829428] saa7130[0]: subsystem: 107d:6f3a, board:
>>> >> >> UNKNOWN/GENERIC [card=3D0,autodetected]
>>> >> >> [ =A0 =A09.829458] saa7130[0]: board init: gpio is 6200c
>>> >> >> [ =A0 =A09.829465] IRQ 17/saa7130[0]: IRQF_DISABLED is not guaran=
teed on
>>> >> >> shared IRQs
>>> >> >> [ =A0 =A09.980513] saa7130[0]: i2c eeprom 00: 7d 10 3a 6f 54 20 1=
c 00 43
>>> >> >> 43 a9 1c 55 d2 b2 92
>>> >> >> [ =A0 =A09.980532] saa7130[0]: i2c eeprom 10: 0c ff 82 0e ff 20 f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980547] saa7130[0]: i2c eeprom 20: 01 40 02 03 03 02 0=
1 03 08
>>> >> >> ff 00 8c ff ff ff ff
>>> >> >> [ =A0 =A09.980562] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980578] saa7130[0]: i2c eeprom 40: 50 89 00 c2 00 00 0=
2 30 02
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980593] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980608] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980623] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980639] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980654] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980670] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980685] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980701] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980716] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980731] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980747] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff f=
f ff ff
>>> >> >> ff ff ff ff ff ff ff
>>> >> >> [ =A0 =A09.980876] saa7130[0]: registered device video0 [v4l2]
>>> >> >> [ =A0 =A09.980908] saa7130[0]: registered device vbi0
>>> >> >>
>>> >> >>
>>> >> >> lsmod:
>>> >> >>
>>> >> >> saa7134 =A0 =A0 =A0 =A0 =A0 =A0 =A0 135552 =A00
>>> >> >> ir_common =A0 =A0 =A0 =A0 =A0 =A0 =A047172 =A01 saa7134
>>> >> >> v4l2_common =A0 =A0 =A0 =A0 =A0 =A014308 =A01 saa7134
>>> >> >> videodev =A0 =A0 =A0 =A0 =A0 =A0 =A0 31040 =A02 saa7134,v4l2_comm=
on
>>> >> >> videobuf_dma_sg =A0 =A0 =A0 =A011340 =A01 saa7134
>>> >> >> videobuf_core =A0 =A0 =A0 =A0 =A016164 =A02 saa7134,videobuf_dma_=
sg
>>> >> >> tveeprom =A0 =A0 =A0 =A0 =A0 =A0 =A0 10720 =A01 saa7134
>>> >> >> i2c_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 20844 =A04
>>> >> >> i2c_viapro,saa7134,v4l2_common,tveeprom
>>> >> >>
>>> >> >> lspci:
>>> >> >>
>>> >> >> 00:08.0 Multimedia controller [0480]: Philips Semiconductors SAA7=
130
>>> >> >> Video Broadcast Decoder [1131:7130] (rev 01)
>>> >> >> =A0 =A0 Subsystem: LeadTek Research Inc. Device [107d:6f3a]
>>> >> >> =A0 =A0 Flags: bus master, medium devsel, latency 64, IRQ 17
>>> >> >> =A0 =A0 Memory at fdffe000 (32-bit, non-prefetchable) [size=3D1K]
>>> >> >> =A0 =A0 Capabilities: [40] Power Management version 1
>>> >> >> =A0 =A0 Kernel driver in use: saa7134
>>> >> >> =A0 =A0 Kernel modules: saa7134
>>> >> >>
>>> >> >> Thanks again,
>>> >> >>
>>> >> >> Pavle.
>>> >> >>
>>> >> >>
>>> >> >>
>>> >> >>
>>> >> >>
>>> >> >> _________________________________________________________________=
_____
>>> >> >> From: hermann pitton <hermann-pitton@arcor.de>
>>> >> >> To: Pavle Predic <pavle.predic@yahoo.co.uk>
>>> >> >> Cc: video4linux-list@redhat.com
>>> >> >> Sent: Sun, 8 November, 2009 23:35:08
>>> >> >> Subject: Re: Leadtek Winfast TV2100
>>> >> >>
>>> >> >> Hi Pavle,
>>> >> >>
>>> >> >> Am Sonntag, den 08.11.2009, 17:11 +0000 schrieb Pavle Predic:
>>> >> >> > Did anyone manage to get this card working on Linux? I got the
>>> >> >> picture out of the box, but it's impossible to get any sound from=
 the
>>> >> >> damned thing. The card is not on CARDLIST.saa7134, but I assume a
>>> >> >> similar card/tuner combination can be used. But which? By the way=
, I
>>> >> >> got the speakers connected directly to card output, I'm not even
>>> >> >> trying to get it working with my sound card. I can hear clicks wh=
en
>>> >> >> loading/unloading modules, so it's alive but not set up properly.
>>> >> >> >
>>> >> >> > Any info would be greatly appreciated. Perhaps someone knows of
>>> >> >> another card that is similar to this one?
>>> >> >> >
>>> >> >> > Card info:
>>> >> >> > Chipset: saa7134
>>> >> >> > Tuner: Tvision TVF88T5-B/DFF
>>> >> >> > Card numbers that produce picture (modprobe saa7134 card=3D$n):=
 3, 7,
>>> >> >> 10, 16, 34, 35, 45, 46, 47, 48, 51, 63, 64, 68
>>> >> >>
>>> >> >> that is not enough information yet.
>>> >> >>
>>> >> >> The correct tuner for this one is tuner=3D69.
>>> >> >>
>>> >> >> Only with this one you will have also radio support.
>>> >> >>
>>> >> >> Since you mail from an UK mail provider, this tuner is not expect=
ed to
>>> >> >> work with PAL-I TV stereo sound there, but radio would work.
>>> >> >>
>>> >> >> Else, if neither amux =3D TV nor amux =3D LINE1 or LINE2 (LINE in=
puts for
>>> >> >> TV
>>> >> >> sound are only found on saa7130 chips, except there is also an ex=
tra
>>> >> >> TV
>>> >> >> mono section directly from the tuner) =A0work for TV sound, most =
often
>>> >> >> an
>>> >> >> external audio mux is in the way and needs to be configured corre=
ctly
>>> >> >> with saa7134 gpio pins. Looking also at the minor chips on the ca=
rd
>>> >> >> with
>>> >> >> more than 3 pins can reveal such a mux.
>>> >> >>
>>> >> >> There is also a software test on such hardware, succeeding in mos=
t
>>> >> >> cases.
>>> >> >>
>>> >> >> By default, external analog audio input is looped through to anal=
og
>>> >> >> audio out, on which you are listening, if the driver is unloaded.
>>> >> >>
>>> >> >> On a saa7134 chip, on saa7130 are some known specials, you should=
 hear
>>> >> >> the incoming sound directly on your headphones or what else you m=
ight
>>> >> >> be
>>> >> >> using directly connected to your card, trying on LINE1 and LINE2 =
for
>>> >> >> that.
>>> >> >>
>>> >> >> If not, you can expect that such a mux chip needs to be treated
>>> >> >> correctly.
>>> >> >>
>>> >> >> The DScaler (deinterlace.sf.net) regspy.exe often can help to ide=
ntify
>>> >> >> such gpios in use, else you must trace lines and resistors on it.
>>> >> >>
>>> >> >> In general, an absolute minimum is to provide related "dmesg" aft=
er
>>> >> >> loading the driver _without_ having tried on other cards previous=
ly.
>>> >> >>
>>> >> >> Please read more on the linuxtv.org wiki about adding support for=
 a
>>> >> >> new
>>> >> >> card.
>>> >> >>
>>> >> >> Cheers,
>>> >> >> Hermann
>>> >> >
>>> >> >
>>
>>
>>
>

--00151774155a18674b0478fff1ad
Content-Type: image/jpeg; name="TV2100_with_FM_GPIO.jpg"
Content-Disposition: attachment; filename="TV2100_with_FM_GPIO.jpg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2ckox5f1

/9j/4AAQSkZJRgABAQEAeAB4AAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcG
BwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwM
DAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAFaAx0DASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9/KKK
KACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoooo
AKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigA
ooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACi
iigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAor4A/wCIo39hT/ouf/lmeIf/
AJBo/wCIo39hT/ouf/lmeIf/AJBoA+/6K+AP+Io39hT/AKLn/wCWZ4h/+QaP+Io39hT/AKLn/wCW
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
K+AP+HeH7dn/AEkV/wDMCeHv/j1H/DvD9uz/AKSK/wDmBPD3/wAeoA+/6K+AP+HeH7dn/SRX/wAw
J4e/+PUf8O8P27P+kiv/AJgTw9/8eoA+/wCivyB/aH8L/t2fAT9uz9nT4Kf8N2/2t/wv7/hJf+Jz
/wAKW8PQf2F/Y+nx3v8AqMt5/nb9n+sj2Y3fPnbXv/8Aw7w/bs/6SK/+YE8Pf/HqAPv+ivgD/h3h
+3Z/0kV/8wJ4e/8Aj1H/AA7w/bs/6SK/+YE8Pf8Ax6gD7/or4A/4d4ft2f8ASRX/AMwJ4e/+PUf8
O8P27P8ApIr/AOYE8Pf/AB6gD7/or4A/4d4ft2f9JFf/ADAnh7/49R/w7w/bs/6SK/8AmBPD3/x6
gD7/AKK+AP8Ah3h+3Z/0kV/8wJ4e/wDj1H/DvD9uz/pIr/5gTw9/8eoA+/6K+AP+HeH7dn/SRX/z
Anh7/wCPV5B+1FD+2d/wTt+Kf7N+reKf2yv+FseGfiZ8avDPw91fQf8AhUuhaF5tnfzSvO32mPzZ
BmO3aPCBGHm7g6lRkA/V6iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoo
ooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiii
gAooooAKKKKACiiigAooooAKKKKACiiigAooooA+AP8Ag1x/5QUfAz/uP/8AqQ6nX3/XwB/wa4/8
oKPgZ/3H/wD1IdTr7/oAKKKKACiiigAooooAKKKKACiiigAr4A/52mv+7Vf/AHbq+/6+AP8Anaa/
7tV/926gD7/ooooAKKKKACiiigAooooAKKKKAPgD/gof/wAp1/8AgnV/3Ur/ANR63r7/AK+AP+Ch
/wDynX/4J1f91K/9R63r7/oAKKKKACiiigAooooAKKKKACvgD/gvp/zZX/2dV4G/9vq+/wCvgD/g
vp/zZX/2dV4G/wDb6gD7/ooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKK
KKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooo
oAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPgD/g1x/5QUfAz/uP/wDqQ6nX3/XwB/wa4/8A
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
0P8A9119/wBFAHwB/wAP9P8Aqyv9v/8A8ND/APddH/D/AE/6sr/b/wD/AA0P/wB119/0UAfAH/D/
AE/6sr/b/wD/AA0P/wB114B+3B+3B4q/4KUfFP8AZV8LeFv2Vf2wPBf/AAhf7QHhLxlq+r+MvhnN
p2lWenWs00U8jzxyy7Nv2hXLOFQIjksMAH9fqKACiiigAooooAKKKKACiiigAooooAKKKKACiiig
AooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAC
iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKK
K8V/4bu8I/8AQO8Sf+A8P/x2t6OGq1r+zjexz4jF0aFvaytfY9qorxX/AIbu8I/9A7xJ/wCA8P8A
8do/4bu8I/8AQO8Sf+A8P/x2uj+zMV/Izn/tbB/8/Ee1UV4r/wAN3eEf+gd4k/8AAeH/AOO0f8N3
eEf+gd4k/wDAeH/47R/ZmK/kYf2tg/8An4j2qivFf+G7vCP/AEDvEn/gPD/8drqPhN+0roXxj8Rz
6Xplpq0FxBbNdM11FGiFQyKQCrsc5cdvWoqYDEQi5yg0kXTzLDVJKEJptnoVFFFcZ2hRRRQAUV5n
Z/tW+Gdc/abm+FOkR6lrniLS9OOpa3c2MIksPDynHkxXUu4BJpskpGAzFVLEKMEy+P8A9qPw14E+
Nfhj4dJ9u1zxn4mbzhpemRrNLplkM77+6ywENupG3cxyzEKoY8VzfXKFnLmVk+X57W9b6euh7X+r
mZ+0jR9hLmlT9qlbX2dnLnfaPKua7snG0tmm/R6KKK6TxQooooAKKKKACiiigAooooAKKKKACiii
gAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKA
CiiigAooooAKKKKACiiigAooooAKKKRiQpIGSBwPWhuyuAtFfnp8Ef2+fGHi/wCMHgK1k+JFnrvx
O8T+NLrQPGHwWRtK3+BtLie8DXwjigGpRNFHDbSNNczyQTedhEXzotvpH7bf7bXjHwT+0r8KfBfw
7ms4tF/4T/RtC8eapJCk5UXqyPFpcO5SomaJfOlcYaKNoMczBlqCcnTS+3JRXq3FJ325feWqum9F
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
vePv2WB438X+MPBXxDvPCniW51XUrLTtMh1LdusSEkguLSW3jLIU3KIFZSMfKcivRv2u/wBnGz+F
X7F/x88S33iLxL428Xa14Cv7C61zXntRcm1ht7h4rdI7WCC3jRWlc/u4lLE5YsQCO+vhsPRShJJt
8y0cm21UnFNPSNrJa2u10Td1hhp1KsotX15P5UtVFu+7u03azsnbWyPUPFn7T96k3hHQ/CvhY+Jf
G3jDR/7ci06XURZWGl2oVMz3d15bskfmSJGvlwySOxJEZCuVg8N/tW3PhzxVqHhr4neHrXwP4isN
EuPEccllqv8AaukalY27AXD2900MEheENGZElgjI81Su9csPLtA1a0/Zx+PnhT4keKrmfT/BHiv4
aab4fn1qZSNO0G6tHe4X7XL923iljnbEsm2MNDtLAugOJ+0hbW//AAUD+Ilo/wAMtTHiDw94T8Fe
JoJPEelz+ZpN9fajZizt7KC6UGOd1IkkkMTOIiiBsMwFRWwtON0o+7abctfdceflW9lqoqzTbvpu
iMLXc3DnnZv2emmqkocz2u7XltZK2uzv6h8N/wBsrxHrPiD4enxf4BtPC3h/4ssY/C95ba+dRu1c
2kl5HHf25toltneCJiBFLcAMCpYcEpf/ALaeveFdf0DUPEvw6vPDvgLxV4lTwppmo3eoOmtC7lne
CCafTXt1EVtLInyOLh5Nrxs0SqSV8j8K/GPw3+0Vb/sveEPCGrWmteI/BeqWeq+KNNgkDXnheO00
i6hkW+h+/bObh0iCShWLHgEAmrn7Rnxh8I/HDWPCmt+DLzUovj14Y1+yg03wTqepub/T4xqAt7ya
50gSyQxxm1e4P24RbliZWSYArXVPA0liVTdOycrdfh5rKW+l9nLVJK/K9E+eGKqSwznz+9yJ7JWn
Z3j8tHZ+8725luvtGiiivmz2QooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooo
oAKKKKACiiigAooooAKKKKACiiigDntT+E3hzWPiVpfjG50i0k8UaNazWNnqQBW4iglwZIiQRuQk
A7WyAeRg80zx18IPDPxL1rw9qWu6NZ6lqPhS+GpaRcyKRNp9wARvRgQRkHBX7rcZBwK6Sis3SptN
OK1d3pu+/rovuO2GZYuEoTjVknBOMWpO8Yu94rXRPmldLR3fdhRRRWhxBRRRQAUUUUAFFFFABRRR
QAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFA
BRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAF
FFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUU
UUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRR
QAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFA
BRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAf/9k=
--00151774155a18674b0478fff1ad
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--00151774155a18674b0478fff1ad--
