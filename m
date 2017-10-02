Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:56200 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdJBJCU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 05:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <20171002084119.3504771-1-arnd@arndb.de>
References: <CAK8P3a0WtHjvo6tOp79U4gKjLSRmVCAmjYU_xTVJfBL1Qe-hdQ@mail.gmail.com>
 <20171002084119.3504771-1-arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 2 Oct 2017 11:02:19 +0200
Message-ID: <CAK8P3a0Zi9B69Yhg9H8UqfnA5RHHk1RrGvx757ejwJcAupf1cg@mail.gmail.com>
Subject: Re: [PATCH] string.h: work around for increased stack usage
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: David Laight <David.Laight@aculab.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-media @ vger . kernel . org" <linux-media@vger.kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "kasan-dev @ googlegroups . com" <kasan-dev@googlegroups.com>,
        "linux-kbuild @ vger . kernel . org" <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 2, 2017 at 10:40 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>  void fortify_panic(const char *name) __noreturn __cold;
> +
> +/* work around GCC PR82365 */
> +#if defined(CONFIG_KASAN) && !defined(__clang__) && GCC_VERSION <= 80000
> +#define fortify_panic(x) \
> +       do { \
> +               asm volatile(""); \
> +               fortify_panic(x); \
> +       } while (0)
> +#endif

This broke the build for the fortify_panic() definition in lib/string.c which
clashes with the macro. I've fixed it locally by renaming it to __fortify_panic,
but won't post the fixed version until I get some feedback on the basic
approach.

      Arnd
