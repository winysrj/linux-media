Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.246.41.159] (helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1JtggH-0003xg-8I
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 12:16:19 +0200
Message-ID: <482180AB.1000806@anevia.com>
Date: Wed, 07 May 2008 12:12:59 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Jean-Louis Dupond <info@dupondje.be>
References: <4816E6F8.1010607@anevia.com> <4816EBBB.5080205@dupondje.be>
	<48206BFA.2010404@anevia.com>
In-Reply-To: <48206BFA.2010404@anevia.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WinTV HVR 1300 Analog Tuner issue
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

Frederic CAND a =E9crit :
> Jean-Louis Dupond a =E9crit :
>> Define 'Does not work' ...
>>
>> Frederic CAND schreef:
>>> Dear all,
>>>
>>> I'm using kernel 2.6.22.19 and I can't make the analog tuner of my hvr =

>>> 1300 work. Anything special to do more than with any other tv card ? =

>>> (I'm using a KNC One TV Station DVR, based on saa7134, saa6752hs and =

>>> tda9887 and it's working - almost - fine ...)
>>>   =

>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
> a coworker of mine gave that diff :
> =

>   /* 130-139 */
>      { TUNER_ABSENT,        "TCL M2523_3DBH_E"},
>      { TUNER_ABSENT,        "TCL M2523_3DIH_E"},
>      { TUNER_ABSENT,        "TCL MFPE05_2_U"},
> -    { TUNER_ABSENT,        "Philips FMD1216MEX"},
> =

> par
> =

> /* 130-139 */
>      { TUNER_ABSENT,        "TCL M2523_3DBH_E"},
>      { TUNER_ABSENT,        "TCL M2523_3DIH_E"},
>      { TUNER_ABSENT,        "TCL MFPE05_2_U"},
> +    { TUNER_PHILIPS_FMD1216ME_MK3,        "Philips FMD1216MEX"},
> =

> to be applied to tveeprom.c and it works now
> =

> however I'm not using 2.6.22.19 v4l drivers anymore, but a snapshot that =

> Hermann Pitton advised me to use :
> =

> http://linuxtv.org/hg/v4l-dvb/rev/d6660f8c6dbb
> =

> I had troubles making my KNC TV Station DVR work (based on saa7134 and =

> saa6752hs chips) and this snapshot solved my problem (sound with tuner).
> =

> Now I'm stuck with another issue : how can I get the audio (with tuner =

> or the audio input of the board) work ? the PS does not contain an audio =

> track, and the VIDIOC_QUERYCAP fills the capability field without the =

> V4L2_CAP_AUDIO flag, the and the VIDIOC_ENUMAUDIO and VIDIOC_G_AUDIO =

> return -1. Anything special to do to get sound in the PS ?
> =

> =

> =

ok my mistake, I forgot to compile with CONFIG_VIDEO_CX2341X=3Dm
now, sound is included in my PS, ... but there is sound only with =

composite/svideo, not with tuner
I tried that patch :
http://linuxtv.org/hg/v4l-dvb/rev/dc1ffef8197b

but it does not change anything

any clue ?



-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
