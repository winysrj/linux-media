Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:39110 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbbBTUHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 15:07:10 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so9472437igb.0
        for <linux-media@vger.kernel.org>; Fri, 20 Feb 2015 12:07:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ+AEyNfefnHiKtr+iGnE6NfWbTVT40DcqPckfa=kQbEw6ymYg@mail.gmail.com>
References: <CAJ+AEyMT6etRK6cj6s2iwNHW3QG4mh7TVdPeNvVKKSBAJU9ztA@mail.gmail.com>
	<54E68315.7020209@iki.fi>
	<CAJ+AEyNfefnHiKtr+iGnE6NfWbTVT40DcqPckfa=kQbEw6ymYg@mail.gmail.com>
Date: Fri, 20 Feb 2015 22:07:09 +0200
Message-ID: <CAAZRmGygjbTgSa9syNNBiOMig5Rb+8o5CH9JWMQtudtpWX_oMA@mail.gmail.com>
Subject: Re: DVBSky T982 (Si2168) Questions/Issues/Request
From: Olli Salonen <olli.salonen@iki.fi>
To: Eponymous - <the.epon@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

It would seem to me that you are using application that are not
capable of handling frontends that do support multiple standards.
TVheadend 3.4.27 does not for sure. You will need to use the 3.9
series where you can define the wanted standard for each mux.

Also, w_scan needs to be fairly recent in order to support DVB-T2.
Many distros have too old versions included. DVB-T2 support was added
on July 2014.

Cheers,
-olli

On 20 February 2015 at 11:11, Eponymous - <the.epon@gmail.com> wrote:
>>> It is increased to 70 ms already,.
>
> A great I will test with this value and see if it is ok.
>
>
>>> I don't understand what you mean. Likely you are not understanding how DVB-T and DVB-T2 works. There is transmitter which uses DVB-T or DVB-T2, not both standards same time. You have to select used standard according to transmitter specs and make proper tuning request. Driver could do DVB-T, DVB-T2 and DVB-C, but only one transmission is possible to receive as once per tuner.
>
> I understand how the system works but I don't think I'm explaining the
> problem very well :)
>
> In tvheadend 3.4.27 I add two muxes, one DVB-T (64QAM 8K 2/324.1Mb/s
> DVB-T MPEG2) and one DVB-T2 (256QAM 32KE 2/340.2Mb/s DVB-T2 MPEG4). I
> can only receive DVB-T services and channel/mux information, not
> DVB-T2.
>
> I've tested with w_scan as well with the same result. It's almost like
> it's not able to see any DVB-T2 muxes.
>
> Sean.
>
> On Fri, Feb 20, 2015 at 12:43 AM, Antti Palosaari <crope@iki.fi> wrote:
>> Moi
>>
>> On 02/20/2015 01:33 AM, Eponymous - wrote:
>>>
>>> Hi.
>>>
>>> I have a couple of issues with the si2168.c dvb-frontend in kernel v
>>> 3.19.0. To get the firnware to load I've had to increase the #define
>>> TIMEOUT to 150 from 50. I read another post
>>> (http://www.spinics.net/lists/linux-media/msg84198.html) where another
>>> user had to do the same modification.
>>>
>>> @ Antti Palosaari: Since the 50ms value you came up with was just
>>> based on some "trail and error", would it be possible to submit a
>>> change upstream to increase this timeout since it's likely others are
>>> going to encounter this issue?
>>
>>
>> It is increased to 70 ms already,
>>
>> commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
>> Author: Jurgen Kramer <gtmkramer@xs4all.nl>
>> Date:   Mon Dec 8 05:30:44 2014 -0300
>> [media] Si2168: increase timeout to fix firmware loading
>>
>> If it is not enough, then send patch which increased it even more.
>>
>> Have to check if that fix never applied to stable, as there is no Cc stable
>> I added.... Mauro has applied patch from patchwork, not from pull request I
>> made:
>> https://patchwork.linuxtv.org/patch/27960/
>> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=si2168_fix
>>
>>>
>>> The second issue I have is that where I am based (UK) we have both
>>> DVB-T and DVB-T2 muxes and I can't get a single tuner to be able to
>>> tune to both transports, but looking through the Si2168.c code, I'm
>>> having trouble working out how (if at all) this is achieved?
>>>
>>> It's not the case where we can only tune to DVB-T OR DVB-T2 is it? If
>>> so, that's far from ideal...
>>>
>>> Are there any workarounds if true?
>>
>>
>> I don't understand what you mean. Likely you are not understanding how DVB-T
>> and DVB-T2 works. There is transmitter which uses DVB-T or DVB-T2, not both
>> standards same time. You have to select used standard according to
>> transmitter specs and make proper tuning request. Driver could do DVB-T,
>> DVB-T2 and DVB-C, but only one transmission is possible to receive as once
>> per tuner.
>>
>> regards
>> Antti
>> --
>> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
