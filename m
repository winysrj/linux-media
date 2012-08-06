Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65100 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2HFKkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 06:40:45 -0400
Received: by yhmm54 with SMTP id m54so2292243yhm.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 03:40:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+C2MxStsujUkSd0HPLp-P9As-5cZu__dNw025LA3ynwzxtG6Q@mail.gmail.com>
References: <1344199202-15744-1-git-send-email-develkernel412222@gmail.com>
	<CALF0-+UHQ_TdAL-wdRLEjoi33UiFBVMUCZLbaMh9oZ5qsDOA_A@mail.gmail.com>
	<CA+C2MxStsujUkSd0HPLp-P9As-5cZu__dNw025LA3ynwzxtG6Q@mail.gmail.com>
Date: Mon, 6 Aug 2012 07:40:44 -0300
Message-ID: <CALF0-+XxbAQ89sQdowuGAUSB2wO757d_o7dVYr5jWiBuQT5MXw@mail.gmail.com>
Subject: Re: [PATCH] staging: media: cxd2099: remove memcpy of similar
 structure variables
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 6, 2012 at 2:28 AM, Devendra Naga
<develkernel412222@gmail.com> wrote:
> Hi Ezequiel,
>
> On Mon, Aug 6, 2012 at 3:36 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> Hi Devendra,
>>
>> Thanks for the patch,
>>
>> On Sun, Aug 5, 2012 at 5:40 PM, Devendra Naga
>> <develkernel412222@gmail.com> wrote:
>>> structure variables can be assigned, no memcpy needed,
>>> remove the memcpy and use assignment for the cfg and en variables.
>>>
>>> Tested by Compilation Only
>>>
>>> Suggested-by: Ezequiel Garcia <elezegarcia@gmail.com>
>>
>> I'm not sure this is completely valid or useful.
>>
>> If you read Documentation/SubmittingPatches (which you should)
>> you will find references to Acked-by, Reported-by, Tested-by,
>> but not this one.
>>
>> You don't need to give me credit for the patch:
>> it's *your* patch, all I did was a very simple suggestion :-)
>>
> Ok. I will remove the Suggested-by line and send out the patch again
> with PATCH RESEND subject line.
> Is it ok?
>

I'm not entirely sure. Perhaps you can leave it as it is, and let
Mauro remove that line.

Regards,
Ezequiel.
