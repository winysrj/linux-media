Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:42694 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdLMM1t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 07:27:49 -0500
MIME-Version: 1.0
In-Reply-To: <20171213095315.437ecf2f@vento.lan>
References: <20171208135650.3f385c45@vento.lan> <CA+55aFwBvXVQavgwDKVV3epFhd4MTaQvDktpDahkPhxweXnMmQ@mail.gmail.com>
 <20171211091223.2ba10fb1@vento.lan> <CAMuHMdUkHda_=7oUrPvOLG9Tt8ZdosQJa2mFkMeoLMjhrVV3PA@mail.gmail.com>
 <20171213095315.437ecf2f@vento.lan>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 13 Dec 2017 13:27:47 +0100
Message-ID: <CAMuHMdV2gKwwDggOwqqXSGDowJNhxxyT9CJuBfFB3LUHZBYE-A@mail.gmail.com>
Subject: Re: [GIT PULL for v4.15-rc3] media fixes
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Dec 13, 2017 at 12:53 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Wed, 13 Dec 2017 10:03:56 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
>> On Mon, Dec 11, 2017 at 12:12 PM, Mauro Carvalho Chehab
>> <mchehab@osg.samsung.com> wrote:
>> > Without this series, I was getting 809 lines of bogus warnings (see below),
>> > with was preventing me to see new warnings on my incremental builds
>> > while applying new patches at the media tree.
>>
>> $ linux-log-diff build.log{.old,}
>>
>> (from https://github.com/geertu/linux-scripts)
>
> That's nice!
>
> Yet, it is producing some noise. I did a clean build with:
>
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' M=drivers/staging/media | grep -v -e " CC " -e " LD " -e " AR " -e " CHK " -e " CALL " -e " UPD " -e "scripts/kconfig/conf " -e " CHECK " >old.log
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' M=drivers/media| grep -v -e " CC " -e " LD " -e " AR " -e " CHK " -e " CALL " -e " UPD " -e "scripts/kconfig/conf " -e " CHECK "  >>old.log
>
> and added a new uninitialized "foo" var to a random driver, doing an
> incremental build with:
>
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' | grep -v -e " CC " -e " LD " -e " AR " -e " CHK " -e " CALL " -e " UPD " -e "scripts/kconfig/conf " -e " CHECK " M=drivers/staging/media >new.log
> $ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' | grep -v -e " CC " -e " LD " -e " AR " -e " CHK " -e " CALL " -e " UPD " -e "scripts/kconfig/conf " -e " CHECK " M=drivers/media >new.log
>
> Then, I ran the script:
>
> $ linux-log-diff old.log new.log
>
> *** ERRORS ***
>
>
> *** WARNINGS ***
>
> 1 warning regressions:
>   + drivers/media/dvb-frontends/dibx000_common.c: warning: unused variable 'foo' [-Wunused-variable]:  => 22:5
>
> 3 warning improvements:
>   - ./arch/x86/include/asm/bitops.h: warning: asm output is not an lvalue: 430:22 =>
>   - drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h: warning: function 'mmu_reg_load' with external linkage has definition: 35:30 =>
>   - drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h: warning: function 'mmu_reg_store' with external linkage has definition: 24:26 =>
>
> It detected the "foo" var warning, but it outputs 3 warning improvements
> on files that were not even built the second time.

If the file wasn't built, the warning cannot be in the log ;-)
So yes, it works best for full builds, only flagging warnings that
(dis)appeared (and ignoring changes due to changed line numbers!).

If you do lots of incremental builds, you want to append the last incremental
log to the existing full log before doing a new build, to avoid false positives
from files that weren't built in the previous run:

    $ cat new.log >> old.log
    $ make ... > new.log
    $ linux-log-diff old.log new.log

And only new warnings should be reported.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
