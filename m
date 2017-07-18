Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35050 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdGRUVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 16:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8XZa6twiqheZ1JCCwKEmqvqeECAq7MyG_4WwO_WQMMQg@mail.gmail.com>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-8-arnd@arndb.de>
 <CAKv+Gu9+0H9w8z8_Zedd-RxXt89Y7sJ=57_ZTThfDpFe4H0uXg@mail.gmail.com>
 <CAK8P3a3qrkZLkL=PuUHkaq9p021-Y+odTj5UrdM=dZw8L=oM8g@mail.gmail.com>
 <CAKv+Gu_OYCNK2qvyDb0+7MqyG4rTEhsf57i6m9SJU80CE7Yt+g@mail.gmail.com>
 <CAK8P3a0549U8zt7MPRJ5a6+pSZ-faqYiDTG3tNQGmvAbrZZfqw@mail.gmail.com> <CAKv+Gu8XZa6twiqheZ1JCCwKEmqvqeECAq7MyG_4WwO_WQMMQg@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 18 Jul 2017 22:21:37 +0200
Message-ID: <CAK8P3a3dC-ZUKMB=V3N67A9xzpLJj7YG9+Oy0OXkfALAwrPiXQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] proc/kcore: hide a harmless warning
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 18, 2017 at 10:07 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 18 July 2017 at 21:01, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tue, Jul 18, 2017 at 9:55 PM, Ard Biesheuvel
>
> Ah, now it makes sense. I was a bit surprised that
> -Wtautological-compare complains about symbolic constants that resolve
> to the same expression, but apparently it doesn't.
>
> I see how ccache needs to preprocess first: that is how it notices
> changes, by hashing the preprocessed input and comparing it to the
> stored hash. I'd still expect it to go back to letting the compiler
> preprocess for the actual build, but apparently it doesn't.

When I tried to figure this out, I saw that ccache has two modes, "direct"
and "preprocessed". It usually tries to use direct mode unless something
prevents that.

In "direct" mode, it hashes the source file and the included headers
instead of the preprocessed source file, however it still calls the compiler
for the preprocessed source file, I guess since it has to preprocess the
file the first time it is seen so it can record which headers are included.

> A quick google search didn't produce anything useful, but I'd expect
> other ccache users to run into the same issue.

I suspect gcc-7 is still too new for most people to have noticed this.
The kernel is a very large codebase, and we only got a handful
of -Wtautological-compare warnings at all, most of them happen
wtihout ccache, too.

Among the four patches, three are for -Wtautological-compare, and one
 is for -Wint-in-bool-context:

         if (v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced))

v4l2_subdev_call() in this case is a function-like macro that may return
-ENODEV if its first argument is NULL. The other -Wint-in-bool-context
I found all happen with or without ccache, most commonly there is
an constant integer expression passed into a macro and then checked
like

#define macro(arg) \
       do { \
            if (arg) \
               do_something(arg);  \
       } while (0)

         Arnd
