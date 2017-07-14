Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37989 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754018AbdGNM2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 08:28:12 -0400
Received: by mail-it0-f41.google.com with SMTP id k192so22355141ith.1
        for <linux-media@vger.kernel.org>; Fri, 14 Jul 2017 05:28:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170714092540.1217397-8-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-8-arnd@arndb.de>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 14 Jul 2017 13:28:10 +0100
Message-ID: <CAKv+Gu9+0H9w8z8_Zedd-RxXt89Y7sJ=57_ZTThfDpFe4H0uXg@mail.gmail.com>
Subject: Re: [PATCH 07/14] proc/kcore: hide a harmless warning
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Pratyush Anand <panand@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14 July 2017 at 10:25, Arnd Bergmann <arnd@arndb.de> wrote:
> gcc warns when MODULES_VADDR/END is defined to the same value as
> VMALLOC_START/VMALLOC_END, e.g. on x86-32:
>
> fs/proc/kcore.c: In function =E2=80=98add_modules_range=E2=80=99:
> fs/proc/kcore.c:622:161: error: self-comparison always evaluates to false=
 [-Werror=3Dtautological-compare]
>   if (/*MODULES_VADDR !=3D VMALLOC_START && */MODULES_END !=3D VMALLOC_EN=
D) {
>

Does it occur for subtraction as well? Or only for comparison?

> The code is correct as it is required for most other configurations.
> The best workaround I found for shutting up that warning is to make
> it a little more complex by adding a temporary variable. The compiler
> will still optimize away the code as it finds the two to be identical,
> but it no longer warns because it doesn't condider the comparison
> "tautological" any more.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/proc/kcore.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index 45629f4b5402..c503ad657c46 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -620,12 +620,14 @@ static void __init proc_kcore_text_init(void)
>  /*
>   * MODULES_VADDR has no intersection with VMALLOC_ADDR.
>   */
> -struct kcore_list kcore_modules;
> +static struct kcore_list kcore_modules;
>  static void __init add_modules_range(void)
>  {
> -       if (MODULES_VADDR !=3D VMALLOC_START && MODULES_END !=3D VMALLOC_=
END) {
> -               kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> -                       MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> +       void *start =3D (void *)MODULES_VADDR;
> +       size_t len =3D MODULES_END - MODULES_VADDR;
> +
> +       if (start !=3D (void *)VMALLOC_START && len !=3D VMALLOC_END - VM=
ALLOC_START) {
> +               kclist_add(&kcore_modules, start, len, KCORE_VMALLOC);
>         }
>  }
>  #else
> --
> 2.9.0
>
