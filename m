Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57774 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2HFU1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 16:27:22 -0400
Received: by weyx8 with SMTP id x8so2221272wey.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 13:27:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5020271B.1020702@redhat.com>
References: <1344279745-13024-1-git-send-email-mchehab@redhat.com>
	<CAHFNz9Jz5x8i7-ip9BOdwC06tYR1SETctvvTpA4V=mbezhRoAw@mail.gmail.com>
	<5020271B.1020702@redhat.com>
Date: Tue, 7 Aug 2012 01:57:20 +0530
Message-ID: <CAHFNz9+mcnq5oWJLieN6P9e_gfS5BJZTVZDTGwhZR-dCtVJgcg@mail.gmail.com>
Subject: Re: [PATCH] [media] mantis: merge both vp2033 and vp2040 drivers
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2012 at 1:50 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 06-08-2012 17:07, Manu Abraham escreveu:
>> On Tue, Aug 7, 2012 at 12:32 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> As noticed at:
>>>         http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/48034
>>>
>>> Both drivers are identical, except for the name. So, there's no
>>> sense on keeping both. Instead of forking the entire code, just
>>> fork the vp3033_config struct, saving some space, and cleaning
>>> up the Kernel.
>>
>>>
>>> Reported-by: Igor M. Liplianin <liplianin@me.by>
>>> Cc: Manu Abraham <abraham.manu@gmail.com>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> Nack.
>>
>> VP-2033 and 2040 are both different in terms of hardware. If someone
>> wants to add
>> in additional frontend characteristic differences, he shouldn't have
>> to add in this code
>> again.
>
> The code are just the same for both! If it ever become different, then
> it could be forked again, but for now, it is just duplicating the same
> code on both places and wasting 200 lines of useless code.


No, because you see the code that way, it doesn't necessarily mean that
you have to merge all code that look similar.

That's just peanuts you are talking about. The memory usage appears only
if you are using the module. 200 lines of .text is nothing. That exists to
differentiate between the 2 devices, not to make both hardware look the same.

I have explained why those 2 devices need to be differentiated.

Manu
