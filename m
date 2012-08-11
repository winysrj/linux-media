Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2HKBH6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 21:07:58 -0400
Message-ID: <5025B05F.8090809@iki.fi>
Date: Sat, 11 Aug 2012 04:07:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	CrazyCat <crazycat69@yandex.ru>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <manu@linuxtv.org>
Subject: Re: [PATCH] DVB-S2 multistream support
References: <59951342221302@web18g.yandex.ru> <50258758.8050902@redhat.com> <5025A3FD.8020001@iki.fi> <CAHFNz9KA1pHgxyjX5KdKgsy8nWgREkVFTVg38cox1TFNGJVqew@mail.gmail.com>
In-Reply-To: <CAHFNz9KA1pHgxyjX5KdKgsy8nWgREkVFTVg38cox1TFNGJVqew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2012 03:31 AM, Manu Abraham wrote:
> On Sat, Aug 11, 2012 at 5:44 AM, Antti Palosaari <crope@iki.fi> wrote:
>> On 08/11/2012 01:12 AM, Mauro Carvalho Chehab wrote:
>>>
>>> Em 13-07-2012 20:15, CrazyCat escreveu:
>>
>>
>>>>    #define DTV_ISDBS_TS_ID               42
>>>>
>>>>    #define DTV_DVBT2_PLP_ID      43
>>>> +#define DTV_DVBS2_MIS_ID       43
>>>
>>>
>>> It would be better to define it as:
>>>
>>> #define DTV_DVBS2_MIS_ID        DTV_DVBT2_PLP_ID
>>>
>>> Even better, we should instead find a better name that would cover both
>>> DVB-T2 and DVB-S2 program ID fields, like:
>>>
>>> #define DTV_DVB_MULT            43
>>> #define DTV_DVBT2_PLP_ID        DTV_DVB_MULT
>>>
>>> And use the new symbol for both DVB-S2 and DVB-T2, deprecating the
>>> legacy symbol.
>>
>>
>> Also DTV_ISDBS_TS_ID means same. All these three DTV_ISDBS_TS_ID,
>> DTV_DVBT2_PLP_ID and DTV_DVBS2_MIS_ID are same thing - just named
>> differently between standards. I vote for common name TS ID (I have said
>> that already enough many times...).
>
> I agree, but a still more generic term like STREAM_ID would be more
> appropriate,

Ack. Since this stream could be something else than MPEG2-TS better to 
give more generic name.

> as it happens at different layers for different delivery
> systems.DVB-S2 additionally
> provides BBHEADER at Physical Layer. In any case setting PLP_ID for DVB-S2
> is completely confusing.
>
> Anyway, the demuxer part is also missing ..

Demuxer for MIS? I am not any familiar with MIS but I know there is 
"raw" demux payload used already for ATSC-M/H. It just passes all the 
data coming from demod "TS".

> If you look a bit more deeper, you will see that the framing structure
> with ISDB-T
> is exactly the same as with ISDB-S, which makes ISDB-T also no different, just
> that the frontend userspace header is just fucked up with junk.
>
> The major chunk for the ISDB-T stuff in the frontend header is
> completely redundant.
>
> Regards,
> Manu
>

regards
Antti

-- 
http://palosaari.fi/
