Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo09.poczta.onet.pl ([213.180.142.140]:43305 "EHLO
	smtpo09.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1JSNHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 09:07:37 -0400
Message-ID: <4E9ECB94.70806@poczta.onet.pl>
Date: Wed, 19 Oct 2011 15:07:32 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/14] staging/media/as102: new driver submission (was
 Re: [PATCH 1/7] Staging submission: PCTV 74e driver (as102)
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl> <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein> <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com> <4E9ADFAE.8050208@redhat.com> <20111018111044.ebbc89a8.chmooreck@poczta.onet.pl> <CAGoCfiwLgGREEO5nRKZ4n=UD70aKTix+HZpjMvmfnADpEDgATg@mail.gmail.com> <20111018192019.4485315f@darkstar> <CAAwP0s2ZeP0JQPLDpryfbv3xhBZNrpjCmz-bfhJF5w0E3tcahQ@mail.gmail.com> <4E9EB82D.30300@redhat.com>
In-Reply-To: <4E9EB82D.30300@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



W dniu 19.10.2011 13:44, Mauro Carvalho Chehab pisze:
> Em 19-10-2011 09:41, Javier Martinez Canillas escreveu:
>> On Tue, Oct 18, 2011 at 7:20 PM, Piotr Chmura<chmooreck@poczta.onet.pl>  wrote:
>>> On Tue, 18 Oct 2011 11:52:17 -0400
>>> Devin Heitmueller<dheitmueller@kernellabs.com>  wrote:
>>>
>>>> On Tue, Oct 18, 2011 at 5:10 AM, Piotr Chmura<chmooreck@poczta.onet.pl>  wrote:
>>>>> Thanks for comments for all of you.
>>>>>
>>>>> [PATCH 1-12/14] Following your guidelines i exported all changes from hg one by one. This way we will have all history in kernel tree.
>>>>> I moved driver to staging/media and removed Kconfig/Makefile changes in parent directory in first patch.
>>>> Hello Piotr,
>>>>
>>>> Not that I want to create more work for you, but it would appear that
>>>> your patches stripped off all the Signed-off-by lines for both myself
>>>> and Pierrick Hascoet (the developer from the hardware vendor).  You
>>>> have replaced them with "cc:" lines, which breaks the chain of
>>>> "Developer's Certificate of Origin".
>>>>
>>>> When you take somebody else's patches, you need to preserve any
>>>> existing Signed-off-by lines, adding your own at the bottom of the
>>>> list.
>>>>
>>>> In other words, the first patch should be:
>>>>
>>>> Signed-off-by: Pierrick Hascoet<pierrick.hascoet@abilis.com>
>>>> Signed-off-by: Devin Heitmueller<dheitmueller@kernellabs.com>
>>>> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
>>>>
>>>> instead of:
>>>>
>>>> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
>>>> Cc: Pierrick Hascoet<pierrick.hascoet@abilis.com>
>>>> Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
>>>>
>>>> Devin
>>>>
>>>> --
>>>> Devin J. Heitmueller - Kernel Labs
>>>> http://www.kernellabs.com
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Ok, i'll resend them again.
>>>
>>> Should I replay to every patch with something like [RESEND PATCH nn/mm]..., right ?
>>>
>>> Peter
>> Hi Peter,
>>
>> A common convention is to add the version of your patch in the subject like:
>>
>> [PATCH v2 0/14] staging/media/as102: new driver submission
>>
>> That way people can know that is actually a resend of a new patch-set
>> and not a resend of the last one.
Thanks, I'll do it this way next time.

> Yes. Also, it seems that you've submitted only 12 patches of this 14 patch
> series. Where are the other two missing patches?
13 and 14 were written by me, so they didn't suffer "signed-off-by" 
mistake. Do I need resend them too ?

Peter

