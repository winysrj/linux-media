Return-path: <linux-media-owner@vger.kernel.org>
Received: from joan.kewl.org ([212.161.35.248]:45106 "EHLO joan.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZA0OH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 09:07:56 -0500
From: Darron Broad <darron@kewl.org>
To: Alex Betis <alex.betis@gmail.com>
cc: Darron Broad <darron@kewl.org>, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2? 
In-reply-to: <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com> 
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de> <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com> <Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org> <c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com> <Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org> <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com> <16900.1232991151@kewl.org> <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com> <18268.1233001231@kewl.org> <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com>
Date: Tue, 27 Jan 2009 14:07:54 +0000
Message-ID: <7316.1233065274@kewl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In message <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com>, Alex Betis wrote:

hi

>On Mon, Jan 26, 2009 at 10:20 PM, Darron Broad <darron@kewl.org> wrote:
>
>> In message <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>,
>> Alex
>> Betis wrote:
>> >
>> >On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad <darron@kewl.org> wrote:
>> >
>> >> In message <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com
>> >,
>> >> Alex Betis wrote:
>> >>
>> >> lo
>> >>
>> >> <snip>
>> >> >
>> >> >The bug is in S2API that doesn't return ANY error message at all :)
>> >> >So the tuner is left locked on previous channel.
>> >> >
>> >> >There are many things that can be done in driver to improve the
>> situation,
>> >> >but I'll leave it to someone who has card with cx24116 chips.
>> >>
>> >> When tuning the event status should change to 0 and if
>> >> it stays that way the tuning operation failed.
>> >>
>> >> If you read the frontend status directly then you will
>> >> retrieve the state of the previous tuning operation
>> >> that suceeded.
>> >
>> >What do you call an event status and what direct status?
>> >
>> >scan-s2 uses FE_READ_STATUS that always success and indicates channel
>> lock,
>> >even if cx24116 driver returned an error due to AUTO parameters.
>>
>> refer to
>>
>> FE_SET_FRONTEND:
>>
>> http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION00328000000000000000
>>
>> and,
>>
>> FE_GET_EVENT
>>
>> http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION003210000000000000000
>>
>Ohh, ok. So there is a solution for that after all. Thanks!
>Unfortunately no one gave me a clear answer on that when I asked about it
>last time.
>Seems to work for stb0899, waiting for confirmation on cx24116.

Okay. If there is a fault I will investigate.

>Darron, looks you're the right person to ask:
>How can I retrieve the REAL tuned parameters from the driver?
>Looks like using FE_GET_PROPERTY returns cached properties that were issued
>with FE_SET_PROPERTY before that.

At present that's all there is. With the cx24116 it is
actually possible to retrieve the actual FEC when requesting
FEC_AUTO for DVB-S but it's not implemented. Such a feature
though could be driver dependant in any case so probably
unreliable. I have not looked.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

