Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:64900 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIASQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 14:16:58 -0400
Received: by mail-la0-f46.google.com with SMTP id pv20so6533398lab.33
        for <linux-media@vger.kernel.org>; Mon, 01 Sep 2014 11:16:57 -0700 (PDT)
Message-ID: <5404B871.601@googlemail.com>
Date: Mon, 01 Sep 2014 20:18:25 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: oravecz@nytud.mta.hu
CC: linux-media@vger.kernel.org
Subject: Re: HVR 900 (USB ID 2040:6500) no analogue sound reloaded
References: <201409010731.s817VHF11525@ny01.nytud.hu>
In-Reply-To: <201409010731.s817VHF11525@ny01.nytud.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 01.09.2014 um 09:31 schrieb Oravecz Csaba:
> Sun Aug 31 17:07:00 2014 =?windows-1252?Q?Frank_Sch=E4fer?= kirjutas:
>>
>> Am 22.08.2014 um 21:03 schrieb Oravecz Csaba:
>>> I reported this issue earlier but for some reason it went pretty much
>>> unnoticed. The essence is that with the newest em28xx drivers now present in
>>> 3.14 kernels (i'm on stock fedora 3.14.15-100.fc19.i686.PAE) I can't get
>>> analogue sound from this card.
>>>
>>> I see that the code snippet that produced this output in the pre 3.14 versions
>>>
>>> em2882/3 #0: Config register raw data: 0x50
>>> em2882/3 #0: AC97 vendor ID = 0xffffffff
>>> em2882/3 #0: AC97 features = 0x6a90
>>> em2882/3 #0: Empia 202 AC97 audio processor detected
>>>
>>> is still there in em28xx-core.c, however, there is nothing like that in
>>> current kernel logs so it seems that this part of the code is just skipped,
>>> which I tend to think is not the intended behaviour. I have not gone any
>>> further to investigate the issue, rather I've simply copied the 'old' em28xx
>> Thank you for reporting this issue.
>> I suspect reverting commit b99f0aadd3 "[media] em28xx: check if a device
>> has audio earlier" will resolve it.
>> Can you check that ?
> Yes, that has indeed solved the problem. I assume this will slowly propagate
> into the mainstraim distros, in the meantime i can happily use the custom
> compiled reverted drivers.
> Thanks,
> o.cs.
Ok, thanks for testing.
I will send a patch reverting this commit later this evening.

Regards,
Frank
