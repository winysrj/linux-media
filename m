Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589Ab2HQTB1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 15:01:27 -0400
Message-ID: <502E94FA.6080301@redhat.com>
Date: Fri, 17 Aug 2012 16:01:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb_frontend: Multistream support
References: <53381345139167@web11e.yandex.ru> <502D37CF.7030608@iki.fi> <839331345224097@web14d.yandex.ru>
In-Reply-To: <839331345224097@web14d.yandex.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-08-2012 14:21, CrazyCat escreveu:
> 
> 16.08.2012, 21:11, "Antti Palosaari" <crope@iki.fi>:
>>>  - /* ISDB-T specifics */
>>>  - u32 isdbs_ts_id;
>>>  -
>>>  - /* DVB-T2 specifics */
>>>  - u32                     dvbt2_plp_id;
>>>  + /* Multistream specifics */
>>>  + u32 stream_id;
>>
>> u32 == 32 bit long unsigned number. See next comment.
>>>
>>>  - c->isdbs_ts_id = 0;
>>>  - c->dvbt2_plp_id = 0;
>>>  + c->stream_id = -1;
>>
>> unsigned number cannot be -1. It can be only 0 or bigger. Due to that
>> this is wrong.
> 
> so maybe better declare in as int ? depend from standard valid stream id (for DVB is 0-255) and any another value (-1) disable stream filtering in demod.

It should be noticed that DVBv5 will pass it as u32 in any case.
So, maybe it is better to use UINT_MAX as the no-filter value:

/home/v4l/v4l/patchwork/include/linux/kernel.h:#define UINT_MAX	(~0U)


Some care is needed when doing that, to avoid 32bits/64bits compat
conflicts. Also, this define doesn't exist in userspace.

so, maybe using something like:

#define NO_STREAM_ID_FILTER	(~0U)

Would work properly, as, even on 64bits system with 32bits userspace,
this should work

or, if we want to be pedantic:

#define NO_STREAM_ID_FILTER	((u32)(~0U))


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

