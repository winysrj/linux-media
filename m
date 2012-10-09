Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36423 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2JIXRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 19:17:20 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so5823904wib.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 16:17:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121009194446.1c652e72@redhat.com>
References: <E1TKqkK-0005vN-Nl@www.linuxtv.org>
	<CAOcJUbzHUA4bCc2FRfThC80BjBc2RkT25-LuYZzQMANjtTTy2w@mail.gmail.com>
	<20121009194446.1c652e72@redhat.com>
Date: Tue, 9 Oct 2012 19:17:18 -0400
Message-ID: <CAOcJUbxs-rgkqj1=dPPNdikyYEQQDLv97mKFbWxci2kchzdmnA@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] tda18271-common: hold the I2C
 adapter during write transfers
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 9, 2012 at 6:44 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Sun, 7 Oct 2012 09:19:51 -0400
> Michael Krufky <mkrufky@linuxtv.org> escreveu:
>
>> umm, again, i didn't actually ACK the patch, I verbally said "ok, i guess"
>>
>> You shouldn't forge someone's signature, Mauro.  :-(
>
> First of all, acked-by is not a signature. Those tags (acked, reviewed, tested,
> reported, etc) are pure indications of the status of the patch, e. g.
> if someone looked into the issue.
>
> In this specific case, what you said, instead was, literally: "So, I retract my NACK."
>
> Well, you're the driver maintainer, so I expected your considerations.
>
> You firstly reviewed it and gave a NACK. Then, you reviewed it again
> and reverted a NACK. The opposite of a NACK is an ACK. This is pure boolean.
>
> If you had, instead asked me for more time to review, I would have kept
> it in hold.
>
> Now that it got merged, what we can do is to revert it, if you have good
> reasons for that, or to keep it.
>
> Your call.

I understand.  Thanks for explaining it.  We spoke about this today in
IRC, also... I'll send another patch when I have some time to address
the trivial remaining issues.  There is nothing wrong (afaik) with
merging this patch for now.

Thanks again,

Mike
