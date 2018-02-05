Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:46194 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752582AbeBERBj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 12:01:39 -0500
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Tim Harvey <tharvey@gateworks.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
 <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
 <20180205143729.12783826@vento.lan> <20180205145457.6c083894@vento.lan>
 <f7e62d1c-ae5f-2131-9331-2cb70c3a9749@xs4all.nl>
Message-ID: <e7db77c5-282a-eb4f-5a37-a4b3859e9b35@xs4all.nl>
Date: Mon, 5 Feb 2018 18:01:34 +0100
MIME-Version: 1.0
In-Reply-To: <f7e62d1c-ae5f-2131-9331-2cb70c3a9749@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 05:59 PM, Hans Verkuil wrote:
> On 02/05/2018 05:55 PM, Mauro Carvalho Chehab wrote:
>> Em Mon, 5 Feb 2018 14:37:29 -0200
>> Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:
>>
>>> Em Mon, 5 Feb 2018 08:21:54 -0800
>>> Tim Harvey <tharvey@gateworks.com> escreveu:
>>>
>>>> Hans,
>>>>
>>>> I'm failing compile (of master 4ee9911) with:
>>>>
>>>>   CXX      v4l2_compliance-media-info.o
>>>> media-info.cpp: In function ‘media_type media_detect_type(const char*)’:
>>>> media-info.cpp:79:39: error: no matching function for call to
>>>> ‘std::basic_ifstream<char>::basic_ifstream(std::__cxx11::string&)’
>>>>   std::ifstream uevent_file(uevent_path);
>>>>                                        ^  
>>>
>>> Btw, while on it, a few days ago, I noticed several class warnings when
>>> building v4l-utils on Raspbian, saying that it was using some features
>>> that future versions of gcc would stop using at qv4l2. See enclosed.
>>>
>>> I didn't have time to look on them.
>>
>> FYI, it still happens with today's upstream's version:
>>
>> 	4ee99116d0ec (HEAD, origin/master, origin/HEAD) v4l2-ctl: improve the fps calculation when streaming
>>
>> $ gcc --version
>> gcc (Raspbian 6.3.0-18+rpi1) 6.3.0 20170516
>> Copyright (C) 2016 Free Software Foundation, Inc.
>> This is free software; see the source for copying conditions.  There is NO
>> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> My guess is that it is a bogus message from gcc 6.
> 
> Regards,
> 
> 	Hans
> 

See: https://gcc.gnu.org/ml/gcc/2017-05/msg00073.html

Nothing to worry about.

	Hans
