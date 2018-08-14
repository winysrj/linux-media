Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35240 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHNStJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 14:49:09 -0400
Received: by mail-wm0-f65.google.com with SMTP id o18-v6so12798801wmc.0
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2018 09:01:23 -0700 (PDT)
Subject: Re: [PATCH] [v2] media: camss: add missing includes
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, hansverk@cisco.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20180814091636.1960071-1-arnd@arndb.de>
 <565437f4-e01a-4558-ccc1-4f312e26cf35@linaro.org>
 <CAK8P3a2swXMsOnOv_Oow6TCShna4LLfm=uuNmvKk+O2GTZMr+A@mail.gmail.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <d7fe134e-ad9b-06cf-d6bd-cba875b6bc24@linaro.org>
Date: Tue, 14 Aug 2018 19:01:20 +0300
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2swXMsOnOv_Oow6TCShna4LLfm=uuNmvKk+O2GTZMr+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 14.08.2018 15:58, Arnd Bergmann wrote:
> On Tue, Aug 14, 2018 at 2:45 PM Todor Tomov <todor.tomov@linaro.org> wrote:
>>
>> Hi Arnd,
>>
>> On 14.08.2018 12:13, Arnd Bergmann wrote:
>>> Multiple files in this driver fail to build because of missing
>>> header inclusions:
>>>
>>> drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c: In function 'csiphy_hw_version_read':
>>> drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c:31:18: error: implicit declaration of function 'readl_relaxed'; did you mean 'xchg_relaxed'? [-Werror=implicit-function-declaration]
>>> drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c: In function 'csiphy_hw_version_read':
>>> drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c:52:2: error: implicit declaration of function 'writel' [-Werror=implicit-function-declaration]
>>
>> Thank you for noticing this and preparing a patch.
>> I build for arm64 and x86_64 with compile test enabled and I don't see these errors. Do you have a guess what is different that I don't have them?
> 
> I try lots of randconfig builds, and only one of them hit this, so
> it's surely some
> header that may or may not include io.h and slab.h depending on the
> configuration,
> or based on some other changes in linux-next.
> 
> Since the solution seemed obvious, I did not investigate further.
> 
> If you want to try reproducing the problem, see the arm64 config file
> at https://pastebin.com/raw/bNTPvYfZ

Thank you, I was able to reproduce it.

I have sent another patch which changes kcalloc to devm_kcalloc so the
hunk including slab.h is not needed anymore. For the rest of the patch
you can have my:
Acked-by: Todor Tomov <todor.tomov@linaro.org>


-- 
Best regards,
Todor Tomov
