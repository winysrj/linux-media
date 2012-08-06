Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59586 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2HFF21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 01:28:27 -0400
Received: by vbbff1 with SMTP id ff1so2242252vbb.19
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 22:28:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+UHQ_TdAL-wdRLEjoi33UiFBVMUCZLbaMh9oZ5qsDOA_A@mail.gmail.com>
References: <1344199202-15744-1-git-send-email-develkernel412222@gmail.com>
	<CALF0-+UHQ_TdAL-wdRLEjoi33UiFBVMUCZLbaMh9oZ5qsDOA_A@mail.gmail.com>
Date: Mon, 6 Aug 2012 11:13:26 +0545
Message-ID: <CA+C2MxStsujUkSd0HPLp-P9As-5cZu__dNw025LA3ynwzxtG6Q@mail.gmail.com>
Subject: Re: [PATCH] staging: media: cxd2099: remove memcpy of similar
 structure variables
From: Devendra Naga <develkernel412222@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Mon, Aug 6, 2012 at 3:36 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi Devendra,
>
> Thanks for the patch,
>
> On Sun, Aug 5, 2012 at 5:40 PM, Devendra Naga
> <develkernel412222@gmail.com> wrote:
>> structure variables can be assigned, no memcpy needed,
>> remove the memcpy and use assignment for the cfg and en variables.
>>
>> Tested by Compilation Only
>>
>> Suggested-by: Ezequiel Garcia <elezegarcia@gmail.com>
>
> I'm not sure this is completely valid or useful.
>
> If you read Documentation/SubmittingPatches (which you should)
> you will find references to Acked-by, Reported-by, Tested-by,
> but not this one.
>
> You don't need to give me credit for the patch:
> it's *your* patch, all I did was a very simple suggestion :-)
>
Ok. I will remove the Suggested-by line and send out the patch again
with PATCH RESEND subject line.
Is it ok?

> Plus, there was some discussion called "Kernel Komedians" [1] where
> some developer expressed their concern on the number of weird signatures
> that have recently appeared.
>
> Regards,
> Ezequiel.
>
> [1] http://lwn.net/Articles/503829/

I will read out the Documentation and will try to send patches accordingly,

Thanks a lot for your help and your time,
