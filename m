Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50344 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3CGHYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:24:15 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so133091wgb.24
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 23:24:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHyeoMYiYZUEUY+gPRGOaLf4Qk500R=N4uKNV7n-csqiWQ@mail.gmail.com>
References: <1362484334-18804-1-git-send-email-sachin.kamat@linaro.org>
 <CA+V-a8vwiXk+0AcRgRRdOP-qbKrsDKFNQ4DKm+fTGgTSiiwn7g@mail.gmail.com> <CAK9yfHyeoMYiYZUEUY+gPRGOaLf4Qk500R=N4uKNV7n-csqiWQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 7 Mar 2013 12:53:54 +0530
Message-ID: <CA+V-a8tEQmabr40j6jWOPDwFRnmH80kKze_G4Ldwr0r3D1ofRg@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] davinci_vpfe: Use module_platform_driver macro
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On Thu, Mar 7, 2013 at 12:46 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 5 March 2013 17:46, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
>> Hi Sachin,
>>
>> Thanks for the patch!
>>
>> On Tue, Mar 5, 2013 at 5:22 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>>> module_platform_driver() eliminates the boilerplate and simplifies
>>> the code.
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>
>> Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>
> Thanks Prabhakar.
> BTW, who is supposed to pick this patch?
>
I'll queue it for 3.10 and a issue a pull request to Mauro soon.
Or if you have a branch and want to issue a pull no problem(anyways
I have Acked it). what do you suggest ?

Regards,
--Prabhakar Lad

> --
> With warm regards,
> Sachin
