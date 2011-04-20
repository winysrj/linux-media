Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1DTPRx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 11:17:53 -0400
Message-ID: <4DAEF919.1080908@redhat.com>
Date: Wed, 20 Apr 2011 12:17:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 1/5] tm6000: add mts parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de> <4DADFCD2.1090401@redhat.com> <4DAE95CE.4020705@arcor.de> <4DAED378.308@redhat.com> <4DAEEB7C.4080608@arcor.de>
In-Reply-To: <4DAEEB7C.4080608@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-04-2011 11:19, Stefan Ringel escreveu:
> Am 20.04.2011 14:37, schrieb Mauro Carvalho Chehab:
>> Em 20-04-2011 05:14, Stefan Ringel escreveu:
>>> Am 19.04.2011 23:21, schrieb Mauro Carvalho Chehab:
>>>> Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
>>>>> From: Stefan Ringel<stefan.ringel@arcor.de>
>>>>>
>>>>> add mts parameter
>>>> Stefan,
>>>>
>>>> The MTS config depends on the specific board design (generally present on
>>>> mono NTSC cards). So, it should be inside the cards struct, and not
>>>> provided as an userspace parameter.
>>>>
>>>> Mauro.
>>> No. It wrong. I think edge board must work under all region and TV standards and if I set MTS, it doesn't work in Germany (PAL_BG and DVB-T). The best is to set outside region specific params.
>> Stefan,
>>
>> Not all boards have MTS wired.
> standard option that param is not auto.
> MTS = 0 or not set means load firmware without MTS.
> MTS = 1 means load firmware with MTS.
> That means, if you MTS then add a param MTS=1.
> Have you other method to detect norm BTSC and EIAJ and set it? I have not that.

Yes. Audio standard is related to video standard. So, it is easy to map on what
standards you have BTSC or EIAJ.

You could find that info listed on some places, like:
	http://www.videouniversity.com/articles/world-wide-tv-standards
	http://en.wikipedia.org/wiki/BTSC
and on good analog TV books.

Basically, BTSC/EIAJ applies only to PAL/M, PAL/N and NTSC/M. So, if the standard is
not PAL/MN, mts should always be equal to 0. We may have a patch at tuner-xc2028 for that.

If standard is V4L_STD_MN, we have:

For NTSC standards:
	if standard == V4L2_STD_NTSC_M_KR, audio is A2 (Korea) and mts should be 0.
	if standard == V4L2_STD_NTSC_M_JP, audio is EIAJ (Japan).
	All the rest use BTSC (or are mono, but the BTSC decoder is designed to be
backward compatible with NTSC mono FM transmission).

For PAL:
	V4L2_STD_PAL_M - always BTSC
	V4L2_STD_PAL_Nc (only Argentina) - always BTSC
	V4L2_STD_PAL_N  (Paraguay/Uruguay) - they also use FM for audio. I think it is also BTSC.

So, basically, assuming that some device could potentiallt have both SIF and MTS baseband 
wired and that the audio decoder is not capable of decoding EIAJ/BTSC, it makes sense to 
add something like this at tuner-xc2028:

/* MTS is only valid for M/N standars, except in Korea */
if (!(std & V4L2_STD_MN) || (std == V4L2_STD_NTSC_M_KR))
	mts = 0;

and, for such device, specify xc2028 with mts = 1.

For devices that support only mts, it makes sense to change the supported standards to
just V4L2_STD_MN.

However, we cannot assume that (std & V4L2_STD_MN) && (std != V4L2_STD_NTSC_M_KR) is always
mts, as it will depend on how xc2028/xc3028 is wired to the bridge/audio demod.

>> Also, MTS works only for BTSC and EIAJ,
>> e. g. STD M/N. The SIF output works for all standards, depending of the audio
>> decoder capabilities, and if the SIF is properly wired. AFAIK, tm5600/6000/tm6010
>> is a worldwide decoder, so if SIF is wired, it should be capable of also decoding
>> BTSC, EIAJ and the other sound standards found elsewhere.
>>
>> In other words, boards shipped outside NTSC or PAL-M Countries use SIF and supports
>> worldwide standards. however, most boards shipped in US with xc3028 have only
>> MTS wired and won't work outside NTSC/PAL-M/PAL-N area (America, Japan and a few
>> other places).
>>
> Which board is only MTS?

Developers need to test, but, based on my experience with other xc3028/2028 devices, 
in general, the ones sold in US are only MTS.

> Which board is only no MTS?
> Which board will both?

Except if the tm5600/tm6000 SIF decoder for BTSC/EIAJ is broken, we don't
need to map the differences between only SIF and SIF + MTS.

All boards sold in Europe should support SIF, so mts should be 0 for them.

Mauro.
