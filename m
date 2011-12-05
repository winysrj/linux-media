Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49723 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1LEXcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 18:32:52 -0500
Received: by bkbzv3 with SMTP id zv3so2530863bkb.19
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2011 15:32:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com> <1321800978-27912-3-git-send-email-mchehab@redhat.com>
 <1321800978-27912-4-git-send-email-mchehab@redhat.com> <1321800978-27912-5-git-send-email-mchehab@redhat.com>
 <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
 <4EDD0F01.7040808@redhat.com> <CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com>
 <CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Tue, 6 Dec 2011 00:32:30 +0100
Message-ID: <CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE
 HVR-930C again
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Mark Lord <kernel@teksavvy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry,  I think I applied follow patch on my tree while I developed
the driver trying to fix tuner initialization.

http://patchwork.linuxtv.org/patch/6617/

I forgot to remove from my tree after I see that don't solve anything.

Regards
Eddi


On Mon, Dec 5, 2011 at 9:01 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Dec 5, 2011 at 1:46 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Mon, Dec 5, 2011 at 1:35 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>>> What's up with this change?  Is this a bugfix for some race condition?
>>>>  Why is it jammed into a patch for some particular product?
>>>>
>>>> It seems like a change such as this could significantly change the
>>>> timing of tuner initialization if you have multiple xc5000 based
>>>> products that might have a slow i2c bus.  Was that intentional?
>>>>
>>>> This patch should be NACK'd and resubmitted as it's own bugfix where
>>>> it's implications can be fully understood in the context of all the
>>>> other products that use xc5000.
>>>
>>>
>>> It is too late for nacking the patch, as there are several other patches
>>> were already applied on the top of it, and we don't rebase the
>>> linux-media.git tree.
>>>
>>> Assuming that this is due to some bug that Eddi picked during xc5000
>>> init, what it can be done now is to write a patch that would replace
>>> this xc5000-global mutex lock into a some other per-device locking
>>> schema.
>>
>> At this point we have zero idea why it's there *at all*.  Eddi, can
>> you comment on what prompted this change?
>>
>> This patch should not have been accepted in the first place.  It's an
>> undocumented change on a different driver than is advertised in the
>> subject line.  Did you review the patch prior to merging?
>>
>> This change can result in a performance regression for all other
>> devices using xc5000, and it's not yet clear why it's there in the
>> first place.  If its use cannot be explained then it should be rolled
>> back.  If this breaks 930c, then the whole device support series
>> should be rolled back until somebody can figure out what is going on.
>>
>> It's crap like this that is the reason that every other week I get
>> complaints from some user that one of the drivers I wrote support for
>> worked fine for months/years until they upgraded to the latest kernel.
>
> Speaking of which, Mark Lord just tried out this change (he has an
> 800i and 950q - both xc5000 based), and now his DVB stack fails to
> load.  And yes, he already has the fix to the mutex_unlock()
> regression which Dan Carpenter found six days ago and which this patch
> introduced.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
