Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:48167 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3GZKR3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 06:17:29 -0400
Message-ID: <51F24C01.8050703@schinagl.nl>
Date: Fri, 26 Jul 2013 12:14:25 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Huei-Horng Yo <hiroshiyui@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [RFC] Dropping of channels-conf from dtv-scan-tables
References: <51DFF8A9.2030705@schinagl.nl> <CAJNvB=ydGohcEQLs+6rUCrUganMkB4dZXhpiTVyMSYkzSKha8Q@mail.gmail.com>
In-Reply-To: <CAJNvB=ydGohcEQLs+6rUCrUganMkB4dZXhpiTVyMSYkzSKha8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26-07-13 10:14, Huei-Horng Yo wrote:
> Sorry for my off-topic, because dvb-apps' 'scan' utility output wrong
> encoding of channels-conf in Taiwan, that's why 'tw-All' channels-conf
> is still useful for some Taiwan people. Or someone could review my
> patch about this encoding issue? ([PATCH][dvb-apps] Fix 'scan' utility
> region 0x14 encoding from BIG5 to UTF-16BE)
Did you notify the maintainer? of the dvb-apps? I think manu is still 
one of the dvb-apps maintainers.


>
> Thanks,
>
> Huei-Horng Yo
>
> 2013/7/12 Oliver Schinagl <oliver+list@schinagl.nl>:
>> Hey all,
>>
>> The channels-conf directory in the dtv-scan-tables repository is bitrotten.
>> Besides tw-All, the newest addition is over 6 years ago, with some being as
>> old as 9 years. While I'm sure it's possible that the channels-conf are
>> still accurate, it's not really needed any longer.
>>
>> Unless valid reasons are brought up to keep it, I will move it to a seperate
>> branch and delete it from the master branch in the next few weeks.
>>
>> Thanks,
>>
>> Oliver
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

