Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53369 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2HKBUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 21:20:14 -0400
Received: by weyx8 with SMTP id x8so1349470wey.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 18:20:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5025B05F.8090809@iki.fi>
References: <59951342221302@web18g.yandex.ru>
	<50258758.8050902@redhat.com>
	<5025A3FD.8020001@iki.fi>
	<CAHFNz9KA1pHgxyjX5KdKgsy8nWgREkVFTVg38cox1TFNGJVqew@mail.gmail.com>
	<5025B05F.8090809@iki.fi>
Date: Sat, 11 Aug 2012 06:50:12 +0530
Message-ID: <CAHFNz9KRXiMwxL+kMsQAmy9mghW4ZkFrizoG0NKBkEiGJxrDjA@mail.gmail.com>
Subject: Re: [PATCH] DVB-S2 multistream support
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	CrazyCat <crazycat69@yandex.ru>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <manu@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 11, 2012 at 6:37 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 08/11/2012 03:31 AM, Manu Abraham wrote:
>>
>> On Sat, Aug 11, 2012 at 5:44 AM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 08/11/2012 01:12 AM, Mauro Carvalho Chehab wrote:
>>>>
>>>>
>>>> Em 13-07-2012 20:15, CrazyCat escreveu:
>>>
>>>
>>>
>>>>>    #define DTV_ISDBS_TS_ID               42
>>>>>
>>>>>    #define DTV_DVBT2_PLP_ID      43
>>>>> +#define DTV_DVBS2_MIS_ID       43
>>>>
>>>>
>>>>
>>>> It would be better to define it as:
>>>>
>>>> #define DTV_DVBS2_MIS_ID        DTV_DVBT2_PLP_ID
>>>>
>>>> Even better, we should instead find a better name that would cover both
>>>> DVB-T2 and DVB-S2 program ID fields, like:
>>>>
>>>> #define DTV_DVB_MULT            43
>>>> #define DTV_DVBT2_PLP_ID        DTV_DVB_MULT
>>>>
>>>> And use the new symbol for both DVB-S2 and DVB-T2, deprecating the
>>>> legacy symbol.
>>>
>>>
>>>
>>> Also DTV_ISDBS_TS_ID means same. All these three DTV_ISDBS_TS_ID,
>>> DTV_DVBT2_PLP_ID and DTV_DVBS2_MIS_ID are same thing - just named
>>> differently between standards. I vote for common name TS ID (I have said
>>> that already enough many times...).
>>
>>
>> I agree, but a still more generic term like STREAM_ID would be more
>> appropriate,
>
>
> Ack. Since this stream could be something else than MPEG2-TS better to give
> more generic name.
>
>
>> as it happens at different layers for different delivery
>> systems.DVB-S2 additionally
>> provides BBHEADER at Physical Layer. In any case setting PLP_ID for DVB-S2
>> is completely confusing.
>>
>> Anyway, the demuxer part is also missing ..
>
>
> Demuxer for MIS? I am not any familiar with MIS but I know there is "raw"
> demux payload used already for ATSC-M/H. It just passes all the data coming
> from demod "TS".

Just grabbing and sending the DMA'd data to userspace is not nice.

With ATSC-M/H you don't simply have a TS. With an ATSC-M/H capable
demod, which supports ATSC (standard) outputs a TS. the M/H part is not
a TS at all.

Even with ATSC-M/H passing raw data causes all the IP (network) packets to
be parsed in userspace, which should have been properly done in kernel
space as a filter. If we were to do everything similarly, then we don't need
any API at all, just a simple read and let each application do whatever it
wants.

Regards,
Manu
