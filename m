Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:43138 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751603AbdKYQyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 11:54:20 -0500
Received: by mail-wm0-f50.google.com with SMTP id x63so27051521wmf.2
        for <linux-media@vger.kernel.org>; Sat, 25 Nov 2017 08:54:19 -0800 (PST)
Subject: Re: dvbv5-scan: Missing NID, TID, and RID in VDR channel output
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <f65773a8-603a-ba10-b420-896efc70c26a@googlemail.com>
 <20171125090819.1a55e11a@vento.lan> <20171125095435.75c982f4@vento.lan>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <e7dfa685-e3f9-d0fe-5a33-5a994b7fea88@googlemail.com>
Date: Sat, 25 Nov 2017 17:54:16 +0100
MIME-Version: 1.0
In-Reply-To: <20171125095435.75c982f4@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 11/25/17 12:54 PM, Mauro Carvalho Chehab wrote:
> Em Sat, 25 Nov 2017 09:08:19 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>> Em Wed, 22 Nov 2017 20:50:56 +0100
>> Gregor Jasny <gjasny@googlemail.com> escreveu:
>>>
>>> Mauro, do you think it would be possible to parse / output NID, TID, and
>>> RID from dvbv5_scan? It would greatly improve usability.  
>>
>> It is possible. Not sure how much efforts it would take. Could you please
>> send me, in priv, a capture of ~30-60 seconds of a recent DVB-T2 channel
>> in Germany with those fields, and the corresponding output from w_scan,
>> for all channels at the same frequency?
>>
>> I'll use it to test it with my RF generator here, and see if I can tweak
>> dvbv5-scan to produce the same output.
>>
>> The syntax to capture the full MPEG-TS is:
>>
>> 	$ dvbv5-zap -P -o channel.ts -t 60 scan_file.conf

I captured all DVB-T2 frequencies I observed so far:
https://drive.google.com/open?id=1As5Ek0iN0n9FgH7xU-HsrFIRBE0hGOWQ
(that is in Germany / Saxony / Dresden)

> Btw, it follows a quick hack that should output network and transport ID.
> 
> Please test. It should be noticed that it adds two new fields on a struct
> that it is part of the API. I didn't care to check if this patch would break
> userspace API.

That works like a charm! Thank you for writing it.

Thanks,
Gregor
