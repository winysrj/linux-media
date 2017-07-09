Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:32785 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdGIMLk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 08:11:40 -0400
Received: by mail-wr0-f172.google.com with SMTP id r103so103465724wrb.0
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 05:11:39 -0700 (PDT)
Subject: Re: [PATCH RFC 1/2] app: kaffeine: Fix missing PCR on live streams.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170709094351.14642-1-tvboxspy@gmail.com>
 <20170709081455.024e4c0d@vento.lan>
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <179d3ac3-673f-7671-e2cc-6dd0262a14d3@gmail.com>
Date: Sun, 9 Jul 2017 13:11:36 +0100
MIME-Version: 1.0
In-Reply-To: <20170709081455.024e4c0d@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/07/17 12:14, Mauro Carvalho Chehab wrote:
> Hi Malcolm,
> 
> Em Sun,  9 Jul 2017 10:43:50 +0100
> Malcolm Priestley <tvboxspy@gmail.com> escreveu:
> 
>> The ISO/IEC standard 13818-1 or ITU-T Rec. H.222.0 standard allow transport
>> vendors to place PCR (Program Clock Reference) on a different PID.
>>
>> If the PCR is unset the value is 0x1fff, most vendors appear to set it the
>> same as video pid in which case it need not be set.
>>
>> The PCR PID is at an offset of 8 in pmtSection structure.
> 
> Thanks for the patches!
> 
> Patches look good, except for two things:
> 
> - we use camelCase at Kaffeine. So, the new field should be pcrPid ;)
Ok, Wasn't sure

> 
> - you didn't use dvbsi.xml. The way we usually update dvbsi.h and part of
>    dvbsi.cpp is to add a field at dvbsi.xml and then run:
> 
> 	$ tools/update_dvbsi.sh
Oh I see.


> 
>    Kaffeine should be built with the optional BUILD_TOOLS feature, in order
>    for it to build the tool that parses dvbsi.xml.
> 
> Anyway, I applied your patchset and added a few pathes afterwards
> adjusting it.

Thanks

How do you turn off debug the spam from epg is horrendous.

Regards


Malcolm
