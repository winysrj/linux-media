Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33216 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3CGHQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:16:45 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so185763oag.22
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 23:16:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vwiXk+0AcRgRRdOP-qbKrsDKFNQ4DKm+fTGgTSiiwn7g@mail.gmail.com>
References: <1362484334-18804-1-git-send-email-sachin.kamat@linaro.org>
	<CA+V-a8vwiXk+0AcRgRRdOP-qbKrsDKFNQ4DKm+fTGgTSiiwn7g@mail.gmail.com>
Date: Thu, 7 Mar 2013 12:46:44 +0530
Message-ID: <CAK9yfHyeoMYiYZUEUY+gPRGOaLf4Qk500R=N4uKNV7n-csqiWQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] davinci_vpfe: Use module_platform_driver macro
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	prabhakar.lad@ti.com, manjunath.hadli@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 March 2013 17:46, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> Hi Sachin,
>
> Thanks for the patch!
>
> On Tue, Mar 5, 2013 at 5:22 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> module_platform_driver() eliminates the boilerplate and simplifies
>> the code.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Thanks Prabhakar.
BTW, who is supposed to pick this patch?

-- 
With warm regards,
Sachin
