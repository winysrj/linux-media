Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35565 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdGRUHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 16:07:30 -0400
Received: by mail-it0-f49.google.com with SMTP id h199so15155125ith.0
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 13:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0549U8zt7MPRJ5a6+pSZ-faqYiDTG3tNQGmvAbrZZfqw@mail.gmail.com>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-8-arnd@arndb.de>
 <CAKv+Gu9+0H9w8z8_Zedd-RxXt89Y7sJ=57_ZTThfDpFe4H0uXg@mail.gmail.com>
 <CAK8P3a3qrkZLkL=PuUHkaq9p021-Y+odTj5UrdM=dZw8L=oM8g@mail.gmail.com>
 <CAKv+Gu_OYCNK2qvyDb0+7MqyG4rTEhsf57i6m9SJU80CE7Yt+g@mail.gmail.com> <CAK8P3a0549U8zt7MPRJ5a6+pSZ-faqYiDTG3tNQGmvAbrZZfqw@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 18 Jul 2017 21:07:29 +0100
Message-ID: <CAKv+Gu8XZa6twiqheZ1JCCwKEmqvqeECAq7MyG_4WwO_WQMMQg@mail.gmail.com>
Subject: Re: [PATCH 07/14] proc/kcore: hide a harmless warning
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Pratyush Anand <panand@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 July 2017 at 21:01, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jul 18, 2017 at 9:55 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 18 July 2017 at 20:53, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Fri, Jul 14, 2017 at 2:28 PM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> On 14 July 2017 at 10:25, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> gcc warns when MODULES_VADDR/END is defined to the same value as
>>>>> VMALLOC_START/VMALLOC_END, e.g. on x86-32:
>>>>>
>>>>> fs/proc/kcore.c: In function =E2=80=98add_modules_range=E2=80=99:
>>>>> fs/proc/kcore.c:622:161: error: self-comparison always evaluates to f=
alse [-Werror=3Dtautological-compare]
>>>>>   if (/*MODULES_VADDR !=3D VMALLOC_START && */MODULES_END !=3D VMALLO=
C_END) {
>>>>>
>>>>
>>>> Does it occur for subtraction as well? Or only for comparison?
>>>
>>> This replacement patch would also address the warning:
>>>
>>> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
>>> index 45629f4b5402..35824e986c2c 100644
>>> --- a/fs/proc/kcore.c
>>> +++ b/fs/proc/kcore.c
>>> @@ -623,7 +623,7 @@ static void __init proc_kcore_text_init(void)
>>>  struct kcore_list kcore_modules;
>>>  static void __init add_modules_range(void)
>>>  {
>>> -       if (MODULES_VADDR !=3D VMALLOC_START && MODULES_END !=3D VMALLO=
C_END) {
>>> +       if (MODULES_VADDR - VMALLOC_START && MODULES_END - VMALLOC_END)=
 {
>>>                 kclist_add(&kcore_modules, (void *)MODULES_VADDR,
>>>                         MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
>>>         }
>>>
>>> I have also verified that four of the 14 patches are not needed when bu=
ilding
>>> without ccache, this is one of them:
>>>
>>>  acpi: thermal: fix gcc-6/ccache warning
>>>  proc/kcore: hide a harmless warning
>>>  SFI: fix tautological-compare warning
>>>  [media] fix warning on v4l2_subdev_call() result interpreted as bool
>>>
>>> Not sure what to do with those, we could either ignore them all and
>>> not care about ccache, or we try to address them all in some way.
>>>
>>
>> Any idea why ccache makes a difference here? It is not obvious (not to
>> me at least)
>
> When ccache is used, the compilation stage is apparently always done on
> the preprocessed source file. So instead of parsing (with the integrated
> preprocessor)
>
>           if (MODULES_VADDR !=3D VMALLOC_START ...)
>
> the compiler sees
>
>           if (((unsigned long)high_memory + (8 * 1024 * 1024))  !=3D
>               ((unsigned long)high_memory + (8 * 1024 * 1024))  ...)
>
> and it correctly considers the first expression something that one
> would write in source code, while -Wtautological-compare
> is intended to warn about the second version being always true,
> which makes the 'if()' pointless.
>

Ah, now it makes sense. I was a bit surprised that
-Wtautological-compare complains about symbolic constants that resolve
to the same expression, but apparently it doesn't.

I see how ccache needs to preprocess first: that is how it notices
changes, by hashing the preprocessed input and comparing it to the
stored hash. I'd still expect it to go back to letting the compiler
preprocess for the actual build, but apparently it doesn't.

A quick google search didn't produce anything useful, but I'd expect
other ccache users to run into the same issue.
