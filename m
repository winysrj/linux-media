Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33002 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbdIHORD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 10:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1709081609440.3165@hadrien>
References: <1504879698-5855-1-git-send-email-srishtishar@gmail.com> <alpine.DEB.2.20.1709081609440.3165@hadrien>
From: Srishti Sharma <srishtishar@gmail.com>
Date: Fri, 8 Sep 2017 19:47:02 +0530
Message-ID: <CAB3L5oyyQFa5Z-eWzpbe6QCNF=U4W2mnkwgt3-uE46nEuPWpEg@mail.gmail.com>
Subject: Re: [Outreachy kernel] [PATCH] Staging: media: omap4iss: Use
 WARN_ON() instead of BUG_ON().
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 7:40 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Fri, 8 Sep 2017, Srishti Sharma wrote:
>
>> Use WARN_ON() instead of BUG_ON() to avoid crashing the kernel.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/media/omap4iss/iss.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
>> index c26c99fd..b1036ba 100644
>> --- a/drivers/staging/media/omap4iss/iss.c
>> +++ b/drivers/staging/media/omap4iss/iss.c
>> @@ -893,7 +893,7 @@ void omap4iss_put(struct iss_device *iss)
>>               return;
>>
>>       mutex_lock(&iss->iss_mutex);
>> -     BUG_ON(iss->ref_count == 0);
>> +     WARN_ON(iss->ref_count == 0);
>>       if (--iss->ref_count == 0) {
>
> Won't this then infinite loop?

 Oh.. yes ! It would, sorry . Please drop this patch .

 Regards,
 Srishti

>
> julia
>
>>               iss_disable_interrupts(iss);
>>               /* Reset the ISS if an entity has failed to stop. This is the
>> --
>> 2.7.4
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504879698-5855-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
>>
