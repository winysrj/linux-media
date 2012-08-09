Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46698 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab2HIJTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 05:19:48 -0400
Received: by lagy9 with SMTP id y9so120883lag.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 02:19:46 -0700 (PDT)
Message-ID: <502380A5.5080808@iki.fi>
Date: Thu, 09 Aug 2012 12:19:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: build docs fails: parser error : Failure to process entity sub-enum-freq-bands
References: <5022F3A5.2030507@iki.fi> <201208090929.41126.hverkuil@xs4all.nl>
In-Reply-To: <201208090929.41126.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2012 10:29 AM, Hans Verkuil wrote:
> It works for me.
>
> make DOCBOOKS=media_api.xml htmldocs
>
> Perhaps you need to do a make cleandocs first?

make cleandocs resolves the problems. Sorry for the noise.

regards
Antti

>
> Regards,
>
> 	Hans
>
> On Thu August 9 2012 01:17:57 Antti Palosaari wrote:
>> That is from current "staging/for_v3.7"
>>
>> [crope@localhost linux]$ make htmldocs
>>     HTML    Documentation/DocBook/media_api.html
>> warning: failed to load external entity
>> "/home/crope/linuxtv/code/linux/Documentation/DocBook/vidioc-enum-freq-bands.xml"
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:542:
>> parser error : Failure to process entity sub-enum-freq-bands
>>       &sub-enum-freq-bands;
>>                            ^
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:542:
>> parser error : Entity 'sub-enum-freq-bands' not defined
>>       &sub-enum-freq-bands;
>>                            ^
>> warning: failed to load external entity
>> "/home/crope/linuxtv/code/linux/Documentation/DocBook/selections-common.xml"
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:600:
>> parser error : Failure to process entity sub-selections-common
>>         &sub-selections-common;
>>                                ^
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:600:
>> parser error : Entity 'sub-selections-common' not defined
>>         &sub-selections-common;
>>                                ^
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:625:
>> parser error : chunk is not well balanced
>>
>> ^
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/media_api.xml:73:
>> parser error : Failure to process entity sub-v4l2
>> &sub-v4l2;
>>             ^
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/media_api.xml:73:
>> parser error : Entity 'sub-v4l2' not defined
>> &sub-v4l2;
>>             ^
>> unable to parse
>> /home/crope/linuxtv/code/linux/Documentation/DocBook/media_api.xml
>> /usr/bin/cp: cannot stat `*.*htm*': No such file or directory
>> make[1]: *** [Documentation/DocBook/media_api.html] Error 1
>> make: *** [htmldocs] Error 2
>> [crope@localhost linux]$
>>
>> regards
>> Antti
>>
>>


-- 
http://palosaari.fi/
