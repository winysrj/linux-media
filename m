Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:59878 "EHLO
        avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932265AbcIETJF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 15:09:05 -0400
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Markus Heiser <markus.heiser@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
 <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
 <20160824114927.3c6ab0d6@vento.lan> <20160824115241.7e2c90ca@vento.lan>
 <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de>
 <20160905102511.6de3dbe4@vento.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Chris Mayo <aklhfex@gmail.com>
Message-ID: <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com>
Date: Mon, 5 Sep 2016 20:01:22 +0100
MIME-Version: 1.0
In-Reply-To: <20160905102511.6de3dbe4@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/16 14:25, Mauro Carvalho Chehab wrote:
> Em Mon, 5 Sep 2016 15:13:04 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Hi Mauro, (Hi Chris)
>>
>> sorry for my late reply. I test the v4-utils on my HTPC,
>> where I'am not often have time for experimentation ;-)
>>
>> Am 24.08.2016 um 16:52 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>
>>> Em Wed, 24 Aug 2016 11:49:27 -0300
>>> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
>>>   
>>>> Hi Markus,
>>>>
>>>> Em Wed, 10 Aug 2016 11:52:19 +0200
>>>> Markus Heiser <markus.heiser@darmarit.de> escreveu:
>>>>   
>>>>> From: Markus Heiser <markus.heiser@darmarIT.de>
>>>>>
>>>>> From: Heiser, Markus <markus.heiser@darmarIT.de>
>>>>>
>>>>> The vdr format was broken, I got '(null)' entries
>>>>>
>>>>> HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
>>>>> 0-:1----:2--------------:3:4-----:
>>>>>
>>>>> refering to the VDR Wikis ...
>>>>>
>>>>> * LinuxTV: http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf
>>>>> * german comunity Wiki: http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Parameter_ab_VDR-1.7.4
>>>>>
>>>>> There is no field at position 4 / in between "Source" and "SRate" which
>>>>> might have a value. I suppose the '(null):' is the result of pointing
>>>>> to *nothing*.
>>>>>
>>>>> An other mistake is the ending colon (":") at the line. It is not
>>>>> explicit specified but adding an collon to the end of an channel entry
>>>>> will prevent players (like mpv or mplayer) from parsing the line (they
>>>>> will ignore these lines).
>>>>>
>>>>> At least: generating a channel list with
>>>>>
>>>>>  dvbv5-scan --output-format=vdr ...
>>>>>
>>>>> will result in the same defective channel entry, containing "(null):"
>>>>> and the leading collon ":".    
>>>>
>>>> Sorry for taking too long to handle that. I usually stop handling
>>>> patches one week before the merge window, returning to merge only
>>>> after -rc1. This time, it took a little more time, due to the Sphinx
>>>> changes, as I was needing some patches to be merged upstream, in order
>>>> to change my handling scripts to work with the new way.
>>>>
>>>> Anyway, with regards to this patch, not sure if you saw, but
>>>> Chris Mayo sent us a different fix for it:
>>>>
>>>> 	https://patchwork.linuxtv.org/patch/35803/
>>>>
>>>> With is meant to support VDR format as used on version 2.2. Not sure
>>>> if this format is backward-compatible with versions 1.x, but usually
>>>> VDR just adds new parameters to the lines.
>>>>
>>>> So, I'm inclined to merge Chris patch instead of yours.
>>>>
>>>> So, could you please test if his patch does what's needed?  
>>>
>>> PS.: If the formats for v 1.x are not compatible with the ones for
>>> v2.x, then the best would be to change the code to add a new format
>>> for vdr v2.x, while keep supporting vdr v1.x.  
>>
>> Hmm, I'am a bit confused about vdr's channel.conf v1.x and v2.x.
>>
>> I can't find any documentation on this and since there is no
>> version control system for vdr it is hard to dig the history.
> 
> Yeah, I see your pain.
> 
>> As far as I can see, Chris fixes an issue with DVB-T and the
>> issue with the leading ":".
>>
>> My patch fixes an issue with DVB-S/2 entry-location (and the
>> issue with the leading ":").
>>
>> I will give it a try to merge my changes on top of Chris's
>> patch and test DVB-T & DVB-S2 on my HTPC with an vdr server.

Thanks. I can't test DVB-S(2) so I decided to leave that part alone.

> 
> Ok, that would be great! it would also be good if either of you could
> take a look on how to allow libdvbv5 to support both VDR versions 1.x and
> 2.x. I don't use VDR here (afaikt, it doesn't support ISDB-T - and nowadays
> I only have DVB/ATSC via my RF test generators), but, IMHO, being able to
> provide output on both formats can be useful for other VDR users.
> 

Is supporting vdr v1.x necessary?

I believe v1.7.x were developer releases leading up to v2.0.
Last stable v1.x was 2012-02-14: Version 1.6.0-3. With v1.6.0 being from 2008!

Looks like v2.2.0 added parameters N, Q and X for S2 and T2. But libdvbv5 does
not currently appear to output these (at least Q and X for T2).

Chris


